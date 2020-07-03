##This script compares the final models that were used in each approach

##PACKAGES ----------------------------------------------------------------------------------------

        #Packages for general data manipulation + visualization
        library(ggplot2)
        library(XML)
        library(RColorBrewer)
        library(wesanderson)


###END PACKAGES ----------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#INITIAL DATA IMPORT ----------------------------------------------------------------------

        #Approach 1 output table
        table_1 <- data.frame(readHTMLTable('1_Albedo_Exclosures/Approach_1/Output/Model_Selection/best_model_approach_1.html'))
                
                #Get low & high CI values
                t1_ci <- table_1[3,3]
                
                        #For some reason, strsplit not working () - grab 'bad' values manually to split
                        bad <- substr(t1_ci, start = 9, stop = 11)
        
                #Split
                t1_ci <- strsplit(t1_ci, bad)
                t1_low <- t1_ci[[1]][1]
                t1_high <- t1_ci[[1]][2]
                        
                
        #Approach 2 output table
        table_2 <- data.frame(readHTMLTable('1_Albedo_Exclosures/Approach_2/Output/Model_Selection/best_model_approach_2.html'))
        
                #Get low & high CI values
                t2_ci <- table_2[3,3]
                
                #Split
                t2_ci <- strsplit(t2_ci, bad)
                t2_low <- t2_ci[[1]][1]
                t2_high <- t2_ci[[1]][2]
        
        #Approach 3 output table
        table_3 <- data.frame(readHTMLTable('1_Albedo_Exclosures/Approach_3/Output/Model_Selection/best_model_approach_3.html'))
        
                #Get low & high CI values
                t3_ci <- table_3[3,3]
                
                #Split
                t3_ci <- strsplit(t3_ci, bad)
                t3_low <- t3_ci[[1]][1]
                t3_high <- t3_ci[[1]][2]
                
        #Approach 4 output table
        table_4 <- data.frame(readHTMLTable('1_Albedo_Exclosures/Approach_4/Output/Model_Selection/best_model_approach_4.html'))
        
                #Get low & high CI values
                t4_ci <- table_4[3,3]
                
                #Split
                t4_ci <- strsplit(t4_ci, bad)
                t4_low <- t4_ci[[1]][1]
                t4_high <- t4_ci[[1]][2]
        

#END INITIAL DATA IMPORT ----------------------------------------------------------------------
        
        
        
        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#COMPARISONS --------------------------------------------------------------------------
        
        #Create effect size plot w/ CIs
        
                #Create vector of labels
                label <- c("Approach 1 Model\n'Allometric Approach'",
                           "Approach 2 Model\n'LiDAR Hull Approach'",
                           "Approach 3 Model\n'LiDAR CHM Approach'",
                           "Approach 4 Model\n'Age-based Approach'")
        
                #Create vector of means
                est  <- c(table_1[3,2], table_2[3,2], table_3[3,2], table_4[3,2]) 
                
                #Create vector of lower CI intervals
                lower <- c(t1_low, t2_low, t3_low, t4_low)
                
                #Create vector of higher CI intervals
                upper <- c(t1_high, t2_high, t3_high, t4_high)
        
                #Join into df
                df <- data.frame(label, est, lower, upper)
                df[,2] <- as.numeric(df[,2])
                df[,3] <- as.numeric(df[,3])
                df[,4] <- as.numeric(df[,4])
        
        # reverses the factor level ordering for labels after coord_flip()
        df$label <- factor(df$label, levels=rev(df$label))
        
        fp <- ggplot(data=df, aes(y=label, x=est, xmin=lower, xmax=upper)) +
                geom_pointrange(size = 2.7) + 
                geom_vline(xintercept=0, lty=2) +  # adds a dotted line at x=0
                ylab("Approach") + xlab("Estimated effect of exclosure on monthly albedo") +
                xlim(-0.027, 0.027) +
                theme_bw() +
                theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                      legend.title = element_text(size = 40),
                      legend.text = element_text(size = 36),
                      axis.text.x = element_text(size = 44, margin = margin(t=16)),
                      axis.text.y = element_text(size = 44, margin = margin(r=16)),
                      axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                      axis.title.y = element_text(size = 60, margin = margin(r=40)))
        print(fp)
        
        
#END COMPARISONS ----------------------------------------------------------------------

                                        
                                        
                                        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                                        
                                        
                                        
                                        
#WRITE OUTPUT --------------------------------------------------------------------------
       
        #Write forest plot to PNG
        
                png(filename = "1_Albedo_Exclosures/Comparisons/Output/Models/model_comparisons_effect_sizes.png",
                        width = 2500,
                        height = 2500,
                        units = "px",
                        bg = "white")
                        fp
                dev.off()
                
             
#END WRITE OUTPUT ----------------------------------------------------------------------
