## This is script to analyze all relevant SatSkog spatial data in Norway


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
        


        
      
#END PACKAGES ----------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#IMPORT + FORMAT DATA --------------------------------------------------------------------------------------------------

        #Load unified shapefile w/ all variables
        data <- st_read("2_Albedo_Regional/Data/Final_Shapefile/Output/ready_for_analysis/full_resolution/final_shapefile.shp")
        
        #Format data correctly
        data$bon1_n <- as.factor(data$bon1_n)
        data$treslag <- as.factor(data$treslag)
        data$Mnt_1_A <- as.numeric(data$Mnt_1_A)
        data$Mnt_2_A <- as.numeric(data$Mnt_2_A)
        data$Mnt_3_A <- as.numeric(data$Mnt_3_A)
        data$Mnt_4_A <- as.numeric(data$Mnt_4_A)
        data$Mnt_5_A <- as.numeric(data$Mnt_5_A)
        data$Mnt_6_A <- as.numeric(data$Mnt_6_A)
        data$Mnt_7_A <- as.numeric(data$Mnt_7_A)
        data$Mnt_8_A <- as.numeric(data$Mnt_8_A)
        data$Mnt_9_A <- as.numeric(data$Mnt_9_A)
        data$Mn_10_A <- as.numeric(data$Mn_10_A)
        data$Mn_11_A <- as.numeric(data$Mn_11_A)
        data$Mn_12_A <- as.numeric(data$Mn_12_A)
        data$Ms_Dnst <- as.numeric(data$Ms_Dnst)
        
#Plot initial geometry of shapefile ---------
        
        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/geometry/init_geometry.png",
            width = 2000,
            height = 2000,
            units = "px",
            bg = "white")
        
        plot(data["Mnt_1_A"],
             main = "January Albedo\nLarge Shapefile (Before Filtering)",
             cex.main = 3.5)
        par(oma=c(0,0,2,0))
        
        dev.off()
        beep(8)
        
# End plot -------------------------------------------------------------
        
        #FILTER STEP #1 (Assign NA to rows w/ invalid albedo values)
        
                data$Mnt_1_A[data$Mnt_1_A < 0 | data$Mnt_1_A > 1] <- NA
                data$Mnt_2_A[data$Mnt_2_A < 0 | data$Mnt_2_A > 1] <- NA
                data$Mnt_3_A[data$Mnt_3_A < 0 | data$Mnt_3_A > 1] <- NA
                data$Mnt_4_A[data$Mnt_4_A < 0 | data$Mnt_4_A > 1] <- NA
                data$Mnt_5_A[data$Mnt_5_A < 0 | data$Mnt_5_A > 1] <- NA
                data$Mnt_6_A[data$Mnt_6_A < 0 | data$Mnt_6_A > 1] <- NA
                data$Mnt_7_A[data$Mnt_7_A < 0 | data$Mnt_7_A > 1] <- NA
                data$Mnt_8_A[data$Mnt_8_A < 0 | data$Mnt_8_A > 1] <- NA
                data$Mnt_9_A[data$Mnt_9_A < 0 | data$Mnt_9_A > 1] <- NA
                data$Mn_10_A[data$Mn_10_A < 0 | data$Mn_10_A > 1] <- NA
                data$Mn_11_A[data$Mn_11_A < 0 | data$Mn_11_A > 1] <- NA
                data$Mn_12_A[data$Mn_12_A < 0 | data$Mn_12_A > 1] <- NA
        
                
        
#Plot after filter step #1 -------------------------------------------------------------
        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/geometry/init_geometry_f1.png",
            width = 2000,
            height = 2000,
            units = "px",
            bg = "white")
        
        plot(data["Mnt_1_A"],
             main = "January Albedo\nLarge Shapefile (Filtering #1)",
             cex.main = 3.5)
        par(oma=c(0,0,2,0))
        
        dev.off()
        beep(9)
        
# End plot -------------------------------------------------------------
        
        
        #FILTER STEP #2 (Remove rows w/ NA values for critical variables)
        
                #Remove rows where Moose Density or kommune name is missing
                data <- data[!is.na(data$Ms_Dnst),]
                data <- data[!is.na(data$NAVN),]
                
                
                
