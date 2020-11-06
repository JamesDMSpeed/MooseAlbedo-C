## This is a script to identify/create three regions of SatSkog data for comparison of trends in moose data

# Per the last meeting, this will substitute for the clustering approaches previously attempted


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




#IMPORT + CROP DATA --------------------------------------------------------------------------------------------------

        #SATSKOG ALBEDO DATASET ----------
        
                #Load unified & FILTERED shapefile w/ all variables (from all years)
                data <- st_read("2_Albedo_Regional/Data/Final_Shapefile/Output/attempt_3/all_data/corrected_shapefile.shp")
                beep(b)
                
                #What years of data are there?
                data$Snrg_yr <- as.factor(data$Snrg_yr)
                years <- levels(data$Snrg_yr) #Data from 1999, 2000, 2001, 2002, 2004, and 2007
                
                #Plot by years
                ggplot() +
                        geom_sf(data = data, aes(fill = Snrg_yr, color = Snrg_yr), lwd = 0.1) +
                        ggtitle("Data by SatSkog Photo Year")
                beep(b)
                        
                        #Which years do I need to keep? Should I keep all years?
                
                        ## LOOKS like I definitely need to use 2007 data (Hedmark) and 1999 data
                        ## (Central + Southern Norway). Should probably include 2004 data (central Norway)
                
                #Remove duplicate geometries
                data <- distinct(data, .keep_all = T)
                beep(b)
                
                #Filter to 1999, 2004, and 2007 for further analysis
                data_filt <- data[data$Snrg_yr %in% c(1999, 2004, 2007),]
                
                        #Plot filtered data for verification
                        ggplot() +
                                geom_sf(data = data_filt, aes(fill = Snrg_yr, color = Snrg_yr), lwd = 0.1) +
                                coord_sf(datum = st_crs(data_filt)) +
                                ggtitle("Data by SatSkog Photo Year\n(Filtered to 1999, 2004, & 2007)")
                        beep(b)
                        
                #Plot by moose density
                ggplot() +
                        geom_sf(data = data_filt, aes(fill = Ms_Dnst, color = Ms_Dnst), lwd = 0.1) +
                        coord_sf(datum = st_crs(data_filt)) +
                        ggtitle("Filtered Satskog Data (1999, 2004, & 2007)\nMoose Density (kg/km2)")
                beep(b)
                
        
        #DRAW BOUNDING BOXES FOR AREAS OF INTEREST -------
        #NOTE: Coordinates of boxes are manually chosen (based on initial plots of moose density)
        #to best capture a gradient in moose densities

                #SOUTHEAST NORWAY (HEDMARK AREA) -------
                
                        #Compute polygon (from coordinates)
                
                                #Create coordinate matrix (5 sets of coordinates to close polygon)
                                #Width 85000x85000
                                se_x <- c(250000,335000,335000,250000,250000)
                                se_y <- c(6675000, 6675000, 6760000, 6760000, 6675000)
                                se_coords <- cbind(se_x, se_y)
                                se_coords_l <- list(as.matrix(se_coords)) #Put into list class for use with st_polygon
                                
                                #Create sf feature from coords
                                se_poly <- st_polygon(se_coords_l)
                                plot(se_poly) #Looks good
                                
                                #Create bbox for use w/ crop
                                se_bbox <- st_bbox(se_poly)

                        #Create crop
                        se_plot <- st_crop(data_filt, se_bbox)
                        plot(se_plot["Ms_Dnst"], border = 0.2) #Looks good!
                

                #SOUTHERN NORWAY -------
                        
                        s_x <- c(150000,235000,235000,150000,150000)
                        s_y <- c(6540000, 6540000, 6625000, 6625000, 6540000)
                        
                        s_coords <- cbind(s_x, s_y)
                        s_coords_l <- list(as.matrix(s_coords)) #Put into list class for use with st_polygon
                        
                        #Create sf feature from coords
                        s_poly <- st_polygon(s_coords_l)
                        plot(s_poly) #Looks good
                        
                        #Create bbox for use w/ crop
                        s_bbox <- st_bbox(s_poly)
                        
                        #Create crop
                        s_plot <- st_crop(data_filt, s_bbox)
                        plot(s_plot["Ms_Dnst"], border = 0.2) #Looks good!
                
                #CENTRAL NORWAY -------
                        
                        c_x <- c(260000,345000,345000,260000,260000)
                        c_y <- c(7020000, 7020000, 7105000, 7105000, 7020000)
                        
                        c_coords <- cbind(c_x, c_y)
                        c_coords_l <- list(as.matrix(c_coords)) #Put into list class for use with st_polygon
                        
                        #Create sf feature from coords
                        c_poly <- st_polygon(c_coords_l)
                        plot(c_poly) #Looks good
                        
                        #Create bbox for use w/ crop
                        c_bbox <- st_bbox(c_poly)
                        
                        #Create crop
                        c_plot <- st_crop(data_filt, c_bbox)
                        plot(c_plot["Ms_Dnst"], border = 0.2) #Looks good!
        
      
        
        
        


