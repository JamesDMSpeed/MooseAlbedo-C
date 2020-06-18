##This is a script to process spatial raster data from the SR16 data product, as well as the large herbivore density data


#PACKAGES ----------------------------------------------------------------------

        library(ggplot2)
        library(raster)
        library(rasterVis)
        library(dplyr)
        library(sf)
        library(tmap)
        library(broom)

#END PACKAGES ----------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#INITIAL DATA IMPORT ----------------------------------------------------------------------------------------------

        #SustHerb Herbivore Spatial Data

                #Read in vector data w/ sf package
                hd_shp <- st_read("2_Albedo_Regional/Data/Herbivore_Densities/NorwayLargeHerbivores.shp")
                
        #SatSkog Spatial Data Product
                
                #Load in Trondheim SatSkog shapefile (SatSkog pictures from 1999)
                trondheim <- st_read("2_Albedo_Regional/Data/Spatial_Data/SatSkog/Trondheim/5001_25833_satskog_8472bd_SHAPE.shp")
                
        #seNorge Gridded Temp + SWE data
                
                #Load in temp data
                
                #Load in SWE data

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
                
        #TEMPERATURE
                
                
        #SWE
                

#END GRIDDED SENORGE DATA -------------------------------------------------------------------------------------------- 
                
                
                
                
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                
                
                
                
#ALBEDO CALCULATIONS ------------------------------------------------------------------------------------------------
       
        ### CALCULATE ALBEDO FOR EACH OBSERVATION, USING VOLUME + ALBEDO MODEL

        ### CACLULATE ALBEDO FOR EACH OBSERVATION, USING AGE + ALBEDO MODEL         
                
#END ALBEDO CALCULATIONS --------------------------------------------------------------------------------------------

                        
        