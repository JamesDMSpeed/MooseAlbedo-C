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
        library(cluster)
        library(caret)
        library(clusterSim)
        library(factoextra)
        
        #Define beepr path
        b <- "4_Misc/beepr_sound.wav"

      
#END PACKAGES ----------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#IMPORT DATA --------------------------------------------------------------------------------------------------

        #Load unified & FILTERED shapefile w/ all variables
        data <- st_read("2_Albedo_Regional/Data/Final_Shapefile/Output/attempt_2/full_resolution/final_shapefile_v2.shp")
        
        #Remove duplicate geometries
        data <- distinct(data, .keep_all = T)
        beep(5)
        
        #Looks like there are some null values for elevation (-9999) - reassign as NA
        data$dem[data$dem < 0] <- NA
        
        #Filter to 1999 only
        data1999 <- data[data$Snrg_yr == 1999,]  #This reduced the dataset by >40%
        rm(data)
        
        beep(b)
        
                
#END IMPORT DATA --------------------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        
   
             
        
#KMEANS CLUSTERING (WITH COORDINATES) ---------------------------------------------------------------------------------------
                
        #K-Means Clustering ---------
                
                #Format data & get centroids -----------
                
                        #Get centroids
                        centroids <- st_centroid(st_geometry(data1999), of_largest_polygon = TRUE)
                        st_crs(centroids)
                        
                        #Grab coordinates of centroids (Latitude + Longitude)
                        coords <- as.data.frame(st_coordinates(centroids))

                        
                #Subset dataset to desired variables for clustering ----------
                        
                        #VARIABLES:
                        
                                #Age
                                #Mean elevation (m)
                                #SWE & Temp (Months 1-12)
                                
                                cl <- st_drop_geometry(data1999[,c(1,14,42:65)])
                        
                #Bind centroid coordinates to data used for clustering ----------
                cl <- cbind(cl, coords)
                
                #Standardized the data (using caret package) & remove NA rows ----------
                preproc1 <- preProcess(cl, method=c("center", "scale"))
                norm1 <- predict(preproc1, cl) #Data standardized
                
                
                #Save normalized data w/ coordinates to CSV ----------
                write.csv(norm1, "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_2_Visualization/Initial_Plots/kmeans_clustering/coordinates/kmeans_normalized_has_coords.csv")
                
                        
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
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_2_Visualization/Initial_Plots/kmeans_clustering/coordinates/wss_scree_plot.png",
                            width = 2000,
                            height = 2000,
                            units = "px",
                            bg = "white")
                        
                        wssplot(norm1, nc = 30)
                        
                        dev.off()
                        
                        beep(b)
                        
                        
