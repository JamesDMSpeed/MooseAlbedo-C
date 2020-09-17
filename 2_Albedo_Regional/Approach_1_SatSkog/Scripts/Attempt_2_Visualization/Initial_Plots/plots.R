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

        #Load unified & FILTERED shapefile w/ all variables
        data <- st_read("2_Albedo_Regional/Data/Final_Shapefile/Output/attempt_2/full_resolution/final_shapefile_v2.shp")
        
        #Looks like there are some null values for elevation (-9999) - reassign as NA
        data$dem[data$dem < 0] <- NA
        
        #Isolate to data from 1999 only (to simplify parameters)
        data1999 <- data[data$Snrg_yr == 1999,]
        
                
#END IMPORT DATA --------------------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#CREATE "MELTED" VERSION OF DATASET -------------------------------------------------------------------------
        
        ##CREATE DATASET W/ SWE, TEMP, ALBEDO, & MONTH AS SINGLE COLUMNS
        # (This is necessary to plot albedo and include month in relevant models)
        ## Each polygon will have 12 distinct observations, each with an associated SWE, temp, albedo, & month (1-12)
        
        #Repeat each row of main sf object ('data') into 12 rows
        data_exp <- data[rep(seq_len(nrow(data)), each = 12), ]
        beep(8)
        
        #Create vector with repeating sequence of 1:12 (to add as month variable)
        months <- rep(c(1:12), times = (nrow(data_exp) / 12))
        data_exp$Month <- months
        data_exp$SWE <- as.numeric('')
        data_exp$Temp <- as.numeric('')
        data_exp$Albedo_Spruce <- as.numeric('')
        data_exp$Albedo_Pine <- as.numeric('')
        data_exp$Albedo_Birch <- as.numeric('')
        rm(months)
        
        #Re-assign columns based on month
        #NOTE: Looks clunky, but doing it this way is INFINITELY faster than loop
        
        #SWE
        data_exp$SWE[data_exp$Month == 1] <- data_exp$SWE_M_1[data_exp$Month == 1]
        data_exp$SWE[data_exp$Month == 2] <- data_exp$SWE_M_2[data_exp$Month == 2]
        data_exp$SWE[data_exp$Month == 3] <- data_exp$SWE_M_3[data_exp$Month == 3]
        data_exp$SWE[data_exp$Month == 4] <- data_exp$SWE_M_4[data_exp$Month == 4]
        data_exp$SWE[data_exp$Month == 5] <- data_exp$SWE_M_5[data_exp$Month == 5]
        data_exp$SWE[data_exp$Month == 6] <- data_exp$SWE_M_6[data_exp$Month == 6]
        data_exp$SWE[data_exp$Month == 7] <- data_exp$SWE_M_7[data_exp$Month == 7]
        data_exp$SWE[data_exp$Month == 8] <- data_exp$SWE_M_8[data_exp$Month == 8]
        data_exp$SWE[data_exp$Month == 9] <- data_exp$SWE_M_9[data_exp$Month == 9]
        data_exp$SWE[data_exp$Month == 10] <- data_exp$SWE_M_10[data_exp$Month == 10]
        data_exp$SWE[data_exp$Month == 11] <- data_exp$SWE_M_11[data_exp$Month == 11]
        data_exp$SWE[data_exp$Month == 12] <- data_exp$SWE_M_12[data_exp$Month == 12]
        
        #TEMP
        data_exp$Temp[data_exp$Month == 1] <- data_exp$Tmp_M_1[data_exp$Month == 1]
        data_exp$Temp[data_exp$Month == 2] <- data_exp$Tmp_M_2[data_exp$Month == 2]
        data_exp$Temp[data_exp$Month == 3] <- data_exp$Tmp_M_3[data_exp$Month == 3]
        data_exp$Temp[data_exp$Month == 4] <- data_exp$Tmp_M_4[data_exp$Month == 4]
        data_exp$Temp[data_exp$Month == 5] <- data_exp$Tmp_M_5[data_exp$Month == 5]
        data_exp$Temp[data_exp$Month == 6] <- data_exp$Tmp_M_6[data_exp$Month == 6]
        data_exp$Temp[data_exp$Month == 7] <- data_exp$Tmp_M_7[data_exp$Month == 7]
        data_exp$Temp[data_exp$Month == 8] <- data_exp$Tmp_M_8[data_exp$Month == 8]
        data_exp$Temp[data_exp$Month == 9] <- data_exp$Tmp_M_9[data_exp$Month == 9]
        data_exp$Temp[data_exp$Month == 10] <- data_exp$Tmp_M_10[data_exp$Month == 10]
        data_exp$Temp[data_exp$Month == 11] <- data_exp$Tmp_M_11[data_exp$Month == 11]
        data_exp$Temp[data_exp$Month == 12] <- data_exp$Tmp_M_12[data_exp$Month == 12]
        
        #ALBEDO
        
                #Spruce
                data_exp$Albedo_Spruce[data_exp$Month == 1] <- data_exp$M_1_A_S[data_exp$Month == 1]
                data_exp$Albedo_Spruce[data_exp$Month == 2] <- data_exp$M_2_A_S[data_exp$Month == 2]
                data_exp$Albedo_Spruce[data_exp$Month == 3] <- data_exp$M_3_A_S[data_exp$Month == 3]
                data_exp$Albedo_Spruce[data_exp$Month == 4] <- data_exp$M_4_A_S[data_exp$Month == 4]
                data_exp$Albedo_Spruce[data_exp$Month == 5] <- data_exp$M_5_A_S[data_exp$Month == 5]
                data_exp$Albedo_Spruce[data_exp$Month == 6] <- data_exp$M_6_A_S[data_exp$Month == 6]
                data_exp$Albedo_Spruce[data_exp$Month == 7] <- data_exp$M_7_A_S[data_exp$Month == 7]
                data_exp$Albedo_Spruce[data_exp$Month == 8] <- data_exp$M_8_A_S[data_exp$Month == 8]
                data_exp$Albedo_Spruce[data_exp$Month == 9] <- data_exp$M_9_A_S[data_exp$Month == 9]
                data_exp$Albedo_Spruce[data_exp$Month == 10] <- data_exp$M_10_A_S[data_exp$Month == 10]
                data_exp$Albedo_Spruce[data_exp$Month == 11] <- data_exp$M_11_A_S[data_exp$Month == 11]
                data_exp$Albedo_Spruce[data_exp$Month == 12] <- data_exp$M_12_A_S[data_exp$Month == 12]
                
                #Pine
                data_exp$Albedo_Pine[data_exp$Month == 1] <- data_exp$M_1_A_P[data_exp$Month == 1]
                data_exp$Albedo_Pine[data_exp$Month == 2] <- data_exp$M_2_A_P[data_exp$Month == 2]
                data_exp$Albedo_Pine[data_exp$Month == 3] <- data_exp$M_3_A_P[data_exp$Month == 3]
                data_exp$Albedo_Pine[data_exp$Month == 4] <- data_exp$M_4_A_P[data_exp$Month == 4]
                data_exp$Albedo_Pine[data_exp$Month == 5] <- data_exp$M_5_A_P[data_exp$Month == 5]
                data_exp$Albedo_Pine[data_exp$Month == 6] <- data_exp$M_6_A_P[data_exp$Month == 6]
                data_exp$Albedo_Pine[data_exp$Month == 7] <- data_exp$M_7_A_P[data_exp$Month == 7]
                data_exp$Albedo_Pine[data_exp$Month == 8] <- data_exp$M_8_A_P[data_exp$Month == 8]
                data_exp$Albedo_Pine[data_exp$Month == 9] <- data_exp$M_9_A_P[data_exp$Month == 9]
                data_exp$Albedo_Pine[data_exp$Month == 10] <- data_exp$M_10_A_P[data_exp$Month == 10]
                data_exp$Albedo_Pine[data_exp$Month == 11] <- data_exp$M_11_A_P[data_exp$Month == 11]
                data_exp$Albedo_Pine[data_exp$Month == 12] <- data_exp$M_12_A_P[data_exp$Month == 12]
                
                #Birch
                data_exp$Albedo_Birch[data_exp$Month == 1] <- data_exp$M_1_A_B[data_exp$Month == 1]
                data_exp$Albedo_Birch[data_exp$Month == 2] <- data_exp$M_2_A_B[data_exp$Month == 2]
                data_exp$Albedo_Birch[data_exp$Month == 3] <- data_exp$M_3_A_B[data_exp$Month == 3]
                data_exp$Albedo_Birch[data_exp$Month == 4] <- data_exp$M_4_A_B[data_exp$Month == 4]
                data_exp$Albedo_Birch[data_exp$Month == 5] <- data_exp$M_5_A_B[data_exp$Month == 5]
                data_exp$Albedo_Birch[data_exp$Month == 6] <- data_exp$M_6_A_B[data_exp$Month == 6]
                data_exp$Albedo_Birch[data_exp$Month == 7] <- data_exp$M_7_A_B[data_exp$Month == 7]
                data_exp$Albedo_Birch[data_exp$Month == 8] <- data_exp$M_8_A_B[data_exp$Month == 8]
                data_exp$Albedo_Birch[data_exp$Month == 9] <- data_exp$M_9_A_B[data_exp$Month == 9]
                data_exp$Albedo_Birch[data_exp$Month == 10] <- data_exp$M_10_A_B[data_exp$Month == 10]
                data_exp$Albedo_Birch[data_exp$Month == 11] <- data_exp$M_11_A_B[data_exp$Month == 11]
                data_exp$Albedo_Birch[data_exp$Month == 12] <- data_exp$M_12_A_B[data_exp$Month == 12]
        
        #Remove replaced columns
        data_exp <- data_exp[,c(1:41, 103:138)] #Shapefile output is HUGE and takes forever to load, easier to just process initial df
        
        beep(8)
        
                #NOTE: I haven't saved this 'melted' version of the unified shapefile, as it's a HUGE file
                ## Loading the initial shapefile and then running the code above is MUCH faster
        
