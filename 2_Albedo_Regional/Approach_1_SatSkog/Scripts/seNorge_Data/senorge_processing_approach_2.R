##Proccessing of seNorge Gridded Temp + SWE data (NOTE: THESE ARE STORED ON AN EXTERNAL HARD DRIVE)

#NOTE: These are netCDF files, and require the ncdf4 package to work with
##Using U of Oregon's GEOG607 Tutorial to process these

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

        #Spatial Data Packages
        library(sf)
        library(tmap)
        library(broom)

        #Packages for netCDF files
        library(ncdf4)
        library(chron)
        library(reshape2)
        library(data.table)

#END PACKAGES ----------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#SWE ----------------------------------------------------------------------------------------------

        #LOAD DATA

                #Load in gridded SWE data for 1999
                swe1999 <- nc_open("/Volumes/JS_Ext_HD/THESIS/SeNorge_Data/swe_1999.nc")
                
                
        #EXPLORE DATA
                
                #Print summary
                print(swe1999)
                
                # Variable of interest: mean_temperature[X, Y, time]
                # Units: Celsius
                # Grid mapping: UTM_Zone_33
                
                #Attributes
                attributes(swe1999)$names
                
                #Variable names
                attributes(swe1999$var)$names
                
                #Investigate SWE variable
                ncatt_get(swe1999, attributes(swe1999$var)$names[1])

                
        #CONVERT MULTIDIMENSIONAL ARRAY INTO DATAFRAME
                
                #Get SWE variable as a three-dimensional array
                swe_var <- ncvar_get(swe1999, attributes(swe1999$var)$names[1])
                
                        #Verify dimensions of matrix
                        dim(swe_var)
                
                #Use 'melt' function to convert 3D array into df
                swe_df <- melt(swe_var)
                
                        ##IS THIS STEP WORKING? NEED TO GET COORDINATES, NOT INDICES (NOT CURRENTLY WORKING)
                
                #Rename columns
                names(swe_df)[1] <- "X_Coordinate"
                names(swe_df)[2] <- "Y_Coordinate"
                names(swe_df)[3] <- "Day"
                names(swe_df)[4] <- "SWE_daily_mm"
                
                
        #CLOSE CONNECTION TO NETCDF FILE & FREE UP MEMORY
                
                #Close SWE file
                nc_close(swe1999)
                
                #Remove netCDF file
                rm(swe1999)
                
                #Remove large array to free up memory
                rm(swe_var)
                
        #REMOVE NA VALUES
        swe_df <- swe_df[!is.na(swe_df$SWE_daily_mm),]
                
        #Convert to data.table for performance optimization
                
                #Convert to data.table and remove data frame
                swe_dt <- data.table(swe_df)
                rm(swe_df)
        
        #AGGREGATE MEAN SWE VALUES FOR EACH CELL (BY MONTH)
        
                #Add a blank column for month
                swe_dt$Month <- ''
                        
                #Manually add month based on day of year
                
                        #Vectorize and pre-allocate output data structure
                        output <- integer(nrow(swe_dt))
        
                        #IFELSE STATEMENT (Fastest performance by far)
                        output <- ifelse(swe_dt$Day <= 31, 1,
                                         ifelse(swe_dt$Day > 31 & swe_dt$Day <= 59, 2,
                                                ifelse(swe_dt$Day > 59 & swe_dt$Day <= 90, 3,
                                                       ifelse(swe_dt$Day > 90 & swe_dt$Day <= 120, 4,
                                                              ifelse(swe_dt$Day > 120 & swe_dt$Day <= 151, 5,
                                                                     ifelse(swe_dt$Day > 151 & swe_dt$Day <= 181, 6,
                                                                            ifelse(swe_dt$Day > 181 & swe_dt$Day <= 212, 7,
                                                                                   ifelse(swe_dt$Day > 212 & swe_dt$Day <= 243, 8,
                                                                                          ifelse(swe_dt$Day > 243 & swe_dt$Day <= 273, 9,
                                                                                                 ifelse(swe_dt$Day > 273 & swe_dt$Day <= 304, 10,
                                                                                                        ifelse(swe_dt$Day > 334 & swe_dt$Day <= 365, 11, 12) ) ) ) ) ) ) ) ) ) )
                        
                        #Join with data table
                        swe_dt$Month <- output
                        
                        #Remove output vector to save memory
                        rm(output)

                #Aggregate based on month
                swe_agg <- aggregate(swe_dt$SWE_daily_mm, by = list(X_Coordinate = swe_dt$X_Coordinate, Y_Coordinate = swe_dt$Y_Coordinate, Month = swe_dt$Month), FUN = mean)
                names(swe_agg)[4] <- 'Avg_SWE_mm'
                
        #WRITE OUTPUT TO CSV
                
                #Remove dt
                rm(swe_dt)
                
                #Write CSV to EXTERNAL HARD DRIVE
                write.csv(swe_agg, file = '/Volumes/JS_Ext_HD/THESIS/SeNorge_Output/swe_mm_1999_all_norway.csv', row.names = TRUE)
         
                #Remove agg
                rm(swe_agg)

#END SWE ------------------------------------------------------------------------------------------

                
                


        