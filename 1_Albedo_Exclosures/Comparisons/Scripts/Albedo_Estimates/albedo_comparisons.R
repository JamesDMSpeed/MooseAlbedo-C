##This script compares albedo estimates produced by various
## used in this project

##PACKAGES ----------------------------------------------------------------------------------------

        #Packages for general data manipulation + visualization
        library(ggplot2)
        library(ggpubr)
        library(dplyr)
        library(RColorBrewer)
        library(wesanderson)

###END PACKAGES ----------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#INITIAL DATA IMPORT ----------------------------------------------------------------------

        #Approach 1
        approach1 <- read.csv('1_Albedo_Exclosures/Approach_1/Output/Albedo_Estimates/albedo_estimates_approach_1.csv', header = TRUE)

        #Approach 2
        approach2 <- read.csv('1_Albedo_Exclosures/Approach_2/Output/Albedo_Estimates/albedo_estimates_approach_2.csv', header = TRUE)

        #Approach 3
        approach3 <- read.csv('1_Albedo_Exclosures/Approach_3/Output/Albedo_Estimates/albedo_estimates_approach_3.csv', header = TRUE)

        #Approach 4
        approach4 <- read.csv('1_Albedo_Exclosures/Approach_4/Output/Albedo_Estimates/albedo_estimates_approach_4.csv', header = TRUE)
        
#END INITIAL DATA IMPORT ----------------------------------------------------------------------
        
        
        
        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#DATA FORMATTING --------------------------------------------------------------------------------

        #Define columns
        
                #Site codes
                loc <- data.frame("LocalityCode" = approach2$LocalityCode)
        
                #Approach 1 Albedo Values
        
                        #Version 1 (for ggplot scatterplots)
                        col1 <- data.frame("Approach_1_Albedo" = approach1$Composite_Albedo)
                        
                                #Create 'meta' col1 w/ 888 rows (to join with other datasets)
                                col1meta <- col1
                                col1meta[nrow(col1meta)+528,] <- NA
                                
                        #Version 2 (for time series)
                        col1_alt <- data.frame("Month" = approach1$Month, "Region" = approach1$Region, "LocalityCode" = approach1$LocalityCode, "Albedo" = approach1$Composite_Albedo, "Approach" = as.factor(1))
                        
                                #Version 2 alt
                                col1_alt_meta <- col1_alt
                                col1_alt_meta[nrow(col1_alt_meta) + 528,] <- NA
                              
                                  
                #Approach 2 Albedo Values
                        
                        #Version 1 (for ggplot scatterplots)
                        col2 <- data.frame("Approach_2_Albedo" = approach2$Composite_Albedo)
                        
                        #Version 2 (for time series)
                        col2_alt <- data.frame("Month" = approach2$Month, "Region" = approach2$Region, "LocalityCode" = approach2$LocalityCode, "Albedo" = approach2$Composite_Albedo, "Approach" = as.factor(2))
        
                        
                #Approach 3 Albedo Values
                        
                        #Version 1 (for ggplot scatterplots)
                        col3 <- data.frame("Approach_3_Albedo" = approach3$Composite_Albedo)
                
                        #Version 2 (for time series)
                        col3_alt <- data.frame("Month" = approach3$Month, "Region" = approach3$Region, "LocalityCode" = approach3$LocalityCode, "Albedo" = approach3$Composite_Albedo, "Approach" = as.factor(3))
                
                
                #Approach 4 Albedo Values
                        
                        #Version 1 (for ggplot scatterplots)
                        col4 <- data.frame("Approach_4_Albedo" = approach4$Composite_Albedo)
                        
                        #Version 2 (for time series)
                        col4_alt <- data.frame("Month" = approach4$Month, "Region" = approach4$Region, "LocalityCode" = approach4$LocalityCode, "Albedo" = approach4$Composite_Albedo, "Approach" = as.factor(4))
                        
