##Script to collect, format, and process forest stand volume data (FSV) from existing
##SUSTHERB LiDAR data

## NOTE: This analysis is based on Ingrid Snøan's previous code and the LidR package tutorial here: 
## https://github.com/Jean-Romain/lidR/wiki/Segment-individual-trees-and-compute-metrics-(Part-2)

##PACKAGES ----------------------------------------------------------------------------------------

        #Packages for general data manipulation + visualization
        library(ggplot2)
        library(dplyr)
        library(RColorBrewer)
        library(wesanderson)

        #Packages related to LiDAR 
        library(raster)
        library(rasterVis)
        library(lidR)
        library(geometry)
        library(sp)
        library(concaveman)
        
        #Need to use BiocManager to install EBImage
        #BiocManager::install("EBImage")


###END PACKAGES ----------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#INITIAL DATA IMPORT + FORMATTING ----------------------------------------------------------------------------------------------

        #Get 'cleaned' site data from adjacent 'Sites' folder
        site_data <- read.csv('1_Albedo_Exclosures/Data/SustHerb_Site_Data/cleaned_data/cleaned_data.csv', header = TRUE)
        
        #Load Plot Coordinates

                #Read in Regional coordinates
                plotcoords_trond <- read.csv('1_Albedo_Exclosures/Data/Site_Coordinates/troendelag_20m_flater_pkt.csv',header=T,sep=';', dec=',')
                plotcoords_hed_ask <- read.csv('1_Albedo_Exclosures/Data/Site_Coordinates/Koordinater_20x20_Hedmark_Akershus.csv',header=T,sep=';', dec=',')
                plotcoords_tel <- read.csv('1_Albedo_Exclosures/Data/Site_Coordinates/Koordinater_20x20_Telemark_formatted.csv',header=T,sep=';', dec=',', encoding = "UTF-8")
                
                ##Exclude sites without LiDAR data
                ##  (exclusions based on Ingrid Snøan's 'HedmarkTroendelagTelemarkSustherbSites' file)
                
                        #Hedmark Exclusions
                        hed_excl <- c("DD1", "DD2", "JCD1", "JCD2", "M1.1", "M1.2", "M2.1", "M2.2", "M3.1", "M3.2", "OIA1", "OIA2", "OL1", "OL2", "SK1", "SK2")
                        plotcoords_hed_ask <- plotcoords_hed_ask[!plotcoords_hed_ask$Uthegningi %in% hed_excl,]
                        
                        #Telemark Exclusions
                        tel_excl <- c("Notodden 1 B", "Notodden 1 UB", "Notodden 4 B", "Notodden 4 UB")
                        plotcoords_tel <- plotcoords_tel[!plotcoords_tel$flatenavn %in%  tel_excl,]
                
                #Create df to hold all coordinates
                plotcoords <- data.frame("Name" = '', "utm32north" = '', "utm32east" = '')
                
                        #Bind Trøndelag coordinates to main coordinates df
                        
                                #Filter down to relevant columns
                                plotcoords_trond_opt <- plotcoords_trond[, c(3:5)]

                                #Convert site codes to uppercase (to match 'site_data' format)
                                plotcoords_trond_opt$Name <- toupper(plotcoords_trond_opt$Name)
                                
                                #Rename columns
                                colnames(plotcoords_trond_opt)[2] <- "utm32east"
                                colnames(plotcoords_trond_opt)[3] <- "utm32north"
                                
                                #Correct extra space in '1NSUB' label
                                plotcoords_trond_opt$Name[plotcoords_trond_opt$Name == ' 1NSUB'] <- '1NSUB'
                
                                #Row bind with main coordinates df
                                plotcoords <- plotcoords_trond_opt
                                
                        #Bind Askerhus + Hedmark coordinates to main coordinates df
                                
                                #Filter down to relevant columns
                                plotcoords_hed_ask_opt <- plotcoords_hed_ask[, c(6, 14:15)]
                                
                                #Rename 'Name' column
                                colnames(plotcoords_hed_ask_opt)[1] <- "Name"
                                
                                #Swap 'coordinate codes' with SustHerb site codes
                                #Note: Using Ingrid's coordinate references here (number order b/t B and UB is a bit wonky)
                                
                                        #Didrik Holmsen UB
                                        plotcoords_hed_ask_opt$Name[plotcoords_hed_ask_opt$Name == 'DH1'] <- 'DHUB'
                                        
                                        #Didrik Holmsen B
                                        plotcoords_hed_ask_opt$Name[plotcoords_hed_ask_opt$Name == 'DH2'] <- 'DHB'
                                        
                                        #Fet3 UB
                                        plotcoords_hed_ask_opt$Name[plotcoords_hed_ask_opt$Name == 'FK1'] <- 'FKUB'
                                        
                                        #Fet3 B
                                        plotcoords_hed_ask_opt$Name[plotcoords_hed_ask_opt$Name == 'FK2'] <- 'FKB'
                                        
                                        #Halvard Pramhus UB
                                        plotcoords_hed_ask_opt$Name[plotcoords_hed_ask_opt$Name == 'HP2'] <- 'HPUB'
                                        
                                        #Halvard Pramhus B
                                        plotcoords_hed_ask_opt$Name[plotcoords_hed_ask_opt$Name == 'HP1'] <- 'HPB'
                                        
                                        #Stig Dahlen UB
                                        plotcoords_hed_ask_opt$Name[plotcoords_hed_ask_opt$Name == 'SD1'] <- 'SDUB'
                                        
                                        #Stig Dahlen B
                                        plotcoords_hed_ask_opt$Name[plotcoords_hed_ask_opt$Name == 'SD2'] <- 'SDB'
                                        
                                        #Stangeskovene Aurskog UB
                                        plotcoords_hed_ask_opt$Name[plotcoords_hed_ask_opt$Name == 'SSA2'] <- 'SSAUB'
                                        
                                        #Stangeskovene Aurskog B
                                        plotcoords_hed_ask_opt$Name[plotcoords_hed_ask_opt$Name == 'SSA1'] <- 'SSAB'
                                        
                                        #Stangeskovene Eidskog UB
                                        plotcoords_hed_ask_opt$Name[plotcoords_hed_ask_opt$Name == 'SSB2'] <- 'SSBUB'
                                        
                                        #Stangeskovene Eidskog B
                                        plotcoords_hed_ask_opt$Name[plotcoords_hed_ask_opt$Name == 'SSB1'] <- 'SSBB'
                                        
                                        #Eidskog UB
                                        plotcoords_hed_ask_opt$Name[plotcoords_hed_ask_opt$Name == 'STSKN1'] <- 'STSKNUB'
                                        
                                        #Eidskog B
                                        plotcoords_hed_ask_opt$Name[plotcoords_hed_ask_opt$Name == 'STSKN2'] <- 'STSKNB'
                                        
                                        #Truls Holm UB
                                        plotcoords_hed_ask_opt$Name[plotcoords_hed_ask_opt$Name == 'TH2'] <- 'THUB'
                                        
                                        #Truls Holm BB
                                        plotcoords_hed_ask_opt$Name[plotcoords_hed_ask_opt$Name == 'TH1'] <- 'THB'
                                        
                                        
                                        
                                        
                                #Row bind with main coordinates df
                                plotcoords <- rbind(plotcoords, plotcoords_hed_ask_opt)
                                
                        #Bind Telemark coordinates to main coordinates df
                                
                                #Filter down to relevant columns
                                plotcoords_tel_opt <- plotcoords_tel[, c(4, 9:10)]
                                
                                #Correct column names
                                colnames(plotcoords_tel_opt)[1] <- "Name"

                                #Remove unicode 'replacement character' in "Fritsoe" (to match site_data)
                                plotcoords_tel_opt$Name <- gsub('\uFFFD', 'o', plotcoords_tel_opt$Name)
                                
                                #Corrections to spelling (to match 'site_data' and allow for loop below)
                                        
                                        #Column to lowercase
                                        plotcoords_tel_opt$Name <- tolower(plotcoords_tel_opt$Name)
                                        
                                        #Fritsoe
                                        plotcoords_tel_opt$Name <- gsub('fritzoe', 'fritsoe', plotcoords_tel_opt$Name)
                                        
                                        #Cappelen
                                        plotcoords_tel_opt$Name <- gsub('cappelen', 'nome_cappelen', plotcoords_tel_opt$Name)
                                
                                        #Furesdal (Note: remove number '1' to match 'site_data')
                                        plotcoords_tel_opt$Name <- gsub('fyresdal 1', 'furesdal', plotcoords_tel_opt$Name)
                                
                                #Replace full name w/ relevant site code
                                        
                                        for(i in 1:nrow(plotcoords_tel_opt)){
                                                
                                                #Split string
                                                s <- strsplit(plotcoords_tel_opt[i, "Name"], split = " ")
                                                
                                                #Perform code below for all except furesdal
                                                if( s[[1]][1] == "furesdal" ){
                                                        
                                                        #Grab 'furesdal' string
                                                        s2 <- s[[1]][1]
                                                        
                                                        #Identify treatment
                                                        st <- s[[1]][2]
                                                        
                                                } else {
                                                        
                                                        #Join site name + number
                                                        s2 <- paste(s[[1]][1], s[[1]][2], sep = "")
                                                        
                                                        #Identify treatment
                                                        st <- s[[1]][3]
                                                        
                                                }
                                                
                                                if( st == "ub" ){
                                                        tr <- "exclosure"
                                                } else if ( st == "b" ){
                                                        tr <- "open"
                                                }
                                                
                                                #Get relevant site code
                                                ## Some sites not in site_data (these are given NA)
                                                if( (s2 %in% site_data$LocalityName) == T ) {
                                                        sc <- site_data$LocalityCode[site_data$LocalityName == s2 & site_data$Treatment == tr]
                                                } else {
                                                        sc <- NA
                                                }
                                                
                                                #Replace existing name w/ site code (or NA)
                                                plotcoords_tel_opt[i, "Name"] <- sc
                                                
                                        }

                                #Row bind with main coordinates df
                                plotcoords <- rbind(plotcoords, plotcoords_tel_opt)
                

