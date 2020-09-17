## This is a script to visualize the processed and unified atSkog spatial dataset in Norway (attempt #2)
## It also has some steps to attempt to cluster the data based on SWE/Temp, age, and elevation


#PACKAGES ----------------------------------------------------------------------

        #Spatial Data Packages
        library(sf)
        library(tmap)
        library(broom)
        
        #Data Manipulation + Visualization
        library(ggplot2)
        library(raster)
        library(lattice)
        library(dplyr)
        library(data.table)
        library(hexbin)
        library(RColorBrewer)
        library(wesanderson)
        library(foreach)
        library(beepr)
        library(rgl)
        library(corrgram)
        library(corrplot)
        library(feather)

        #Clustering
        library(HiClimR)
        library(ncdf4)

        

      
#END PACKAGES ----------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#IMPORT DATA --------------------------------------------------------------------------------------------------

        #Load unified & FILTERED shapefile w/ all variables
        data <- st_read("2_Albedo_Regional/Data/Final_Shapefile/Output/attempt_2/full_resolution/final_shapefile_v2.shp")
        
        #Remove duplicate geometries
        data <- distinct(data, .keep_all = T)
        beep(5)
        
        #Looks like there are some null values for elevation (-9999) - reassign as NA
        data$dem[data$dem < 0] <- NA
        
        #Filter to 1999 only
        data1999 <- data[data$Snrg_yr == 1999,]  #This reduced the dataset by >40%
        rm(data)
        
        

#END IMPORT DATA --------------------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#HICLIMR CLUSTERING ------------------------------------------------------------------------------

        #Attempting to use HiClimR package to cluster data
        #Source: https://github.com/hsbadr/HiClimR  - Badr et al. (2015)
        

        #1 - Clustering by spatiotemporal SWE data for each polygon
        
                #Data is entered as a matrix (N spatial elements x M observations)
                
        #2 - Multivariate Clustering (MVC) implementation - SWE, Temp, and Age?
        
                #For MVC, each variable to cluster by is stored as a UNIQUE MATRIX (in a list)
                #N spatial elements x M observations (i.e. represents spatiotemporal data)


        #STEP 1: PREP DATA FOR CLUSTERING
        
                #Copy of data
                db <- data1999
        
                #Filter to relevant columns
                db <- db[ ,c(1,14,42,43:102,112:129)]
                
                #Remove rows with NA values for these variables
                db <- na.omit(db)
                
                #What is CRS of data? Should be UTM33N
                st_crs(db) #Is UTM33N
                st_is_longlat(db) #FALSE
                
                        #NEED TO PROJECT TO LAT AND LON FOR HICLIMR FUNCTION
                        new_crs <- "+proj=longlat +datum=WGS84"
                        db <- st_transform(db, crs = new_crs)
                        
                                #Verify is lat lon now
                                st_is_longlat(db) #TRUE
                
                #Compute centroids for all polygons (grabs centroids from largest polygons)
                centroids <- st_centroid(st_geometry(db), of_largest_polygon = TRUE)
                st_crs(centroids)
                
                #Grab coordinates of centroids (Latitude + Longitude)
                coords <- as.data.frame(st_coordinates(centroids))
                
                #Bind centroid coordinates with data
                db <- cbind(db, coords)
                beep(8)

        
        #STEP 2: TEST CASE WITH EXISTING DATA FROM PACKAGE
                
                #Necessary to define data of interest as matrix
                x <- TestCase$x
                
                #Define lat and lon as numeric vectors
                lon <- TestCase$lon
                lat <- TestCase$lat
        
                #Run function
                y <- HiClimR(x, lon = lon, lat = lat, lonStep = 1, latStep = 1, geogMask = FALSE,
                             country = "NOR", meanThresh = 10, varThresh = 0, detrend = TRUE,
                             standardize = TRUE, nPC = NULL, method = "ward", hybrid = FALSE, kH = NULL,
                             members = NULL, nSplit = 1, upperTri = TRUE, verbose = TRUE,
                             validClimR = TRUE, k = 12, minSize = 1, alpha = 0.01,
                             plot = TRUE, colPalette = NULL, hang = -1, labels = FALSE)
                
                        #Sample code successfully gives output - let's run with our data
                        
        #STEP 3: TRY CLUSTERING WITH ACTUAL DATA (UNIVARIATE CLUSTERING)
                        
                ##Try a test with only SWE data (12 months)
                
                        #Define x as matrix - include all 12 months of SWE data
                        x <- as.matrix(st_drop_geometry(db[,c(3,5,7,9,11,13,15,17,19,21,23,25)]))
                        
                        #Define lat and lon as numeric vectors (removing duplicate values and rounding to 2 decimal places)
                        lat <- as.numeric(round(db$Y, digits = 3))
                        lon <- as.numeric(round(db$X, digits = 3))
                        
                        #Run function with base settings
                        y <- HiClimR(x, lon = lon, lat = lat, lonStep = 2, latStep = 2, geogMask = TRUE,
                                     country = "NOR", meanThresh = 10, varThresh = 0, detrend = F,
                                     standardize = TRUE, nPC = NULL, method = "ward", kH = NULL,
                                     members = NULL, nSplit = 5, upperTri = TRUE, verbose = TRUE,
                                     validClimR = TRUE, k = 12, minSize = 1, alpha = 0.01,
                                     plot = TRUE, colPalette = NULL, hang = -1, labels = FALSE)
                        
                                #Set detrend to F (was getting error while detrending)
                                #Vector memory exhausted while computing correlation dissimilarity matrix
                        
