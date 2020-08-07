## This is a script to process spatial raster data from the SatSkog data product, large herbivore density data,
## and seNorge temp + SWE data

#It only uses the 'Trondheim' file of SatSkog data, and is meant to develop a workflow which will allow for processing
#of all SatSkog files


#PACKAGES ----------------------------------------------------------------------

        #Spatial Data Packages
        library(sf)
        library(tmap)
        library(broom)

        #Packages for netCDF files
        library(ncdf4)
        library(chron)
        library(reshape2)

        #Packages for analysis
        library(lme4)
        library(lmerTest)
        library(sjPlot)
        library(spdep)

        #Data Manipulation + Visualization
        library(ggplot2)
        library(raster)
        library(rasterVis)
        library(dplyr)

#END PACKAGES ----------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#INITIAL DATA IMPORT ----------------------------------------------------------------------------------------------

        #SustHerb Herbivore Spatial Data

                #Read in vector data w/ sf package
                hd_shp <- st_read("2_Albedo_Regional/Data/Herbivore_Densities/NorwayLargeHerbivores.shp")
                
                        #Eliminate columns from older dates (to speed up processing)
                
                                #Start w/ W__1949
                                start <- grep("W__1949", colnames(hd_shp))
                                end <- grep("WP_1989", colnames(hd_shp))
                                
                                #Filter out subset
                                hd_shp <- hd_shp[,c(2:(start - 1), (end + 1):ncol(hd_shp))]
                
                        #Fix 'S__' variables (last digit dropped)
                        names(hd_shp)[grep("S___199", colnames(hd_shp))] <- "S___1999"
                        names(hd_shp)[grep("S___200", colnames(hd_shp))] <- "S___2009"
                        names(hd_shp)[grep("S___201", colnames(hd_shp))] <- "S___2015"
                        
        #SatSkog Spatial Data Product
                
                #Load in Trondheim SatSkog shapefile (SatSkog pictures from 1999)
                satskog <- st_read("2_Albedo_Regional/Data/Spatial_Data/SatSkog/Trondheim/5001_25833_satskog_8472bd_SHAPE.shp")
                
        #seNorge Gridded Temp + SWE data for all of Norway (1999 ONLY)
        ## NOTE: These files were processed from large netCDF files provided by met.no
        ## Monthly means for each grid cell in Norway (1km2 resolution) have been calculated
        ## This data has been stored in RasterBrick files (saved to disk as .tif files)
                
                #Load in SWE as RasterBrick
                swe <- brick("2_Albedo_Regional/Data/seNorge/Output/SWE/swe_means_1999_all_norway.tif")
                
                #Load in temp data as RasterBrick
                temp <- brick("2_Albedo_Regional/Data/seNorge/Output/Temperature/temp_means_1999_all_norway.tif")
               

#END INITIAL DATA IMPORT ------------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#VERIFY COORDINATE REFERENCE SYSTEMS --------------------------------------------------------------------------------
     
        #Set desired CRS as variable (using the SatSkog CRS as a base)
        st_crs_ver <- st_crs(satskog)
        crs_ver <- crs(satskog)

        #CRS - Herbivore data
        st_crs(hd_shp) #Slightly different
        
                #Change CRS to desired
                hd_shp <- st_transform(hd_shp, crs = st_crs_ver)
                
        #CRS - SatSkog product
        st_crs(satskog) #Good

        #CRS - SWE & TEMP
        crs(swe) #Wrong ellipse/datum
        crs(temp) #Wrong ellipse/datum
        
                #Change CRS to desired
                proj4string(swe) <- crs_ver
                proj4string(temp) <- crs_ver
        
                #ALL DATA NOW USES SAME CRS AS SATSKOG PRODUCT
                          
        
#END VERIFY COORDINATE REFERENCE SYSTEMS --------------------------------------------------------------------------------
                
                
                
                
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                
                
                
                
