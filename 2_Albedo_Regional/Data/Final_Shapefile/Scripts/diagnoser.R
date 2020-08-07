library(sf)
library(raster)

##DIAGNOSE MISSING DATA - WHICH KOMMUNES ARE MISSING OR HAVE INVALID ALBEDO VALUES?

#GET DATA FROM FINAL SHAPEFILE --------------------------------------------------------------------

        #Identify kommunes w/ missing data
        final_shp <- st_read("2_Albedo_Regional/Data/Final_Shapefile/Output/ready_for_analysis/full_resolution/final_shapefile.shp")
        missing <- final_shp$NAVN[final_shp$Mnt_1_A <= 0]
        missing <- as.factor(missing)
        missing_names <- levels(missing)
        
        
## SET NAME OF KOMMUNE TO INVESTIGATE --------------------------------------------------------------------
        
        #Set kommune name here
        the_name <- "Oslo"
        
        #Get already-written shapefile
        oslo <- st_read("2_Albedo_Regional/Data/Spatial_Data/Output/Osen/Osen_processed.shp")


#PRE-PROCESSING FOR DIAGNOSING --------------------------------------------------------------------

        #Define directory path to Satskog file for desired kommune
        dir <- paste("2_Albedo_Regional/Data/Spatial_Data/SatSkog/", the_name, sep = "")
        
        #SATSKOG DATA
        
                #Set age limit of 30 (max age of forest in polygons)
                age_limit <- 30
        
        #HERBIVORE DENSITY DATA
        
                #Read in vector data of herbivore densities w/ sf package
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
                
                #Predefine df's of herbivore densities (1999, 2009, 2015) to speed up processing
                hd1999 <- hd_shp[,c(1:9, grep("W__1999", colnames(hd_shp)):grep("WP_1999", colnames(hd_shp)))]
                hd2009 <- hd_shp[,c(1:9, grep("W__2009", colnames(hd_shp)):grep("WP_2009", colnames(hd_shp)))]
                hd2015 <- hd_shp[,c(1:9, grep("W__2015", colnames(hd_shp)):grep("WP_2015", colnames(hd_shp)))]
                
                #Predefine vector of potential years (to speed up processing)
                herb_years <- c(1999, 2009, 2015)
                
                #Predefine vector of column names (these will be used to remove '_Year' from existing
                #column names, in order to row bind densities from different years)
                herb_cols <- c('W_Density',
                               'S_Density',
                               'Ms_Density',
                               'Rd_Density',
                               'R_d_Density',
                               'M_Density',
                               'Sh_Density',
                               'Cw_Density',
                               'Hf_Density',
                               'Gt_Density',
                               'Hr_Density',
                               'Tt_Density',
                               'Ct_Density',
                               'al_Density',
                               'Lv_Density',
                               'Wl_Density',
                               'WP_Density')
        
        #MISC 
        
                #Define function to get FIRST n characters of a string (used in loop below)
                substrLeft <- function(x, n){
                        substr(x, 1, n)
                }
                
                #Define function to get LAST n characters of a string (used in loop below)
                substrRight <- function(x, n){
                        substr(x, nchar(x)-n+1, nchar(x))
                }
                
                #Source albedo model function
                source("3_Albedo_Model/albedo_model_volume_regional.R")





