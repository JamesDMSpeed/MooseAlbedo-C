## This is a script to process spatial raster data from the SatSkog data product, large herbivore density data,
## and seNorge temp + SWE data


#PACKAGES ----------------------------------------------------------------------

        #Data Manipulation + Visualization
        library(ggplot2)
        library(raster)
        library(rasterVis)
        library(dplyr)

        #Spatial Data Packages
        library(sf)
        library(tmap)
        library(broom)

        #Packages for netCDF files
        library(ncdf4)
        library(chron)
        library(reshape2)

#END PACKAGES ----------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#INITIAL DATA IMPORT ----------------------------------------------------------------------------------------------

        #SustHerb Herbivore Spatial Data

                #Read in vector data w/ sf package
                hd_shp <- st_read("2_Albedo_Regional/Data/Herbivore_Densities/NorwayLargeHerbivores.shp")
                
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

                        
                        
                        
#TRONDHEIM TEST ----------------------------------------------------------------------------------------------
                        
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
        write.csv(satskog, file = '2_Albedo_Regional/Approach_1_SatSkog/Output/Analysis/satskog_with_albedo.csv', row.names = TRUE)
        
        
#END TRONDHEIM TEST -------------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\                


                

        