##I THINK my current dataset has WAY TOO MANY elements to work with this function - I'm going to try and do the
##try clustering based on SWE alone (gridded SWE monthly averages from 1999)
                        
        #If this works, I might also try using additional variables at the same spatial resolution (temperature)

##I can then create a gridded raster of "clusters", which I can then combine with the forest polygon data
##(via st_join function)
                        
                        
        #PREPARE SWE DATA (1999) FOR CLUSTERING
                        
                #Load in RasterBrick
                swe <- brick("2_Albedo_Regional/Data/seNorge/Output/SWE/swe_means_1999_all_norway.tif")
        
                #Transform CRS from UTM33 to Lat/Lon
                swe <- projectRaster(swe, crs = new_crs)
                crs(swe)
            
                #Plot January SWE to verify re-projection
                swe_jan <- subset(swe, 1)
                plot(swe_jan) #Looks slightly weird - seems OK for clustering purposes, though
                
        #TRY CLUSTERING WITH SWE ONLY
                
                #Get SWE values as appropriate matrix (N grid cells x M months)
                mat <- values(swe) #526539 rows(i.e. 526539 cells)
                
                #Remove all observations from cells with NA values (to reduce matrix size)
                mat <- na.omit(mat) #HUGE reduction
                
                #Get coordinates
                points <- rasterToPoints(swe) #526539 rows (i.e. 526539 cells) - SAME AS ABOVE (looks like NAs were removed)
                lat <- points[,2]
                lon <- points[,1]
                
                #Try running HiClimR function
                y <- HiClimR(mat, lon = lon, lat = lat, lonStep = 5, latStep = 5, geogMask = TRUE,
                             country = "NOR", meanThresh = 10, varThresh = 0, detrend = F,
                             standardize = TRUE, nPC = NULL, method = "ward", kH = NULL,
                             members = NULL, nSplit = 10000, upperTri = TRUE, verbose = TRUE,
                             validClimR = TRUE, k = 12, minSize = 1, alpha = 0.01,
                             plot = TRUE, colPalette = NULL, hang = -1, labels = FALSE)
                
                        #STILL exhausting vector memory - what if I try aggregating the SWE dataset to a 
                        #coarser spatial resolution (to reduce size)?
                
                
        #AGGREGATE SWE to coarser SWE w/ fact = 4 and using 'max' function
        swe_agg <- aggregate(swe, fact = 4, FUN = "max")
        
                #Plot subset to verify
                plot(subset(swe_agg, 1))
                
                #Try running HiClimR again
        
                        #Get SWE values as appropriate matrix (N grid cells x M months)
                        mat <- values(swe_agg) 
                        
                        #Remove all observations from cells with NA values (to reduce matrix size)
                        mat <- na.omit(mat) #34962 rows (i.e. 34962 cells w/o NAs)
                        
                        #Get coordinates
                        points <- rasterToPoints(swe_agg) #349629 rows (i.e. 34962 cells) - SAME AS ABOVE (looks like NAs were removed)
                        lat <- points[,2]
                        lon <- points[,1]
                        
                        #Try running HiClimR function 
                        
                                #Using "regional" method (which determines optimum # of clusters w/ alpha = 0.05)
                                y <- HiClimR(mat, lon = lon, lat = lat, lonStep = 1, latStep = 1, geogMask = TRUE,
                                             country = "NOR", meanThresh = 10, varThresh = 0, detrend = F,
                                             standardize = TRUE, nPC = NULL, method = "regional", hybrid = FALSE, kH = NULL,
                                             members = NULL, nSplit = 10, upperTri = TRUE, verbose = TRUE,
                                             validClimR = TRUE, k = NULL, minSize = 1, alpha = 0.05,
                                             plot = TRUE, colPalette = NULL, hang = -1, labels = FALSE)
                                
                                beep(8)
                                
                                        #FINDINGS: NOT ABLE to cluster well with alpha of 0.05 (only resolves into
                                        #2 clusters). Going to try to cluster using standard "ward" method (w/
                                        #default # of clusters - k=12)
                                
                                
                                #Using default "ward" method (with k = 12 clusters)
                                y <- HiClimR(mat, lon = lon, lat = lat, lonStep = 1, latStep = 1, geogMask = TRUE,
                                             country = "NOR", meanThresh = 10, varThresh = 0, detrend = F,
                                             standardize = TRUE, nPC = NULL, method = "ward", hybrid = FALSE, kH = NULL,
                                             members = NULL, nSplit = 10, upperTri = TRUE, verbose = TRUE,
                                             validClimR = TRUE, k = 12, minSize = 1, alpha = 0.05,
                                             plot = TRUE, colPalette = NULL, hang = -1, labels = FALSE)
                                
                                beep(8)
                                
                                        #Subjectively investigate dendrogram to estimate optimum # of clusters
                                        plot(y)
                                        
                                                #Looks like 2 is ideal - this reminds me of what
                                                #happened w/ the k-means clustering (i.e. way fewer clusters
                                                #than I thought would be relevant)
                                        
                                                #Maybe I need to add temperature data (or other variables), too?
                                        
                                        
                                #Using default "ward" method (with k = 12 clusters)
                                #NOTE: Adding a spatial contiguity constraint of 0.5 (is there any difference?)
                                y <- HiClimR(mat, lon = lon, lat = lat, lonStep = 1, latStep = 1, geogMask = TRUE,
                                             country = "NOR", contigConst = 0.5, meanThresh = 10, varThresh = 0, detrend = F,
                                             standardize = TRUE, nPC = NULL, method = "ward", hybrid = FALSE, kH = NULL,
                                             members = NULL, nSplit = 10, upperTri = TRUE, verbose = TRUE,
                                             validClimR = TRUE, k = 12, minSize = 1, alpha = 0.05,
                                             plot = TRUE, colPalette = NULL, hang = -1, labels = FALSE)
                                
                                beep(8)
                                
                                        #Pretty similar to above (i.e. spatial contiguity constraint doesn't affect
                                        #number of clusters)
                                