#INITIAL DATA EXPLORATION + FILTERING --------------------------------------------------------------------------------------------

        #HERBIVORE DATA -------------
                
                #Summary 
                str(hd_shp, max.level = 2)
        
                #Filter to data from 1999 only
                ## Note: Only using densities from 1999, since these correspond best to date of 
                ## the pictures used for the SatSkog product
                        
                        #Grab relevant 1999 densities, kommune info, + geometry (since these are closest to SatSkog)
                        hd1999 <- hd_shp %>% select( c(1:10, 96:112, geometry))
                                                
                                           
                #Plot data
        
                        #Outline of geometry (map of Norway)
                        geo <- st_geometry(hd1999)
                        plot(geo)
                
                        #Plot moose density for 1999 (example plot)
                        plot(hd1999["Ms_1999"])
        
                #Explore area of kommunes
                        
                        #Calculate area of each polygon in hd1999 df
                        area <- st_area(hd1999)
                        
                        #Histogram of areas
                        hist(area, breaks = 300)
                
                        
        #SATSKOG DATA PRODUCT -------------
                
                #Summary of data (provides summary stats for each variable)
                summary(satskog)
                        
                #Get geometry and plot
                geo_satskog <- st_geometry(satskog)
                plot(geo_satskog)
                
                #Filter and clean up data
                
                        #Remove rows w/ age of '-1' (invalid observations)
                        satskog <- satskog[satskog$alder != -1, ]
                        
                        #Remove observations with 'reduced' quality images (which may affect accuracy of data)
                        satskog <- satskog[satskog$kvalitet != "redusert",]
                        
                        #Make sure all pictures from same year (1999), to be as close to 1999 herbivore density data as possible
                        satskog <- satskog[satskog$bildedato == '060899',]
                        
                        #Filter to 'Clear Sky' observations ('ikke_sky') 
                        satskog <- satskog[satskog$class_sky == 'ikke_sky',]
                        
                        #Filter pixels with NDVI of 0 (which might indicate non-vegetative pixels)
                        satskog <- satskog[satskog$ndvi > 0,]
                        
                        #SHOULD I FILTER TO PRODUCTIVE FOREST ONLY? ('pskog')
                        
                        #Filter to 'younger' forest
                        
                                #Set minimum age
                                min_age <- min(satskog$alder)
                                
                                #Set age limit of 30
                                age_limit <- 30
                                
                                #Filter to observations between min age and 'age limit'
                                satskog <- satskog[satskog$alder >= min_age & satskog$alder <= age_limit,]
                                
                #Explore filtered data
                                
                        #Plot geometry of filtered forest plots
                        plot(satskog$geometry)
                                
                        #Age of stands
                        hist(satskog$alder, breaks = 30)
                        
                        #Area (m2)
                        hist(satskog$areal_m2, breaks = 500) #Some large areas - should I remove these?
                        
                        #Bonitet (quality)
                        hist(satskog$bonitet, breaks = 8)
                
                        

        
        
#END INITIAL DATA EXPLORATION + FILTERING ----------------------------------------------------------------------------------------
       
        
        
        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

                        
                        
                        
