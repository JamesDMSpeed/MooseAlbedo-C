## This script produces the output (CSV + plots) for the FINAL DATASET used in the exclosures approach.
## As discussed, we will only use the 15 plots for which we have detailed tree data in 2016 (Trøndelag).


##PACKAGES ----------------------------------------------------------------------------------------

        #Packages
        library(ggplot2)
        library(dplyr)
        library(RColorBrewer)
        library(wesanderson)
        library(GGally)


###END PACKAGES ----------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#INITIAL DATA IMPORT ----------------------------------------------------------------------

        ## ALBEDO ESTIMATES -------
        
                #Get CSV of albedo estimates
                model_data <- read.csv('1_Albedo_Exclosures/Approach_1/Output/Albedo_Estimates/albedo_estimates_approach_1.csv', header = TRUE)
                
                #Format columns
                model_data$Month <- as.factor(model_data$Month)
                model_data$Treatment <- as.factor(model_data$Treatment)
                model_data$LocalityCode <- as.factor(model_data$LocalityCode)
                model_data$LocalityName <- as.factor(model_data$LocalityName)
                
                #Remove first column w/ indices
                model_data <- model_data[,2:16]
                
        ## SITE DATA
                
#END INITIAL DATA IMPORT ----------------------------------------------------------------------
                
                
                
                
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#DATA FORMATTING ----------------------------------------------------------------------                

        #ADD SITE DATA --------
                
                
        
                        
#END DATA FORMATTING ----------------------------------------------------------------------