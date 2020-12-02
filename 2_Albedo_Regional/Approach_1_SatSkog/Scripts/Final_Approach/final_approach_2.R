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
        library(zoo)
        
        
        #Define beepr path
        b <- "4_Misc/beepr_sound.wav"


#END PACKAGES ----------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#IMPORT  --------------------------------------------------------------------------------------------------

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
                
#END IMPORT DATA ----------------------------------------------------------------------------------
                
                
                
                
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                
                
                
                
#RE-CALCULATE ALBEDO FOR EACH OBSERVATION IN PLOTS ----------------------------------------------------------------------

        #BIRCH ALBEDO (Months 1-12)
                
                data_filt$M_1_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_1 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_1 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_1))
                data_filt$M_2_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_2 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_2 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_2))
                data_filt$M_3_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_3 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_3 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_3))
                data_filt$M_4_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_4 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_4 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_4))
                data_filt$M_5_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_5 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_5 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_5))
                data_filt$M_6_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_6 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_6 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_6))
                data_filt$M_7_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_7 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_7 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_7))
                data_filt$M_8_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_8 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_8 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_8))
                data_filt$M_9_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_9 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_9 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_9))
                data_filt$M_10_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_10 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_10 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_10))
                data_filt$M_11_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_11 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_11 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_11))
                data_filt$M_12_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_12 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_12 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_12))
                

        #SPRUCE ALBEDO (Months 1-12)
                
                data_filt$M_1_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_1 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_1 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_1))
                data_filt$M_2_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_2 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_2 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_2))
                data_filt$M_3_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_3 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_3 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_3))
                data_filt$M_4_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_4 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_4 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_4))
                data_filt$M_5_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_5 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_5 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_5))
                data_filt$M_6_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_6 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_6 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_6))
                data_filt$M_7_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_7 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_7 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_7))
                data_filt$M_8_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_8 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_8 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_8))
                data_filt$M_9_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_9 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_9 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_9))
                data_filt$M_10_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_10 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_10 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_10))
                data_filt$M_11_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_11 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_11 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_11))
                data_filt$M_12_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_12 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_12 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_12))
                

        #PINE ALBEDO (Months 1-12)
                
                data_filt$M_1_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_1 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_1 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_1))
                data_filt$M_2_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_2 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_2 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_2))
                data_filt$M_3_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_3 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_3 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_3))
                data_filt$M_4_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_4 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_4 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_4))
                data_filt$M_5_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_5 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_5 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_5))
                data_filt$M_6_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_6 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_6 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_6))
                data_filt$M_7_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_7 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_7 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_7))
                data_filt$M_8_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_8 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_8 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_8))
                data_filt$M_9_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_9 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_9 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_9))
                data_filt$M_10_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_10 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_10 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_10))
                data_filt$M_11_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_11 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_11 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_11))
                data_filt$M_12_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_12 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_12 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_12))
            
                
        #SAVE UPDATED SHAPEFILE
                
                #Write ESRI shapefile
                st_write(data_filt, "2_Albedo_Regional/Approach_1_SatSkog/Output/Final_Approach/corrected_shapefile", driver = "ESRI Shapefile")
                
        
                    
#END RE-CALCULATE ALBEDO FOR EACH OBSERVATION IN PLOTS ----------------------------------------------------------------------
                
                
                
                
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                
                
                
                
#CROP DATA ---------------------------------------------------------------------------    
        
        #LOAD CORRECTED SHAPEFILE
        data_filt <- st_read("2_Albedo_Regional/Approach_1_SatSkog/Output/Final_Approach/corrected_shapefile/corrected_shapefile.shp")
        beep(3)
        
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
                        #plot(se_plot["Ms_Dnst"], border = 0.2) #Looks good!
                

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
                        #plot(s_plot["Ms_Dnst"], border = 0.2) #Looks good!
                
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
                        #plot(c_plot["Ms_Dnst"], border = 0.2) #Looks good!
        