#EXTRACT SENORGE DATA & CALCULATE ALBEDO FOR EACH POLYGON -------------------------------------------------------------------------
                        
        #Filter SWE & Temp to bounding box around SatSkog data (for quicker analysis)
        
                #DEFINE BOUNDING BOX
                        
                        #Get coordinates for bounding box around data
                        trond_box <- st_bbox(satskog)
                        
                        #Construct matrix of coordinates based on bounding box
                        ## Using coordinates as follows:
                        ## xmin, ymin; xmin, ymax; xmax, ymax; xmax, ymin
                        coords <- matrix(c(trond_box[1], trond_box[2],
                                           trond_box[1], trond_box[4],
                                           trond_box[3], trond_box[4],
                                           trond_box[3], trond_box[2],
                                           trond_box[1], trond_box[2]), 
                                         ncol = 2, byrow = TRUE)
                        
                        #Create polygon from coordinates
                        bb_poly <- as(extent(coords), 'SpatialPolygons')
                        
                        #Set CRS for polygon
                        crs(bb_poly) <- crs_ver
                        
                        
                #Convert sf objects to sp objects (for use w/ extract function in loop below)
                        
                        #SatSkog geometry
                        satskog_sp <- as(satskog, Class = "Spatial")
                        
                        #Herbivore density
                        hd1999_sp <- as(hd1999, Class = "Spatial")
                        
                        
                #LOOP THROUGH EACH MONTH OF SENORGE DATA
                        
                        for(i in 1:12){
                                
                                #Grab SWE & Temp RasterLayers for month i from brick
                                swe_month <- subset(swe,i)
                                temp_month <- subset(temp,i)
                                
                                #Crop SWE & Temp based on polygon of bounding box
                                swe_month <- crop(swe_month, bb_poly)
                                temp_month <- crop(temp_month, bb_poly)
                                
                                ## Extract SWE (raster) values based on SatSkog polygons
                                
                                        #Extract values for SWE RasterLayer of month i
                                
                                                #Create title for dataframe column of values
                                                swe_month_title <- paste("SWE_Month_", i, sep = "")                
                                
                                                #Extract values
                                                swe_month_extract <- data.frame(extract(swe_month, satskog_sp, fun = mean))
                                                names(swe_month_extract)[1] <- swe_month_title
                                        
                                        #Cbind vector of SWE values for each polygon (in Jan.) back to sf object dataframe
                                        satskog <- cbind(satskog, swe_month_extract)
                                        
                                        #Plot SWE by plot (with geometry)
                                        plot(satskog$geometry, border = "#f6f6f6", lwd = 0.5, main = swe_month_title)
                                        plot(satskog[swe_month_title], border = F, add = T)
                                        
                                ## Extract Temp (raster) values based on SatSkog polygons
                                        
                                        #Extract values for Temp RasterLayer of month i
                                        
                                                #Create title for dataframe column of values
                                                temp_month_title <- paste("Temp_Month_", i, sep = "")                
                                                
                                                #Extract values
                                                temp_month_extract <- data.frame(extract(temp_month, satskog_sp, fun = mean))
                                                names(temp_month_extract)[1] <- temp_month_title
                                                
                                        #Cbind vector of SWE values for each polygon (in Jan.) back to sf object dataframe
                                        satskog <- cbind(satskog, temp_month_extract)
                                        
                                        #Plot SWE by plot (with geometry)
                                        plot(satskog$geometry, border = "#f6f6f6", lwd = 0.5, main = temp_month_title)
                                        plot(satskog[temp_month_title], border = F, add = T)
                                
                        }
                        
                #REMOVE ALL POLYGONS THAT HAVE NA VALUES FOR SWE AND/OR TEMP
                ## (Since it isn't possible to calculate albedo for these plots)
                
                        #Omit rows w/ NA values
                        satskog <- na.omit(satskog)
                        
                #CONVERT ALL TEMPS FROM C TO KELVIN
                #Convert temps from celsius (C) to kelvin (K)
                for( i in 1:nrow(satskog)){
                        #K = C + 273.15
                        satskog[i, "Temp_Month_1"] <- satskog[i, "Temp_Month_1"] + 273.15
                        satskog[i, "Temp_Month_2"] <- satskog[i, "Temp_Month_2"] + 273.15
                        satskog[i, "Temp_Month_3"] <- satskog[i, "Temp_Month_3"] + 273.15
                        satskog[i, "Temp_Month_4"] <- satskog[i, "Temp_Month_4"] + 273.15
                        satskog[i, "Temp_Month_5"] <- satskog[i, "Temp_Month_5"] + 273.15
                        satskog[i, "Temp_Month_6"] <- satskog[i, "Temp_Month_6"] + 273.15
                        satskog[i, "Temp_Month_7"] <- satskog[i, "Temp_Month_7"] + 273.15
                        satskog[i, "Temp_Month_8"] <- satskog[i, "Temp_Month_8"] + 273.15
                        satskog[i, "Temp_Month_9"] <- satskog[i, "Temp_Month_9"] + 273.15
                        satskog[i, "Temp_Month_10"] <- satskog[i, "Temp_Month_10"] + 273.15
                        satskog[i, "Temp_Month_11"] <- satskog[i, "Temp_Month_11"] + 273.15
                        satskog[i, "Temp_Month_12"] <- satskog[i, "Temp_Month_12"] + 273.15
                }
                        
                #FOR EACH POLYGON, CALCULATE ALBEDO
                        
                        #Source albedo model function
                        source("3_Albedo_Model/albedo_model_volume_regional.R")
                        
                        #Create placeholder columns in main SatSkog df
                        satskog$Month_1_Albedo <- ''
                        satskog$Month_2_Albedo <- ''
                        satskog$Month_3_Albedo <- ''
                        satskog$Month_4_Albedo <- ''
                        satskog$Month_5_Albedo <- ''
                        satskog$Month_6_Albedo <- ''
                        satskog$Month_7_Albedo <- ''
                        satskog$Month_8_Albedo <- ''
                        satskog$Month_9_Albedo <- ''
                        satskog$Month_10_Albedo <- ''
                        satskog$Month_11_Albedo <- ''
                        satskog$Month_12_Albedo <- ''
                        
                        #Loop through each polygon and calculate albedo
                        for(i in 1:nrow(satskog)){
                                
                                print(i)
                                
                                #For each month (1-12), calculate albedo and add to main df
                                for(j in 1:12){
                                        
                                        #Define arguments for albedo function
                                        
                                                #Month = j
                                        
                                                #Total volume
                                        
                                                        #Get m3/ha value
                                                        vol_a <- satskog[i, "vuprha"][[1]]
                                                        
                                                        #Get total plot volume (multiple m3/ha * ha)
                                                        
                                                                #Grab value
                                                                area <- satskog[i, "areal_hekt"][[1]]
                                                                
                                                                #Replace ',' w/ '.' and convert to number
                                                                area <- as.numeric(gsub(',', '.', area))
                                                                
                                                                #Multiply area (ha) * volume/ha
                                                                vol_t <- vol_a*area

                                                #SWE
                                                swe_match <- paste("SWE_Month_", j, sep = "")
                                                swe_a <- satskog[i, swe_match][[1]]

                                                #Temp
                                                temp_match <- paste("Temp_Month_", j, sep = "")
                                                temp_a <- satskog[i, temp_match][[1]]

                                                #Spruce % (convert to proportion)
                                                spr_a <- satskog[i, "gran_pct"][[1]] / 100

                                                #Pine % (convert to proportion)
                                                pin_a <- satskog[i, "furu_pct"][[1]] / 100
                                                
                                                #Birch/Deciduous % (convert to proportion)
                                                bir_a <- satskog[i, "lauv_pct"][[1]] / 100
                                             
                                        
                                        #Run function
                                        output <- albedoVolRegional(month = j,
                                                                    vol = vol_t,
                                                                    temp = temp_a,
                                                                    swe = swe_a,
                                                                    spruce = spr_a,
                                                                    pine = pin_a,
                                                                    birch = bir_a)
                                        
                                        #Place albedo value in correct column (within main SatSkog df)
                                        place <- paste("Month_", j, "_Albedo", sep = "")
                                        satskog[i, place] <- output
                                        
                                } 
                                
                        }
                        
        #Plot January albedo as test
        plot(satskog$geometry, border = "#f6f6f6", lwd = 0.5)
        plot(satskog["Month_1_Albedo"], border = F, add = T)
        
                #Looks good - each polygon has an albedo value
        
        #CONVERT TO SP OBJECT FOR BETTER PLOTTING
        satskog_final_sp <- as(satskog, Class = "Spatial")
        spplot(satskog_final_sp["Month_1_Albedo"], col = NA)
        
        #WRITE SF OBJECT TO CSV FOR LATER USE
        write.csv(satskog, file = '2_Albedo_Regional/Approach_1_SatSkog/Output/Trondheim_Test/trondheim_test.csv', row.names = TRUE)
        
        
