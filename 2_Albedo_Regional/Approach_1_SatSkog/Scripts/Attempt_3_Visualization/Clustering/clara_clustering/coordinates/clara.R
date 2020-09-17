## This is a script to cluster/regionalize the SatSkog albedo data product by climate, elevation,
## and forest parameters (in order to "fix parameters" and examine moose density vs albedo in each
## cluster)

# It attemps to use the CLARA algorithm, which was used by Long et al. (2009) to cluster
# areas of forest based on forest parameters

#CLARA is an extension of PAM for large datasets

##NOTE: This version of the CLARA script further delimits the study area to central
#and southern Norway (in order to better cluster)


#PACKAGES ----------------------------------------------------------------------

        #Spatial Data Packages
        library(sf)
        
        #Data Manipulation + Visualization
        library(ggplot2)
        library(raster)
        library(lattice)
        library(dplyr)
        library(wesanderson)
        library(beepr)
        
        #Clustering
        library(cluster)
        library(caret)
        library(factoextra)
        library(clusterSim)
        
        #Define beepr path
        b <- "4_Misc/beepr_sound.wav"


#END PACKAGES ----------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#IMPORT DATA --------------------------------------------------------------------------------------------------

        #Load unified & FILTERED shapefile w/ all variables
        data <- st_read("2_Albedo_Regional/Data/Final_Shapefile/Output/attempt_3/1999_only/corrected_shapefile_1999.shp")
        
        #Verify 1999 only
        data1999 <- data[data$Snrg_yr == 1999,]  #This reduced the dataset by >40%
        rm(data)
        
        #Remove duplicate geometries
        data1999 <- distinct(data1999, .keep_all = T)

        beep(b)



#END IMPORT DATA --------------------------------------------------------------------------------------------------
        
        
        
        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#CLARA CLUSTERING ------------------------------------------------------------------------------

        #Plot (simplified) centroids to delimit
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
        
        #Save normalized data to CSV ----------
        write.csv(norm1, "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_3_Visualization/Clustering/clara_clustering/coordinates/clara_normalized_variables.csv")

        
        #Run the CLARA algorithm ----------
        
                #To select the "best" number of clusters, I'm going to run CLARA for k=2 to k=30
                #I'm then going to create a df with avg. silhouette scores
        
                #This is a balance between finding homogenous areas (i.e. clustering) and
                #getting a range of values
        
                #Method: Average Silhouette Method (Kaufman and Rousseeuw 1990)
        
                        sils <- data.frame("Clusters" = integer(), "Avg_Sil_Width" = double(), "DB_Index" = double())
                        
                        for(i in 2:30){
                                
                                print(i)
                                
                                #CLARA algorithm 
                                clara.res <- clara(norm1, k = i, metric = "euclidean", stand = T, 
                                                   samples = 50, pamLike = FALSE, correct.d = T)
                                
                                        #Get avg. silhouette values
                                        sils[i-1,"Clusters"] <- i
                                        sils[i-1, "Avg_Sil_Width"] <- clara.res$silinfo$avg.width
                                        
                                        #Calculate Davies-Bouldin's index
                                        db <- index.DB(x = norm1, cl = clara.res$clustering, centrotypes = "centroids")
                                        sils[i-1, "DB_Index"] <- db$DB
                                        
                        }
                        
                        beep(8)
                        
                        #Aiming to identify # of clusters where ASW is highest and 
                        #DB is lowest (Long et al. (2010)) - i.e. where DB - ASW is lowest
                        
                                #Calculate DB - ASW for each number of clusters
                                sils$Diff <- sils$DB_Index - sils$Avg_Sil_Width
                                
                                #Create df version for plotting
                                asw <- data.frame("Index_Value" = sils$Avg_Sil_Width, "Index_Name" = "ASW", "Clusters" = sils$Clusters)
                                db <- data.frame("Index_Value" = sils$DB_Index, "Index_Name" = "DB",  "Clusters" = sils$Clusters)
                                diff <- data.frame("Index_Value" = sils$Diff, "Index_Name" = "DB-ASW",  "Clusters" = sils$Clusters)
                                melt <- rbind(asw, db, diff)
                                
                                #Plot index values vs. # of clusters
                                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_3_Visualization/Clustering/clara_clustering/coordinates/clara_clustering_indices_plot.png",
                                    bg = "white",
                                    height = 900,
                                    width = 1200,
                                    units = "px")
                                
                                ggplot(melt, aes(x = Clusters, y = Index_Value, color = Index_Name, group = Index_Name)) +
                                        geom_point(aes(shape = Index_Name)) +
                                        geom_line() +
                                        ggtitle("DB & ASW Indices vs. Clusters")
                                
                                dev.off()
                                
                                beep(b)
                                
                                
                                