#END CROP DATA --------------------------------------------------------------------------------------------------
        
        
        
        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


                        
                        
#EXPLORE CROPS --------------------------------------------------------------------------------------------------                        
                        

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
        rm(data)
        rm(months)
        rm(spec)
        
        beep(8)
        
        
#PLOTS ----------------------------------------------------
        
        
        #SUMMARY OF SOUTHEAST PLOT ---------
        
                #ELEVATION
        
                        #Histogram
                        ggplot(data = se_plot, aes(x = dem)) +
                                geom_histogram() +
                                theme_bw() +
                                labs(x = "Mean Elevation of Forest Plot (m)", y = "Frequency")
        
                        #Spatial plot
                        ggplot() +
                                geom_sf(data = se_plot, aes(fill = dem, color = dem), lwd = 0.1) +
                                ggtitle("Elevation of Southeast Plots") +
                                theme_bw()
        
                #Age
                ggplot(data = subset(unified, Plot == "Southeast"), aes(x = alder)) +
                        geom_histogram() +
                        theme_bw() +
                        labs(x = "Age of Forest Plot (years)", y = "Frequency")
                

        #INVESTIGATE VOLUME -----------
        
                #Volume vs. moose density scatterplots
                unified$Ms_Dnst <- as.numeric(as.character(unified$Ms_Dnst))
        
                        #Spruce
                        ggplot(data = subset(unified, Plot == "Southeast"), aes(x = Ms_Dnst, y = vuprhag)) +
                                geom_point(alpha = 0.3) +
                                geom_smooth(method = "loess", span = 50, se = F) +
                                theme_bw() +
                                labs(x = "Moose Density (kg/km2)", y = "Spruce Stand Volume (m3/ha)")
                        
                        #Pine
                        ggplot(data = subset(unified, Plot == "Southeast"), aes(x = Ms_Dnst, y = vuprhaf)) +
                                geom_point(alpha = 0.3) +
                                geom_smooth(method = "loess", span = 50, se = F) +
                                theme_bw() +
                                labs(x = "Moose Density (kg/km2)", y = "Pine Stand Volume (m3/ha)")
                        
                        #Birch (Deciduous)
                        ggplot(data = subset(unified, Plot == "Southeast"), aes(x = Ms_Dnst, y = vuprhal)) +
                                geom_point(alpha = 0.3) +
                                geom_smooth(method = "loess", span = 50, se = F) +
                                theme_bw() +
                                labs(x = "Moose Density (kg/km2)", y = "Deciduous Stand Volume (m3/ha)")
                        
                        
                        
                #Plot volume vs. means for moose density (w/ SE)
                unified$Ms_Dnst <- as.factor(unified$Ms_Dnst)
                
                        #Define Southeast plot as new df
                        southeast <- unified[unified$Plot == "Southeast",]
                        birch_vol <- aggregate(southeast$vuprhal, by = list(southeast$Ms_Dnst), FUN = mean)
                        spruce_vol <- aggregate(southeast$vuprhag, by = list(southeast$Ms_Dnst), FUN = mean)
                        pine_vol <- aggregate(southeast$vuprhaf, by = list(southeast$Ms_Dnst), FUN = mean)
                
                        #Birch
                        birch_vol$Group.1 <- as.numeric(as.character(birch_vol$Group.1))
                        ggplot(data = birch_vol, aes(x = Group.1, y = x)) +
                                geom_point() +
                                geom_line() + 
                                labs(x = "Moose Density (kg/km2)", y = "Mean Birch Stand Volume (m3/ha)")
                        
                        
                        #Pine
                        pine_vol$Group.1 <- as.numeric(as.character(pine_vol$Group.1))
                        ggplot(data = pine_vol, aes(x = Group.1, y = x)) +
                                geom_point() +
                                geom_line() + 
                                labs(x = "Moose Density (kg/km2)", y = "Mean Pine Stand Volume (m3/ha)")
                        
                        
                        #Spruce
                        spruce_vol$Group.1 <- as.numeric(as.character(spruce_vol$Group.1))
                        ggplot(data = spruce_vol, aes(x = Group.1, y = x)) +
                                geom_point() +
                                geom_line() + 
                                labs(x = "Moose Density (kg/km2)", y = "Mean Spruce Stand Volume (m3/ha)")
        
                  
                #ROLLING MEANS FOR VOLUME ------------
                        
                        #Rolling means for Spruce        
                        roll_spruce <- as.data.frame(rollapplyr(spruce_vol, 5, mean, partial = TRUE))
                        ggplot(data = roll_spruce, aes(x = Group.1, y = x)) +
                                geom_point() +
                                geom_line() +
                                labs(x = "Moose Density (kg/km2)", y = "Mean Spruce Stand Volume (m3/ha)\nRolling Average")
                        
                
                        #Rolling means for Pine        
                        roll_pine <- as.data.frame(rollapplyr(pine_vol, 5, mean, partial = TRUE))
                        ggplot(data = roll_pine, aes(x = Group.1, y = x)) +
                                geom_point() +
                                geom_line() +
                                labs(x = "Moose Density (kg/km2)", y = "Mean Pine Stand Volume (m3/ha)\nRolling Average")
                        
                        
                        #Rolling means for Birch
                        roll_birch <- as.data.frame(rollapplyr(birch_vol, 5, mean, partial = TRUE))
                        ggplot(data = roll_birch, aes(x = Group.1, y = x)) +
                                geom_point() +
                                geom_line() +
                                labs(x = "Moose Density (kg/km2)", y = "Mean Birch Stand Volume (m3/ha)\nRolling Average")
                        
                        
        
        #CENTRAL PLOT SUMMARY ---------------
                        
                #Define Southeast plot as new df
                central <- unified[unified$Plot == "Central",]
                birch_vol_c <- aggregate(central$vuprhal, by = list(central$Ms_Dnst), FUN = mean)
                spruce_vol_c <- aggregate(central$vuprhag, by = list(central$Ms_Dnst), FUN = mean)
                pine_vol_c <- aggregate(central$vuprhaf, by = list(central$Ms_Dnst), FUN = mean)
                
                        #Birch
                        birch_vol_c$Group.1 <- as.numeric(as.character(birch_vol_c$Group.1))
                        ggplot(data = birch_vol_c, aes(x = Group.1, y = x)) +
                                geom_point() +
                                geom_line() + 
                                labs(x = "Moose Density (kg/km2)", y = "Mean Birch Stand Volume (m3/ha)")
                        
                        
                        #Pine
                        pine_vol_c$Group.1 <- as.numeric(as.character(pine_vol_c$Group.1))
                        ggplot(data = pine_vol_c, aes(x = Group.1, y = x)) +
                                geom_point() +
                                geom_line() + 
                                labs(x = "Moose Density (kg/km2)", y = "Mean Pine Stand Volume (m3/ha)")
                        
                        
                        #Spruce
                        spruce_vol_c$Group.1 <- as.numeric(as.character(spruce_vol_c$Group.1))
                        ggplot(data = spruce_vol_c, aes(x = Group.1, y = x)) +
                                geom_point() +
                                geom_line() + 
                                labs(x = "Moose Density (kg/km2)", y = "Mean Spruce Stand Volume (m3/ha)")
                
                
                #ROLLING MEANS FOR VOLUME ------------
                
                        
                        #Rolling means for Spruce        
                        roll_spruce_c <- as.data.frame(rollmean(spruce_vol_c, 5, align = "center"))
                        ggplot(data = roll_spruce_c, aes(x = Group.1, y = x)) +
                                geom_point() +
                                geom_line() +
                                labs(x = "Moose Density (kg/km2)", y = "Mean Spruce Stand Volume (m3/ha)\nRolling Average")
                        
                        
                        #Rolling means for Pine        
                        roll_pine_c <- as.data.frame(rollmean(pine_vol_c, 5, align = "center"))
                        ggplot(data = roll_pine_c, aes(x = Group.1, y = x)) +
                                geom_point() +
                                geom_line() +
                                labs(x = "Moose Density (kg/km2)", y = "Mean Pine Stand Volume (m3/ha)\nRolling Average")
                        
                        
                        #Rolling means for Birch
                        roll_birch_c <- as.data.frame(rollmean(birch_vol_c, 5, align = "center"))
                        ggplot(data = roll_birch_c, aes(x = Group.1, y = x)) +
                                geom_point() +
                                geom_line() +
                                labs(x = "Moose Density (kg/km2)", y = "Mean Birch Stand Volume (m3/ha)\nRolling Average")
               
                        
                                 
        #NO NOTICEABLE TRENDS
        