#END EXTRACT SENORGE DATA & CALCULATE ALBEDO FOR EACH POLYGON ---------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\                


                
        
#EXTRACT HERBIVORE DENSITY DATA & ADD TO EACH POLYGON -----------------------------------------------------------------

        #Use st_join() to get satskog and herbivore densities together
        sat_herb <- st_join(satskog, hd1999)
        
        #Plot moose density as an example
        plot(sat_herb["Ms_1999"], border = F)
        
                #Looks good - clear separation of moose density based on hd1999 shapefile
        
#END EXTRACT HERBIVORE DENSITY DATA & ADD TO EACH POLYGON -----------------------------------------------------------------
        
        
        
        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\                




#DATA EXPLORATION ----------------------------------------------------------------------------------------------------
  
        #Format columns correctly
        sat_herb$areal_hekt <- as.numeric(gsub(',', '.', sat_herb$areal_hekt))
        
        #ALBEDO --------------------------
        
                #Create proper df

                        #Create vector of column names from satskog to grab
                        ts_col <- c("Month_1_Albedo",
                                    "Month_2_Albedo",
                                    "Month_3_Albedo",
                                    "Month_4_Albedo",
                                    "Month_5_Albedo",
                                    "Month_6_Albedo",
                                    "Month_7_Albedo",
                                    "Month_8_Albedo",
                                    "Month_9_Albedo",
                                    "Month_10_Albedo",
                                    "Month_11_Albedo",
                                    "Month_12_Albedo")
                        
                        #Initialize blank df w/ column names
                        sat_herb_ts <- data.frame("Albedo" = character(), "Month" = integer())
                
                        #Cycle through each column of satskog albedos
                        for(i in 1:length(ts_col)){
                                
                                temp_df <- data.frame(sat_herb[, ts_col[i]][[1]])
                                names(temp_df)[1] <- "Albedo"
                                temp_df$Month <- as.integer(i)
                                
                                sat_herb_ts <- rbind(sat_herb_ts, temp_df)
                        }
                        
                        #Format columns
                        sat_herb_ts$Albedo <- as.numeric(sat_herb_ts$Albedo)
                        sat_herb_ts$Month <- as.integer(sat_herb_ts$Month)
                        
                #Scatterplot
                time_series_albedo_sc <- ggplot(data = sat_herb_ts, aes(x = Month, y = Albedo)) +
                                                geom_point(alpha = 0.4) +
                                                geom_jitter(width = 0.2, alpha = 0.4) +
                                                geom_smooth()
                time_series_albedo_sc
                
                #Bar chart
                sat_herb_ts$Month <- as.factor(sat_herb_ts$Month)
                time_series_albedo_bc <- ggplot(data = sat_herb_ts, aes(x = Month, y = Albedo)) +
                                                        geom_boxplot()
                time_series_albedo_bc
                
                #Histogram
                histogram(sat_herb_ts$Albedo)
                
                
                
        #SENORGE DATA--------------------------
                
                #SWE
                
                        #Format df
                
                                #Create vector of column names from satskog to grab
                                ts_swe <- c("SWE_Month_1",
                                            "SWE_Month_2",
                                            "SWE_Month_3",
                                            "SWE_Month_4",
                                            "SWE_Month_5",
                                            "SWE_Month_6",
                                            "SWE_Month_7",
                                            "SWE_Month_8",
                                            "SWE_Month_9",
                                            "SWE_Month_10",
                                            "SWE_Month_11",
                                            "SWE_Month_12")
                                
                                #Initialize blank df w/ column names
                                sat_herb_ts_swe <- data.frame("SWE" = character(), "Month" = integer())
                                
                                #Cycle through each column of satskog albedos
                                for(i in 1:length(ts_swe)){
                                        
                                        temp_df <- data.frame(sat_herb[, ts_swe[i]][[1]])
                                        names(temp_df)[1] <- "SWE"
                                        temp_df$Month <- as.integer(i)
                                        
                                        sat_herb_ts_swe <- rbind(sat_herb_ts_swe, temp_df)
                                        
                                }
                        
                                #Format columns
                                sat_herb_ts_swe$SWE <- as.numeric(sat_herb_ts_swe$SWE)
                                sat_herb_ts_swe$Month <- as.integer(sat_herb_ts_swe$Month)
                                
                        #Scatterplot
                        time_series_swe_sc <- ggplot(data = sat_herb_ts_swe, aes(x = Month, y = SWE)) +
                                geom_point(alpha = 0.4) +
                                geom_jitter(width = 0.2, alpha = 0.4) +
                                geom_smooth()
                        time_series_swe_sc
                        
                        #Bar chart
                        sat_herb_ts_swe$Month <- as.factor(sat_herb_ts_swe$Month)
                        time_series_swe_bc <- ggplot(data = sat_herb_ts_swe, aes(x = Month, y = SWE)) +
                                geom_boxplot()
                        time_series_swe_bc
                        
                        #Histogram
                        histogram(sat_herb_ts_swe$SWE)
                
                #TEMP
                        
                        #Format df
                        
                                #Create vector of column names from satskog to grab
                                ts_temp <- c("Temp_Month_1",
                                            "Temp_Month_2",
                                            "Temp_Month_3",
                                            "Temp_Month_4",
                                            "Temp_Month_5",
                                            "Temp_Month_6",
                                            "Temp_Month_7",
                                            "Temp_Month_8",
                                            "Temp_Month_9",
                                            "Temp_Month_10",
                                            "Temp_Month_11",
                                            "Temp_Month_12")
                                
                                #Initialize blank df w/ column names
                                sat_herb_ts_temp <- data.frame("Temp" = character(), "Month" = integer())
                                
                                #Cycle through each column of satskog albedos
                                for(i in 1:length(ts_temp)){
                                        
                                        temp_df <- data.frame(sat_herb[, ts_temp[i]][[1]])
                                        names(temp_df)[1] <- "Temp"
                                        temp_df$Month <- as.integer(i)
                                        
                                        sat_herb_ts_temp <- rbind(sat_herb_ts_temp, temp_df)
                                        
                                }
                                
                                #Format columns
                                sat_herb_ts_temp$Temp <- as.numeric(sat_herb_ts_temp$Temp)
                                sat_herb_ts_temp$Month <- as.integer(sat_herb_ts_temp$Month)
                        
                        #Scatterplot
                        time_series_temp_sc <- ggplot(data = sat_herb_ts_temp, aes(x = Month, y = Temp)) +
                                geom_point(alpha = 0.4) +
                                geom_jitter(width = 0.2, alpha = 0.4) +
                                geom_smooth()
                        time_series_temp_sc
                        
                        #Bar chart
                        sat_herb_ts_temp$Month <- as.factor(sat_herb_ts_temp$Month)
                        time_series_temp_bc <- ggplot(data = sat_herb_ts_temp, aes(x = Month, y = Temp)) +
                                geom_boxplot()
                        time_series_temp_bc
                        
                        #Histogram
                        histogram(sat_herb_ts_temp$Temp)
        
                
