##This script joins shapefiles for each kommune in Norway into one unified shapefile (for analysis)

#PACKAGES ----------------------------------------------------------------------

        #Data Manipulation + Visualization
        library(dplyr)
        library(ggplot2)
        library(sf)
        library(tmap)
        library(broom)
        library(foreach)
        library(data.table)

#END PACKAGES ----------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#CREATE UNIFIED SHAPEFILE ----------------------------------------------------------------------------------

        #UNIFIED SHAPEFILE (for analysis)

                #Create blank list to store shapefiles
                files <- vector()
        
                #Load all directories w/ individual processed shapefiles
                dirs <- list.dirs(path="2_Albedo_Regional/Data/Spatial_Data/Output", full.names=TRUE, recursive=FALSE)
        
                #Loop through each directory and load shapefiles into list
                for( dir in dirs ){
                        
                        #Grab shapefile from subdirectory (w/ .shp extension)
                        file <- list.files(path = dir, pattern="*.shp", full.names=TRUE, recursive=FALSE)
                        
                        #Append to file list
                        files <- append(files, file)
                        
                }
                
                #Read all shapefiles in vector and store as list
                shapefile_list <- lapply(files, st_read)
                
                #Bind all individual shapefiles into single shapefile
                
                
#SOMETHING is going wrong at this step (how can I combine these?)
                
                        #Set up final shapefile w/ rest of list items
                        final_shp <- shapefile_list[[1]]
                        
                        for(i in 2:length(shapefile_list)){
                                
                                print(i)
                                
                                #Rbind w/ existing df (using rbind instead of bind_rows due to index error)
                                final_shp <- rbind(final_shp, shapefile_list[[i]])
                                
                        }
                
                
                #Filter out unused or unimportant variables (to slightly speed up processing)
                final_shp <- final_shp[,c(1,3,4,7:106)]
                
                #Remove rows where albedo is NA
                final_shp <- final_shp[!is.na(final_shp$Mnt_1_A),]
                
                #Convert 'area in hectacres' to numeric/double
                final_shp$arl_hkt <- as.numeric(gsub(',', '.', final_shp$arl_hkt))
                
        #TEST (Oslo) - did rbind work correctly?
                oslo <- final_shp %>% filter(NAVN == "Oslo") 
                
                
        #SIMPLIFIED (removed small polygons)
                
                final_simple <- final_shp[final_shp$arl_hkt > 0.3,]
                final_simple <- st_simplify(final_simple, dTolerance = 1000, preserveTopology = T)
        
        
        #ALBEDO ONLY (for map visualization)
                
                albedo_only <- final_shp[,c("Mnt_1_A",
                                            "Mnt_2_A",
                                            "Mnt_3_A",
                                            "Mnt_4_A",
                                            "Mnt_5_A",
                                            "Mnt_6_A",
                                            "Mnt_7_A",
                                            "Mnt_8_A",
                                            "Mnt_9_A",
                                            "Mn_10_A",
                                            "Mn_11_A",
                                            "Mn_12_A")]
                
        #SIMPLIFIED ALBEDO ONLY (remove very small polygons)
                
                #Convert albedo_only to simple feature
                albedo_only_simple <- final_simple[,c("Mnt_1_A",
                                                  "Mnt_2_A",
                                                  "Mnt_3_A",
                                                  "Mnt_4_A",
                                                  "Mnt_5_A",
                                                  "Mnt_6_A",
                                                  "Mnt_7_A",
                                                  "Mnt_8_A",
                                                  "Mnt_9_A",
                                                  "Mn_10_A",
                                                  "Mn_11_A",
                                                  "Mn_12_A")]
                albedo_only_simple <- st_simplify(albedo_only_simple, dTolerance = 1000, preserveTopology = T)

        #ALBEDO ONLY (SIMPLIFIED) FOR MAPBOX VISUALIZATION 
        ## PROJECTED TO RELEVANT WEB MERCATOR CRS 
        
                mapbox_crs <- "+proj=merc +a=6378137 +b=6378137 +lat_ts=0.0 +lon_0=0.0 +x_0=0.0 +y_0=0 +k=1.0 +units=m +nadgrids=@null +wktext  +no_defs"
                mapbox <- st_transform(albedo_only_simple, crs = mapbox_crs)
                
                #Get individual shapefile for each month & write
                for(i in 1:12){
                        
                        obj <- mapbox[,i]
                        
                        st_write(obj, paste("2_Albedo_Regional/Data/Final_Shapefile/Output/albedo_only/mapbox/month_", i, "/mapbox_month_", i, ".shp", sep = ""), driver = "ESRI Shapefile")
                
                        rm(obj)
                }

                
#END CREATE UNIFIED SHAPEFILE ------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#EXPLORE PLOT ----------------------------------------------------------------------------------

        #Plot January albedo (simplified)
        ggplot(mapbox) +
                        geom_sf( aes(fill = "Mnt_1_A")) +
                        ggtitle("January Albedo Estimates in Early-Mid Successional Forest (Simplified)")
        
                
#END EXPLORE PLOT ------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

                
                
                
#WRITE OUTPUT ------------------------------------------------------------------------------

        #Write full ESRI shapefile to relevant output directory
        st_write(final_shp, "2_Albedo_Regional/Data/Final_Shapefile/Output/ready_for_analysis/full_resolution/final_shapefile.shp", driver = "ESRI Shapefile")
        
        #Write simplified version of full shapefile       
        st_write(final_simple, "2_Albedo_Regional/Data/Final_Shapefile/Output/ready_for_analysis/simplified/final_shapefile_simple.shp", driver = "ESRI Shapefile")
                
        #Write albedo-only shapefile to relevant output directory
        st_write(albedo_only, "2_Albedo_Regional/Data/Final_Shapefile/Output/albedo_only/full_resolution/albedo_only_shapefile.shp", driver = "ESRI Shapefile")

        #Write simplified version of albedo-only shapefile
        st_write(albedo_only_simple, "2_Albedo_Regional/Data/Final_Shapefile/Output/albedo_only/simplified/albedo_only_shapefile_simple.shp", driver = "ESRI Shapefile")
        
        
#END WRITE OUTPUT ------------------------------------------------------------------------------