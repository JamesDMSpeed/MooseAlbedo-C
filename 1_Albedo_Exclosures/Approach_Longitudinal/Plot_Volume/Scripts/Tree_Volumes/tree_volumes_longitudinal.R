## Script to calculate tree volumes for each relevant SustHerb site across all years

##PACKAGES ----------------------------------------------------------------------------------------

        #Packages for general data manipulation + visualization
        library(ggplot2)
        library(dplyr)
        library(RColorBrewer)
        library(wesanderson)
        library(sp)
        library(raster)
        library(GGally)
        library(lattice)


###END PACKAGES ----------------------------------------------------------------------------------------





#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#INITIAL DATA IMPORT + FORMATTING ----------------------------------------------------------------------

        ## SITE DATA
        
                #Get 'cleaned' site data from adjacent 'Sites' folder
                site_data <- read.csv('1_Albedo_Exclosures/Data/SustHerb_Site_Data/cleaned_data/cleaned_data.csv', header = TRUE)
                
        #TREE DATA
                
                #Tree density data for Trøndelag, Telemark, and Hedmark
                ##NOTE: THIS DATA IS CURRENTLY LIMITED TO 2018, SINCE ADDITIONAL SENORGE DATA NEEDS TO BE PULLED TO ALLOW ANALYSIS
                ## OF 2019 AND 2020
                
                        #Load CSV
                        tree_data <- read.csv('1_Albedo_Exclosures/Data/Tree_Data/sustherb_tree_data.csv', header = TRUE)
                        
                        #Set date column to proper class
                        tree_data$X_Date <- as.Date(tree_data$X_Date, "%m/%d/%y")
        
                        #Filter out unused SustHerb sites (which don't have available productivity data)
                
                                #Convert site codes to factors
                                tree_data$LocalityCode <- as.factor(tree_data$LocalityCode)
                                site_data$LocalityCode <- as.factor(site_data$LocalityCode)
                                
                                #Get vector of levels for sites that will be used (n = 74)
                                used_sites <- levels(site_data$LocalityCode)
                
                                #Filter tree data to used sites
                                tree_data <- tree_data[tree_data$LocalityCode %in% used_sites,]
                                tree_data$LocalityCode <- as.factor(as.character(tree_data$LocalityCode))
        
#END INITIAL DATA IMPORT + FORMATTING ----------------------------------------------------------------------
                                
                                
                                
                                
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                                
                                
                                
                                
#FILTER TO YEARS WHERE DETAILED DATA IS AVAILABLE ----------------------------------------------------------
                                
                                

#END FILTER TO YEARS WHERE DETAILED DATA IS AVAILABLE ----------------------------------------------------------
        
   