#SUMMARY of wssplot: Elbow plot seems to indicate that ~11 clusters is ideal for kmeans clustering ------
        
        
        #K-means clustering with 11 clusters (k = 11) --------------
        set.seed(1234)
        dc_k <- kmeans(norm1, centers = 11, nstart = 20) 
        data_viz <- cbind(data1999, dc_k$cluster)
        colnames(data_viz)[132] <- "Cluster"
        data_viz$Cluster <- as.factor(data_viz$Cluster)
        
        
        #Save shapefile ----------
        
                #Write full ESRI shapefile to relevant output directory
                st_write(data_viz, "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_2_Visualization/Initial_Plots/kmeans_clustering/coordinates/clusters/shapefile/kmeans_clustered.shp", driver = "ESRI Shapefile", append = FALSE)
                
        
                #Plot clusters together -------
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_2_Visualization/Initial_Plots/kmeans_clustering/coordinates/kmeans_clusters.png",
                    width = 1200,
                    height = 1200,
                    units = "px",
                    bg = "white")
                
                ggplot() +
                        geom_sf(data = data_viz, aes(fill = Cluster, color = Cluster), lwd = 0.1)
                
                dev.off()
                
                beep(b)
                 
                
                #Plot individual clusters ---------
                for(i in 1:11){
                        
                        png(filename = paste("2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_2_Visualization/Initial_Plots/kmeans_clustering/coordinates/clusters/geometry/cluster_", i, ".png", sep = ""),
                            bg = "white",
                            height = 1500,
                            width = 1500,
                            units = "px")
                        
                        print(ggplot() +
                                      geom_sf(data = subset(data_viz, Cluster == i), aes(fill = Cluster, color = Cluster), lwd = 0.1))
                        
                        dev.off()
                        
                }
                
                beep(b)

                #Examine each cluster in greater detail ----------
                
                        #Histograms of relevant variables ---------
                        
                                #Moose Density ---------
                                gg1 <- ggplot(data_viz, aes(x = Ms_Dnst, fill = Cluster)) +
                                        geom_histogram() +
                                        facet_wrap(~ Cluster) + 
                                        ggtitle("Moose Density (by Cluster)") +
                                        labs(x = "Moose Metabolic Biomass (kg/km2)")
                                
                                #Red Deer Density ---------
                                gg2 <- ggplot(data_viz, aes(x = Rd_Dnst, fill = Cluster)) +
                                        geom_histogram() +
                                        facet_wrap(~ Cluster) + 
                                        ggtitle("Red Deer Density (by Cluster)") +
                                        labs(x = "Red Deer Metabolic Biomass (kg/km2)")
                                
                                
                                #Roe Deer Density ---------
                                gg3 <- ggplot(data_viz, aes(x = R_d_Dns, fill = Cluster)) +
                                        geom_histogram() +
                                        facet_wrap(~ Cluster)  + 
                                        ggtitle("Roe Deer Density (by Cluster)") +
                                        labs(x = "Roe Deer Metabolic Biomass (kg/km2)")
                                
                                
                                #Sheep Density ---------
                                gg4 <- ggplot(data_viz, aes(x = Sh_Dnst, fill = Cluster)) +
                                        geom_histogram() +
                                        facet_wrap(~ Cluster) + 
                                        ggtitle("Sheep Density (by Cluster)") +
                                        labs(x = "Sheep Metabolic Biomass (kg/km2)")
                                

                                #Age ---------
                                gg5 <- ggplot(data_viz, aes(x = alder, fill = Cluster)) +
                                        geom_histogram() +
                                        facet_wrap(~ Cluster) +
                                        ggtitle("Forest Plot Age (by Cluster)") +
                                        labs(x = "Plot Age (Years)")
                                
                                
                                #SWE (Jan) ---------
                                gg6 <- ggplot(data_viz, aes(x = SWE_M_1, fill = Cluster)) +
                                        geom_histogram() +
                                        facet_wrap(~ Cluster) +
                                        ggtitle("January SWE (by Cluster)") +
                                        labs(x = "SWE (mm)")
                                
                                
                                #Temp (Aug) ---------
                                gg7 <- ggplot(data_viz, aes(x = Tmp_M_8, fill = Cluster)) +
                                        geom_histogram() +
                                        facet_wrap(~ Cluster)  +
                                        ggtitle("August Temperature (by Cluster)") +
                                        labs(x = "Temperature (C)")
                                
                                #Plot Volumes ----------
                                gg8 <- ggplot(data_viz, aes(x = vuprha, fill = Cluster)) +
                                        geom_histogram() +
                                        facet_wrap(~ Cluster) +
                                        ggtitle("Plot volumes (by Cluster)") +
                                        labs(x = "Plot Volume (m3/ha)")
                                
                                #Bonitet ---------
                                gg9 <- ggplot(data_viz, aes(x = bonitet, fill = Cluster)) +
                                        geom_histogram(bins = 4) +
                                        facet_wrap(~ Cluster) +
                                        ggtitle("Bonitet (by Cluster)") +
                                        labs(x = "Bonitet Value")
                                
                                #Dominant Tree Type ---------
                                data_viz$treslag <- as.factor(data_viz$treslag)
                                gg10 <- ggplot(data_viz, aes(x = treslag, fill = treslag)) +
                                        geom_bar() +
                                        facet_wrap(~ Cluster) +
                                        ggtitle("Plot Dominant Tree Type (by Cluster)") +
                                        labs(x = "Dominant Tree Type")
                                
                                #Elevation ----
                                gg11 <- ggplot(data_viz, aes(x = dem, fill = dem)) +
                                        geom_bar() +
                                        facet_wrap(~ Cluster) +
                                        ggtitle("Elevation (by Cluster)") +
                                        labs(x = "Elevation (m)")
                        
                
                #Plot descriptive stuff ------------
                for(i in 1:11){
                        
                        png(filename = paste("2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_2_Visualization/Initial_Plots/kmeans_clustering/coordinates/clusters/descriptive/descriptive_plot_", i, ".png", sep = ""),
                            bg = "white",
                            height = 1500,
                            width = 1500,
                            units = "px")
                        
                        print(get(paste("gg", i, sep = ""), envir = .GlobalEnv))
                        
                        dev.off()
                }
                                
                beep(b)
                      
                
                