#END IMPORT + CROP DATA --------------------------------------------------------------------------------------------------
        
        
        
        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#EXPLORE WITHIN CROPS ------------------------------------------------------------------------------


        #SOUTHEAST NORWAY
        ggplot(data = se_plot, aes(x = Ms_Dnst, y = M_1_A_B)) +
                geom_point(alpha = 0.2) +
                geom_smooth() +
                facet_wrap(~ cut_interval(dem, n = 10))
                        
        #SOUTHERN NORWAY
        ggplot(data = s_plot, aes(x = Ms_Dnst, y = M_1_A_B)) +
                geom_point(alpha = 0.2) +
                geom_smooth() +
                facet_wrap(~ cut_interval(dem, n = 15))
        
        #CENTRAL NORWAY
        ggplot(data = c_plot, aes(x = Ms_Dnst, y = M_1_A_B)) +
                geom_point(alpha = 0.2) +
                geom_smooth() +
                facet_wrap(~ cut_interval(dem, n = 15))
        
        #Plot with polygons
        rect_df <- data.frame("xmin" = integer(),
                              "xmax" = integer(),
                              "ymin" = integer(),
                              "ymax" = integer(),
                              "cluster" = character())
        
                #Add SE Norway coords
                se_coords_df <- data.frame(se_coords)
                rect_df[1,1] <- min(se_coords_df$se_x)
                rect_df[1,2] <- max(se_coords_df$se_x)
                rect_df[1,3] <- min(se_coords_df$se_y)
                rect_df[1,4] <- max(se_coords_df$se_y)
                rect_df[1,5] <- "SE_Norway"
                
                #Add Southern Norway coords
                s_coords_df <- data.frame(s_coords)
                rect_df[2,1] <- min(s_coords_df$s_x)
                rect_df[2,2] <- max(s_coords_df$s_x)
                rect_df[2,3] <- min(s_coords_df$s_y)
                rect_df[2,4] <- max(s_coords_df$s_y)
                rect_df[2,5] <- "S_Norway"
                
                #Add C Norway coords
                c_coords_df <- data.frame(c_coords)
                rect_df[3,1] <- min(c_coords_df$c_x)
                rect_df[3,2] <- max(c_coords_df$c_x)
                rect_df[3,3] <- min(c_coords_df$c_y)
                rect_df[3,4] <- max(c_coords_df$c_y)
                rect_df[3,5] <- "C_Norway"
                
        #Plot w/ rectangles
        rect_df$cluster <- as.factor(rect_df$cluster)
        ggplot() +
                geom_sf(data = data_filt, aes(fill = Ms_Dnst, color = Ms_Dnst), lwd = 0.1) +
                geom_rect(data = rect_df, aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax), colour = "green", fill = "grey", alpha = 0, lwd = 2) +
                coord_sf(datum = st_crs(data_filt)) +
                ggtitle("Moose Density in 3 Selected Plots")
        
                        
                