#END INITIAL DATA IMPORT + FORMATTING --------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#LOOP FOR LAS DATA PROCESSING ----------------------------------------------------------------------------------------------

#Blank dataframe for holding volumes + site names
final_data <- data.frame("Summed_crown_volume" = '', "Site_name" = '', "Treatment" = '')
        
#Loop through all LAS files
files <- list.files(path="1_Albedo_Exclosures/Data/LiDAR_Data/clipped_las_files", pattern="*.las", full.names=TRUE, recursive=FALSE)
        
#For each LAS file, do the following:
for(file in files) {
        
        #Get site name from file string (these should match the site names in 'site_data') ----------------------------------
        
                #Read in base file name        
                filename <- tools::file_path_sans_ext(basename(file))
                
                #Function to get last n characters of a string
                substrRight <- function(x, n){
                        substr(x, nchar(x)-n+1, nchar(x))
                }
                
                #Get last 2 characters of filename string
                treatment_string <- substrRight(filename, 2)
                
                #Split string based on '_b' or '_ub' (i.e. identify treatment)
                if( treatment_string == "ub"){
                        
                        site_name <- substr(filename, 1, nchar(filename) - 3)
                        treatment <- 'exclosure'
                        
                } else if ( treatment_string == "_b" ){
                        
                        site_name <- substr(filename, 1, nchar(filename) - 2)
                        treatment <- 'open'
                        
                }
                
        #Get site code for use w/ plotcoords df
        site_code <- site_data$LocalityCode[site_data$LocalityName == site_name & site_data$Treatment == treatment]
        print(site_code)
                
        #Read in LAS file of plot ---------------------------------------------------------------------------------
               
                 ## Note: This LAS file contains the LiDAR point cloud for a plot (32m x 32m)
                las_file <- readLAS(file)
                #plot(las_file)
        
                
        #Normalize data --------------------------------------------------------------------------------------------

                #Generate digital terrain model (using KNN algorithm for interpolation)
                dtm <- grid_terrain(las_file, algorithm = knnidw(k = 8, p = 2))
                
                #Remove the topography from a point cloud
                las_normalized <- lasnormalize(las_file, dtm)
                #plot(las_normalized)
                
                print("Normalized")
                
        #Generate a Canopy Height Model ------------------------------------------------------------------------------
                
                #Create CHM (using 'p2r' algorithm) 
                chm <- grid_canopy(las_normalized, res = 1, p2r())
                
                #Plot raster
                #plot(chm)
                
                #Plot 3D
                #plot_dtm3d(chm)
                
                #Smoothing step clips edges, so skipping it
                
                print("CHM generated")
                
        #Segment individual trees ------------------------------------------------------------------------------------
                
                #NOTE: I used a minimum tree height of 1m (instead of Ingrid's 5m)
                ## The goal is to calculate total tree volume per plot, so I think a lower
                ## threshold is necessary 
                algo <- watershed(chm, th = 1)
                las_watershed  <- lastrees(las_normalized, algo)
                
                # Remove point cloud points that aren't assigned to a tree
                trees <- lasfilter(las_watershed, !is.na(treeID))
                
                # Plot trees by color
                #plot(trees, color = "treeID", colorPalette = pastel.colors(100))
                
                print("Segmented trees")
                
        #Filter out big trees (> 7m, as in Snøan) --------------------------------------------------------------------
                
                #Height Threshold = 7m
                threshold <- 7
                
                #Create tree hulls
                ##NOTE: Tree Hulls function omits any trees that have fewer than 4 associated points
                hulls <- tree_hulls(trees, type = "concave", concavity = 2, func = .stdmetrics, attribute = "treeID")
                #plot(chm)
                #plot(hulls, add = T)         
                
                print("Created first tree hulls")
                
                #Get tree IDs for 'big trees' (over 7m)
                
                        #Get dataframe with all tree heights and corresponding tree IDs
                        ## Note: Tree heights correspond to 'zmax' within each hull
                        tree_heights <- hulls@data[,1:2]
                        
                        #Get vector tree IDs for 'big trees' (greater than 7m)
                        ## This vector will be used below to filter out LiDAR points
                        big_trees <- tree_heights$treeID[tree_heights$zmax > 7]
                
                        
        ##ERROR HANDLING - IF ONLY BIG TREES AND NO OTHER TREES - RETURN 0 FOR STAND VOLUME
        if( length(big_trees) != length(tree_heights$treeID) ){
                
                        #Filter out all points that correspond to IDs of 'big trees'
                        trees_final <- lasfilter(trees, !trees@data$treeID %in% big_trees)
                        
                        #Plot initial LAS w/ filtered LAS for comparison
                        #plot(trees, color = "treeID")
                        #plot(trees_final, color = "treeID")
                        
                        #Plot remaining tree hulls (ensure that large trees are removed)
                        ##NOTE: Tree Hulls function omits any trees that have fewer than 4 associated points
                        hulls2 <- tree_hulls(trees_final, type = "concave", concavity = 2, func = .stdmetrics, attribute = "treeID")
                        #plot(chm)
                        #plot(hulls2, add = T)
                        
                        print("Removed big trees")
                        
                #Cut plot size down to 20m x 20m --------------------------------------------------------------------------------
                        
                        print(site_name)
                        
                        #FOR LOOP, NEED TO AUTOMATICALLY GRAB NAME OF PLOT
                        plot_order <- chull(as.matrix(plotcoords[plotcoords$Name == site_code, 2:3]))
                        plot_poly <- Polygon(as.matrix(plotcoords[plotcoords$Name == site_code, 2:3][plot_order,]))
                        
                        print("Pulled polygon")
                       
                        
                        plot_cut <- lasclip(trees_final, plot_poly)
                        
                        print("Clipped to 20x20")
                        
                #FINAL 20x20m LiDAR Point Cloud (w/ trees > 7m removed) -------------------------------------------------------------
                        #plot(plot_cut)
                
                        #Plot CHM w/ hulls
                        plot_label <- paste(site_name, treatment, sep = " ")
                        plot(chm, main = plot_label)
                
                ##ERROR HANDLER - SOME PLOTS MAY NOT HAVE TREES OVER BETWEEN 1M & 7M
                if( length(plot_cut@data$X > 0) ){
                        
                        #CREATE HULLS FOR FINAL TREES
                        
                                ###NOTE: TREE HULLS ARE ONLY CREATED FOR TREES W/ MINIMUM OF 4 POINTS
                                #### SO, A TREE ID MUST HAVE 4 POINTS ASSOCIATED WITH IT TO BECOME A HULL
                        
                                #Some plots have small trees but not enough points per tree - need to handle this error below
                                        
                                ##Updated Hulls for volume
                                
                                hulls3 <- tryCatch({
                                        
                                        #If function doesn't throw error, create hulls3 object
                                        tree_hulls(plot_cut, type = "concave", concavity = 2, func = .stdmetrics, attribute = "treeID")
                                
                                }, error = function(e){
                                        
                                        #If function throws error (i.e. too few points for any trees), hulls3 = NA
                                        NA
                                })
                        
                        
                        #CALCULATE VOLUME FOR EACH TREE, ONLY IF FINAL HULLS CREATED SUCCESSFULLY
                        if( !is.na(hulls3) ){
                                
                                #Add hulls to plot
                                plot(hulls3, add = T)
                                
                                print("Created final hulls")
                                        
                                #CALCULATE TREE VOLUME FOR PLOT (Based on volume of convex hulls) ----------------------------------------------------
                                        
                                        #Create a dataframe to hold individual tree volumes
                                        tree_volumes <- data.frame("Volume_m3" = '', "treeID" = '')
                                        
                                        ##For each tree hull, use lasclip to isolate point cloud and then rLiDAR to calculate volume
                                        for(i in 1:length(hulls3@polygons)){
                                                
                                                #Clip out point cloud from 20x20m plot, based on hulls
                                                temp_tree <- lasclip(plot_cut, hulls3@polygons[[i]]@Polygons[[1]])
                                                
                                                #Create dataframe of XYZ coordinates
                                                temp_df <- temp_tree@data[, c(1:3)]
                                                
                                                #Compute a convex hull (smallest possible that can enclose set of points)
                                                ##NOTE: This only creates hulls (and computes volumes) for trees w/ at least 4 points
                                                ## At least 4 points are required for this function to work
                                                if( length(temp_tree@data$X) > 3 ){
                                                        output <- convhulln(p = temp_df, options = "FA")
                                                        #plot(output)
                                                }
                                                
                                                #Save volume to df
                                                tree_volumes[i, "Volume_m3"] <- round(output$vol, 5)
                                                
                                                #Save treeID to df
                                                tree_volumes[i, "treeID"] <- temp_tree@data[1,18]
                                                
                                        }
                                        
                                        tree_volumes$Volume_m3 <- as.numeric(tree_volumes$Volume_m3)
                                        
                                        print("Calculated all tree volumes")
                                        
                                #TOTAL PLOT VOLUME (sum of all tree hull volumes) ------------------------------------------------------------------
                                final_plot_volume <- sum(tree_volumes$Volume_m3)
                                
                        } else {
                                
                                #NO Trees w/ more 4 or more points - set plot volume to 0
                                final_plot_volume <- 0
                        }
                        
                } else {
                        
                        #NO Trees above 1m and below 7m
                        final_plot_volume <- 0
                        
                }
                
        } else {
                
                #NO Trees above 1m and below 7m
                final_plot_volume <- 0
                
        }
                
        #ADD SUMMED VOLUME, SITE, AND TREATMENT TO FINAL DF ----------------------------------------------------------------
        
                #Create temp row 
                temp_row <- data.frame("Summed_crown_volume" = final_plot_volume,
                                        "Site_name" = site_name,
                                        "Treatment" = treatment)
                
                final_data <- rbind(final_data, temp_row)
                
                
                cat("Completed: ", site_code)
                
}

