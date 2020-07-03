##This script compares the final models that were used in each approach

##PACKAGES ----------------------------------------------------------------------------------------

        #Packages for general data manipulation + visualization
        library(ggplot2)
        library(ggpubr)
        library(dplyr)
        library(RColorBrewer)
        library(wesanderson)
        library(plotly)
        library(XML)

###END PACKAGES ----------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#INITIAL DATA IMPORT ----------------------------------------------------------------------

        #Approach 1 output table
        table_1 <- data.frame(readHTMLTable('1_Albedo_Exclosures/Approach_1/Output/Model_Selection/best_model_approach_1.html'))
                
        #Approach 2 output table
        table_2 <- data.frame(readHTMLTable('1_Albedo_Exclosures/Approach_2/Output/Model_Selection/best_model_approach_2.html'))
        
        #Approach 3 output table
        table_3 <- data.frame(readHTMLTable('1_Albedo_Exclosures/Approach_3/Output/Model_Selection/best_model_approach_3.html'))
        
        #Approach 4 output table
        table_4 <- data.frame(readHTMLTable('1_Albedo_Exclosures/Approach_4/Output/Model_Selection/best_model_approach_4.html'))
        

#END INITIAL DATA IMPORT ----------------------------------------------------------------------
        
        
        
        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#COMPARISONS -------------------------------------------------------------------------
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
                
        #Albedo Differences
                
                #2 vs 3
                png(filename = "1_Albedo_Exclosures/Comparisons/Output/Albedo_Estimates/Differences/diff_approach_2_vs_3.png",
                    width = 2500,
                    height = 2000,
                    units = "px",
                    bg = "white")
                plot_d_2_3
                dev.off()
                
                #2 vs 4
                png(filename = "1_Albedo_Exclosures/Comparisons/Output/Albedo_Estimates/Differences/diff_approach_2_vs_4.png",
                    width = 2500,
                    height = 2000,
                    units = "px",
                    bg = "white")
                plot_d_2_4
                dev.off()
                
                #3 vs 4
                png(filename = "1_Albedo_Exclosures/Comparisons/Output/Albedo_Estimates/Differences/diff_approach_3_vs_4.png",
                    width = 2500,
                    height = 2000,
                    units = "px",
                    bg = "white")
                plot_d_3_4
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