##SUBSET TO CLUSTERS 1,2,3,5,7, and 11 (good spread of moose density)
                
        #Subset data to clusters 1-4
        sel <- data_viz[data_viz$Cluster %in% c(1,2,3,5,7,11),]    
        
        
        #NO AGE INTERVAL ------
                
                #January
                
                        #Spruce
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_2_Visualization/Initial_Plots/kmeans_clustering/coordinates/clusters/scatterplots/density_albedo_jan.png",
                            bg = "white",
                            height = 1000,
                            width = 1000,
                            units = "px")
                        
                        ggplot(data = sel, aes(x = Ms_Dnst, y = M_1_A_S, color = Cluster, group = Cluster)) +
                                geom_point(alpha = 0.1, size = 0.4) +
                                geom_jitter(alpha = 0.1, size = 0.4) +
                                geom_smooth() +
                                ggtitle("Moose Density vs. Spruce Albedo (Jan)") +
                                labs(x = "Moose Metabolic Biomass (kg/km2)", y = "Spruce Albedo (Jan)") +
                                scale_y_continuous(limits = c(0,1), breaks = c(0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0))
                        
                        dev.off()
                        
                        #Birch
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_2_Visualization/Initial_Plots/kmeans_clustering/coordinates/clusters/scatterplots/density_albedo_birch_jan.png",
                            bg = "white",
                            height = 1000,
                            width = 1000,
                            units = "px")
                        
                        ggplot(data = sel, aes(x = Ms_Dnst, y = M_1_A_B, color = Cluster, group = Cluster)) +
                                geom_point(alpha = 0.1, size = 0.4) +
                                geom_jitter(alpha = 0.1, size = 0.4) +
                                geom_smooth() +
                                ggtitle("Moose Density vs. Birch Albedo (Jan)") +
                                labs(x = "Moose Metabolic Biomass (kg/km2)", y = "Birch Albedo (Jan)") +
                                scale_y_continuous(limits = c(0,1), breaks = c(0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0))
                        
                        dev.off()
                        
                #April
                
                        #Spruce
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_2_Visualization/Initial_Plots/kmeans_clustering/coordinates/clusters/scatterplots/density_albedo_april.png",
                            bg = "white",
                            height = 1000,
                            width = 1000,
                            units = "px")
                        
                        ggplot(data = sel, aes(x = Ms_Dnst, y = M_4_A_S, color = Cluster, group = Cluster)) +
                                geom_point(alpha = 0.1, size = 0.4) +
                                geom_jitter(alpha = 0.1, size = 0.4) +
                                geom_smooth() +
                                ggtitle("Moose Density vs. Spruce Albedo (Apr)") +
                                labs(x = "Moose Metabolic Biomass (kg/km2)", y = "Spruce Albedo (April)") +
                                scale_y_continuous(limits = c(0,1), breaks = c(0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0))
                        
                        dev.off()
                        
                        #Birch
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_2_Visualization/Initial_Plots/kmeans_clustering/coordinates/clusters/scatterplots/density_albedo_birch_april.png",
                            bg = "white",
                            height = 1000,
                            width = 1000,
                            units = "px")
                        
                        ggplot(data = sel, aes(x = Ms_Dnst, y = M_4_A_B, color = Cluster, group = Cluster)) +
                                geom_point(alpha = 0.1, size = 0.4) +
                                geom_jitter(alpha = 0.1, size = 0.4) +
                                geom_smooth() +
                                ggtitle("Moose Density vs. Birch Albedo (Apr)") +
                                labs(x = "Moose Metabolic Biomass (kg/km2)", y = "Birch Albedo (April)") +
                                scale_y_continuous(limits = c(0,1), breaks = c(0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0))
                        
                        dev.off()
                
                        
                        
        #AGE INTERVAL (15x 2-year intervals) --------
                
                #January
                
                        #Spruce
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_2_Visualization/Initial_Plots/kmeans_clustering/coordinates/clusters/scatterplots/density_albedo_jan_by_age.png",
                            bg = "white",
                            height = 1000,
                            width = 1000,
                            units = "px")
                        
                        ggplot(data = sel, aes(x = Ms_Dnst, y = M_1_A_S, color = Cluster, group = Cluster)) +
                                geom_point(alpha = 0.1, size = 0.4) +
                                geom_jitter(alpha = 0.1, size = 0.4) +
                                geom_smooth() +
                                facet_wrap(~ cut_interval(alder, 15)) +
                                ggtitle("Moose Density vs. Spruce Albedo (Jan)\nFaceted by Age (Years)") +
                                labs(x = "Moose Metabolic Biomass (kg/km2)", y = "Spruce Albedo (January)") +
                                scale_y_continuous(limits = c(0,1), breaks = c(0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0))
                        
                        dev.off()
                
                        #Birch
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_2_Visualization/Initial_Plots/kmeans_clustering/coordinates/clusters/scatterplots/density_albedo_birch_jan_by_age.png",
                            bg = "white",
                            height = 1000,
                            width = 1000,
                            units = "px")
                        
                        ggplot(data = sel, aes(x = Ms_Dnst, y = M_1_A_B, color = Cluster, group = Cluster)) +
                                geom_point(alpha = 0.1, size = 0.4) +
                                geom_jitter(alpha = 0.1, size = 0.4) +
                                geom_smooth() +
                                facet_wrap(~ cut_interval(alder, 15)) +
                                ggtitle("Moose Density vs. Birch Albedo (Jan)\nFaceted by Age (Years)") +
                                labs(x = "Moose Metabolic Biomass (kg/km2)", y = "Birch Albedo (January)") +
                                scale_y_continuous(limits = c(0,1), breaks = c(0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0))
                        
                        dev.off()
                
                #April
                
                        #Spruce
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_2_Visualization/Initial_Plots/kmeans_clustering/coordinates/clusters/scatterplots/density_albedo_april_by_age.png",
                            bg = "white",
                            height = 1000,
                            width = 1000,
                            units = "px")
                        
                        ggplot(data = sel, aes(x = Ms_Dnst, y = M_4_A_S, color = Cluster, group = Cluster)) +
                                geom_point(alpha = 0.1, size = 0.4) +
                                geom_jitter(alpha = 0.1, size = 0.4) +
                                geom_smooth() +
                                facet_wrap(~ cut_interval(alder, 15)) +
                                ggtitle("Moose Density vs. Spruce Albedo (Apr)\nFaceted by Age (Years)") +
                                labs(x = "Moose Metabolic Biomass (kg/km2)", y = "Spruce Albedo (April)") +
                                scale_y_continuous(limits = c(0,1), breaks = c(0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0))
                        
                        dev.off()
                
                        #Birch
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_2_Visualization/Initial_Plots/kmeans_clustering/coordinates/clusters/scatterplots/density_albedo_birch_april_by_age.png",
                            bg = "white",
                            height = 1000,
                            width = 1000,
                            units = "px")
                        
                        ggplot(data = sel, aes(x = Ms_Dnst, y = M_4_A_B, color = Cluster, group = Cluster)) +
                                geom_point(alpha = 0.1, size = 0.4) +
                                geom_jitter(alpha = 0.1, size = 0.4) +
                                geom_smooth() +
                                facet_wrap(~ cut_interval(alder, 15)) +
                                ggtitle("Moose Density vs. Birch Albedo (April)\nFaceted by Age (Years)") +
                                labs(x = "Moose Metabolic Biomass (kg/km2)", y = "Birch Albedo (April)") +
                                scale_y_continuous(limits = c(0,1), breaks = c(0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0))
                        
                        dev.off()
                        
                        beep(b)
                
#END KMEANS CLUSTERING (WITH COORDINATES) ------------------------------------------------------------------------------------                
                
                
                

                
                