## PROCESS KOMMUNE --------------------------------------------------------------------
        
        #Print directory
        print(dir)
                
        #Construct directory path
        
        #Get name of direct parent directory (to write files later on in loop)
        dir_base <- strsplit(dir, split = "/")
        dir_base <- dir_base[[1]][length(dir_base[[1]])]
        
        #Get base working directory (to reset to later on in loop)
        wd <- getwd()
                
        #Define output path
        output_path <- paste("2_Albedo_Regional/Data/Spatial_Data/Output/",
                             dir_base,
                             '/',
                             sep = '')
                
                        
                        #SATSKOG SHAPEFILE ------------
                        
                                #Load shapefile
                                
                                #Grab shapefile from subdirectory (w/ .shp extension)
                                file <- list.files(path = dir, pattern="*.shp", full.names=TRUE, recursive=FALSE)
                        
                                #Read shapefile w/ st_read()
                                satskog <- st_read(file)
                        
                        #ERROR HANDLER - if nrow(SatSkog) >0, continue
                        if( nrow(satskog) > 0 ){
                                
                                #Filter SatSkog forest polygons to intended polygons
                                
                                #Remove rows w/ age less than 1 (likely invalid observations)
                                satskog <- satskog[satskog$alder > 0, ]
                                
                                #Remove observations with 'reduced' quality images (which may affect accuracy of data)
                                satskog <- satskog[satskog$kvalitet != "redusert" | is.na(satskog$kvalitet),]
                                
                                #Filter to 'Clear Sky' observations ('ikke_sky') 
                                satskog <- satskog[satskog$class_sky == 'ikke_sky' | satskog$class_sky == "1.#INF",]
                                
                                #Filter pixels with NDVI of 0 (which might indicate non-vegetative pixels)
                                satskog <- satskog[satskog$ndvi > 0,]
                                
                                #Filter to 'younger' forest
                                
                                #Filter to observations between age 1 and 'age limit'
                                satskog <- satskog[satskog$alder <= age_limit,]
                                
                                ##ERROR HANDLER - Does satskog still have rows after filtering?
                                if( nrow(satskog) > 0 ){
                                        
                                        #Determine years of SatSkog pictures (which will be used to select closest herb. data + seNorge data)
                                        
                                        #Convert 'bildedato' to factor
                                        satskog$bildedato <- as.factor(satskog$bildedato)
                                        
                                        #Get 'bildedato' dates in vector
                                        pic_dates <- levels(satskog$bildedato)
                                        
                                        #Project all spatial data on to UTM33 CRS (Same as SatSkog product)
                                        
                                        #Set desired CRS as variable (using the SatSkog CRS as a base)
                                        st_crs_ver <- st_crs(satskog)
                                        crs_ver <- crs(satskog)
                                        
                                        #Define bounding box around shapefile (which will be used to filter raster seNorge data
                                        #and speed up processing)
                                        
                                        #Get coordinates for bounding box around data
                                        box <- st_bbox(satskog, crs = crs_ver)
                                        
                                        #Construct matrix of coordinates based on bounding box
                                        ## Using coordinates as follows:
                                        ## xmin, ymin; xmin, ymax; xmax, ymax; xmax, ymin
                                        coords <- matrix(c(box[1], box[2],
                                                           box[1], box[4],
                                                           box[3], box[4],
                                                           box[3], box[2],
                                                           box[1], box[2]), 
                                                         ncol = 2, byrow = TRUE)
                                        
                                        #Create polygon from coordinates
                                        bb_poly <- as(extent(coords), 'SpatialPolygons')
                                        
                                        #Set CRS for polygon (UTM33 - same as SatSkog)
                                        crs(bb_poly) <- crs_ver
                                        
                                        
                                        ##FOR EACH PICTURE DATE, PROCESS ACCORDINGLY (USE CORRESPONDING SENORGE DATA + HERB. DENSITY DATA)
                                        
                                        #Set iterator 
                                        k <- 1
                                        
                                        for(date in pic_dates){
                                                
                                                print(date)
                                                
                                                #GET FULL YEAR FOR SATSKOG PICTURE ----------------
                                                
                                                #Isolate last two characters (i.e 2-digit year)
                                                year <- substrRight(date, 2)
                                                
                                                #Convert to full 4 digit year code
                                                if(year > 20){
                                                        year <- paste("19", year, sep = "")
                                                } else {
                                                        year <- paste("20", year, sep = "")
                                                }
                                                
                                                
                                                #SENORGE ------------
                                                
                                                #Load in seNorge files of year corresponding to picture
                                                
                                                #Load in SWE as RasterBrick (corresponding to year of SatSkog picture)
                                                swe <- brick(paste("2_Albedo_Regional/Data/seNorge/Output/SWE/swe_means_", year, "_all_norway.tif", sep = ""))
                                                
                                                #Load in temp data as RasterBrick (corresponding to year of SatSkog picture)
                                                temp <- brick(paste("2_Albedo_Regional/Data/seNorge/Output/Temperature/temp_means_", year, "_all_norway.tif", sep = ""))
                                                
                                                
                                                #HERBIVORE DENSITIES ------------
                                                
                                                #Define df w/ herbivore densities from closest year
                                                
                                                #Chose closest year from pre-defined vector
                                                herb_year <- herb_years[which.min(abs(herb_years - as.numeric(year)))]
                                                
                                                #Choose relevant pre-defined df from global environment
                                                herb <- get(paste("hd", herb_year, sep=""), envir = .GlobalEnv)
                                                
                                                #Rename/generalize herbivore density columns
                                                # (to allow row binding of densities from different years)
                                                colnames(herb)[10:26] <- herb_cols
                                                
                                                #Add 'herb year' as a new variable/column
                                                herb$Herb_year <- as.integer(herb_year)
                                                
                                                
                                                #CRS PROJECTION ------------
                                                
                                                #Change CRS to same as SatSkog
                                                
                                                #Herbivore density data
                                                herb <- st_transform(herb, crs = st_crs_ver)
                                                
                                                #SWE
                                                proj4string(swe) <- crs_ver
                                                
                                                #Temperature
                                                proj4string(temp) <- crs_ver
                                                
                                                
                                                #CREATE SATSKOG SUBSET FOR CORRESPONDING DATE ------------
                                                
                                                #Create subset of polygons from corresponding bildedato
                                                satskog_sub <- satskog[satskog$bildedato == date,]
                                                
                                                #Convert sf object to sp object (required for use w/ raster extract function)
                                                
                                                #SatSkog shapefile to sp object
                                                satskog_sub_sp <- as(satskog_sub, Class = "Spatial")
                                                
                                                
                                                #EXTRACT SENORGE DATA FOR EACH POLYGON ------------
                                                
                                                #Loop through each month of seNorge data and extract SWE + Temp for each polygon
                                                ##NOTE: For polygons that share multiple seNorge tiles, means of SWE + Temp are calculated
                                                
                                                #Pre-initialize vectors to store extracted values (equiv. to # of SatSkog subset polygons)
                                                #swe_month_extract <- vector(, length = nrow(satskog_sub))
                                                #temp_month_extract <- vector(, length = nrow(satskog_sub))                        
                                                
                                                #Loop
                                                for(i in 1:12){
                                                        
                                                        print(paste("Month ", i, sep = ""))
                                                        
                                                        #Grab SWE & Temp RasterLayers for month i from brick
                                                        swe_month <- subset(swe,i)
                                                        temp_month <- subset(temp,i)
                                                        
                                                        print("Subset")
                                                        
                                                        #Crop SWE & Temp based on polygon of bounding box
                                                        swe_month <- crop(swe_month, bb_poly)
                                                        temp_month <- crop(temp_month, bb_poly)
                                                        
                                                        print("Cropped")
                                                        
                                                        ## Extract SWE (raster) values based on SatSkog polygons
                                                        
                                                        #Extract values for SWE RasterLayer of month i
                                                        
                                                        #Create title for dataframe column of values
                                                        swe_month_title <- paste("SWE_Month_", i, sep = "")                
                                                        
                                                        #Extract values
                                                        swe_month_extract <- data.frame(extract(swe_month, satskog_sub_sp, fun = mean))
                                                        
                                                        #Error handler - if extract() returns no values, add NA to df
                                                        if( nrow(swe_month_extract) == 0 ){
                                                                
                                                                #Not able to extract value - add as NA instead
                                                                swe_month_extract[1,1] <- NA
                                                                
                                                        }
                                                        
                                                        #Add name to df column
                                                        names(swe_month_extract)[1] <- swe_month_title
                                                        
                                                        #Cbind vector of SWE values for each polygon (in Jan.) back to sf object dataframe
                                                        satskog_sub <- cbind(satskog_sub, swe_month_extract)
                                                        
                                                        print("Extracted and binded SWE")
                                                        
                                                        
                                                        ## Extract Temp (raster) values based on SatSkog polygons
                                                        
                                                        #Extract values for Temp RasterLayer of month i
                                                        
                                                        #Create title for dataframe column of values
                                                        temp_month_title <- paste("Temp_Month_", i, sep = "")                
                                                        
                                                        #Extract values
                                                        temp_month_extract <- data.frame(extract(temp_month, satskog_sub_sp, fun = mean))
                                                        
                                                        #Error handler - if extract() returns no values, add NA to df
                                                        if( nrow(temp_month_extract) == 0 ){
                                                                
                                                                #Not able to extract value - add as NA instead
                                                                temp_month_extract[1,1] <- NA
                                                                
                                                        }
                                                        
                                                        names(temp_month_extract)[1] <- temp_month_title
                                                        
                                                        #Convert to Kelvin (K = C + 273.15)
                                                        temp_month_extract <- temp_month_extract + 273.15
                                                        
                                                        #Cbind vector of SWE values for each polygon (in Jan.) back to sf object dataframe
                                                        satskog_sub <- cbind(satskog_sub, temp_month_extract)
                                                        
                                                        print("Extracted and binded Temp")
                                                        
                                                } #END Extract Temp + SWE Loop
                                                
                                                #Remove all rows from Satskog file that have NAs
                                                ## (Since it isn't possible to calculate albedo for these plots)
                                                
                                                #Omit rows w/ NA values
                                                satskog_sub <- satskog_sub[!is.na(satskog_sub$alder) &
                                                                                   !is.na(satskog_sub$vuprha) &
                                                                                   !is.na(satskog_sub$SWE_Month_1) &
                                                                                   !is.na(satskog_sub$SWE_Month_2) &
                                                                                   !is.na(satskog_sub$SWE_Month_3) &
                                                                                   !is.na(satskog_sub$SWE_Month_4) &
                                                                                   !is.na(satskog_sub$SWE_Month_5) &
                                                                                   !is.na(satskog_sub$SWE_Month_6) &
                                                                                   !is.na(satskog_sub$SWE_Month_7) &
                                                                                   !is.na(satskog_sub$SWE_Month_8) &
                                                                                   !is.na(satskog_sub$SWE_Month_9) &
                                                                                   !is.na(satskog_sub$SWE_Month_10) &
                                                                                   !is.na(satskog_sub$SWE_Month_11) &
                                                                                   !is.na(satskog_sub$SWE_Month_12),]
                                                
                                                
                                                #CALCULATE ALBEDO FOR EACH POLYGON ------------
                                                ##ERROR HANDLER: Only run this step if there are >0 polygons left
                                                
                                                if( nrow(satskog_sub) > 0 ){
                                                        
                                                        #Create placeholder columns in main SatSkog df
                                                        satskog_sub$Month_1_Albedo <- ''
                                                        satskog_sub$Month_2_Albedo <- ''
                                                        satskog_sub$Month_3_Albedo <- ''
                                                        satskog_sub$Month_4_Albedo <- ''
                                                        satskog_sub$Month_5_Albedo <- ''
                                                        satskog_sub$Month_6_Albedo <- ''
                                                        satskog_sub$Month_7_Albedo <- ''
                                                        satskog_sub$Month_8_Albedo <- ''
                                                        satskog_sub$Month_9_Albedo <- ''
                                                        satskog_sub$Month_10_Albedo <- ''
                                                        satskog_sub$Month_11_Albedo <- ''
                                                        satskog_sub$Month_12_Albedo <- ''
                                                        
                                                        #Loop through each polygon and calculate albedo
                                                        for(i in 1:nrow(satskog_sub)){
                                                                
                                                                print(i)
                                                                
                                                                #For each month (1-12), calculate albedo and add to main df
                                                                for(j in 1:12){
                                                                        
                                                                        #Define arguments for albedo function
                                                                        
                                                                        #Month = j
                                                                        
                                                                        #Total volume
                                                                        
                                                                        #Get m3/ha value
                                                                        vol_a <- satskog_sub[i, "vuprha"][[1]]
                                                                        
                                                                        #Get total plot volume (multiple m3/ha * ha)
                                                                        
                                                                        #Grab value
                                                                        area <- satskog_sub[i, "areal_hekt"][[1]]
                                                                        
                                                                        #Replace ',' w/ '.' and convert to number
                                                                        area <- as.numeric(gsub(',', '.', area))
                                                                        
                                                                        #Multiply area (ha) * volume/ha
                                                                        vol_t <- vol_a*area
                                                                        
                                                                        #SWE
                                                                        swe_match <- paste("SWE_Month_", j, sep = "")
                                                                        swe_a <- satskog_sub[i, swe_match][[1]]
                                                                        
                                                                        #Temp
                                                                        temp_match <- paste("Temp_Month_", j, sep = "")
                                                                        temp_a <- satskog_sub[i, temp_match][[1]]
                                                                        
                                                                        #Spruce % (convert to proportion)
                                                                        spr_a <- satskog_sub[i, "gran_pct"][[1]] / 100
                                                                        
                                                                        #Pine % (convert to proportion)
                                                                        pin_a <- satskog_sub[i, "furu_pct"][[1]] / 100
                                                                        
                                                                        #Birch/Deciduous % (convert to proportion)
                                                                        bir_a <- satskog_sub[i, "lauv_pct"][[1]] / 100
                                                                        
                                                                        #Run albedo function & save results to 'output' df
                                                                        output <- albedoVolRegional(month = j,
                                                                                                    vol = vol_t,
                                                                                                    temp = temp_a,
                                                                                                    swe = swe_a,
                                                                                                    spruce = spr_a,
                                                                                                    pine = pin_a,
                                                                                                    birch = bir_a)
                                                                        
                                                                        #Place albedo value in correct column (within main SatSkog df)
                                                                        place <- paste("Month_", j, "_Albedo", sep = "")
                                                                        satskog_sub[i, place] <- output
                                                                        
                                                                } 
                                                                
                                                        }
                                                        
                                                        
                                                        #FINAL CHANGES TO DF ------------
                                                        
                                                        #Add 'year' variable (year of seNorge data) to df
                                                        satskog_sub$Senorge_year <- year
                                                        
##### THIS MAY BE WHERE ISSUE IS - INCORRECT JOINING                                                        
                                                        
                                
                                                        #JOIN herbivore density data w/ satskog using st_join
                                                        #Use st_join() to get satskog and herbivore densities together
                                                        satskog_sub <- st_join(satskog_sub, herb)
                                                        
                                                        satskog_join <- st_join(satskog_sub, herb)
                                                                #THIS WORKED - WHAT IS GOING ON?
                                                        
                                                        #JOIN SATSKOG SUBSETS ------------
                                                        
                                                        #Check iterator (is this date #2, #3, etc?)
                                                        if(k == 1){
                                                                
                                                                satskog_final <- satskog_sub   
                                                                
                                                        } else if (k > 1){
                                                                
                                                                satskog_final <- rbind(satskog_final, satskog_sub)
                                                                
                                                        }
                                                        
                                                }               
                                                
                                                #Iterate
                                                k <- k + 1
                                                
                                        } #END LOOP FOR EACH BILDODATE
                                        
                                } else {
                                        
                                        #After filtering, SatSkog has 0 rows - set up for conditional below
                                        satskog_final <- satskog
                                        
                                } #End conditional loop
                                
                                
                        }

                        
#COMPARE TO ACTUAL SAVED SHAPEFILE
actual <- st_read(paste("2_Albedo_Regional/Data/Spatial_Data/Output/", the_name, "/", the_name, "_processed.shp", sep = ""))


#KEY POINT - SOMETHING HAPPENED WHILE COMBINING SHAPEFILES
# EACH INDIVIDUAL SHAPEFILE APPEARS TO BE FINE, BUT IN THE UNIFIED FILE, THINGS LOOK STRANGE AND A TON 
# OF NA'S ARE ADDED