## DB is smallest and ASW is largest when K = 11 clusters --------------
## Let's explore CLARA clustering with k = 11
                                
        
        #CLARA algorithm w/ k = 11
        set.seed(123)
        clara.res <- clara(norm1, k = 11, metric = "euclidean", stand = T, 
                           samples = 50, pamLike = FALSE, correct.d = T)
        beep(b)
                
                
        #Bind cluster IDs to spatial object ----------
                
                #Bind vector of cluster IDs to data (output from CLARA)
                data_viz <- cbind(data1999, clara.res$clustering)
                colnames(data_viz)[131] <- "Cluster"
                data_viz$Cluster <- as.factor(data_viz$Cluster)
                
                
        #Save shapefile ----------
                
                #Write full ESRI shapefile to relevant output directory
                st_write(data_viz, "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_3_Visualization/Clustering/clara_clustering/coordinates/clusters/shapefile/clara_clustered.shp", driver = "ESRI Shapefile", append = FALSE)
                
                
        #Visualize clusters in a plot -----------
                
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_3_Visualization/Clustering/clara_clustering/coordinates/clara_clustering.png",
                    bg = "white",
                    height = 1500,
                    width = 1500,
                    units = "px")
                
                ggplot() +
                        geom_sf(data = data_viz, aes(fill = Cluster, color = Cluster), lwd = 0.1)
                
                dev.off()
                
                beep(b)
                
                
                        #Plot individual clusters
                
                        for(i in 1:11){
                                
                                png(filename = paste("2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_3_Visualization/Clustering/clara_clustering/coordinates/clusters/geometry/cluster_", i, ".png", sep = ""),
                                    bg = "white",
                                    height = 1500,
                                    width = 1500,
                                    units = "px")
                                
                                print(ggplot() +
                                        geom_sf(data = subset(data_viz, Cluster == i), aes(fill = Cluster, color = Cluster), lwd = 0.1))
                                
                                dev.off()
                                
                        }
                        
                        beep(b)
                

        #Visualize silhouette plot of CLARA w/ k=11 -------------
                
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_3_Visualization/Clustering/clara_clustering/coordinates/clara_silhouette_plot.png",
                    bg = "white",
                    height = 1500,
                    width = 1500,
                    units = "px")
                
                fviz_silhouette(clara.res, label = F)
                
                dev.off()
        
                
        #Examine each cluster in greater detail ----------
                
                #Histograms of relevant variables ---------
                
                        #Moose Density ---------
                        gg1 <- ggplot(data_viz, aes(x = Ms_Dnst, fill = Cluster)) +
                                        geom_histogram() +
                                        facet_wrap(~ Cluster) + 
                                        ggtitle("Moose Density (by Cluster)") +
                                        labs(x = "Moose Metabolic Biomass (kg/km2)")
                
                                #Looks like 1-4 have good spread of moose density
                
                        #Red Deer Density ---------
                        gg2 <- ggplot(data_viz, aes(x = Rd_Dnst, fill = Cluster)) +
                                        geom_histogram() +
                                        facet_wrap(~ Cluster) + 
                                        ggtitle("Red Deer Density (by Cluster)") +
                                        labs(x = "Red Deer Metabolic Biomass (kg/km2)")
                        
                                #Looks like 1, 2, 4, 5, and 6 have low reed deer densities
                                #3 has greater spread
                                
                        #Roe Deer Density ---------
                        gg3 <- ggplot(data_viz, aes(x = R_d_Dns, fill = Cluster)) +
                                        geom_histogram() +
                                        facet_wrap(~ Cluster)  + 
                                        ggtitle("Roe Deer Density (by Cluster)") +
                                        labs(x = "Roe Deer Metabolic Biomass (kg/km2)")
                
                                #Looks like 1, 2, and 5 have low roe deer density
                                #3 and 4 have larger spread

                        #Sheep Density ---------
                        gg4 <- ggplot(data_viz, aes(x = Sh_Dnst, fill = Cluster)) +
                                        geom_histogram() +
                                        facet_wrap(~ Cluster) + 
                                        ggtitle("Sheep Density (by Cluster)") +
                                        labs(x = "Sheep Metabolic Biomass (kg/km2)")
                                
                                #Similar distributions, except for 3
                
                        #Age ---------
                        gg5 <- ggplot(data_viz, aes(x = alder, fill = Cluster)) +
                                        geom_histogram() +
                                        facet_wrap(~ Cluster) +
                                        ggtitle("Forest Plot Age (by Cluster)") +
                                        labs(x = "Plot Age (Years)")
                        
                                #All have similar distributions
        
                
                        #SWE (Jan) ---------
                        gg6 <- ggplot(data_viz, aes(x = SWE_M_1, fill = Cluster)) +
                                        geom_histogram() +
                                        facet_wrap(~ Cluster) +
                                        ggtitle("January SWE (by Cluster)") +
                                        labs(x = "SWE (mm)")
                
                                #Clusters 1,3,and 4 have low SWE
                                #Cluster 2 has slightly larger spread
                                #Cluster 5 has less spread but few observations and higher SWE
                
                
                        #Temp (Aug) ---------
                        gg7 <- ggplot(data_viz, aes(x = Tmp_M_8, fill = Cluster)) +
                                        geom_histogram() +
                                        facet_wrap(~ Cluster)  +
                                        ggtitle("August Temperature (by Cluster)") +
                                        labs(x = "Temperature (C)")
                
                                #1,3,4, and 5 have smallest spread
                
                        #Plot Volumes ----------
                        gg8 <- ggplot(data_viz, aes(x = vuprha, fill = Cluster)) +
                                        geom_histogram() +
                                        facet_wrap(~ Cluster) +
                                        ggtitle("Plot volumes (by Cluster)") +
                                        labs(x = "Plot Volume (m3/ha)")
                        
                                #Reasonably similar distributions
                
                        #Bonitet ---------
                        gg9 <- ggplot(data_viz, aes(x = bonitet, fill = Cluster)) +
                                        geom_histogram(bins = 4) +
                                        facet_wrap(~ Cluster) +
                                        ggtitle("Bonitet (by Cluster)") +
                                        labs(x = "Bonitet Value")
                
                                #Variable distributions
                
                        #Dominant Tree Type ---------
                        data_viz$treslag <- as.factor(data_viz$treslag)
                        gg10 <- ggplot(data_viz, aes(x = treslag, fill = treslag)) +
                                        geom_bar() +
                                        facet_wrap(~ Cluster) +
                                        ggtitle("Plot Dominant Tree Type (by Cluster)") +
                                        labs(x = "Dominant Tree Type")
                        
                        
                        #Elevation ----------
                        gg11 <- ggplot(data_viz, aes(x = dem, fill = Cluster)) +
                                geom_histogram() +
                                facet_wrap(~ Cluster) +
                                ggtitle("Plot Elevation (by Cluster)") +
                                labs(x = "Avg. Elevation (m)")
                
                        
                #Plot descriptive stuff ------------
                for(i in 1:11){
                        
                        png(filename = paste("2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_3_Visualization/Clustering/clara_clustering/coordinates/clusters/descriptive/descriptive_plot_", i, ".png", sep = ""),
                            bg = "white",
                            height = 1500,
                            width = 1500,
                            units = "px")
                        
                        print(get(paste("gg", i, sep = ""), envir = .GlobalEnv))
                        
                        dev.off()
                }
                        
    
