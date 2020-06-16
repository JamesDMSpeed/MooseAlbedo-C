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
        library(rgl)

        #Packages related to LiDAR 
        library(raster)
        library(rasterVis)
        library(lidR)
        library(sp)

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
final_data <- data.frame("Total_plot_volume" = '', "Site_name" = '', "Treatment" = '')
        
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
        
        #Set correct Coordinate Reference System (CRS) for LAS file - UTM32
                
                proj4string(las_file) <- CRS("+proj=utm +zone=32 +datum=WGS84 +units=m +no_defs ")
                
        #Define pixel resolution (m2) for CHMs
                
                pix_res <- 0.5
                
        #Normalize data --------------------------------------------------------------------------------------------
                
                
                #Generate digital terrain model (using KNN algorithm for interpolation)
                dtm <- grid_terrain(las_file, res = pix_res, algorithm = knnidw(k = 8, p = 2))
                
                #Remove the topography from a point cloud
                las_normalized <- lasnormalize(las_file, dtm)
                #plot(las_normalized)
                
                print("Normalized")
                
        #Generate a Canopy Height Model ------------------------------------------------------------------------------
                
                #Create CHM (using 'pitfree' algorithm, sub-circling tweak, and 0.5m resolution)
                chm <- grid_canopy(las_normalized, res = pix_res, pitfree(c(0,2,5,10,15), c(0,1), subcircle = 0.2))

                #Plot raster
                #plot_label1 <- paste("Initial CHM", site_name, treatment, sep = " ")
                #plot(chm, main = plot_label1)
                
                #Plot 3D
                #plot_dtm3d(chm)
                
                #Smoothing step clips edges, so skipping it
                
                print("CHM generated")
                
        #Segment individual trees ------------------------------------------------------------------------------------
                
                #NOTE: Uses a minimum tree height threshold of 2m 
                algo <- watershed(chm, th = 2)
                las_watershed  <- lastrees(las_normalized, algo)
                
                # Plot trees by color
                #plot(las_watershed, color = "treeID", colorPalette = pastel.colors(100))
                
                print("Segmented trees")

        ##ERROR HANDLER - If no trees >2m, skip step below
                
        #CONDITIONAL - Does las_watershed have at least 1 segmented tree? (i.e. is 1 found in las_watershed@data$treeID?)
        if( 1 %in% las_watershed@data$treeID ){

                #Filter out big trees (> 7m, as in Snøan) --------------------------------------------------------------------
                        
                        #Height Threshold = 7m
                        threshold <- 7
                        
                        #Create tree hulls
                        hulls <- tree_hulls(las_watershed, type = "concave", concavity = 2, func = .stdmetrics, attribute = "treeID")
                        #plot(chm)
                        #plot(hulls, add = T)         
                        
                        print("Created first tree hulls")
                        
                        #Get tree IDs for 'big trees' (over 7m)
                        
                                #Get dataframe with all tree heights and corresponding tree IDs
                                ## Note: Tree heights correspond to 'zmax' within each hull
                                tree_heights <- hulls@data[,1:2]
                                
                                #Get vector of tree IDs for 'big trees' (greater than 7m)
                                ## This vector will be used below to filter out LiDAR points
                                big_trees <- tree_heights$treeID[tree_heights$zmax > 7]
                        
                                #Filter out all points that correspond to IDs of 'big trees'
                                trees_final <- lasfilter(las_watershed, !las_watershed@data$treeID %in% big_trees)
                                
                                #Plot initial LAS w/ filtered LAS for comparison
                                #plot(las_watershed, color = "treeID")
                                #plot(trees_final, color = "treeID")
                                
                                print("Removed big trees")
                                
        } else {
                
                trees_final <- las_watershed
                
        }
        #Cut plot size down to 20m x 20m --------------------------------------------------------------------------------
                        
                #FOR LOOP, NEED TO AUTOMATICALLY GRAB NAME OF PLOT
                plot_order <- chull(as.matrix(plotcoords[plotcoords$Name == site_code, 2:3]))
                plot_poly <- Polygon(as.matrix(plotcoords[plotcoords$Name == site_code, 2:3][plot_order,]))
                
                print("Pulled polygon")
               
                #FINAL 20x20m LiDAR Point Cloud (w/ trees > 7m removed)
                plot_cut <- lasclip(trees_final, plot_poly)
                #plot(plot_cut)
                
                #Create polygon of plot outline
                Ps1 <- Polygons(list(plot_poly), ID = "a")
                sps <- SpatialPolygons(list(Ps1))

                print("Clipped to 20x20")
                        
        #Create new CHM of final 20x20m point cloud (w/ big trees removed) -------------------------------------------------------------
                
                #Generate new digital terrain model (using KNN algorithm for interpolation)
                dtm2 <- grid_terrain(plot_cut, algorithm = knnidw(k = 8, p = 2))
                
                #Remove the topography from a point cloud
                normalized2 <- lasnormalize(plot_cut, dtm2)

                #Create new CHM (using 'pitfree' algorithm, 0.5m resolution, and sub-circling tweak) 
                chm2 <- grid_canopy(normalized2, res = pix_res, pitfree(c(0,2,5,10,15), c(0,1), subcircle = 0.2))
                #plot(chm2)
                
                #Plot new CHM w/ hulls
                #plot_label2 <- paste("Clipped CHM", site_name, treatment, sep = " ")
                #plot(chm2, main = plot_label2)
                
                        #Save CHMs in Output folder
                
                                #Define file path
                                the_path <- "1_Albedo_Exclosures/Approach_3/Output/Tree_Volumes/CHM/"
                                
                                #Save INITIAL CHM (Unclipped w/ plot polygon)
                                        plot_label3 <- paste("Unclipped:", site_name, treatment, sep = " ")
                                        chm_file <- paste(the_path, filename, "_1", ".png", sep = '')
                                        
                                        png(filename = chm_file,
                                            width = 800,
                                            height = 800,
                                            units = "px",
                                            bg = "white")
                                        
                                        print(levelplot(chm, margin = F,
                                                        ylab='utm32north',
                                                        xlab='utm32east',
                                                        main = paste(plot_label3, "CHM", sep = " "),
                                                        at = seq(from = 0, to = 15, by = 0.5)) +
                                                      layer(sp.polygons(sps, col = "green"), packets = 1))
                                        
                                        dev.off()
                        
                                #Save FINAL CHM (Clipped w/ plot polygon)
                                        plot_label4 <- paste("Clipped:", site_name, treatment, sep = " ")
                                        chm_file_2 <- paste(the_path, filename, "_2", ".png", sep = '')
                                        
                                        png(filename = chm_file_2,
                                            width = 800,
                                            height = 800,
                                            units = "px",
                                            bg = "white")
                                        
                                        print(levelplot(chm2, margin = F,
                                                  ylab='utm32north',
                                                  xlab='utm32east',
                                                  main = paste(plot_label4, "CHM", sep = " "),
                                                  at = seq(from = 0, to = 7, by = 0.25)) +
                                                      layer(sp.polygons(sps, col = "green"), packets = 1))
                                        
                                        dev.off()
                        

        #Calculate total plot volume (sum volume of all pixels)
                
                #Volume = height of pixel (z attribute), since area of 
                ## each pixel is 0.5m2 (V = 0.5m * 0.5m x height (m))
                        
                        pix_vols <- vector()
                
                        #Loop through all pixes
                        for(i in 1:length(chm2@data@values)){
                                
                                #Only pixels w/ numeric values
                                if( !is.na( chm2@data@values[i] ) ){
                                        
                                        #Calculate pixel volume
                                        pixel_vol <- pix_res * pix_res * chm2@data@values[i]
                                        
                                        #Add to vector of pixel volumes
                                        pix_vols <- c(pix_vols, pixel_vol)
                                        
                                }
                                
                        }
                        
                        #Sum all volumes (m3)
                        final_plot_volume <- sum(pix_vols)
                
        #ADD SUMMED VOLUME, SITE, AND TREATMENT TO FINAL DF ----------------------------------------------------------------
        
                #Create temp row 
                temp_row <- data.frame("Total_plot_volume" = final_plot_volume,
                                        "Site_name" = site_name,
                                        "Treatment" = treatment)
                
                final_data <- rbind(final_data, temp_row)
                
                cat("Completed: ", site_code)
                
}