#END CREATE "MELTED" VERSION OF DATASET -------------------------------------------------------------------------
        
  
        
              
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        
   
             
        
#INITIAL DATA EXPLORATION  --------------------------------------------------------------------------------------------------

        #Define color palette
        myPalette <- colorRampPalette(rev(brewer.pal(11, "Spectral")))
        
        #AGE ---------------------------------
        
                #Explore age
                min(data$alder) #Min age of 1 year
                max(data$alder) #Max age of 30 years
                
                #Plot histogram of age by 2-year intervals
                ggplot(data = subset(data_exp, Month == 4), aes(x = Ms_Dnst, y = Albedo_Spruce)) +
                        geom_bin2d(binwidth = c(5,0.025)) +
                        facet_wrap(~ cut_interval(alder, 15)) +
                        geom_smooth(colour = "red") +
                        ggtitle("Moose Density vs. Spruce Albedo (April)\nSplit by 15 age intervals") +
                        labs(x = "Moose Density (kg/km-2)", y = "Albedo")
                
                        ##Looks like ages 7-30 have strongest trend
                
                #Fix age to specific interval (8-10), and then facet by elevation
                ggplot(data = subset(data_exp, Month == 4 & alder >=8 & alder <= 10), aes(x = Ms_Dnst, y = Albedo_Spruce)) +
                        geom_bin2d(binwidth = c(5,0.025)) +
                        facet_wrap(~ cut_interval(dem, 15)) +
                        geom_smooth(colour = "red") +
                        ggtitle("Moose Density vs. Spruce Albedo (April)\nSplit by 15 elevation intervals") +
                        labs(x = "Moose Density (kg/km-2)", y = "Albedo")
                
                        #Looks like 70-300m has the most data for higher moose densities in this age range
                
                #Facet by SWE (with elevation of 70-100m, removing SWE greater than 300)
                ggplot(data = subset(data_exp, Month == 4 & alder >=8 & alder <= 10 & dem >= 70 & dem <= 100 & SWE <= 300), aes(x = Ms_Dnst, y = Albedo_Spruce)) +
                        geom_point(alpha = 0.5) +
                        facet_wrap(~ cut_interval(SWE, 20)) +
                        geom_smooth(colour = "red") +
                        ggtitle("Moose Density vs. Spruce Albedo (April)\nSplit by 15 elevation intervals") +
                        labs(x = "Moose Density (kg/km-2)", y = "Albedo")
        
