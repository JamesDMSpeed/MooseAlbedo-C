##This is a script to process spatial raster data from the SR16 data product, as well as the large herbivore density data


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
                trondheim <- st_read("2_Albedo_Regional/Data/Spatial_Data/SatSkog/Trondheim/5001_25833_satskog_8472bd_SHAPE.shp")
                
        #seNorge Gridded Temp + SWE data (NOTE: THESE ARE STORED ON AN EXTERNAL HARD DRIVE)
                
                #NOTE: These are netCDF files, and require the ncdf4 package to work with
                ##Using U of Oregon's GEOG607 Tutorial to process these
                
                #OTHER DETAILS:
                        ## Time is in a strange format for these objects - it is recorded in 'seconds since 1900-01-01'
                        ## However, there are 365 total observations, and the number of seconds between each observation 
                        ## is equivalent to exactly 24 hours
                
                        #Load in gridded temp data for 1999
                        
                                temps1999 <- nc_open("/Volumes/JS_Ext_HD/THESIS/SeNorge_Data/seNorge_v2_1_TEMP1d_grid_1999.nc")
                                
                        #Load in gridded SWE data for 1999
                        
                                swe1999 <- nc_open("/Volumes/JS_Ext_HD/THESIS/SeNorge_Data/swe_1999.nc")
                             

#END INITIAL DATA IMPORT ------------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#HERBIVORE DENSITY DATA --------------------------------------------------------------------------------------------

        #INITIAL DATA EXPLORATION
                
                #View CRS
                crs(hd_shp)
                
                #Summary 
                str(hd_shp, max.level = 2)
        
        #FILTER TO DATA FROM 1999
        ## Note: Only using densities from 1999, since these correspond best to date of the pictures used for the SatSkog product
                
                #Grab relevant 1999 densities, kommune info, + geometry (since these are closest to SatSkog)
                hd1999 <- hd_shp %>% select(KOMMUNE, OBJECTI, OBJTYPE, NAVN, OPPDATE, kommnnr, Shp_Lng, Shap_Ar, kommnr, kommnvn, geometry, W__1999, S___199, Ms_1999, Rd__1999, R_d_1999, M__1999, Sh_1999, Cw_1999, Hf_1999, Gt_1999, Hr_1999, Tt_1999, Ct_1999, al_1999, Lv_1999, Wl_1999, WP_1999)
        
        #PLOT DATA
        
                #Outline of geometry (map of Norway)
                geo <- st_geometry(hd1999)
                plot(geo)
        
                #Plot moose density for 1999 (example plot)
                plot(hd1999["Ms_1999"])
        
                #Explore area of kommunes
                area <- st_area(hd1999)
                hist(area, breaks = 300)
                
#END HERBIVORE DENSITY DATA ----------------------------------------------------------------------------------------
       
        
        
        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        
        
        
        
#SATSKOG DATA PRODUCT --------------------------------------------------------------------------------------------

        #INITIAL DATA EXPLORATION
                
                #Check CRS (Looks like this matches the herbivore density vector data)
                crs(trondheim)
                
                #Get geometry and plot
                geo_trondheim <- st_geometry(trondheim)
                plot(geo_trondheim)
                
                
        #FILTER + CLEAN UP DATA
                
                #Remove rows w/ age of '-1'
                trondheim <- trondheim[trondheim$alder != -1, ]
                
                #Remove observations with 'reduced' quality images
                trondheim <- trondheim[trondheim$kvalitet != "redusert",]
                
                #Make sure all pictures from same year (1999), to be as close to herbivore density data as possible
                trondheim <- trondheim[trondheim$bildedato == '060899',]
                
                #Filter to 'Clear Sky' observations ('ikke_sky')
                trondheim <- trondheim[trondheim$class_sky == 'ikke_sky',]
                
                #Filter pixels with NDVI of 0 (which might indicate non-vegetative pixels)
                trondheim <- trondheim[trondheim$ndvi > 0,]
                
                #SHOULD I FILTER TO PRODUCTIVE FOREST ONLY? ('pskog')
                
                #Filter to 'younger' forest
                        
                        #Min age
                        min_age <- min(trondheim$alder)
                        age_limit <- 30
                        
                        #Filter to forest between min age and 'age limit'
                        trondheim <- trondheim[trondheim$alder >= min_age & trondheim$alder <= age_limit,]
                        
                
        #EXPLORE FILTERED DATA
                
                #Age of stands
                hist(trondheim$alder, breaks = 30)
                
                #Area (m2)
                hist(trondheim$areal_m2, breaks = 500)
                
                #Bonitet (quality)
                hist(trondheim$bonitet, breaks = 3)
        