#END EXPLORE WITHIN CROPS ------------------------------------------------------------------------------
        
        
        
        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#CREATE UNIFIED DATASET ------------------------------------------------------------------------------
        
        #Add "cluster" variable to each cropped df
        se_plot$Plot <- "Southeast"
        s_plot$Plot <- "South"
        c_plot$Plot <- "Central"
        
        #Row bind three plots
        unified <- rbind(se_plot, s_plot, c_plot)
        
        #Melt/expand the dataset
        
                #Create 12 copies of each row
                unified_exp <- unified[rep(seq_len(nrow(unified)), each = 12), ]

                #Create vector with repeating sequence of 1:12 (to add as month variable)
                months <- rep(c(1:12), times = (nrow(unified_exp) / 12))
                unified_exp$Month <- months
                unified_exp$SWE <- as.numeric('')
                unified_exp$Temp <- as.numeric('')
                
                #SWE
                unified_exp$SWE[unified_exp$Month == 1] <- unified_exp$SWE_M_1[unified_exp$Month == 1]
                unified_exp$SWE[unified_exp$Month == 2] <- unified_exp$SWE_M_2[unified_exp$Month == 2]
                unified_exp$SWE[unified_exp$Month == 3] <- unified_exp$SWE_M_3[unified_exp$Month == 3]
                unified_exp$SWE[unified_exp$Month == 4] <- unified_exp$SWE_M_4[unified_exp$Month == 4]
                unified_exp$SWE[unified_exp$Month == 5] <- unified_exp$SWE_M_5[unified_exp$Month == 5]
                unified_exp$SWE[unified_exp$Month == 6] <- unified_exp$SWE_M_6[unified_exp$Month == 6]
                unified_exp$SWE[unified_exp$Month == 7] <- unified_exp$SWE_M_7[unified_exp$Month == 7]
                unified_exp$SWE[unified_exp$Month == 8] <- unified_exp$SWE_M_8[unified_exp$Month == 8]
                unified_exp$SWE[unified_exp$Month == 9] <- unified_exp$SWE_M_9[unified_exp$Month == 9]
                unified_exp$SWE[unified_exp$Month == 10] <- unified_exp$SWE_M_10[unified_exp$Month == 10]
                unified_exp$SWE[unified_exp$Month == 11] <- unified_exp$SWE_M_11[unified_exp$Month == 11]
                unified_exp$SWE[unified_exp$Month == 12] <- unified_exp$SWE_M_12[unified_exp$Month == 12]
                
                #TEMP
                unified_exp$Temp[unified_exp$Month == 1] <- unified_exp$Tmp_M_1[unified_exp$Month == 1]
                unified_exp$Temp[unified_exp$Month == 2] <- unified_exp$Tmp_M_2[unified_exp$Month == 2]
                unified_exp$Temp[unified_exp$Month == 3] <- unified_exp$Tmp_M_3[unified_exp$Month == 3]
                unified_exp$Temp[unified_exp$Month == 4] <- unified_exp$Tmp_M_4[unified_exp$Month == 4]
                unified_exp$Temp[unified_exp$Month == 5] <- unified_exp$Tmp_M_5[unified_exp$Month == 5]
                unified_exp$Temp[unified_exp$Month == 6] <- unified_exp$Tmp_M_6[unified_exp$Month == 6]
                unified_exp$Temp[unified_exp$Month == 7] <- unified_exp$Tmp_M_7[unified_exp$Month == 7]
                unified_exp$Temp[unified_exp$Month == 8] <- unified_exp$Tmp_M_8[unified_exp$Month == 8]
                unified_exp$Temp[unified_exp$Month == 9] <- unified_exp$Tmp_M_9[unified_exp$Month == 9]
                unified_exp$Temp[unified_exp$Month == 10] <- unified_exp$Tmp_M_10[unified_exp$Month == 10]
                unified_exp$Temp[unified_exp$Month == 11] <- unified_exp$Tmp_M_11[unified_exp$Month == 11]
                unified_exp$Temp[unified_exp$Month == 12] <- unified_exp$Tmp_M_12[unified_exp$Month == 12]
                
                #Expand 3x (one duplicate for each tree species)
                unified_exp <- unified_exp[rep(seq_len(nrow(unified_exp)), each = 3), ]
                
                #Add species column
                unified_exp$Species <- ''
                
                #Create species vector
                spec <- rep(c("Spruce","Birch","Pine"), times = (nrow(unified_exp) / 3))
                unified_exp$Species <- spec
                
                
                #ALBEDO
                
                        #Blank column
                        unified_exp$Albedo <- ''
                
                        #Spruce
                        unified_exp$Albedo[unified_exp$Month == 1 & unified_exp$Species == "Spruce"] <- unified_exp$M_1_A_S[unified_exp$Month == 1 & unified_exp$Species == "Spruce"]
                        unified_exp$Albedo[unified_exp$Month == 2 & unified_exp$Species == "Spruce"] <- unified_exp$M_2_A_S[unified_exp$Month == 2 & unified_exp$Species == "Spruce"]
                        unified_exp$Albedo[unified_exp$Month == 3 & unified_exp$Species == "Spruce"] <- unified_exp$M_3_A_S[unified_exp$Month == 3 & unified_exp$Species == "Spruce"]
                        unified_exp$Albedo[unified_exp$Month == 4 & unified_exp$Species == "Spruce"] <- unified_exp$M_4_A_S[unified_exp$Month == 4 & unified_exp$Species == "Spruce"]
                        unified_exp$Albedo[unified_exp$Month == 5 & unified_exp$Species == "Spruce"] <- unified_exp$M_5_A_S[unified_exp$Month == 5 & unified_exp$Species == "Spruce"]
                        unified_exp$Albedo[unified_exp$Month == 6 & unified_exp$Species == "Spruce"] <- unified_exp$M_6_A_S[unified_exp$Month == 6 & unified_exp$Species == "Spruce"]
                        unified_exp$Albedo[unified_exp$Month == 7 & unified_exp$Species == "Spruce"] <- unified_exp$M_7_A_S[unified_exp$Month == 7 & unified_exp$Species == "Spruce"]
                        unified_exp$Albedo[unified_exp$Month == 8 & unified_exp$Species == "Spruce"] <- unified_exp$M_8_A_S[unified_exp$Month == 8 & unified_exp$Species == "Spruce"]
                        unified_exp$Albedo[unified_exp$Month == 9 & unified_exp$Species == "Spruce"] <- unified_exp$M_9_A_S[unified_exp$Month == 9 & unified_exp$Species == "Spruce"]
                        unified_exp$Albedo[unified_exp$Month == 10 & unified_exp$Species == "Spruce"] <- unified_exp$M_10_A_S[unified_exp$Month == 10 & unified_exp$Species == "Spruce"]
                        unified_exp$Albedo[unified_exp$Month == 11 & unified_exp$Species == "Spruce"] <- unified_exp$M_11_A_S[unified_exp$Month == 11 & unified_exp$Species == "Spruce"]
                        unified_exp$Albedo[unified_exp$Month == 12 & unified_exp$Species == "Spruce"] <- unified_exp$M_12_A_S[unified_exp$Month == 12 & unified_exp$Species == "Spruce"]
                
                        #Pine
                        unified_exp$Albedo[unified_exp$Month == 1 & unified_exp$Species == "Pine"] <- unified_exp$M_1_A_P[unified_exp$Month == 1 & unified_exp$Species == "Pine"]
                        unified_exp$Albedo[unified_exp$Month == 2 & unified_exp$Species == "Pine"] <- unified_exp$M_2_A_P[unified_exp$Month == 2 & unified_exp$Species == "Pine"]
                        unified_exp$Albedo[unified_exp$Month == 3 & unified_exp$Species == "Pine"] <- unified_exp$M_3_A_P[unified_exp$Month == 3 & unified_exp$Species == "Pine"]
                        unified_exp$Albedo[unified_exp$Month == 4 & unified_exp$Species == "Pine"] <- unified_exp$M_4_A_P[unified_exp$Month == 4 & unified_exp$Species == "Pine"]
                        unified_exp$Albedo[unified_exp$Month == 5 & unified_exp$Species == "Pine"] <- unified_exp$M_5_A_P[unified_exp$Month == 5 & unified_exp$Species == "Pine"]
                        unified_exp$Albedo[unified_exp$Month == 6 & unified_exp$Species == "Pine"] <- unified_exp$M_6_A_P[unified_exp$Month == 6 & unified_exp$Species == "Pine"]
                        unified_exp$Albedo[unified_exp$Month == 7 & unified_exp$Species == "Pine"] <- unified_exp$M_7_A_P[unified_exp$Month == 7 & unified_exp$Species == "Pine"]
                        unified_exp$Albedo[unified_exp$Month == 8 & unified_exp$Species == "Pine"] <- unified_exp$M_8_A_P[unified_exp$Month == 8 & unified_exp$Species == "Pine"]
                        unified_exp$Albedo[unified_exp$Month == 9 & unified_exp$Species == "Pine"] <- unified_exp$M_9_A_P[unified_exp$Month == 9 & unified_exp$Species == "Pine"]
                        unified_exp$Albedo[unified_exp$Month == 10 & unified_exp$Species == "Pine"] <- unified_exp$M_10_A_P[unified_exp$Month == 10 & unified_exp$Species == "Pine"]
                        unified_exp$Albedo[unified_exp$Month == 11 & unified_exp$Species == "Pine"] <- unified_exp$M_11_A_P[unified_exp$Month == 11 & unified_exp$Species == "Pine"]
                        unified_exp$Albedo[unified_exp$Month == 12 & unified_exp$Species == "Pine"] <- unified_exp$M_12_A_P[unified_exp$Month == 12 & unified_exp$Species == "Pine"]
                        
                
                        #Birch
                        unified_exp$Albedo[unified_exp$Month == 1 & unified_exp$Species == "Birch"] <- unified_exp$M_1_A_B[unified_exp$Month == 1 & unified_exp$Species == "Birch"]
                        unified_exp$Albedo[unified_exp$Month == 2 & unified_exp$Species == "Birch"] <- unified_exp$M_2_A_B[unified_exp$Month == 2 & unified_exp$Species == "Birch"]
                        unified_exp$Albedo[unified_exp$Month == 3 & unified_exp$Species == "Birch"] <- unified_exp$M_3_A_B[unified_exp$Month == 3 & unified_exp$Species == "Birch"]
                        unified_exp$Albedo[unified_exp$Month == 4 & unified_exp$Species == "Birch"] <- unified_exp$M_4_A_B[unified_exp$Month == 4 & unified_exp$Species == "Birch"]
                        unified_exp$Albedo[unified_exp$Month == 5 & unified_exp$Species == "Birch"] <- unified_exp$M_5_A_B[unified_exp$Month == 5 & unified_exp$Species == "Birch"]
                        unified_exp$Albedo[unified_exp$Month == 6 & unified_exp$Species == "Birch"] <- unified_exp$M_6_A_B[unified_exp$Month == 6 & unified_exp$Species == "Birch"]
                        unified_exp$Albedo[unified_exp$Month == 7 & unified_exp$Species == "Birch"] <- unified_exp$M_7_A_B[unified_exp$Month == 7 & unified_exp$Species == "Birch"]
                        unified_exp$Albedo[unified_exp$Month == 8 & unified_exp$Species == "Birch"] <- unified_exp$M_8_A_B[unified_exp$Month == 8 & unified_exp$Species == "Birch"]
                        unified_exp$Albedo[unified_exp$Month == 9 & unified_exp$Species == "Birch"] <- unified_exp$M_9_A_B[unified_exp$Month == 9 & unified_exp$Species == "Birch"]
                        unified_exp$Albedo[unified_exp$Month == 10 & unified_exp$Species == "Birch"] <- unified_exp$M_10_A_B[unified_exp$Month == 10 & unified_exp$Species == "Birch"]
                        unified_exp$Albedo[unified_exp$Month == 11 & unified_exp$Species == "Birch"] <- unified_exp$M_11_A_B[unified_exp$Month == 11 & unified_exp$Species == "Birch"]
                        unified_exp$Albedo[unified_exp$Month == 12 & unified_exp$Species == "Birch"] <- unified_exp$M_12_A_B[unified_exp$Month == 12 & unified_exp$Species == "Birch"]
                        
                        
        #Explore the data
        unified_exp$Albedo <- as.numeric(unified_exp$Albedo)
        unified_exp$Species <- as.factor(unified_exp$Species)
        unified_exp$Plot <- as.factor(unified_exp$Plot)
        rm(unified)
        rm(data)
        rm(data_filt)
        rm(months)
        rm(spec)
        
                #Export plots
        
                        #Birch Albedo
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Final_Approach/unfiltered/albedo_plots/birch_albedo_by_month.png",
                            width = 2000,
                            height = 2000,
                            units = "px",
                            bg = "white")
                        
                        ggplot(data = subset(unified_exp, Species == "Birch"), aes(x = Ms_Dnst, y = Albedo, color = Plot)) +
                                geom_point(alpha = 0.1) +
                                geom_smooth(method = NULL) +
                                facet_wrap(~ Month) +
                                scale_y_continuous(limits = c(0,1), breaks = c(0,0.2,0.4,0.6,0.8,1)) +
                                ggtitle("Moose Density vs. Birch Albedo (by Month)") +
                                labs(x = "Moose Density (kg/km-2)", y = "Albedo (Birch)") +
                                theme(plot.title = element_text(hjust = 0.5, size = 50, margin = margin(t = 40, b = 40)),
                                      legend.title = element_text(size = 40),
                                      legend.text = element_text(size = 36, margin = margin(t=16)),
                                      strip.text.x = element_text(size = 32),
                                      axis.text.x = element_text(size = 38, margin = margin(t=16)),
                                      axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                      axis.title.x = element_text(size = 50, margin = margin(t=40, b = 40)),
                                      axis.title.y = element_text(size = 50, margin = margin(r=40)))
                        
                        dev.off()
                        
                        
                        #Pine Albedo
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Final_Approach/unfiltered/albedo_plots/pine_albedo_by_month.png",
                            width = 2000,
                            height = 2000,
                            units = "px",
                            bg = "white")
                        
                        ggplot(data = subset(unified_exp, Species == "Pine"), aes(x = Ms_Dnst, y = Albedo, color = Plot)) +
                                geom_point(alpha = 0.1) +
                                geom_smooth(method = NULL) +
                                facet_wrap(~ Month) +
                                scale_y_continuous(limits = c(0,1), breaks = c(0,0.2,0.4,0.6,0.8,1)) +
                                ggtitle("Moose Density vs. Pine Albedo (by Month)") +
                                labs(x = "Moose Density (kg/km-2)", y = "Albedo (Pine)") +
                                theme(plot.title = element_text(hjust = 0.5, size = 50, margin = margin(t = 40, b = 40)),
                                      legend.title = element_text(size = 40),
                                      legend.text = element_text(size = 36, margin = margin(t=16)),
                                      strip.text.x = element_text(size = 32),
                                      axis.text.x = element_text(size = 38, margin = margin(t=16)),
                                      axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                      axis.title.x = element_text(size = 50, margin = margin(t=40, b = 40)),
                                      axis.title.y = element_text(size = 50, margin = margin(r=40)))
                        
                        dev.off()
                
                        
                        #Spruce Albedo
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Final_Approach/unfiltered/albedo_plots/spruce_albedo_by_month.png",
                            width = 2000,
                            height = 2000,
                            units = "px",
                            bg = "white")
                        
                        ggplot(data = subset(unified_exp, Species == "Spruce"), aes(x = Ms_Dnst, y = Albedo, color = Plot)) +
                                geom_point(alpha = 0.1) +
                                geom_smooth(method = NULL) +
                                facet_wrap(~ Month) +
                                scale_y_continuous(limits = c(0,1), breaks = c(0,0.2,0.4,0.6,0.8,1)) +
                                ggtitle("Moose Density vs. Spruce Albedo (by Month)") +
                                labs(x = "Moose Density (kg/km-2)", y = "Albedo (Spruce)") +
                                theme(plot.title = element_text(hjust = 0.5, size = 50, margin = margin(t = 40, b = 40)),
                                      legend.title = element_text(size = 40),
                                      legend.text = element_text(size = 36, margin = margin(t=16)),
                                      strip.text.x = element_text(size = 32),
                                      axis.text.x = element_text(size = 38, margin = margin(t=16)),
                                      axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                      axis.title.x = element_text(size = 50, margin = margin(t=40, b = 40)),
                                      axis.title.y = element_text(size = 50, margin = margin(r=40)))
                        
                        dev.off()
                        
                        beep(b)
                        
                        
        #Descriptive statistics for plots
                        
                #Age
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Final_Approach/unfiltered/descriptive/age.png",
                    width = 1500,
                    height = 1500,
                    units = "px",
                    bg = "white")
                
                ggplot(data = unified, aes(x = Plot, y = alder)) +
                        geom_boxplot() +
                        ggtitle("Forest Plot Age (by Location)") +
                        labs(x = "Location", y = "Age (years)") +
                        theme(plot.title = element_text(hjust = 0.5, size = 50, margin = margin(t = 40, b = 40)),
                              legend.title = element_text(size = 40),
                              legend.text = element_text(size = 36, margin = margin(t=16)),
                              strip.text.x = element_text(size = 32),
                              axis.text.x = element_text(size = 38, margin = margin(t=16)),
                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                              axis.title.x = element_text(size = 50, margin = margin(t=40, b = 40)),
                              axis.title.y = element_text(size = 50, margin = margin(r=40)))
                
                dev.off()
                        
                #Volume
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Final_Approach/unfiltered/descriptive/volume.png",
                    width = 1500,
                    height = 1500,
                    units = "px",
                    bg = "white")
                
                ggplot(data = unified, aes(x = Plot, y = vuprha)) +
                        geom_boxplot() +
                        ggtitle("Forest Plot Volume (by Location)") +
                        labs(x = "Location", y = "Volume (m3/ha)") +
                        theme(plot.title = element_text(hjust = 0.5, size = 50, margin = margin(t = 40, b = 40)),
                              legend.title = element_text(size = 40),
                              legend.text = element_text(size = 36, margin = margin(t=16)),
                              strip.text.x = element_text(size = 32),
                              axis.text.x = element_text(size = 38, margin = margin(t=16)),
                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                              axis.title.x = element_text(size = 50, margin = margin(t=40, b = 40)),
                              axis.title.y = element_text(size = 50, margin = margin(r=40)))
                
                dev.off()
                
                #SWE
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Final_Approach/unfiltered/descriptive/swe.png",
                    width = 1800,
                    height = 1500,
                    units = "px",
                    bg = "white")
                
                unified_exp$Month <- as.factor(unified_exp$Month)
                ggplot(data = unified_exp, aes(x = Month, y = SWE, fill = Plot)) +
                        geom_boxplot() +
                        ggtitle("Forest Plot SWE\n(by Location)") +
                        labs(x = "Month", y = "Mean Plot Snow-Water Equivalent (mm)") +
                        theme(plot.title = element_text(hjust = 0.5, size = 50, margin = margin(t = 40, b = 40)),
                              legend.title = element_text(size = 40),
                              legend.text = element_text(size = 36, margin = margin(t=16)),
                              legend.position = "bottom",
                              strip.text.x = element_text(size = 32),
                              axis.text.x = element_text(size = 38, margin = margin(t=16)),
                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                              axis.title.x = element_text(size = 50, margin = margin(t=40, b = 40)),
                              axis.title.y = element_text(size = 50, margin = margin(r=40)))
                
                dev.off()
                        
                #Temp
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Final_Approach/unfiltered/descriptive/temp.png",
                    width = 1800,
                    height = 1500,
                    units = "px",
                    bg = "white")
                
                ggplot(data = unified_exp, aes(x = Month, y = Temp, fill = Plot)) +
                        geom_boxplot() +
                        ggtitle("Forest Plot Temperature\n(by Location)") +
                        labs(x = "Month", y = "Mean Plot Temperature (K)") +
                        theme(plot.title = element_text(hjust = 0.5, size = 50, margin = margin(t = 40, b = 40)),
                              legend.title = element_text(size = 40),
                              legend.text = element_text(size = 36, margin = margin(t=16)),
                              legend.position = "bottom",
                              strip.text.x = element_text(size = 32),
                              axis.text.x = element_text(size = 38, margin = margin(t=16)),
                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                              axis.title.x = element_text(size = 50, margin = margin(t=40, b = 40)),
                              axis.title.y = element_text(size = 50, margin = margin(r=40)))
                
                dev.off()
                
                #Moose Density
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Final_Approach/unfiltered/descriptive/moose_density.png",
                    width = 1500,
                    height = 1500,
                    units = "px",
                    bg = "white")
                
                ggplot(data = unified_exp, aes(x = Plot, y = Ms_Dnst)) +
                        geom_boxplot() +
                        ggtitle("Forest Plot Moose Density\n(by Location)") +
                        labs(x = "Location", y = "Moose Metabolic Biomass (kg/km2)") +
                        theme(plot.title = element_text(hjust = 0.5, size = 50, margin = margin(t = 40, b = 40)),
                              legend.title = element_text(size = 40),
                              legend.text = element_text(size = 36, margin = margin(t=16)),
                              strip.text.x = element_text(size = 32),
                              axis.text.x = element_text(size = 38, margin = margin(t=16)),
                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                              axis.title.x = element_text(size = 50, margin = margin(t=40, b = 40)),
                              axis.title.y = element_text(size = 50, margin = margin(r=40)))
                
                dev.off()
                
                
                #Filter to an elevation range (100-300m)
                se_elev <- unified_exp[unified_exp$Plot == "Southeast" &
                                       unified_exp$dem >= 100 &
                                       unified_exp$dem <= 300,]

                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Final_Approach/unfiltered/albedo_plots/se_filt_elevation.png",
                    width = 1800,
                    height = 1500,
                    units = "px",
                    bg = "white")
                
                ggplot(data = subset(se_elev, Species == "Birch"), aes(x = Ms_Dnst, y = Albedo)) +
                        geom_point(alpha = 0.1) +
                        geom_smooth(method = NULL) +
                        facet_wrap(~ Month) +
                        scale_y_continuous(limits = c(0,1), breaks = c(0,0.2,0.4,0.6,0.8,1)) +
                                ggtitle("Moose Density vs. Birch Albedo (by Month)\nSoutheast Plot Only\nFiltered to 100-300m Elevation\n(n = 18898 plots)") +
                                labs(x = "Moose Density (kg/km-2)", y = "Albedo (Birch)") +
                                theme(plot.title = element_text(hjust = 0.5, size = 50, margin = margin(t = 40, b = 40)),
                                      legend.title = element_text(size = 40),
                                      legend.text = element_text(size = 36, margin = margin(t=16)),
                                      strip.text.x = element_text(size = 32),
                                      axis.text.x = element_text(size = 38, margin = margin(t=16)),
                                      axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                      axis.title.x = element_text(size = 50, margin = margin(t=40, b = 40)),
                                      axis.title.y = element_text(size = 50, margin = margin(r=40)))
                
                dev.off()
                
                

        
#END CREATE UNIFIED DATASET --------------------------------------------------------------------------------
                        
                        
                        
                        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#FILTER DATA ------------------------------------------------------------------------------

        #Note: I'm going to try to filter some of the data by the parameters that were used
        #by Hu et al. (2017) - hopefully, this will reduce some of the variation
        
                #Copy expanded dataset
                filt <- unified_exp
                
                #Filter to forest dominated by spruce, pine, or birch (no mixed)
                filt <- filt[filt$treslag %in% c("Grandominert", "Lauvdominert", "Furudominert"),]
                
                #Filter to homogenous forest (>75% coverage)
                
                        ggplot(data = subset(filt, Species == "Birch"), aes(x = Ms_Dnst, y = Albedo, color = Plot)) +
                                geom_point(alpha = 0.1) +
                                geom_smooth(method = NULL) +
                                facet_wrap(~ Month) +
                                scale_y_continuous(limits = c(0,1), breaks = c(0,0.2,0.4,0.6,0.8,1))
                        
        
                                        
#END FILTER DATA ------------------------------------------------------------------------------
                        