#GOING TO TRY MULTIVARIATE CLUSTERING WITH TEMPERATURE 
                                        
        #PREPARE TEMP DATA (1999) FOR CLUSTERING
        
                #Load in RasterBrick
                temp <- brick("2_Albedo_Regional/Data/seNorge/Output/Temperature/temp_means_1999_all_norway.tif")
                
                #Transform CRS from UTM33 to Lat/Lon
                temp <- projectRaster(temp, crs = new_crs)
                crs(temp)
                
                #Plot January SWE to verify re-projection
                temp_jan <- subset(temp, 1)
                plot(temp_jan) #Looks slightly weird - seems OK for clustering purposes, though                                                        
                
                #AGGREGATE TEMP to coarser resolution w/ fact = 4 and using 'max' function
                temp_agg <- aggregate(temp, fact = 4, FUN = "max")
                
                        #Verify that aggregation worked
                        plot(subset(temp_agg, 1))
                
                #Reset SWE matrix 
                mat <- values(swe_agg)
                
                        #Replace NaN w/ NA
                        mat[is.nan(mat)] <- NA
                
                
                #Get temp values as appropriate matrix (N grid cells x M months)
                mat2 <- values(temp_agg) 
                
                        #Replace NaN w/ NA
                        mat2[is.nan(mat2)] <- NA
                
                        #NOTE: Both SWE and Temp matrices should have SAME # of rows
                
                #Get coordinates for ALL CELLS
                
                        #Grab XY values for one slice of temp_agg
                        num_cells <- dim(subset(temp_agg, 1))[1] * dim(subset(temp_agg, 1))[2]
                        points <- xyFromCell(subset(temp_agg, 1), cell = 1:num_cells)
                        lat <- points[,2]
                        lon <- points[,1]
                
        #RUN MULTIVARIATE CLUSTERING W/ SWE and TEMP
        y <- HiClimR(x = list(mat, mat2), lon = lon, lat = lat, lonStep = 1, latStep = 1, geogMask = F,
                     country = "NOR", meanThresh = list(NULL, NULL), varThresh = list(0,0), detrend = list(F,F),
                     standardize = list(T,T), weightMVC = list(1,1), nPC = NULL, method = "ward", hybrid = FALSE, kH = NULL,
                     members = NULL, nSplit = 1, upperTri = TRUE, verbose = TRUE,
                     validClimR = TRUE, k = 12, minSize = 1, alpha = 0.05,
                     plot = TRUE, colPalette = NULL, hang = -1, labels = FALSE)
        beep(8)
            
        
         
        
        
        
        
           