#END SATSKOG DATA PRODUCT ----------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#GRIDDED SENORGE DATA ------------------------------------------------------------------------------------------------

#Processing of these netCDF files is based upon a U of Oregon Tutorial:
## http://geog.uoregon.edu/bartlein/courses/geog490/week04-netCDFprojected.html
                
        #EXPLORE + VERIFY DATA
                
                #Temperature
                
                      
                                        
                        
                
                #SWE
                                 
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
                        
                        #Get SWE variable as a three-dimensional array
                        swe_var <- ncvar_get(swe1999, attributes(swe1999$var)$names[1])
                        

                                #Verify dimensions of matrix
                                dim(swe_var)
                                
                                #Use 'melt' function to convert 3D array into df
                                swe_df <- melt(swe_var)
                                        
                                        #Rename columns
                                        names(swe_df)[1] <- "X_Coordinate"
                                        names(swe_df)[2] <- "Y_Coordinate"
                                        names(swe_df)[3] <- "Day"
                                        names(swe_df)[4] <- "SWE_daily_mm"
                                        
                                        #Verify values in new df
                                        swe_var[80, 100, 5]
                                        swe_df$SWE_daily_mm[swe_df$X_Coordinate == 80 & swe_df$Y_Coordinate == 100 & swe_df$Day == 5]
                                        
                                        test <- swe_df[]
                                        
                        #Close SWE file
                        nc_close(swe1999)

        #TEMPERATURE
                
                #ASSEMBLE DATAFRAME 
                
                        #Assign variable name
                        dname <- "mean_temperature"
                        
                        #Get coordinate variables
                        
                                #X Coordinate Projections
                                x_coords <- temps1999$var$mean_temperature$dim[[1]]$vals
                                
                                #Y Coordinate Projections
                                y_coords <- temps1999$var$mean_temperature$dim[[2]]$vals
                                
                                #Time (Weird unit - "Days since 1900-01-01)
                                time <- temps1999$var$mean_temperature$dim[[3]]$vals
                                
                        #Get temperature variable
                        temp_array <- temps1999 %>% get.var.ncdf("mean_temperature")
                        
                        #Convert 'time-since' units into more readable units & grab as vector
                        
                                #Get vector of time observations (currently in "time since 1900-01-01")
                                t <- ncvar_get(temps1999, "time")
                        
                                #Get details on time units to verify
                                tunits <- ncatt_get(temps1999, "time", "units")
                                
                                #Verify length of time vector (should be 365)
                                nt <- dim(t)
                                
                                # split the time units string into fields
                                
                                #Split time units string to array of strings
                                tustr <- strsplit(tunits$value, " ")
                                
                                #Isolate starting date string and split again
                                tdstr <- strsplit(unlist(tustr)[3], "-")
                                
                                #Define month, day, and year as integers
                                tmonth <- as.integer(unlist(tdstr)[2])
                                tday <- as.integer(unlist(tdstr)[3])
                                tyear <- as.integer(unlist(tdstr)[1])
                                
                                #For initial vector of time observations, convert to absolute dates
                                t_abs <- chron(t, origin = c(tmonth, tday, tyear))
                                
                        #Grab X and Y coordinates
                        x_coord <- <- ncvar_get(ncin, "lon")
                        nlon <- dim(lon)
                        head(lon)
                
                #Calculate monthly averages for every single grid pixel
                
                
        #SWE
                
                
                
        ##CLOSE NETCDF FILE
                
                #Close temperature file
                nc_close(temps1999)
                
        

#END GRIDDED SENORGE DATA -------------------------------------------------------------------------------------------- 
                
                
                
                
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                
                
                
                
#ALBEDO CALCULATIONS ------------------------------------------------------------------------------------------------
       
        ### CALCULATE ALBEDO FOR EACH OBSERVATION, USING VOLUME + ALBEDO MODEL

        ### CACLULATE ALBEDO FOR EACH OBSERVATION, USING AGE + ALBEDO MODEL         
                
#END ALBEDO CALCULATIONS --------------------------------------------------------------------------------------------

                        
        