#Plot after filter step #2 -------------------------------------------------------------
        
        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/geometry/init_geometry_f2.png",
            width = 2000,
            height = 2000,
            units = "px",
            bg = "white")
        
        plot(data["Mnt_1_A"],
             main = "January Albedo\nLarge Shapefile (Filtering #2)",
             cex.main = 3.5)
        par(oma=c(0,0,2,0))
        
        dev.off()
        beep(9)

# End plot -------------------------------------------------------------

        #FILTER STEP #3 (Replace invalid bonitet values w/ NA)
        
                # Only 'bonitet' between 11 (unproductive) and 15 (highly productive) - according to SatSkog
                # metadata, 11 should be minimum value
                data$bonitet[data$bonitet < 11] <- NA
        
                #Replace rows where 'bon1_n' is 'Null' w/ NA
                data$bon1_n[data$bon1_n == "Null"] < NA

        #FINAL FIXES TO DF
                
                #Fix weird variations in SWE, Temp, and Albedo labels
                colnames(data)[39] <- "SWE_M_1"
                colnames(data)[58] <- "Tmp_M_10"
                colnames(data)[60] <- "Tmp_M_11"
                colnames(data)[62] <- "Tmp_M_12"
                colnames(data)[72] <- "Mnt_10_A"
                colnames(data)[73] <- "Mnt_11_A"
                colnames(data)[74] <- "Mnt_12_A"
                
                #Add column w/ arbitrary IDs (for use in spatial analysis below)
                ids <- as.vector(1:nrow(data))
                data <- cbind(data, ids)
                rm(ids)
                
##WRITE FILTERED DATASET TO SHAPEFILE
                st_write(data, "2_Albedo_Regional/Data/Final_Shapefile/Output/ready_for_analysis/full_resolution/final_shapefile_FILTERED.shp", driver = "ESRI Shapefile")    
                
        
                
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
                data_exp$Albedo <- as.numeric('')
                
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
                        data_exp$Albedo[data_exp$Month == 1] <- data_exp$Mnt_1_A[data_exp$Month == 1]
                        data_exp$Albedo[data_exp$Month == 2] <- data_exp$Mnt_2_A[data_exp$Month == 2]
                        data_exp$Albedo[data_exp$Month == 3] <- data_exp$Mnt_3_A[data_exp$Month == 3]
                        data_exp$Albedo[data_exp$Month == 4] <- data_exp$Mnt_4_A[data_exp$Month == 4]
                        data_exp$Albedo[data_exp$Month == 5] <- data_exp$Mnt_5_A[data_exp$Month == 5]
                        data_exp$Albedo[data_exp$Month == 6] <- data_exp$Mnt_6_A[data_exp$Month == 6]
                        data_exp$Albedo[data_exp$Month == 7] <- data_exp$Mnt_7_A[data_exp$Month == 7]
                        data_exp$Albedo[data_exp$Month == 8] <- data_exp$Mnt_8_A[data_exp$Month == 8]
                        data_exp$Albedo[data_exp$Month == 9] <- data_exp$Mnt_9_A[data_exp$Month == 9]
                        data_exp$Albedo[data_exp$Month == 10] <- data_exp$Mnt_10_A[data_exp$Month == 10]
                        data_exp$Albedo[data_exp$Month == 11] <- data_exp$Mnt_11_A[data_exp$Month == 11]
                        data_exp$Albedo[data_exp$Month == 12] <- data_exp$Mnt_12_A[data_exp$Month == 12]
                
                #Remove replaced columns
                data_exp <- data_exp[,c(1:38, 75:108)] #Shapefile output is HUGE and takes forever to load, easier to just process initial df
                
                beep(8)

                
