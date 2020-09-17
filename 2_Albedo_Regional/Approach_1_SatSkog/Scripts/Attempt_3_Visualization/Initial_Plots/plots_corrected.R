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

        #Clustering
        library(clusterSim)
        library(factoextra)
        

      
#END PACKAGES ----------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#IMPORT DATA --------------------------------------------------------------------------------------------------

        #Load unified 1999-only shapefile
        data <- st_read("2_Albedo_Regional/Data/Final_Shapefile/Output/attempt_3/1999_only/corrected_shapefile_1999.shp")
        
        #Verify only data from 1999
        data1999 <- data[data$Snrg_yr == 1999,]
        rm(data)
        
        #Remove any duplicate geometries
        data1999 <- distinct(data1999, .keep_all = T)
        
        beep(4)
        
        
                
#END IMPORT DATA --------------------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#INITIAL DATA EXPLORATION  --------------------------------------------------------------------------------------------------

        
                #Plot histogram of age by 2-year intervals
        
                        #Spruce
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_3_Visualization/Initial_Plots/spruce_albedo_pre_clustering.png",
                            height = 1500,
                            width = 1500,
                            units = "px")
                
                        ggplot(data = data1999, aes(x = Ms_Dnst, y = M_1_A_S)) +
                                geom_bin2d(binwidth = c(5,0.025)) +
                                facet_wrap(~ cut_interval(alder, 15)) +
                                geom_smooth(colour = "red") +
                                ggtitle("Moose Density vs. Spruce Albedo (January)\nSplit by 15 age intervals - 1999 data") +
                                labs(x = "Moose Density (kg/km-2)", y = "Albedo")
                        
                        dev.off()
                
                
                        #Pine
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_3_Visualization/Initial_Plots/pine_albedo_pre_clustering.png",
                            height = 1500,
                            width = 1500,
                            units = "px")
                        
                        ggplot(data = data1999, aes(x = Ms_Dnst, y = M_1_A_P)) +
                                geom_bin2d(binwidth = c(5,0.025)) +
                                facet_wrap(~ cut_interval(alder, 15)) +
                                geom_smooth(colour = "red") +
                                ggtitle("Moose Density vs. Pine Albedo (January)\nSplit by 15 age intervals - 1999 data") +
                                labs(x = "Moose Density (kg/km-2)", y = "Albedo")
                        
                        dev.off()
                        
                        
                        #Birch
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_3_Visualization/Initial_Plots/birch_albedo_pre_clustering.png",
                            height = 1500,
                            width = 1500,
                            units = "px")
                        
                        ggplot(data = data1999, aes(x = Ms_Dnst, y = M_1_A_B)) +
                                geom_bin2d(binwidth = c(5,0.025)) +
                                facet_wrap(~ cut_interval(alder, 15)) +
                                geom_smooth(colour = "red") +
                                ggtitle("Moose Density vs. Birch Albedo (January)\nSplit by 15 age intervals - 1999 data") +
                                labs(x = "Moose Density (kg/km-2)", y = "Albedo")
                        
                        dev.off()
                
                beep(8)
                
                
#END INITIAL DATA EXPLORATION --------------------------------------------------------------------------    
                
      