#--------------------------------------
##SOMETHING WRONG WITH COORDINATES:
        # SHOULD COMBINE TEMP AND SWE INTO 12 LAYER BRICK AND THEN CROP, MASK, & REMOVE ALL CELLS (IN ALL LAYERS)
        # THAT HAVE NA'S IN 1 OR MORE LAYERS (i.e. make sure there are the same number of valid cells
        # in both SWE & TEMP DATA)
        
        #RE-LOAD DATA (BEFORE CRS TRANSFORMATION) - NEED TO GET TEMP & SWE ON SAME EXTENT
        
                #Load in RasterBrick
                swe <- brick("2_Albedo_Regional/Data/seNorge/Output/SWE/swe_means_1999_all_norway.tif")
                swe_ext <- extent(swe)
                
                #Load in RasterBrick
                temp <- brick("2_Albedo_Regional/Data/seNorge/Output/Temperature/temp_means_1999_all_norway.tif")
                temp_ext <- extent(temp)
                
                        #Looking at extents - SWE is shifted -500 left & down
                
                #Resample
                temp_r <- resample(temp, swe)
                
                        #Does extent of resampled RasterBrick match that of swe?
                        extent(temp_r) #MATCHES
                
        #COMBINE DATA FOR AGGREGATION (TO COARSER RESOLUTION)
                        
                plot(subset(swe,1))
                plot(subset(temp_r,1))
                
                        #TEMP extends farther out than SWE - thus, SWE layers will be limiting
                        #(in terms of NAs)
                
                        #Need to get the number of valid "non-NA" cells to be the same in SWE &
                        #temp layers (i.e. mask temp layers by SWE layers)
                        temp_r <- mask(temp_r, swe)
                        plot(subset(temp_r,1)) #THIS WAS SUCCESSFUL
                        
                        swe_r <- mask(swe, temp_r)
                
                #Stack SWE w/ temps for aggregation (to increase coarseness of dataset for HiClimr())
                all <- stack(swe_r, temp_r)
                all <- aggregate(all, fact = 4, FUN = "max")
                

        #REPROJECT DATA TO LAT/LON CRS
                
                new_crs <- "+proj=longlat +datum=WGS84"
                all <- projectRaster(all, crs = new_crs)
                
        #REMOVE OBJECTS TO FREE UP MEMORY
                
                rm(temp_r)
                rm(swe_r)
                rm(temp)
                rm(swe)
                
        #PREPARE DATA FOR CLUSTERING
                
                #Variable 1 matrix: SWE
                
                        #Define matrix
                        mat <- values(subset(all, 1:12))
                        
                        #Replace NaN w/ NA
                        mat[is.nan(mat)] <- NA
                        
                        #How many rows?
                        nrow(mat) #172992
                        
                
                #Variable 2 matrix: Temp
                        
                        #Get temp values as appropriate matrix (N grid cells x M months)
                        mat2 <- values(subset(all, 13:24)) 
                        
                        #Replace NaN w/ NA
                        mat2[is.nan(mat2)] <- NA
                        
                        #How many rows?
                        nrow(mat2) #172992 - same as above (172992 observations)
                        
                #How many NA's in each matrix?
                mat_na <- sum(is.na(mat[,])) #1649028 NAs
                mat2_na <- sum(is.na(mat2[,])) #1649028 NAs (same as SWE matrix)
                        
                        #Remove NA's in both matrices
                        mat <- na.omit(mat) #426876 valid cells
                        mat2 <- na.omit(mat2) #426876 valid cells

                #Lat/Lon Vectors
                
                        #Grab XY values for one slice of data (define 2D mesh grid)
                        swe_jan <- rasterToPoints(subset(all, 1))[,1:2]  
                        
                                #Automatically removes NA's - so, the number of points should be identical
                                #to the number of cells / 12
                        
                                        #Is this true?
                                        (nrow(swe_jan) * 12) == 426876 #TRUE
                        
                                #SO, there are 35,573 valid cells in the matrix (and 35,573 sets of 
                                #corresponding coordinates)
                        
                                        #How many unique longitude coordinates?
                                        length(unique(swe_jan[,1])) #313 unique longitude coordinates
                                        
                                        #How many unique latitude coordinates?
                                        length(unique(swe_jan[,2])) #369 unique longitude coordinates
                                        
                                #I think what's happening is that the function expects a square/rectangle
                                #(longitude * latitude), but right now, my data represents an irregular shape 
                                #(since all NA's were removed)
                                        
                                        #Redefine matrices and KEEP NA values
                                        mat <- values(subset(all, 1:12))
                                        mat2 <- values(subset(all, 13:24))
                                        
                                        #Get coordinates of centers from all cells
                                        coords <- coordinates(subset(all,1))
                                        
                                                #Get latitudes and longitudes
                                                lon <- coords[,1] #408 unique coordinates
                                                lat <- coords[,2] #424 unique coordinates
                                                
                                                        #Gridded - n x m = N
                                                        #424 * 408 = 172992
                                                
                                                        #ACCORDING TO HICLIMR docs, lon and lat
                                                        #should be length N (same as number of
                                                        #spatial features)
                                                
                                                                #What is N?
                                                                nrow(mat) #172992
                                                                

                                                        