#END IMPORT + FORMAT DATA --------------------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#DATA EXPLORATION --------------------------------------------------------------------------------------------------

        #Define color palette
        myPalette <- colorRampPalette(rev(brewer.pal(11, "Spectral")))
        
        #PLOT EXPLANATORY VARIABLES (WRITE OUTPUT TO RELEVANT FOLDER)
        
                #Age Histogram ---------------
        
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/variables/init_age_histogram.png",
                            width = 2000,
                            height = 2000,
                            units = "px",
                            bg = "white")
                        
                        ggplot(data = data, aes(x = alder)) +
                                geom_histogram(bins = 30) +
                                ggtitle("Age of Selected Forest Plots") + 
                                labs(x = "Age (Years)", y = "Frequency") +
                                theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                      legend.title = element_text(size = 40),
                                      legend.text = element_text(size = 36),
                                      axis.text.x = element_text(size = 44, margin = margin(t=16)),
                                      axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                      axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                                      axis.title.y = element_text(size = 60, margin = margin(r=40)))
                        
                        dev.off()

                #Area (hectacres) Histogram -----------------
                        
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/variables/init_area_histogram.png",
                            width = 2000,
                            height = 2000,
                            units = "px",
                            bg = "white")
                        
                        ggplot(data = data, aes(x = arl_hkt)) +
                                geom_histogram(bins = 100) +
                                ggtitle("Area of Selected Forest Plots (Ha)") +
                                labs(x = "Area (Ha)", y = "Frequency") +
                                theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                      legend.title = element_text(size = 40),
                                      legend.text = element_text(size = 36),
                                      axis.text.x = element_text(size = 44, margin = margin(t=16)),
                                      axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                      axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                                      axis.title.y = element_text(size = 60, margin = margin(r=40)))
                        
                        dev.off()
                
                #Bonitet Histogram ----------------
                        
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/variables/init_bonitet_histogram.png",
                            width = 2000,
                            height = 2000,
                            units = "px",
                            bg = "white")
                        
                        ggplot(data = data, aes(x = bonitet)) +
                                geom_histogram(bins = 15) +
                                ggtitle("Bonitet (Site Quality) of Selected Forest Plots") +
                                labs(x = "Site Quality ('Bonitet')", y = "Frequency") +
                                theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                      legend.title = element_text(size = 40),
                                      legend.text = element_text(size = 36),
                                      axis.text.x = element_text(size = 44, margin = margin(t=16)),
                                      axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                      axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                                      axis.title.y = element_text(size = 60, margin = margin(r=40)))
                        
                        dev.off()
                
                #Productive vs non-productive forest ----------------
                        
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/variables/init_forest_productivity_bars.png",
                            width = 2000,
                            height = 2000,
                            units = "px",
                            bg = "white")
                        
                        ggplot(data = data, aes(x = clss_ms, fill = clss_ms)) +
                                geom_bar() +
                                ggtitle("Forest Classification of Selected Plots") +
                                labs(x = "Productivity Classification", y = "Frequency") +
                                scale_fill_manual(values = wes_palette("Royal1")) +
                                scale_x_discrete(labels = c("Productive\nForest", "Forest")) +
                                theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                      legend.position = "none",
                                      axis.text.x = element_text(size = 44, margin = margin(t=16)),
                                      axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                      axis.title.x = element_text(size = 60, margin = margin(t=60, b = 40)),
                                      axis.title.y = element_text(size = 60, margin = margin(r=40)))
                        
                        dev.off()
                
                #NDVI ----------------
                        
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/variables/init_ndvi_histogram.png",
                            width = 2000,
                            height = 2000,
                            units = "px",
                            bg = "white")
                        
                        ggplot(data = data, aes(x = ndvi)) +
                                geom_histogram() +
                                ggtitle("NDVI of Selected Plots") +
                                labs(x = "NDVI", y = "Frequency") +
                                theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                      legend.title = element_text(size = 40),
                                      legend.text = element_text(size = 36),
                                      axis.text.x = element_text(size = 44, margin = margin(t=16)),
                                      axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                      axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                                      axis.title.y = element_text(size = 60, margin = margin(r=40)))
                        
                        dev.off()
                
                #Moose Density
                        
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/variables/init_moose_density_histogram.png",
                            width = 2000,
                            height = 2000,
                            units = "px",
                            bg = "white")
                        
                        ggplot(data = data, aes(x = Ms_Dnst)) +
                                geom_histogram() +
                                ggtitle("Moose Density of Selected Plots") +
                                labs(x = "Moose Density (kg/km-2)", y = "Frequency") +
                                theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                      legend.title = element_text(size = 40),
                                      legend.text = element_text(size = 36),
                                      axis.text.x = element_text(size = 44, margin = margin(t=16)),
                                      axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                      axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                                      axis.title.y = element_text(size = 60, margin = margin(r=40)))
                        
                        dev.off()
                

        #CORRELATION MATRIX BETWEEN NUMERIC EXPLANATORY VARIABLES --------------------------------- 
        
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/variables/init_correlation_matrix.png",
                            width = 1000,
                            height = 1000,
                            units = "px",
                            bg = "white")
                        
                        corr_sub <- st_drop_geometry(data[,c(1,2,11,27,85:101)])
                        
                        #Generate correlation matrix
                        res <- cor(corr_sub)
                        
                        corrplot(res,
                                 type = "upper",
                                 tl.col = "black",
                                 tl.cex = 1,
                                 tl.srt = 30,
                                 number.cex = 0.8,
                                 title = "Correlogram of Numeric Variables",
                                 mar=c(0,0,5,0)) 
                        
                        dev.off()
                        
                        rm(corr_sub)
                        
        #PLOT ALBEDO ---------------------------------
                        
                        #2D BIN PLOTS (Faceted by month) -------
                        
                                #No mean line
                                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/albedo/init_albedo_moose_density_by_month.png",
                                    width = 3000,
                                    height = 2000,
                                    units = "px",
                                    bg = "white")
                                
                                ggplot(data = data_exp, aes(x = Ms_Dnst, y = Albedo)) +
                                                geom_bin2d(binwidth = c(5,0.025)) +
                                                facet_wrap(~ Month) +
                                                scale_fill_gradientn(colours = myPalette(100)) +
                                                ggtitle("Moose Density vs. Albedo (by Month)") +
                                                labs(x = "Moose Density (kg/km-2)", y = "Albedo") +
                                                theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                                      legend.title = element_text(size = 40),
                                                      legend.text = element_text(size = 36, margin = margin(t=16)),
                                                      strip.text.x = element_text(size = 32),
                                                      axis.text.x = element_text(size = 38, margin = margin(t=16)),
                                                      axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                                      axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                                                      axis.title.y = element_text(size = 60, margin = margin(r=40)))

                                dev.off()
                                
                                #Has mean line
                                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/albedo/init_albedo_moose_density_by_month_smooth.png",
                                    width = 3000,
                                    height = 2000,
                                    units = "px",
                                    bg = "white")
                                
                                n_obs <- nrow(data)
                                ggplot(data = data_exp, aes(x = Ms_Dnst, y = Albedo)) +
                                        geom_bin2d(binwidth = c(5,0.025)) +
                                        facet_wrap(~ Month) +
                                        geom_smooth(colour = "red") +
                                        scale_fill_gradientn(colours = myPalette(100)) +
                                        ggtitle(paste("Moose Density vs. Albedo (by Month)\n(n = ", n_obs, ")", sep = "")) +
                                        labs(x = "Moose Density (kg/km-2)", y = "Albedo") +
                                        theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                              legend.title = element_text(size = 40),
                                              legend.text = element_text(size = 36, margin = margin(t=16)),
                                              strip.text.x = element_text(size = 32),
                                              axis.text.x = element_text(size = 38, margin = margin(t=16)),
                                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                              axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                                              axis.title.y = element_text(size = 60, margin = margin(r=40)))

                                dev.off()
                        
                        
                        #THREE-VARIABLE PLOTS -------
                        
                                #3RD VARIABLE: AGE -------
                                
                                        #JANUARY -------
                                        
                                                #Cloud plot
                                                #cloud(Albedo ~ Ms_Dnst * alder, pch = ".", data = subset(data_exp, Month == 1))
                                
                                                #Equal counts bin plot (faceted by age, cut into equal count intervals)
                                                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/albedo/cut/age/init_january_age_interval.png",
                                                    width = 3000,
                                                    height = 2000,
                                                    units = "px",
                                                    bg = "white")
                                                
                                                ggplot(data = subset(data_exp, Month == 1), aes(x = Ms_Dnst, y = Albedo)) +
                                                        geom_bin2d(binwidth = c(5,0.025)) +
                                                        facet_wrap(~ cut_interval(alder, 6)) +
                                                        geom_smooth(colour = "red") +
                                                        ggtitle("Moose Density vs. Albedo (January)\nSplit by 6 age intervals") +
                                                        labs(x = "Moose Density (kg/km-2)", y = "Albedo") +
                                                        theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                                              legend.title = element_text(size = 40),
                                                              legend.text = element_text(size = 36, margin = margin(t=16)),
                                                              strip.text.x = element_text(size = 32),
                                                              axis.text.x = element_text(size = 38, margin = margin(t=16)),
                                                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                                              axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                                                              axis.title.y = element_text(size = 60, margin = margin(r=40)))
                                                
                                                        #Seems to be a bit more variable in younger forest
                                                
                                                dev.off()
                                                
                                                
                                        #April -------
                                                
                                                
                                                #Equal counts bin plot (faceted by age, cut into equal count intervals)
                                                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/albedo/cut/age/init_april_age_interval.png",
                                                    width = 3000,
                                                    height = 2000,
                                                    units = "px",
                                                    bg = "white")
                                                
                                                ggplot(data = subset(data_exp, Month == 4), aes(x = Ms_Dnst, y = Albedo)) +
                                                        geom_bin2d(binwidth = c(5,0.025)) +
                                                        facet_wrap(~ cut_interval(alder, 6)) +
                                                        geom_smooth(colour = "red") +
                                                        ggtitle("Moose Density vs. Albedo (April)\nSplit by 6 age intervals") +
                                                        labs(x = "Moose Density (kg/km-2)", y = "Albedo") +
                                                        theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                                              legend.title = element_text(size = 40),
                                                              legend.text = element_text(size = 36, margin = margin(t=16)),
                                                              strip.text.x = element_text(size = 32),
                                                              axis.text.x = element_text(size = 38, margin = margin(t=16)),
                                                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                                              axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                                                              axis.title.y = element_text(size = 60, margin = margin(r=40)))
                                                
                                                #Seems to be a bit more variable in younger forest
                                                
                                                dev.off()
                                                
                                                
                                        #July -------
                                                
                                                #Equal counts bin plot (faceted by age, cut into equal count intervals)
                                                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/albedo/cut/age/init_july_age_interval.png",
                                                    width = 3000,
                                                    height = 2000,
                                                    units = "px",
                                                    bg = "white")
                                                
                                                ggplot(data = subset(data_exp, Month == 7), aes(x = Ms_Dnst, y = Albedo)) +
                                                        geom_bin2d(binwidth = c(5,0.025)) +
                                                        facet_wrap(~ cut_interval(alder, 6)) +
                                                        geom_smooth(colour = "red") +
                                                        ggtitle("Moose Density vs. Albedo (July)\nSplit by 6 age intervals") +
                                                        labs(x = "Moose Density (kg/km-2)", y = "Albedo") +
                                                        theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                                              legend.title = element_text(size = 40),
                                                              legend.text = element_text(size = 36, margin = margin(t=16)),
                                                              strip.text.x = element_text(size = 32),
                                                              axis.text.x = element_text(size = 38, margin = margin(t=16)),
                                                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                                              axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                                                              axis.title.y = element_text(size = 60, margin = margin(r=40)))
                                                
                                                #Seems to be a bit more variable in younger forest
                                                
                                                dev.off()
                                                
                                                
                                        #October -------
                                                
                                                #Equal counts bin plot (faceted by age, cut into equal count intervals)
                                                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/albedo/cut/age/init_october_age_interval.png",
                                                    width = 3000,
                                                    height = 2000,
                                                    units = "px",
                                                    bg = "white")
                                                
                                                ggplot(data = subset(data_exp, Month == 10), aes(x = Ms_Dnst, y = Albedo)) +
                                                        geom_bin2d(binwidth = c(5,0.025)) +
                                                        facet_wrap(~ cut_interval(alder, 6)) +
                                                        geom_smooth(colour = "red") +
                                                        ggtitle("Moose Density vs. Albedo (October)\nSplit by 6 age intervals") +
                                                        labs(x = "Moose Density (kg/km-2)", y = "Albedo") +
                                                        theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                                              legend.title = element_text(size = 40),
                                                              legend.text = element_text(size = 36, margin = margin(t=16)),
                                                              strip.text.x = element_text(size = 32),
                                                              axis.text.x = element_text(size = 38, margin = margin(t=16)),
                                                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                                              axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                                                              axis.title.y = element_text(size = 60, margin = margin(r=40)))
                                                
                                                #Seems to be a bit more variable in younger forest
                                                
                                                dev.off()
                                     
                                                           
                        #Cut Interval by UTM33 North -----------
                                                
                                #January ----------
                                                
                                        #Equal counts bin plot (faceted by age, cut into equal count intervals)
                                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/albedo/cut/UTM33N/init_albedo_jan_cut_utm33n.png",
                                            width = 3000,
                                            height = 2000,
                                            units = "px",
                                            bg = "white")
                                        
                                        ggplot(data = subset(data_exp, Month == 1), aes(x = Ms_Dnst, y = Albedo)) +
                                                geom_bin2d(binwidth = c(5,0.025)) +
                                                facet_wrap(~ cut_interval(utm33_north, 6)) +
                                                geom_smooth(colour = "red") +
                                                ggtitle("Moose Density vs. Albedo (January)\nSplit into 6 regions (by UTM33N)") +
                                                labs(x = "Moose Density (kg/km-2)", y = "Albedo") +
                                                theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                                      legend.title = element_text(size = 40),
                                                      legend.text = element_text(size = 36, margin = margin(t=16)),
                                                      strip.text.x = element_text(size = 32),
                                                      axis.text.x = element_text(size = 38, margin = margin(t=16)),
                                                      axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                                      axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                                                      axis.title.y = element_text(size = 60, margin = margin(r=40)))
                                        
                                        dev.off()
                                        
                                        
                                #April ----------
                                        
                                        #Equal counts bin plot (faceted by age, cut into equal count intervals)
                                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/albedo/cut/UTM33N/init_albedo_apr_cut_utm33n.png",
                                            width = 3000,
                                            height = 2000,
                                            units = "px",
                                            bg = "white")
                                        
                                        ggplot(data = subset(data_exp, Month == 4), aes(x = Ms_Dnst, y = Albedo)) +
                                                geom_bin2d(binwidth = c(5,0.025)) +
                                                facet_wrap(~ cut_interval(utm33_north, 6)) +
                                                geom_smooth(colour = "red") +
                                                ggtitle("Moose Density vs. Albedo (April)\nSplit into 6 regions (by UTM33N)") +
                                                labs(x = "Moose Density (kg/km-2)", y = "Albedo") +
                                                theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                                      legend.title = element_text(size = 40),
                                                      legend.text = element_text(size = 36, margin = margin(t=16)),
                                                      strip.text.x = element_text(size = 32),
                                                      axis.text.x = element_text(size = 38, margin = margin(t=16)),
                                                      axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                                      axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                                                      axis.title.y = element_text(size = 60, margin = margin(r=40)))
                                        
                                        dev.off()
                                        
                                        
                                #July ----------
                                        
                                        #Equal counts bin plot (faceted by age, cut into equal count intervals)
                                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/albedo/cut/UTM33N/init_albedo_jul_cut_utm33n.png",
                                            width = 3000,
                                            height = 2000,
                                            units = "px",
                                            bg = "white")
                                        
                                        ggplot(data = subset(data_exp, Month == 7), aes(x = Ms_Dnst, y = Albedo)) +
                                                geom_bin2d(binwidth = c(5,0.025)) +
                                                facet_wrap(~ cut_interval(utm33_north, 6)) +
                                                geom_smooth(colour = "red") +
                                                ggtitle("Moose Density vs. Albedo (July)\nSplit into 6 regions (by UTM33N)") +
                                                labs(x = "Moose Density (kg/km-2)", y = "Albedo") +
                                                theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                                      legend.title = element_text(size = 40),
                                                      legend.text = element_text(size = 36, margin = margin(t=16)),
                                                      strip.text.x = element_text(size = 32),
                                                      axis.text.x = element_text(size = 38, margin = margin(t=16)),
                                                      axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                                      axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                                                      axis.title.y = element_text(size = 60, margin = margin(r=40)))
                                        
                                        dev.off()
                                        
                                        
                                #October ----------
                                        
                                        #Equal counts bin plot (faceted by age, cut into equal count intervals)
                                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/albedo/cut/UTM33N/init_albedo_oct_cut_utm33n.png",
                                            width = 3000,
                                            height = 2000,
                                            units = "px",
                                            bg = "white")
                                        
                                        ggplot(data = subset(data_exp, Month == 10), aes(x = Ms_Dnst, y = Albedo)) +
                                                geom_bin2d(binwidth = c(5,0.025)) +
                                                facet_wrap(~ cut_interval(utm33_north, 6)) +
                                                geom_smooth(colour = "red") +
                                                ggtitle("Moose Density vs. Albedo (October)\nSplit into 6 regions (by UTM33N)") +
                                                labs(x = "Moose Density (kg/km-2)", y = "Albedo") +
                                                theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                                      legend.title = element_text(size = 40),
                                                      legend.text = element_text(size = 36, margin = margin(t=16)),
                                                      strip.text.x = element_text(size = 32),
                                                      axis.text.x = element_text(size = 38, margin = margin(t=16)),
                                                      axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                                      axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                                                      axis.title.y = element_text(size = 60, margin = margin(r=40)))
                                        
                                        dev.off()
                                                