##WHEN I get to very fixed parameters (ex. age 8-10, elevation 70-100m, SWE <300, month of April), I see much
## less variation in some of the plots - however, with so many important variables to filter down by, I'm
## going to have trouble making any reasonable conclusions. I think trying some kind of geospatial clustering
## is going to make much more sense - i.e. I'll essentially be "filtering down" my dataset into a smaller dataset
## where SWE, temp, elevation, and age are similar. Major concern with this approach is whether or not there 
## will be enough diversity in moose density to make reasonable conclusions
                
                
#END INITIAL DATA EXPLORATION --------------------------------------------------------------------------    
                
                
                
                
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                
                
                
                
#CLUSTERING ---------------------------------------------------------------------------------------
                
        #K-Means Clustering
                
                #Format data & get centroids
                
                        #Copy of data
                        db <- data1999
                
                        #Filter to relevant columns
                        db <- db[ ,c(1,11,14,30,42:102,112:129)]
                        
                                ##Looks like elevation is strongly correlated with SWE and Temp
                                ##Only going to cluster by age and temperature
                
                        #Remove rows w/ NA values
                        db <- na.omit(db)
                        
                        #Create another copy to generate clusters from (with
                        #only variables that will be useful to cluster with)
                        
                                #Age
                                #Bonitet
                                #Elevation
                                #SWE (Months 1-12)
                                #Temperature (Months 1-12)
                                #Deer Densities (year 1999)
                        
                        dc <- db[,c(1:3,5:28,70:71)]
                        
                        #Compute centroids for all polygons (grabs centroids from largest polygons)
                        dc_centroids <- st_centroid(st_geometry(dc), of_largest_polygon = TRUE)
                        
                        #Grab coordinates of centroids
                        dc_coords <- as.data.frame(st_coordinates(dc_centroids))
                        
                        #Bind centroid coordinates with data
                        dc <- cbind(dc, dc_coords)
                        dc <- st_drop_geometry(dc)
                        
                
                #Function to identify ideal # of clusters (elbow/scree plot of Within-cluster sum of squares vs # of clusters)
                ## Source: https://towardsdatascience.com/clustering-analysis-in-r-using-k-means-73eca4fb7967
                
                        #Define function
                        wssplot <- function(data, nc = 30, seed = 123){
                                wss <- (nrow(data)-1)*sum(apply(data,2,var))
                                for (i in 2:nc){
                                        set.seed(seed)
                                        wss[i] <- sum(kmeans(data, centers=i)$withinss)}
                                plot(1:nc, wss, type="b", xlab="Number of groups",
                                     ylab="Sum of squares within a group")}
                
                        #Run function & export plot
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_2_Visualization/Initial_Plots/kmeans_clustering/wss_scree_plot.png",
                            width = 2000,
                            height = 2000,
                            units = "px",
                            bg = "white")
                        
                        wssplot(dc, nc = 30)
                        
                        dev.off()
                        
                        beep(8)
                        
