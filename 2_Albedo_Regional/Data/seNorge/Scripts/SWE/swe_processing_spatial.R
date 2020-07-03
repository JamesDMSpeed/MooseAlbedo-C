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




#INITIAL DATA IMPORT + EXPLORATION ------------------------------------------------------------------------------

        #LOAD DATA

                #Load in gridded SWE data for 1999 into 3D RasterBrick object
                data <- brick("/Volumes/JS_Ext_HD/THESIS/SeNorge_Data/swe_1999.nc", varname = "snow_water_equivalent")
                
                #Set CRS (UTM 33)
                crs(data) <- "+proj=utm +zone=33 +ellps=WGS84 +datum=WGS84 +units=m +no_defs"
                
                
        #EXPLORE DATA
                
                #View details
                data
                
                #Set 'no data value' to fix error
                NAvalue(data) <- -9999
                
                
                #Test one layer of brick
                
                        #Grab slice from day 180
                        test <- subset(data, 20)

                        #Plot layer
                        plot(test)
                        levelplot(test, margin = F) #Looks good
                        
                #Try creating a layer for January average
                jan_test <- subset(data, 1:31)
                jan_avg_test <- mean(jan_test)
                plot(jan_avg_test)
                        
                        
#END INITIAL DATA IMPORT + EXPLORATION ------------------------------------------------------------------------------
                        
                        
                        
                        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#CALCULATE MONTHLY AVG SWE FOR EACH CELL ------------------------------------------------------------------------------                        

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
        
        #For each month, calculate average SWE using the mean function
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
        swe_means <- stack(jan_mean,
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
        
                        
#END CALCULATE MONTHLY AVG SWE FOR EACH CELL -------------------------------------------------------------------------- 



                        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#WRITE OUTPUT ------------------------------------------------------------------------------
        
        #Save RasterStack file to output folder as GeoTiff file
        writeRaster(swe_means,
                    filename = "2_Albedo_Regional/Data/seNorge/Output/SWE/swe_means_1999_all_norway.tif",
                    format = "GTiff",
                    overwrite = T)
        
#END WRITE OUTPUT --------------------------------------------------------------------------                        
    
                


        