#END DATA EXPLORATION --------------------------------------------------------------------------------------------------
                                        
                                        
                                        
                                        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#ALBEDO + OUTLIER INVESTIGATION --------------------------------------------------------------------------------------------------
        
                                        
        #Identify outliers------
        
                #January -------
                
                        #Get IQR
                        iqr_jan <- IQR(data_exp$Albedo[data_exp$Month == 1], na.rm = T)
                        quant_jan <- quantile(data_exp$Albedo[data_exp$Month == 1], na.rm = T) 
                                        
                        #Get outliers in df
                        outliers_jan <- data_exp[ (data_exp$Albedo > quant_jan[4] + (1.5 * iqr_albedo_jan) | data_exp$Albedo < quant_jan[2] - (1.5 * iqr_albedo_jan) ) & data_exp$Month == 1,]
                        
                        #Print some simple plots of relevant variables
                        
                                #Albedo histogram
                                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/albedo/outliers/outliers_jan_albedo_hist.png",
                                    width = 2000,
                                    height = 2000,
                                    units = "px",
                                    bg = "white")
                                
                                ggplot(data = outliers_jan, aes(x = Albedo)) +
                                        geom_histogram() +
                                        ggtitle("Albedo in Outlier Plots (January)") +
                                        theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                              strip.text.x = element_text(size = 32),
                                              axis.text.x = element_text(size = 38, margin = margin(t=16)),
                                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                              axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                                              axis.title.y = element_text(size = 60, margin = margin(r=40)))
                                
                                dev.off()
                                
                                #Area
                                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/albedo/outliers/outliers_jan_area_hist.png",
                                    width = 2000,
                                    height = 2000,
                                    units = "px",
                                    bg = "white")
                                
                                ggplot(data = outliers_jan, aes(x = arl_hkt)) +
                                        geom_histogram(bins = 5) +
                                        ggtitle("Area (ha) of Outlier Plots (January)") +
                                        theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                              strip.text.x = element_text(size = 32),
                                              axis.text.x = element_text(size = 38, margin = margin(t=16)),
                                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                              axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                                              axis.title.y = element_text(size = 60, margin = margin(r=40)))
                                
                                dev.off()
                                
                                
                                #Volume/ha
                                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/albedo/outliers/outliers_jan_volume_hist.png",
                                    width = 2000,
                                    height = 2000,
                                    units = "px",
                                    bg = "white")
                                
                                ggplot(data = outliers_jan, aes(x = vuprha)) +
                                        geom_histogram(bins = 5) +
                                        ggtitle("Volume/ha of Outlier Plots (January)") +
                                        theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                              strip.text.x = element_text(size = 32),
                                              axis.text.x = element_text(size = 38, margin = margin(t=16)),
                                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                              axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                                              axis.title.y = element_text(size = 60, margin = margin(r=40)))
                                
                                dev.off()
                                
                                
                                #Spruce %
                                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/albedo/outliers/outliers_spruce_hist.png",
                                    width = 2000,
                                    height = 2000,
                                    units = "px",
                                    bg = "white")
                                
                                ggplot(data = outliers_jan, aes(x = grn_pct)) +
                                        geom_histogram() +
                                        ggtitle("% Spruce in Outlier Plots (January)") +
                                        theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                              strip.text.x = element_text(size = 32),
                                              axis.text.x = element_text(size = 38, margin = margin(t=16)),
                                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                              axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                                              axis.title.y = element_text(size = 60, margin = margin(r=40)))
                                
                                dev.off()
                                
                                #Pine %
                                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/albedo/outliers/outliers_pine_hist.png",
                                    width = 2000,
                                    height = 2000,
                                    units = "px",
                                    bg = "white")
                                
                                ggplot(data = outliers_jan, aes(x = fur_pct)) +
                                        geom_histogram() +
                                        ggtitle("% Pine in Outlier Plots (January)") +
                                        theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                              strip.text.x = element_text(size = 32),
                                              axis.text.x = element_text(size = 38, margin = margin(t=16)),
                                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                              axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                                              axis.title.y = element_text(size = 60, margin = margin(r=40)))
                                
                                dev.off()
                                
                                #Deciduous %
                                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/albedo/outliers/outliers_lauv_hist.png",
                                    width = 2000,
                                    height = 2000,
                                    units = "px",
                                    bg = "white")
                                
                                ggplot(data = outliers_jan, aes(x = lav_pct)) +
                                        geom_histogram() +
                                        ggtitle("% Deciduous in Outlier Plots (January)") +
                                        theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                              strip.text.x = element_text(size = 32),
                                              axis.text.x = element_text(size = 38, margin = margin(t=16)),
                                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                              axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                                              axis.title.y = element_text(size = 60, margin = margin(r=40)))
                                
                                dev.off()
                                
        
        #Albedo - Histogram by Month   
                                        
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/albedo/albedo_only/init_albedo_histogram.png",
                    width = 3000,
                    height = 2000,
                    units = "px",
                    bg = "white")
                                        
                ggplot(data = data_exp, aes(x = Albedo)) +
                        geom_histogram() +
                        facet_wrap(~ Month) +
                        ggtitle("Albedo in Selected Forest Plots (by Month)") +
                        theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                              strip.text.x = element_text(size = 32),
                              axis.text.x = element_text(size = 38, margin = margin(t=16)),
                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                              axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                              axis.title.y = element_text(size = 60, margin = margin(r=40)))
                
                dev.off()
        
        #Albedo - Boxplot (by Month)
                
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/albedo/albedo_only/init_albedo_boxplot.png",
                    width = 3000,
                    height = 2000,
                    units = "px",
                    bg = "white")
                
                data_exp$Month <- as.factor(data_exp$Month)                                
                ggplot(data = data_exp, aes(x = Month, y = Albedo)) +
                        geom_boxplot() +
                        ggtitle("Albedo in Selected Forest Plots (by Month)") +
                        theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                              axis.text.x = element_text(size = 38, margin = margin(t=16)),
                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                              axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                              axis.title.y = element_text(size = 60, margin = margin(r=40)))
                
                dev.off()
                                        

                                        