#END DATA FORMATTING --------------------------------------------------------------------------------               
                        
                        
                        
                        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#COMPARISONS ---------------------------------------------------------------------------------------------             

        #ALL APPROACHES ----------------------------------------------------------------
                        
                #TIME SERIES
                        
                        #APPROACHES 2-4
                        
                                #Bind relevant df's
                                ts_2_3_4 <- rbind(col2_alt, col3_alt, col4_alt)
                                
                                #Plot time series
                                plot_ts_2_3_4 <- ggplot(ts_2_3_4, aes(x = Month, y = Albedo, color = Approach)) +
                                        geom_point(alpha = 0.3, size = 3) + 
                                        geom_jitter(alpha = 0.3, size = 3) +
                                        geom_smooth(size = 3) +
                                        scale_x_discrete(limits=c(1:12)) +
                                        ggtitle("Monthly albedo grouped by approach\n(Approaches 2-4)") +
                                        theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                              legend.title = element_text(size = 40),
                                              legend.text = element_text(size = 36),
                                              axis.text.x = element_text(size = 44, margin = margin(t=16)),
                                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                              axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                                              axis.title.y = element_text(size = 60, margin = margin(r=40)))
                                
                                plot_ts_2_3_4
                        
                        
        #APPROACH 2 + 3 ----------------------------------------------------------------
                        
                #TIME SERIES
                        
                        #Bind relevant df's
                        ts_2_3 <- rbind(col2_alt, col3_alt)
                        
                        #Plot time series
                        plot_ts_2_3 <- ggplot(ts_2_3, aes(x = Month, y = Albedo, color = Approach)) +
                                                geom_point(alpha = 0.3) + 
                                                geom_jitter(alpha = 0.3) +
                                                geom_smooth() +
                                                scale_x_discrete(limits=c(1:12))
                        plot_ts_2_3
                        
                #SCATTERPLOT
                        
                        #Correlation
                        cor.test(col2_alt$Albedo, col3_alt$Albedo)
                        
                        #Plot scatterplot
                                
                                #Bind relevant df's
                                cor_2_3 <- cbind(col2, col3)
                        
                                #Plot
                                plot_cor_2_3 <- ggscatter(cor_2_3, x = "Approach_2_Albedo", y = "Approach_3_Albedo") +
                                        stat_cor( aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")), size = 18 ) +
                                        geom_smooth(method = lm, size = 4) +
                                        ggtitle("Approach 2 vs 3") +
                                        labs(x = "Approach 2 Albedo", y = "Approach 3 Albedo") +
                                        theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                              legend.title = element_text(size = 40),
                                              legend.text = element_text(size = 36),
                                              axis.text.x = element_text(size = 44, margin = margin(t=16)),
                                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                              axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                                              axis.title.y = element_text(size = 60, margin = margin(r=40)))
                                
                                
                                plot_cor_2_3

                
        #APPROACH 2 + 4 ----------------------------------------------------------------
                
                #TIME SERIES
                                
                        #Bind relevant df's
                        ts_2_4 <- rbind(col2_alt, col4_alt)
                        
                        #Plot time series
                        plot_ts_2_4 <- ggplot(ts_2_4, aes(x = Month, y = Albedo, color = Approach)) +
                                geom_point(alpha = 0.3) + 
                                geom_jitter(alpha = 0.3) +
                                geom_smooth() +
                                scale_x_discrete(limits=c(1:12))  
                        plot_ts_2_4
                        
                #SCATTERPLOT
                                
                        #Correlation
                        cor.test(col2_alt$Albedo, col4_alt$Albedo)
                                
                        #Plot scatterplot
                                
                                #Bind relevant df's
                                cor_2_4 <- cbind(col2, col4)
                                
                                #Plot
                                plot_cor_2_4 <- ggscatter(cor_2_4, x = "Approach_2_Albedo", y = "Approach_4_Albedo") +
                                        stat_cor( aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")), size = 18 ) +
                                        geom_smooth(method = lm, size = 4) +
                                        ggtitle("Approach 2 vs 4") +
                                        labs(x = "Approach 2 Albedo", y = "Approach 4 Albedo") +
                                        theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                              legend.title = element_text(size = 40),
                                              legend.text = element_text(size = 36),
                                              axis.text.x = element_text(size = 44, margin = margin(t=16)),
                                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                              axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                                              axis.title.y = element_text(size = 60, margin = margin(r=40)))
                                plot_cor_2_4
                
        
        #APPROACH 3 + 4 ----------------------------------------------------------------
                
                #TIME SERIES
                
                        #Bind relevant df's
                        ts_3_4 <- rbind(col3_alt, col4_alt)
                
                        #Plot time series
                        plot_ts_3_4 <- ggplot(ts_3_4, aes(x = Month, y = Albedo, color = Approach)) +
                                geom_point(alpha = 0.3) + 
                                geom_jitter(alpha = 0.3) +
                                geom_smooth() +
                                scale_x_discrete(limits=c(1:12))
                        plot_ts_3_4
                
                #SCATTERPLOT
                
                        #Correlation
                        cor.test(col3_alt$Albedo, col4_alt$Albedo)
                
                        #Plot scatterplot
                
                                #Bind relevant df's
                                cor_3_4 <- cbind(col3, col4)
                                
                                #Plot
                                plot_cor_3_4 <- ggscatter(cor_3_4, x = "Approach_3_Albedo", y = "Approach_4_Albedo") +
                                        stat_cor( aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")), size = 18 ) +
                                        geom_smooth(method = lm, size = 4) +
                                        ggtitle("Approach 3 vs 4") +
                                        labs(x = "Approach 3 Albedo", y = "Approach 4 Albedo") +
                                        theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                              legend.title = element_text(size = 40),
                                              legend.text = element_text(size = 36),
                                              axis.text.x = element_text(size = 44, margin = margin(t=16)),
                                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                              axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                                              axis.title.y = element_text(size = 60, margin = margin(r=40)))
                                plot_cor_3_4
                                
        
        ##TRØNDELAG ONLY (TO ALLOW COMPARISONS OF APPROACH 1 WITH 2, 3, & 4)-------------------------------------------- 
                                
                ##APPROACH 1 + 2 ----------------------------------------------------------------
                                        
                        #TIME SERIES
                        
                                #Bind relevant df's
                                ts_1_2 <- rbind(col1_alt, col2_alt[col2_alt$Region == "trondelag",])
                                
                                #Plot time series
                                plot_ts_1_2 <- ggplot(ts_1_2, aes(x = Month, y = Albedo, color = Approach)) +
                                        geom_point(alpha = 0.3) + 
                                        geom_jitter(alpha = 0.3) +
                                        geom_smooth() +
                                        scale_x_discrete(limits=c(1:12))
                                plot_ts_1_2
                        
                        #SCATTERPLOT
                        
                                #Correlation
                                cor.test(col1_alt$Albedo, col2_alt$Albedo[col2_alt$Region == "trondelag"])
                                
                                #Plot scatterplot
                        
                                        #Bind relevant df's
                                        cor_1_2 <- data.frame(cbind(col1_alt$Albedo, col2_alt$Albedo[col2_alt$Region == "trondelag"]))
                                        colnames(cor_1_2) <- c("Approach_1_Albedo", "Approach_2_Albedo")
                                        
                                        #Plot
                                        plot_cor_1_2 <- ggscatter(cor_1_2, x = "Approach_1_Albedo", y = "Approach_2_Albedo") +
                                                stat_cor( aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")), size = 18 ) +
                                                geom_smooth(method = lm, size = 4) +
                                                ggtitle("Approach 1 vs 2 (Trøndelag only)") +
                                                labs(x = "Approach 1 Albedo", y = "Approach 2 Albedo") +
                                                theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                                      legend.title = element_text(size = 40),
                                                      legend.text = element_text(size = 36),
                                                      axis.text.x = element_text(size = 44, margin = margin(t=16)),
                                                      axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                                      axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                                                      axis.title.y = element_text(size = 60, margin = margin(r=40)))
                                        plot_cor_1_2
                                        
                ##APPROACH 1 + 3 ----------------------------------------------------------------
                                        
                        #TIME SERIES
                        
                                #Bind relevant df's
                                ts_1_3 <- rbind(col1_alt, col3_alt[col3_alt$Region == "trondelag",])
                                
                                #Plot time series
                                plot_ts_1_3 <- ggplot(ts_1_3, aes(x = Month, y = Albedo, color = Approach)) +
                                        geom_point(alpha = 0.3) + 
                                        geom_jitter(alpha = 0.3) +
                                        geom_smooth() +
                                        scale_x_discrete(limits=c(1:12))
                                plot_ts_1_3
                        
                        #SCATTERPLOT
                        
                                #Correlation
                                cor.test(col1_alt$Albedo, col3_alt$Albedo[col3_alt$Region == "trondelag"])
                                
                                #Plot scatterplot
                                
                                        #Bind relevant df's
                                        cor_1_3 <- data.frame(cbind(col1_alt$Albedo, col3_alt$Albedo[col3_alt$Region == "trondelag"]))
                                        colnames(cor_1_3) <- c("Approach_1_Albedo", "Approach_3_Albedo")
                                        
                                        #Plot
                                        plot_cor_1_3 <- ggscatter(cor_1_3, x = "Approach_1_Albedo", y = "Approach_3_Albedo") +
                                                stat_cor( aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")), size = 18 ) +
                                                geom_smooth(method = lm, size = 4) +
                                                ggtitle("Approach 1 vs 3 (Trøndelag only)") +
                                                labs(x = "Approach 1 Albedo", y = "Approach 3 Albedo") +
                                                theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                                      legend.title = element_text(size = 40),
                                                      legend.text = element_text(size = 36),
                                                      axis.text.x = element_text(size = 44, margin = margin(t=16)),
                                                      axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                                      axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                                                      axis.title.y = element_text(size = 60, margin = margin(r=40)))
                                        plot_cor_1_3
                                        
                ##APPROACH 1 + 4 ----------------------------------------------------------------
                
                        #TIME SERIES
                        
                                #Bind relevant df's
                                ts_1_4 <- rbind(col1_alt, col4_alt[col4_alt$Region == "trondelag",])
                                
                                #Plot time series
                                plot_ts_1_4 <- ggplot(ts_1_4, aes(x = Month, y = Albedo, color = Approach)) +
                                        geom_point(alpha = 0.3) + 
                                        geom_jitter(alpha = 0.3) +
                                        geom_smooth() +
                                        scale_x_discrete(limits=c(1:12))
                                plot_ts_1_4
                                
                        #SCATTERPLOT
                        
                                #Correlation
                                cor.test(col1_alt$Albedo, col4_alt$Albedo[col4_alt$Region == "trondelag"])
                                
                                #Plot scatterplot
                                
                                        #Bind relevant df's
                                        cor_1_4 <- data.frame(cbind(col1_alt$Albedo, col4_alt$Albedo[col4_alt$Region == "trondelag"]))
                                        colnames(cor_1_4) <- c("Approach_1_Albedo", "Approach_4_Albedo")
                                        
                                        #Plot
                                        plot_cor_1_4 <- ggscatter(cor_1_4, x = "Approach_1_Albedo", y = "Approach_4_Albedo") +
                                                stat_cor( aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~")), size = 18 ) +
                                                geom_smooth(method = lm, size = 4) +
                                                ggtitle("Approach 1 vs 4 (Trøndelag only)") +
                                                labs(x = "Approach 1 Albedo", y = "Approach 4 Albedo") +
                                                theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                                      legend.title = element_text(size = 40),
                                                      legend.text = element_text(size = 36),
                                                      axis.text.x = element_text(size = 44, margin = margin(t=16)),
                                                      axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                                      axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                                                      axis.title.y = element_text(size = 60, margin = margin(r=40)))
                                        plot_cor_1_4