#END DATA EXPLORATION ----------------------------------------------------------------------------------------------------
                        
                        
                        
                        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\                




#TEST ANALYSIS -------------------------------------------------------------------------------------------------------------
        
        #Get correct form for df
                        
                #Add unique 'polygon ID' to each polygon in sat_herb df
                sat_herb$Polygon_ID <- c(1:nrow(sat_herb))
                        
                #Add placeholder columns to re-add month, temp, swe, and albedo
                sat_herb$Month <- ''
                sat_herb$SWE <- ''
                sat_herb$Temperature_K <- ''
                sat_herb$Albedo <- ''
                        
                #Copy sat_herb df to work with
                        
                        #Create final df to work with (w/ same structure as sat_herb df)
                        trondheim_final <- sat_herb[0,]
                        
                #For each polygon in sat_herb, append corresponding df (12 rows) to trondheim_final
                for( i in 1:max(sat_herb$Polygon_ID) ){
                        
                        print(i)
                        
                        #Create temp_df w/ existing values (12 identical rows)
                        tdf <- sat_herb[sat_herb$Polygon_ID == i, ]
                        tdf <- rbind(tdf, tdf[rep(1, 11), ])
                        
                        #For the polygon, get vector of albedo values (use st_set_geometry to drop geometry column)
                        ## Add to temp df
                        tdf$Albedo <- as.numeric(st_set_geometry(tdf[1, c("Month_1_Albedo",
                                                               "Month_2_Albedo",
                                                               "Month_3_Albedo",
                                                               "Month_4_Albedo",
                                                               "Month_5_Albedo",
                                                               "Month_6_Albedo",
                                                               "Month_7_Albedo",
                                                               "Month_8_Albedo",
                                                               "Month_9_Albedo",
                                                               "Month_10_Albedo",
                                                               "Month_11_Albedo",
                                                               "Month_12_Albedo")], NULL))
                        
                        #For the polygon, get vector of SWE values (drop geo)
                        ## Add to temp df
                        tdf$SWE <- as.numeric(st_set_geometry(tdf[1, c("SWE_Month_1",
                                                                               "SWE_Month_2",
                                                                               "SWE_Month_3",
                                                                               "SWE_Month_4",
                                                                               "SWE_Month_5",
                                                                               "SWE_Month_6",
                                                                               "SWE_Month_7",
                                                                               "SWE_Month_8",
                                                                               "SWE_Month_9",
                                                                               "SWE_Month_10",
                                                                               "SWE_Month_11",
                                                                               "SWE_Month_12")], NULL))
                        
                        #For the row i, get vector of Temperature values (drop geo)
                        ## Add to temp df
                        tdf$Temperature_K <- as.numeric(st_set_geometry(tdf[1, c("Temp_Month_1",
                                                                                "Temp_Month_2",
                                                                                "Temp_Month_3",
                                                                                "Temp_Month_4",
                                                                                "Temp_Month_5",
                                                                                "Temp_Month_6",
                                                                                "Temp_Month_7",
                                                                                "Temp_Month_8",
                                                                                "Temp_Month_9",
                                                                                "Temp_Month_10",
                                                                                "Temp_Month_11",
                                                                                "Temp_Month_12")], NULL))
                        
                        #Add month (1:12) to temp df
                        tdf$Month <- as.integer(1:12)
                        
                        #Rbind to 'final' df
                        trondheim_final <- rbind(trondheim_final, tdf)
                        
                        
                }

                        
                #Drop old columns for temp, SWE, and albedo
                        
                        #Get column index for first column to drop
                        col_min <- grep("SWE_Month_1", colnames(trondheim_final))[1]
                        col_max <- grep("Month_12_Albedo", colnames(trondheim_final))[1]
                        
                        #Drop columns
                        trondheim_final <- trondheim_final[,c(1:(col_min - 1), (col_max + 1):109)]
                                
        #Test for spatial autocorrelation (Using Month 1 (Jan) only, and original dataset)           
                
                w <- poly2nb(sat_herb, row.names=sat_herb$Polygon_ID)
                class(w)
                summary(w)
                
                #Create a 'listw' type spatial weights object
                ww <- nb2listw(w, style='B', zero.policy = F)
                
                #Compute Moran's I metric for spatial autocorrelation
                ##Note: this is a recommended method w/ Monte-Carlo simulations
                M1 <- moran.mc(as.numeric(sat_herb$Month_1_Albedo), ww, nsim=99)
                M1
                plot(M1)
                                    
        
        
        #Assess spatial autocorrelation in data
                        
        #Model?
                        
#END TEST ANALYSIS ---------------------------------------------------------------------------------------------------------- 
        
        