#END ALBEDO + OUTLIER INVESTIGATION --------------------------------------------------------------------------------------------------

                
                
                
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#PLOT RESULTS WITH OUTLIERS REMOVED --------------------------------------------------------------------------------------------------

        #REMOVE OUTLIERS from expanded df (for each month)
                
                no_outliers <- data_exp 
                
                for(i in 1:12){
                        
                        #Get IQR
                        iqr <- IQR(no_outliers$Albedo[no_outliers$Month == i], na.rm = T)
                        quant <- quantile(no_outliers$Albedo[no_outliers$Month == i], na.rm = T) 
                        
                        #Subtract outliers from main df
                        no_outliers <- no_outliers[ !( (no_outliers$Albedo > quant[4] + (1.5 * iqr) | no_outliers$Albedo < quant[2] - (1.5 * iqr) ) & no_outliers$Month == i ),]

                }
                
                beep(8)
                
        #PLOTS
                
                #Has mean line
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Initial_Visualization/albedo/outliers_removed/albedo_moose_density_no_outliers.png",
                    width = 3000,
                    height = 2000,
                    units = "px",
                    bg = "white")
                
                no_outliers <- no_outliers[!is.na(no_outliers$Month),]
                
                n_obs_no_outl <- nrow(no_outliers)
                
                ggplot(data = no_outliers, aes(x = Ms_Dnst, y = Albedo)) +
                        geom_bin2d(binwidth = c(5,0.025)) +
                        facet_wrap(~ Month) +
                        geom_smooth(colour = "red") +
                        scale_fill_gradientn(colours = myPalette(100)) +
                        ggtitle( paste("Moose Density vs. Albedo (by Month)\n(n = ", n_obs_no_outl, ")", sep = "" )) +
                        labs(x = "Moose Density (kg/km-2)", y = "Albedo") +
                        scale_y_continuous(limits = c(0.00, 1.00), breaks = c(0.00, 0.25, 0.50, 0.75, 1.00)) +
                        theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                              legend.title = element_text(size = 40),
                              legend.text = element_text(size = 36, margin = margin(t=16)),
                              strip.text.x = element_text(size = 32),
                              axis.text.x = element_text(size = 38, margin = margin(t=16)),
                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                              axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                              axis.title.y = element_text(size = 60, margin = margin(r=40)))
                
                dev.off()
                beep(8)

#END PLOT RESULTS WITH OUTLIERS REMOVED --------------------------------------------------------------------------------------------------
                
                
                
                