#END OF LOOP FOR LAS DATA PROCESSING ----------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#DATA VISUALIZATION ----------------------------------------------------------------------------------------

        #Remove random blank row
        final_data <- final_data[final_data$Total_plot_volume != '',]

        #Make sure data has correct class
        final_data$Total_plot_volume <- as.numeric(final_data$Total_plot_volume)
        final_data$Treatment <- as.factor(final_data$Treatment)
        

        #Boxplot to visualize difference in volume by treatment
        vol_plot <- ggplot(data = final_data, aes(x = Treatment, y = Total_plot_volume, fill = Treatment)) +
                geom_boxplot() +
                ggtitle("Range of plot volumes for SustHerb study sites") +
                labs(x = "Site Treatment", y = bquote("Plot volume"~(m^3))) +
                scale_fill_manual(values=wes_palette(n=2, name="FantasticFox1")) +
                theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                      legend.position = "none",
                      axis.text.x = element_text(size = 44, margin = margin(t=16)),
                      axis.text.y = element_text(size = 40, margin = margin(r=16)),
                      axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                      axis.title.y = element_text(size = 60, margin = margin(r=40)))
        
        #Faceted bar plot - total plot volume for each study site, w/ comparison between treatments
        vol_plot_faceted <- ggplot(data = final_data, aes(x = Treatment, y = Total_plot_volume, fill = Treatment)) +
                geom_bar(position="dodge", stat="identity") +
                facet_wrap(~ Site_name, ncol = 5) +
                ggtitle("Total plot volume for SustHerb study sites") +
                labs(x = "Site Treatment", y = bquote("Plot volume"~(m^3))) +
                scale_fill_manual(values=wes_palette(n=2, name="FantasticFox1")) +
                theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                      legend.position = "none",
                      axis.text.x = element_text(size = 20, margin = margin(t=16)),
                      axis.text.y = element_text(size = 20, margin = margin(r=16)),
                      axis.title.x = element_text(size = 50, margin = margin(t=40, b = 40)),
                      axis.title.y = element_text(size = 50, margin = margin(r=40)),
                      strip.text.x = element_text(size = 20))
        
        #Histogram of volume by treatment
        vol_hist <- ggplot(data = final_data, aes(x = Total_plot_volume, fill = Treatment, group = Treatment)) +
                geom_histogram(aes(y=..density..), bins = 30, alpha=1, position="identity") +
                geom_density(alpha= 0.5) +
                ggtitle("Density plot of volume") +
                labs(x = "Total plot volume", y = "Density") +
                scale_fill_manual(values=wes_palette(n=2, name="FantasticFox1")) +
                theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                      legend.title = element_text(size = 40),
                      legend.text = element_text(size = 36),
                      axis.text.x = element_text(size = 20, margin = margin(t=16)),
                      axis.text.y = element_text(size = 20, margin = margin(r=16)),
                      axis.title.x = element_text(size = 50, margin = margin(t=40, b = 40)),
                      axis.title.y = element_text(size = 50, margin = margin(r=40)),
                      strip.text.x = element_text(size = 20))
        
                

#END OF DATA VISUALIZATION ----------------------------------------------------------------------------------------
        
        
        

#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#WRITE OUTPUT  ----------------------------------------------------------------------------
        
        #Write CSV to Output Folder
        write.csv(final_data, file = '1_Albedo_Exclosures/Approach_3/Output/Tree_Volumes/total_plot_volumes_approach_3.csv', row.names = TRUE)
        
        #Export volume boxplot as PNG
        png(filename = "1_Albedo_Exclosures/Approach_3/Output/Tree_Volumes/plot_volumes_approach_3.png",
            width = 2000,
            height = 2000,
            bg = "white")
        vol_plot
        dev.off()
        
        #Export faceted volume barplot as PNG
        png(filename = "1_Albedo_Exclosures/Approach_3/Output/Tree_Volumes/plot_volumes_faceted_approach_3.png",
            width = 2000,
            height = 3000,
            bg = "white")
        vol_plot_faceted
        dev.off()
        
        #Export density plot as PNG
        png(filename = "1_Albedo_Exclosures/Approach_3/Output/Tree_Volumes/plot_volumes_density_approach_3.png",
            width = 2000,
            height = 2000,
            bg = "white")
        vol_hist
        dev.off()
        
        
#END WRITE OUTPUT -------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




    