#SUMMARY of wssplot: Indicates that there may only be 4-6 clusters in the data 
#I'm going to remove "age" from the clustering data and see what happens
                        
        #Drop age
        dd <- dc[,2:ncol(dc)]
                        
        #WSS Plot                 
        wssplot(dd, nc = 1000)                
        beep(8)
        
                #Still 4-6 clusters looks best
        
#Going to try clustering by Jan SWE & coordinates only
        
        dd <- dc[,c(4,30,31)]
        wssplot(dd, nc = 30)
        beep(8)

## I think this means that the data is too heterogenous (in terms of age, SWE, Temp, and elevation)
## across the whole of Norway to actually form meaningful clusters (at least at a national scale)
                        
        ##It might be worth it to try to subset the data down further and cluster it
        ## Maybe I could break up the data into 6 intervals by age (1-5, 6-10, and so on)
        ## Then, I could create clusters from that data
        
        
        #INCLUDING COORDINATES
        
                #5 clusters seems to be recommended
                dc_k <- kmeans(dd, centers = 5, nstart = 20) 
                dc_clustered <- cbind(dc_coords, dc_k$cluster)
                colnames(dc_clustered)[3] <- "Cluster"
                
                dc_clustered$Cluster <- as.factor(dc_clustered$Cluster)
                
                #Plot centroids in clusters
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_2_Visualization/Initial_Plots/kmeans_clustering/kmeans_cluster_plot.png",
                    width = 1200,
                    height = 1200,
                    units = "px",
                    bg = "white")
                
                ggplot(data = dc_clustered, aes(x = X, y = Y, color = Cluster)) +
                        geom_point(size = 0.25) +
                        ggtitle("K-means clustering of forest plots (k = 5)\n(coordinates included as variables)")
                
                dev.off()
          
                      
        #NOT INCLUDING COORDINATES
                
                swe_only <- dd[,1]
                wssplot(swe_only, nc = 30)
                
                #5 clusters seems to be recommended
                dc_k <- kmeans(dd[,1], centers = 5, nstart = 20) 
                dc_clustered <- cbind(dc_coords, dc_k$cluster)
                colnames(dc_clustered)[3] <- "Cluster"
                
                dc_clustered$Cluster <- as.factor(dc_clustered$Cluster)
                
                #Plot centroids in clusters
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_2_Visualization/Initial_Plots/kmeans_clustering/kmeans_cluster_plot.png",
                    width = 1200,
                    height = 1200,
                    units = "px",
                    bg = "white")
                
                ggplot(data = dc_clustered, aes(x = X, y = Y, color = Cluster)) +
                        geom_point(size = 0.25) +
                        ggtitle("K-means clustering of forest plots (k = 5)")
                
                dev.off()
                

                
