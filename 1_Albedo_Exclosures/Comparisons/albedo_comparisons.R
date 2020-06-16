##This script compares albedo estimates produced by various
## used in this project

##PACKAGES ----------------------------------------------------------------------------------------

        #Packages for general data manipulation + visualization
        library(ggplot2)
        library(dplyr)
        library(RColorBrewer)
        library(wesanderson)

###END PACKAGES ----------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#INITIAL DATA IMPORT ----------------------------------------------------------------------

        #Approach 2
        approach2 <- read.csv('1_Albedo_Exclosures/Approach_2/Output/Albedo_Estimates/albedo_estimates_approach_2.csv', header = TRUE)

        #Approach 3
        approach3 <- read.csv('1_Albedo_Exclosures/Approach_3/Output/Albedo_Estimates/albedo_estimates_approach_3.csv', header = TRUE)

#END INITIAL DATA IMPORT ----------------------------------------------------------------------
        
        
        
        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#COMPARISONS ----------------------------------------------------------------------

        #Define columns
        
                #Site codes
                loc <- data.frame("LocalityCode" = approach2$LocalityCode)
        
                #Approach 2 Albedo Values
                col2 <- data.frame("Approach_2_Albedo" = approach2$Composite_Albedo)
        
                #Approach 3 Albedo Values
                col3 <- data.frame("Approach_3_Albedo" = approach3$Composite_Albedo)
        
        #Approach 2 + Approach 3

                #Create dataset for comparison
                comp2_3 <- cbind(loc, col2, col3)

                #Correlation
                cor.test(comp2_3$Approach_2_Albedo, comp2_3$Approach_3_Albedo)
                ggplot(comp2_3, aes(x = Approach_2_Albedo, y = Approach_3_Albedo)) +
                        geom_point() + 
                        geom_jitter(aes(colour=LocalityCode)) 
                
                        ##Appears as if Approach 2 produces albedo values that are much higher than Approach 3

                #Linear Regression
                lm2_3 <- lm(Approach_2_Albedo~Approach_3_Albedo, data = comp2_3)
                summary(lm2_3)

#END COMPARISONS ----------------------------------------------------------------------