#END OF LOOP FOR LAS DATA PROCESSING ----------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#DATA VISUALIZATION ----------------------------------------------------------------------------------------

        #Remove random blank row
        final_data <- final_data[final_data$Summed_crown_volume != '',]

        #Make sure data has correct class
        final_data$Summed_crown_volume <- as.numeric(final_data$Summed_crown_volume)
        final_data$Treatment <- as.factor(final_data$Treatment)
        
        #Boxplot to visualize difference in volume by treatment
        ggplot(data = final_data, aes(x = Treatment, y = Summed_crown_volume)) +
                geom_boxplot()
        
        #Boxplot to visualize difference in volume by treatment
        vol_plot <- ggplot(data = final_data, aes(x = Treatment, y = Summed_crown_volume, fill = Treatment)) +
                geom_boxplot() +
                ggtitle("Summed tree hull volume for SustHerb\nstudy sites") +
                labs(x = "Site Treatment", y = bquote("Plot volume"~(m^3))) +
                theme(plot.title = element_text(hjust = 0.5),
                      axis.text.x = element_text(size = 9),
                      axis.title.x = element_text(size = 12, margin = margin(t=12, b = 12)),
                      axis.title.y = element_text(size = 12, margin = margin(r=12))) +
                scale_fill_manual(values=wes_palette(n=2, name="FantasticFox1"))