#END COMPARISONS ----------------------------------------------------------------------

                                        
                                        
                                        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                                        
                                        
                                        
                                        
#WRITE OUTPUT --------------------------------------------------------------------------
       
        #Time Series
        
                #Approaches 2-4
                png(filename = "1_Albedo_Exclosures/Comparisons/Output/Albedo_Estimates/Time_Series/time_series_2_3_4.png",
                        width = 2500,
                        height = 2000,
                        units = "px",
                        bg = "white")
                        plot_ts_2_3_4
                dev.off()
                
        #Scatterplots
                
                #2 vs 3
                png(filename = "1_Albedo_Exclosures/Comparisons/Output/Albedo_Estimates/Scatterplots/approach_2_vs_3.png",
                    width = 2500,
                    height = 2000,
                    units = "px",
                    bg = "white")
                plot_cor_2_3
                dev.off()
                
                #2 vs 4
                png(filename = "1_Albedo_Exclosures/Comparisons/Output/Albedo_Estimates/Scatterplots/approach_2_vs_4.png",
                    width = 2500,
                    height = 2000,
                    units = "px",
                    bg = "white")
                plot_cor_2_4
                dev.off()
                
                #3 vs 4
                png(filename = "1_Albedo_Exclosures/Comparisons/Output/Albedo_Estimates/Scatterplots/approach_3_vs_4.png",
                    width = 2500,
                    height = 2000,
                    units = "px",
                    bg = "white")
                plot_cor_3_4
                dev.off()
                
        #Trøndelag-only scatterplots (to include Approach 1)
                
                #1 vs 2
                png(filename = "1_Albedo_Exclosures/Comparisons/Output/Albedo_Estimates/Scatterplots/approach_1_vs_2_trondelag.png",
                    width = 2500,
                    height = 2000,
                    units = "px",
                    bg = "white")
                plot_cor_1_2
                dev.off()
                
                #1 vs 3
                png(filename = "1_Albedo_Exclosures/Comparisons/Output/Albedo_Estimates/Scatterplots/approach_1_vs_3_trondelag.png",
                    width = 2500,
                    height = 2000,
                    units = "px",
                    bg = "white")
                plot_cor_1_3
                dev.off()
                
                #1 vs 4
                png(filename = "1_Albedo_Exclosures/Comparisons/Output/Albedo_Estimates/Scatterplots/approach_1_vs_4_trondelag.png",
                    width = 2500,
                    height = 2000,
                    units = "px",
                    bg = "white")
                plot_cor_1_4
                dev.off()
                                        
#END WRITE OUTPUT ----------------------------------------------------------------------
