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
                        col1_alt <- data.frame("Month" = approach1$Month, "LocalityCode" = approach1$LocalityCode, "Albedo" = approach1$Composite_Albedo, "Approach" = as.factor(1))
                        
                                #Version 2 alt
                                col1_alt_meta <- col1_alt
                                col1_alt_meta[nrow(col1_alt_meta) + 528,] <- NA
                              
                                  
                #Approach 2 Albedo Values
                        
                        #Version 1 (for ggplot scatterplots)
                        col2 <- data.frame("Approach_2_Albedo" = approach2$Composite_Albedo)
                        
                        #Version 2 (for time series)
                        col2_alt <- data.frame("Month" = approach2$Month, "LocalityCode" = approach2$LocalityCode, "Albedo" = approach2$Composite_Albedo, "Approach" = as.factor(2))
        
                        
                #Approach 3 Albedo Values
                        
                        #Version 1 (for ggplot scatterplots)
                        col3 <- data.frame("Approach_3_Albedo" = approach3$Composite_Albedo)
                
                        #Version 2 (for time series)
                        col3_alt <- data.frame("Month" = approach3$Month, "LocalityCode" = approach3$LocalityCode, "Albedo" = approach3$Composite_Albedo, "Approach" = as.factor(3))
                
                
                #Approach 4 Albedo Values
                        
                        #Version 1 (for ggplot scatterplots)
                        col4 <- data.frame("Approach_4_Albedo" = approach4$Composite_Albedo)
                        
                        #Version 2 (for time series)
                        col4_alt <- data.frame("Month" = approach4$Month, "LocalityCode" = approach4$LocalityCode, "Albedo" = approach4$Composite_Albedo, "Approach" = as.factor(4))
                        
#END DATA FORMATTING --------------------------------------------------------------------------------               
                        
                        
                        
                        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#COMPARISONS ---------------------------------------------------------------------------------------------             

        #ALL APPROACHES ----------------------------------------------------------------
                        
                #TIME SERIES
                        
                        #Bind relevant df's
                        ts_2_3_4 <- rbind(col2_alt, col3_alt, col4_alt)
                        
                        #Plot time series
                        plot_ts_2_3_4 <- ggplot(ts_2_3_4, aes(x = Month, y = Albedo, color = Approach)) +
                                geom_point(alpha = 0.3) + 
                                geom_jitter(alpha = 0.3) +
                                geom_smooth() +
                                scale_x_discrete(limits=c(1:12))
                        
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
                        
                #SCATTERPLOT
                        
                        #Correlation
                        cor.test(col2_alt$Albedo, col3_alt$Albedo)
                        
                        #Plot scatterplot
                                
                                #Bind relevant df's
                                cor_2_3 <- cbind(col2, col3)
                        
                                #Plot
                                plot_cor_2_3 <- ggscatter(cor_2_3, x = "Approach_2_Albedo", y = "Approach_3_Albedo") +
                                        stat_cor(
                                                aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~"))
                                        ) +
                                        geom_smooth(method = lm) +
                                        ggtitle("Approach 2 vs 3")

                
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
                        
                #SCATTERPLOT
                                
                        #Correlation
                        cor.test(col2_alt$Albedo, col4_alt$Albedo)
                                
                        #Plot scatterplot
                                
                                #Bind relevant df's
                                cor_2_4 <- cbind(col2, col4)
                                
                                #Plot
                                plot_cor_2_4 <- ggscatter(cor_2_4, x = "Approach_2_Albedo", y = "Approach_4_Albedo") +
                                                        stat_cor(
                                                                aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~"))
                                                        ) +
                                                        geom_smooth(method = lm) +
                                                        ggtitle("Approach 2 vs 4")
                
        
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
                
                #SCATTERPLOT
                
                        #Correlation
                        cor.test(col3_alt$Albedo, col4_alt$Albedo)
                
                        #Plot scatterplot
                
                                #Bind relevant df's
                                cor_3_4 <- cbind(col3, col4)
                                
                                #Plot
                                plot_cor_3_4 <- ggscatter(cor_3_4, x = "Approach_3_Albedo", y = "Approach_4_Albedo") +
                                        stat_cor(
                                                aes(label = paste(..rr.label.., ..p.label.., sep = "~`,`~"))
                                        ) +
                                        geom_smooth(method = lm) +
                                        ggtitle("Approach 3 vs 4")

#END COMPARISONS ----------------------------------------------------------------------