#END CREATE UNIFIED DATASET --------------------------------------------------------------------------------
                        
                        
                        
                        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#FILTER DATA ------------------------------------------------------------------------------

        #Note: I'm going to try to filter some of the data by the parameters that were used
        #by Hu et al. (2017) - hopefully, this will reduce some of the variation
        
                #Copy expanded dataset
                filt <- unified_exp
                
                #Filter to forest dominated by spruce, pine, or birch (no mixed)
                filt <- filt[filt$treslag %in% c("Grandominert", "Lauvdominert", "Furudominert"),]
                beep(b)
                
                #Filter to homogenous forest (>75% coverage)
                
                        #Filter & calculate means
                
                                #Birch ------
                                
                                        #Filter
                                        filt_b <- filt[filt$lav_pct >= 75,]
                
                                        #Calculate mean birch vol for each moose density
                                        filt_b$Ms_Dnst <- as.numeric(filt_b$Ms_Dnst)
                                        filt_b <- aggregate(filt_b$vuprhal, by = list(filt_b$Ms_Dnst, filt_b$Plot), FUN = mean)
                                        
                                        #Rolling means
                                        
                                                #Central
                                                filt_b_c <- filt_b[filt_b$Group.2 == "Central",]
                                                filt_b_c <- filt_b_c[,c(1,3)]
                                                filt_b_c <- as.data.frame(rollapplyr(filt_b_c, 7, mean, partial = TRUE))
                                                filt_b_c$Plot <- "Central"
                                                
                                                #Southeast
                                                filt_b_se <- filt_b[filt_b$Group.2 == "Southeast",]
                                                filt_b_se <- filt_b_se[,c(1,3)]
                                                filt_b_se <- as.data.frame(rollapplyr(filt_b_se, 7, mean, partial = TRUE))
                                                filt_b_se$Plot <- "Southeast"
                                                
                                                #South
                                                filt_b_s <- filt_b[filt_b$Group.2 == "South",]
                                                filt_b_s <- filt_b_s[,c(1,3)]
                                                filt_b_s <- as.data.frame(rollapplyr(filt_b_s, 7, mean, partial = TRUE))
                                                filt_b_s$Plot <- "South"
                                                
                                                #Bind together
                                                filt_b_roll <- rbind(filt_b_c, filt_b_se, filt_b_s)
                                                
                                        #Plot rolling means for birch
                                        ggplot(data = filt_b_roll, aes(x = Group.1, y = x, color = Plot)) +
                                                geom_point() +
                                                geom_line() +
                                                labs(x = "Moose Density", y = "Birch Stand Volume (m3/ha)\nRolling Average")
                                                
                                
                                #Spruce
                                        
                                        #Filter
                                        filt_s <- filt[filt$grn_pct >= 75,]
                                        
                                        #Calculate mean birch vol for each moose density
                                        filt_s$Ms_Dnst <- as.numeric(filt_s$Ms_Dnst)
                                        filt_s <- aggregate(filt_s$vuprhag, by = list(filt_s$Ms_Dnst, filt_s$Plot), FUN = mean)
                                        
                                        #Rolling means
                                        
                                                #Central
                                                filt_s_c <- filt_s[filt_s$Group.2 == "Central",]
                                                filt_s_c <- filt_s_c[,c(1,3)]
                                                filt_s_c <- as.data.frame(rollapplyr(filt_s_c, 7, mean, partial = TRUE))
                                                filt_s_c$Plot <- "Central"
                                                
                                                #Southeast
                                                filt_s_se <- filt_s[filt_s$Group.2 == "Southeast",]
                                                filt_s_se <- filt_s_se[,c(1,3)]
                                                filt_s_se <- as.data.frame(rollapplyr(filt_s_se, 7, mean, partial = TRUE))
                                                filt_s_se$Plot <- "Southeast"
                                                
                                                #South
                                                filt_s_s <- filt_s[filt_s$Group.2 == "South",]
                                                filt_s_s <- filt_s_s[,c(1,3)]
                                                filt_s_s <- as.data.frame(rollapplyr(filt_s_s, 7, mean, partial = TRUE))
                                                filt_s_s$Plot <- "South"
                                        
                                        #Bind together
                                        filt_s_roll <- rbind(filt_s_c, filt_s_se, filt_s_s)
                                        
                                        #Plot rolling means for birch
                                        ggplot(data = filt_s_roll, aes(x = Group.1, y = x, color = Plot)) +
                                                geom_point() +
                                                geom_line() +
                                                labs(x = "Moose Density", y = "Spruce Stand Volume (m3/ha)\nRolling Average")
                                        
                                
                                #Pine

                                        #Filter
                                        filt_p <- filt[filt$fur_pct >= 75,]
                                        
                                        #Calculate mean birch vol for each moose density
                                        filt_p$Ms_Dnst <- as.numeric(filt_p$Ms_Dnst)
                                        filt_p <- aggregate(filt_p$vuprhaf, by = list(filt_p$Ms_Dnst, filt_p$Plot), FUN = mean)
                                        
                                        #Rolling means
                                        
                                                #Central
                                                filt_p_c <- filt_p[filt_p$Group.2 == "Central",]
                                                filt_p_c <- filt_p_c[,c(1,3)]
                                                filt_p_c <- as.data.frame(rollapplyr(filt_p_c, 7, mean, partial = TRUE))
                                                filt_p_c$Plot <- "Central"
                                                
                                                #Southeast
                                                filt_p_se <- filt_p[filt_p$Group.2 == "Southeast",]
                                                filt_p_se <- filt_p_se[,c(1,3)]
                                                filt_p_se <- as.data.frame(rollapplyr(filt_p_se, 7, mean, partial = TRUE))
                                                filt_p_se$Plot <- "Southeast"
                                                
                                                #South
                                                filt_p_s <- filt_p[filt_p$Group.2 == "South",]
                                                filt_p_s <- filt_p_s[,c(1,3)]
                                                filt_p_s <- as.data.frame(rollapplyr(filt_p_s, 7, mean, partial = TRUE))
                                                filt_p_s$Plot <- "South"
                                                
                                        #Bind together
                                        filt_p_roll <- rbind(filt_p_c, filt_p_se, filt_p_s)
                                        
                                        #Plot rolling means for birch
                                        ggplot(data = filt_p_roll, aes(x = Group.1, y = x, color = Plot)) +
                                                geom_point() +
                                                geom_line() +
                                                labs(x = "Moose Density", y = "Pine Stand Volume (m3/ha)\nRolling Average")
                                        
                        
                        #Remove filt df to save memory    
                        rm(filt)
                

                                        
                        
        
                                        
#END FILTER DATA ------------------------------------------------------------------------------
                        