#THIS DOESN'T SOLVE THINGS (STILL GETTING WEIRD RESULTS) - going to try another approach
                                                                
                                swe_input <- rasterToPoints(subset(all,1:12))
                                mat <- swe_input[,3:14]
                                
                                temp_input <- rasterToPoints(subset(all,13:24))
                                mat2 <- temp_input[,3:14]
                                
                                lon <- mat[,1]
                                lat <- mat[,2]
                                
                                        #THIS APPROACH AUTOMATICALLY FILTERS OUT NA'S, WHICH WAS
                                        #THE ONLY WAY CLUSTERING WAS WORKING
                                
                                
                        #RUN MULTIVARIATE CLUSTERING W/ SWE and TEMP
                        y <- HiClimR(x=list(mat, mat2), lon = lon, lat = lat, lonStep = 1, latStep = 1,
                                     geogMask = F, country = "NOR", meanThresh = list(NULL, NULL),
                                     varThresh = list(0, 0), detrend = list(F, F), standardize = list(TRUE, TRUE),
                                     weightMVC = list(1, 1), nPC = NULL, method = "ward", hybrid = FALSE, kH = NULL,
                                     members = NULL, nSplit = 100, upperTri = TRUE, verbose = TRUE,
                                     validClimR = TRUE, k = 12, minSize = 1, alpha = 0.01,
                                     plot = T, colPalette = NULL, hang = -1, labels = FALSE)
                        beep(8)
                
                                #IT WORKED!!
                       
                        #RUN MULTIVARIATE CLUSTERING W/ SWE and TEMP (W/ CONTIGUITY CONSTRAINT)
                        z <- HiClimR(x=list(mat, mat2), lon = lon, lat = lat, lonStep = 1, latStep = 1,
                                     geogMask = T, country = "NOR", contigConst = 0.5, meanThresh = list(NULL, NULL),
                                     varThresh = list(0, 0), detrend = list(F, F), standardize = list(TRUE, TRUE),
                                     weightMVC = list(1, 1), nPC = NULL, method = "ward", hybrid = FALSE, kH = NULL,
                                     members = NULL, nSplit = 100, upperTri = TRUE, verbose = TRUE,
                                     validClimR = TRUE, k = 12, minSize = 1, alpha = 0.01,
                                     plot = TRUE, colPalette = NULL, hang = -1, labels = FALSE)
                        beep(8) 
                        
                                #LOOKS OK, BUT CLUSTERS ARE PRETTY BIG - CAN THE REGIONAL METHOD MAKE BETTER ONES?
                        
                        
                        #RUN MULTIVARIATE CLUSTERING W/ SWE and TEMP (W/ CONTIGUITY CONSTRAINT & "REGIONAL" METHOD)
                        w <- HiClimR(x=list(mat, mat2), lon = lon, lat = lat, lonStep = 1, latStep = 1,
                                     geogMask = T, country = "NOR", contigConst = 0.5, meanThresh = list(NULL, NULL),
                                     varThresh = list(0, 0), detrend = list(F, F), standardize = list(TRUE, TRUE),
                                     weightMVC = list(1, 1), nPC = NULL, method = "regional", hybrid = FALSE, kH = NULL,
                                     members = NULL, nSplit = 100, upperTri = TRUE, verbose = TRUE,
                                     validClimR = TRUE, k = NULL, minSize = 1, alpha = 0.01,
                                     plot = TRUE, colPalette = NULL, hang = -1, labels = FALSE)
                        beep(8) 
                        
                                #DIDN'T cluster well at all - "regional" method seems to work poorly here
                        
                        
                        #RUN MULTIVARIATE CLUSTERING W/ SWE and TEMP (W/ default # of clusters = 12)
                        v <- HiClimR(x=list(mat, mat2), lon = lon, lat = lat, lonStep = 1, latStep = 1,
                                     geogMask = T, country = "NOR", contigConst = 0.5, meanThresh = list(NULL, NULL),
                                     varThresh = list(0, 0), detrend = list(F, F), standardize = list(TRUE, TRUE),
                                     weightMVC = list(1, 1), nPC = NULL, method = "ward", hybrid = FALSE, kH = NULL,
                                     members = NULL, nSplit = 50, upperTri = TRUE, verbose = TRUE,
                                     validClimR = TRUE, k = 12, minSize = 1, alpha = 0.01,
                                     plot = T, colPalette = NULL, hang = -1, labels = FALSE)
                        beep(8)
                        
                                #Plot gridded output
                                colPalette <- colorRampPalette(c("#899DA4","#C93312", "#FAEFD1", "#DC863B"))
                                
                                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_2_Visualization/Initial_Plots/hiclimr_clustering/hiclimr_swe_temp_clustering.png",
                                    bg = "white",
                                    width = 1500,
                                    height = 1500,
                                    units = "px")
                                
                                plot(v$coords[, 1], v$coords[, 2], col = colPalette(max(v$region, na.rm = TRUE))[v$region],
                                     pch = 15, cex = 1, main = "HiClimR Clustering by SWE & Temperature (1999)\n(k = 12)", xlab = "Longitude", ylab = "Latitude")
                                
                                dev.off()
                                
                                #Plot dendrogram
                                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_2_Visualization/Initial_Plots/hiclimr_clustering/hiclimr_swe_temp_dendrogram.png",
                                    bg = "white",
                                    width = 1000,
                                    height = 1000,
                                    units = "px")
                                
                                plot(v, hang = -1, labels = FALSE)
                                
                                dev.off()
                                

#HOW DO I EXPORT THIS FILE?
                                
                                #Save as netCDF file
                                v.nc <- HiClimR2nc(v, ncfile="2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_2_Visualization/Initial_Plots/hiclimr_clustering/HiClimR_cluster.nc")
                                nc_close(v.nc)
                                

                               
        
                        
 
#END HICLIMR CLUSTERING --------------------------------------------------------------------------    
                
                
        