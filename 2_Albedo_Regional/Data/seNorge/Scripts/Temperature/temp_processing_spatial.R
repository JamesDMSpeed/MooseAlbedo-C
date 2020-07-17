##Proccessing of seNorge Gridded SWE data (NOTE: THIS NETCDF FILE IS STORED ON AN EXTERNAL HARD DRIVE)

#NOTE: This script uses netCDF files, and requires the ncdf4 or raster package to work with

#OTHER DETAILS:
## Time is in a strange format for these objects - it is recorded in 'seconds since 1900-01-01'
## However, there are 365 total observations, and the number of seconds between each observation 
## is equivalent to exactly 24 hours


#PACKAGES ----------------------------------------------------------------------

        #Data Manipulation + Visualization
        library(ggplot2)
        library(raster)
        library(rasterVis)
        library(dplyr)
        library(RColorBrewer)

        #Spatial Data Packages
        library(sf)
        library(tmap)
        library(broom)
        library(rgdal)

        #Packages for netCDF files
        library(ncdf4)
        library(chron)
        library(reshape2)
        library(data.table)

#END PACKAGES ----------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#DATA PROCESSING ------------------------------------------------------------------------------

        #Create a list of netCDF files (stored in directory of External HD)
        files <- list.files(path="/Volumes/JS_Ext_HD/THESIS/SeNorge_Data/Temperature", pattern="*.nc", full.names=TRUE, recursive=FALSE)

        #Loop through and process all seNorge netCDF temperature files
        for(file in files){
                
                print(file)
                
                #DATA IMPORT + FORMATTING -----------
                
                        #Read in base file name        
                        filename <- tools::file_path_sans_ext(basename(file))
                        
                        
                        #Function to get last n characters of a string
                        substrRight <- function(x, n){
                                substr(x, nchar(x)-n+1, nchar(x))
                        }
                        
                        #Get last 2 characters of filename string
                        year <- substrRight(filename, 4)
                        
                        #Re-add netCDF extension to name (for raster functions below)
                        filename <- paste("/Volumes/JS_Ext_HD/THESIS/SeNorge_Data/Temperature/", filename, '.nc', sep = '')
                        
                        #Load in gridded temperature data for 1999 into 3D RasterBrick object
                        data <- brick(filename, varname = "mean_temperature")
                        
                        #Set CRS (UTM 33)
                        crs(data) <- "+proj=utm +zone=33 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"
                        
                        #Set 'no data value' to fix error
                        NAvalue(data) <- -9999
                        
                #CALCULATE MONTHLY MEANS -----------
                        
                        #For each month, create a RasterBrick subset based on day number
                        #Ex. For January, create a subset from days 1-31
                        jan <- subset(data, 1:31)
                        feb <- subset(data, 32:59)
                        mar <- subset(data, 60:90)
                        apr <- subset(data, 91:120)
                        may <- subset(data, 121:151)
                        jun <- subset(data, 152:181)
                        jul <- subset(data, 182:212)
                        aug <- subset(data, 213:243)
                        sep <- subset(data, 244:273)
                        oct <- subset(data, 274:304)
                        nov <- subset(data, 305:334)
                        dec <- subset(data, 335:365)
                        
                        #For each month, calculate average temp using the mean function
                        jan_mean <- mean(jan)
                        feb_mean <- mean(feb)
                        mar_mean <- mean(mar)
                        apr_mean <- mean(apr)
                        may_mean <- mean(may)
                        jun_mean <- mean(jun)
                        jul_mean <- mean(jul)
                        aug_mean <- mean(aug)
                        sep_mean <- mean(sep)
                        oct_mean <- mean(oct)
                        nov_mean <- mean(nov)
                        dec_mean <- mean(dec)
                        
                        #Stack all monthly mean RasterLayers into brick
                        temp_means <- stack(jan_mean,
                                            feb_mean,
                                            mar_mean,
                                            apr_mean,
                                            may_mean,
                                            jun_mean,
                                            jul_mean,
                                            aug_mean,
                                            sep_mean,
                                            oct_mean,
                                            nov_mean,
                                            dec_mean)
                
                #WRITE OUTPUT
                        
                        #Save RasterStack file to output folder as GeoTiff file
                        writeRaster(temp_means,
                                    filename = paste("/Volumes/JS_Ext_HD/THESIS/SeNorge_Output/Temperature/temp_means_", year, "_all_norway.tif", sep = ''),
                                    format = "GTiff",
                                    overwrite = T)
                
        }

#END DATA PROCESSING ------------------------------------------------------------------------------