#END CLUSTERING ------------------------------------------------------------------------------------                
                
                
                
                
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                
                
                

#EXPLORE WITHIN CLUSTER #3 (SE NORWAY) ---------------------------------------------------------------------------------------
   
        #Bind cluster IDs to filtered data (NAs removed from important variables)
        db <- cbind(db, dc_clustered$Cluster)
        colnames(db)[84] <- "Cluster"
        
        cluster3 <- subset(db, Cluster == 3)
        
        #Explore cluster 3 variables of interest
        histogram(cluster3$alder) #bit less skewed
        histogram(cluster3$Ms_Dnst) # nice bell-shaped distribution
        histogram(cluster3$SWE_M_1) #Still quite a bit of variation
        
                #Spruce albedo - January
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_2_Visualization/Initial_Plots/kmeans_clustering/cluster3_spruce_jan.png",
                    width = 800,
                    height = 800,
                    units = "px",
                    bg = "white")
                
                ggplot(cluster3, aes(x = Ms_Dnst, y = M_1_A_S)) +
                        geom_bin2d() +
                        geom_smooth() +
                        ggtitle("Spruce Albedo (January) for Cluster 3") +
                        labs(x = "Moose Density (kg/km2)", y = "Spruce Albedo (January)")
                
                dev.off()
                
                #TRY SUBSETTING TO REDUCE VARIATION - For low SWE (<100) & age 20-25
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_2_Visualization/Initial_Plots/kmeans_clustering/cluster3_subset.png",
                    width = 800,
                    height = 800,
                    units = "px",
                    bg = "white")
                
                ggplot(subset(cluster3, SWE_M_1 <= 100 & alder <= 25 & alder >= 20), aes(x = Ms_Dnst, y = M_1_A_S)) +
                        geom_bin2d() +
                        geom_smooth() +
                        ggtitle("Spruce Albedo (January) for Cluster 3\n (Jan. SWE < 100mm & Age 20-25 Years)")
                
                dev.off()
                
                        
