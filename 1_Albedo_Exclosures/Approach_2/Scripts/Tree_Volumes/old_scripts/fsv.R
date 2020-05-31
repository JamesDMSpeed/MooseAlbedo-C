##Script to collect, format, and process forest stand volume data (FSV) from existing
##SUSTHERB LiDAR data

##PACKAGES ----------------------------------------------------------------------------------------

        #Packages for general data manipulation + visualization
        library(ggplot2)
        library(dplyr)

        #Packages related to LiDAR 
        library(raster)
        library(rasterVis)
        library(lidR)
        library(itcSegment)
        library(sp)

###END PACKAGES ----------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#INITIAL DATA IMPORT ----------------------------------------------------------------------------------------------

        #Get 'cleaned' site data from adjacent 'Sites' folder
        site_data <- read.csv('1_Albedo_Exclosures/1_Data/Sites/cleaned_data/cleaned_data.csv', header = TRUE)
        
#END INITIAL DATA IMPORT --------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#DATA PROCESSING ----------------------------------------------------------------------------------------------

#Summary:      
        
#Bratsberg test
        
        #Read in LAS file of plot
        ## Note: This LAS file contains the LiDAR point cloud for a plot (32m x 32m)
        las_file <- readLAS('1_Albedo_Exclosures/1_Data/FSV/lidar_data/clipped_las/bratsberg_b.las')
        
        #Plot point cloud of LAS file
        plot(las_file)
        
        #Resample ------------------------------------------------------------------------------------
                
                #Interpolate 'ground points' (from point cloud) & compute a rasterized 'digital terrain model' 
                ##  Note: interpolation is via 'K-Nearest Neighbors' approach with inverse-distance weighting (IDW)
                ##  (with defaults of 10 neighbors and power of 2 for IDW)
                terrainmod <-grid_terrain(las_file, algorithm = knnidw(k = 10, p = 2), res=1)
                
                #Create a rasterized Canopy Height Model (CHM) from the point cloud
                ##  Note: this function uses the 'p2r' Digital Surface Model (DSM) algorithm
                canopymod <-grid_canopy(las_file, res=1, algorithm = p2r())
                
                #Use 'raster' package to resample (transfer) values from 'ground points' raster layer
                #to CHM raster layer
                terrainmod_resampled <-resample(terrainmod, canopymod, method='bilinear')
                
                #Obtain heights for each pixel (canopy height - ground points) 
                canopy_diff <- (canopymod - terrainmod_resampled)
                
                #Plot heights
                plot(canopy_diff)
        
        #Remove Large Trees ---------------------------------------------------------------------------
        
                #Detect and ID Trees > 5m height
        
                        #Detect individual trees in original LAS file
                        ## Note: this function uses the 'lmf' individual tree detection algorithm
                        ## In this case, lmf is using a minimum height threshold of 5m
                        trees <- tree_detection(las_file, algorithm = lmf(ws = 5, hmin = 5))
                        plot(trees)
                        
                        #Get numeric vector of tree heights (for all trees detected by 'tree_detection')
                        tree_heights <- extract(canopy_diff, trees[,1:2])
                
                        #Individually segment trees using 'lastrees' (assign 'treeID' to each tree)
                        indiv_trees <- lastrees(las_file,
                                                dalponte2016(chm = canopy_diff,
                                                                 treetops = trees[tree_heights >= 5,],
                                                                 th_seed=0.05,
                                                                 th_cr=0.1))
                        
                        plot(indiv_trees, color = "treeID")
                        
                #Remove Trees > 7m height ---------------
                        
                        #Create hulls for each tree (plot + double-check hulls match tall trees)
                        ### Note: This produces a spatial object with "tree hulls"
                        treeout <- tree_hulls(indiv_trees, type = 'convex', attribute = 'treeID')
                        
                        #Plot canopy difference
                        plot(canopy_diff)
                        
                        #Add tree hulls to current plot ('add = TRUE')
                        plot(treeout, add = TRUE) 
                        
                        #Identify trees > 7m height
                        
                                #Height Threshold = 7m
                                threshold <- 7
                                
                                #Get tree heights (of trees >5m)
                                new_trees <- extract(canopy_diff,
                                                     treeout,
                                                     fun = max,
                                                     na.rm = TRUE)
                                
                                #Get indices of tree heights vector where height > threshold (7m)
                                big_trees <- which(extract(canopy_diff, treeout, fun = max, na.rm = T) > threshold)
                        
                        #Clip out polygons of 'big trees'
                                
                                #Initial clip and define object
                                ## Note: this function uses the geometry of the 'tree hull' polygons to clip out LiDAR points
                                

                                #For each large tree (in vector of large tree indices)
                                for(i in 1:length(big_trees)){
                                        
                                        print(i)
                                        small_trees <- lasfilter(indiv_trees, !indiv_trees@data$treeID %in% big_trees)
                                        
                                        #Clip out corresponding polygon 
                                        large_tree <- lasclip(indiv_trees, treeout@polygons[[big_trees[i]]]@Polygons[[1]])
                                        plot(small_trees)
                                        
                                }
                                
                                bratsberg_ub_clip<-lasclip(indiv_trees,treeout@polygons[[big_trees[1]]]@Polygons[[1]],inside=F) #remove trees larger than 7m
                                for(i in 2:length(big_trees)){
                                        print(i)
                                        bratsberg_ub_clip<-lasclip(bratsberg_ub_clip,treeout@polygons[[big_trees[i]]]@Polygons[[1]],inside=F)}
                                plot(bratsberg_ub_clip)
                        
                                
                                
                                
                                
                                
                                
                                
                                
                        canopy_diff_bratsberg_b_clip <- (as.raster(grid_canopy(bratsberg_b_clip,res=0.5))-(crop(as.raster(grid_terrain(bratsberg_b_clip,method='knnidw',res=0.5)),as.raster(grid_canopy(bratsberg_b_clip,res=0.5)))))
                        plot(canopy_diff_bratsberg_b_clip)
                        
                
                
    