##Selected and explored clusters - let's look at albedo in each --------------
##NOTE: Subsetting to Clusters 1, 2, 3, 6, and 7 - good spread of moose density (unlike other clusters)
                        
        #Subset data to clusters 1-4
        sel <- data_viz[data_viz$Cluster %in% c(1,2,3,6,7),]
                        
        #NO AGE INTERVAL ------
                        
                #January
                        
                        #Spruce
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_3_Visualization/Clustering/clara_clustering/coordinates/clusters/scatterplots/density_albedo_jan.png",
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
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_3_Visualization/Clustering/clara_clustering/coordinates/clusters/scatterplots/density_albedo_birch_jan.png",
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
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_3_Visualization/Clustering/clara_clustering/coordinates/clusters/scatterplots/density_albedo_april.png",
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
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_3_Visualization/Clustering/clara_clustering/coordinates/clusters/scatterplots/density_albedo_birch_april.png",
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
                        
                        
                        
        #FACETED BY SITE BONITET - NO AGE INTERVAL ---------
                        
                #January
                        
                        #Spruce
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_3_Visualization/Clustering/clara_clustering/coordinates/clusters/scatterplots/density_albedo_spruce_jan_bonitet.png",
                            bg = "white",
                            height = 1000,
                            width = 1000,
                            units = "px")
                        
                        ggplot(data = sel, aes(x = Ms_Dnst, y = M_1_A_S, color = Cluster, group = Cluster)) +
                                geom_point(alpha = 0.1, size = 0.4) +
                                geom_jitter(alpha = 0.1, size = 0.4) +
                                geom_smooth() +
                                facet_wrap(~ bonitet) +
                                ggtitle("Moose Density vs. Spruce Albedo (Jan)\nFaceted by Site Quality ('Bonitet')") +
                                labs(x = "Moose Metabolic Biomass (kg/km2)", y = "Spruce Albedo (Jan)") +
                                scale_y_continuous(limits = c(0,1), breaks = c(0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0))
                        
                        dev.off()
                        
                        #Birch
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_3_Visualization/Clustering/clara_clustering/coordinates/clusters/scatterplots/density_albedo_birch_jan_bonitet.png",
                            bg = "white",
                            height = 1000,
                            width = 1000,
                            units = "px")
                        
                        ggplot(data = sel, aes(x = Ms_Dnst, y = M_1_A_B, color = Cluster, group = Cluster)) +
                                geom_point(alpha = 0.1, size = 0.4) +
                                geom_jitter(alpha = 0.1, size = 0.4) +
                                geom_smooth() +
                                facet_wrap(~ bonitet) +
                                ggtitle("Moose Density vs. Birch Albedo (Jan)\nFaceted by Site Quality ('Bonitet')") +
                                labs(x = "Moose Metabolic Biomass (kg/km2)", y = "Birch Albedo (Jan)") +
                                scale_y_continuous(limits = c(0,1), breaks = c(0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0))
                        
                        dev.off()
        
        #AGE INTERVAL (15x 2-year intervals) --------
                
                
                #January
                        
                        #Spruce
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_3_Visualization/Clustering/clara_clustering/coordinates/clusters/scatterplots/density_albedo_jan_by_age.png",
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
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_3_Visualization/Clustering/clara_clustering/coordinates/clusters/scatterplots/density_albedo_birch_jan_by_age.png",
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
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_3_Visualization/Clustering/clara_clustering/coordinates/clusters/scatterplots/density_albedo_april_by_age.png",
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
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_3_Visualization/Clustering/clara_clustering/coordinates/clusters/scatterplots/density_albedo_birch_april_by_age.png",
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
                        
                        
                
#END CLARA CLUSTERING ------------------------------------------------------------------------------
        