#STILL SEEING LARGE VARIATION IN ALBEDO, EVEN WITH VERY SPECIFIC SUBSETTING BY SWE AND AGE
##I DON'T THINK CLUSTERING HERE IS SUCCESSFUL
                             
                        
#END EXPLORE WITHIN CLUSTER #3 (SE NORWAY) ---------------------------------------------------------------------------------------
                
                
                
                
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#CLUSTERING WITHOUT COORDINATES ---------------------------------------------------------------------------
                
        #Clustering across whole of Norway (by age and elevation) didn't really work - still a lot 
        #of variation in albedo, and difficult to see trends. I think this is because there aren't
        #clear clusters of forest with the same age (very heterogenous for a given shapefile)
                
        #Going to try clustering the data by age, dem, SWE and temperature, but NO COORDINATES, and then facet by age intervals
        ##GOAL: Identify areas with similar climatic conditions, and then see trends across age
                
                #Copy of data
                db <- data
                        
                        
                #Filter to relevant columns
                db <- db[ ,c(1,14,42,43:102,112:129)]
                
                #Remove rows w/ NA values
                db <- na.omit(db)
                
                #Create another copy to generate clusters from (with
                #only variables that will be useful to cluster with - age and elevation)
                dc <- db[,1:4]
                
                #Compute centroids for all polygons (grabs centroids from largest polygons)
                dc_centroids <- st_centroid(st_geometry(dc), of_largest_polygon = TRUE)
                
                #Grab coordinates of centroids
                dc_coords <- as.data.frame(st_coordinates(dc_centroids))
                
                #Bind centroid coordinates with data
                dc <- cbind(dc, dc_coords)
                dc <- st_drop_geometry(dc)
                
                #Identify best number of clusters
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_2_Visualization/Initial_Plots/kmeans_clustering/no_coordinates/wss_plot_no_coords.png",
                    width = 1200,
                    height = 1200,
                    units = "px",
                    bg = "white")
                
                wssplot(dc[,1:4], nc = 30)
                
                dev.off()
                
                beep(8)
                
                #Try to cluster by SWE and Temp
                dc_k <- kmeans(dc[,1:4], centers = 7, nstart = 20) 
                dc_clustered <- cbind(dc_coords, dc_k$cluster)
                colnames(dc_clustered)[3] <- "Cluster"
                dc_clustered$Cluster <- as.factor(dc_clustered$Cluster)
                
                #Plot centroids grouped by clusters
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_2_Visualization/Initial_Plots/kmeans_clustering/no_coordinates/kmeans_cluster_plot_no_coords.png",
                    width = 1200,
                    height = 1200,
                    units = "px",
                    bg = "white")
                
                ggplot(data = dc_clustered, aes(x = X, y = Y, color = Cluster)) +
                        geom_point(size = 0.25) +
                        ggtitle("K-means clustering of forest plots (k = 4)\n(Not clustered by coordinates)")
                
                dev.off()
                
                beep(2)
                
                
                
        #TRY PLOTTING BY AGE WITHIN ONE OF THE CLUSTERS
                
                #Bind cluster IDs to filtered data (NAs removed from important variables)
                db <- cbind(db, dc_clustered$Cluster)
                colnames(db)[82] <- "Cluster"
                
                #Plot cluster 3 only for January
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_2_Visualization/Initial_Plots/kmeans_clustering/no_coordinates/spruce_albedo_jan_C3.png",
                    width = 1500,
                    height = 1200,
                    units = "px",
                    bg = "white")
                
                ggplot(data = subset(db, Cluster == 3), aes(x = Ms_Dnst, y = M_1_A_S)) +
                        geom_point(alpha = 0.3) +
                        geom_jitter(alpha = 0.3) +
                        geom_smooth() +
                        facet_wrap(~ cut_interval(alder, 10)) +
                        ggtitle("Spruce Albedo (January) for Cluster 3") +
                        labs(x = "Moose Density (kg/km2)", y = "Spruce Albedo (January)")
                
                dev.off()

        
        
                
#END CLUSTERING WITHOUT COORDINATES ------------------------------------------------------------------------
      