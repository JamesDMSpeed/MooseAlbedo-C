##Script to collect, format, and process forest stand volume data (FSV) from existing
##SUSTHERB LiDAR data

#Load relevant packages
library(ggplot2)
library(dplyr)
library(raster)
library(rasterVis)
library(lidR)
library(sp)


#Get 'cleaned' site data from adjacent 'Sites' folder
site_data <- read.csv('1_Albedo_Exclosures/1_Data/Sites/cleaned_data/cleaned_data.csv', header = TRUE)

#Bratsberg test
        
        #Read in LAS file
        bratsberg_b <- readLAS('1_Albedo_Exclosures/1_Data/FSV/lidar_data/clipped_las/bratsberg_b.las')

        #Identify + remove large trees (>5m)
        
                #Moving window of 5m (ws=5) and minimum tree height of 5m (hmin=5)
                trees_bratsberg_b <- tree_detection(bratsberg_b, algorithm = lmf(ws=5, hmin=5))
                
                treeheight_bratsberg_b <- extract(canopy_diff_bratsberg_b,trees_bratsberg_b[,1:2])
        
treeheight_bratsberg_b<-extract(canopy_diff_bratsberg_b,trees_bratsberg_b[,1:2])