#END OF DATA VISUALIZATION ----------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


        

#WRITE OUTPUT  ----------------------------------------------------------------------------

        #Write CSV to Output Folder
        write.csv(final_data, file = '1_Albedo_Exclosures/Approach_2/Output/Tree_Volumes/total_plot_volumes_approach_2.csv', row.names = TRUE)

        #Export volume boxplot as PNG
        png(filename = "1_Albedo_Exclosures/Approach_2/Output/Tree_Volumes/plot_volumes_approach_2.png",
            width = 1000,
            height = 1000,
            units = "px",
            bg = "white")
        vol_plot
        dev.off()
        
        
#END WRITE OUTPUT-------------------------------------------------------------------------
        
        
        

#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




# MISC CODE FOR INDIVIDUAL INSPECTION (REMOVED FROM LOOP) -------------------------------------------------------------
## Note: This is some leftover code that may be useful for diagnosing/investigating 
## individual LAS files (outside of the loop above)

        #Inspect the data
        summary(las_file)
        lascheck(las_file)
        
                #Investigate classification
                sort(unique(las_file@data$Classification))
                plot(las_file, color = "Classification")
                
                #Any outliers in vegetation?
                las_veg_class <- lasfilter(las_file, Classification == 5)
                plot(las_veg_class)
                
        
       
        #Explore tree volumes
                hist(tree_volumes$Volume_m3)
                
                

                                         
    