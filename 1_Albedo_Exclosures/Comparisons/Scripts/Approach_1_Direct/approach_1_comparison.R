##NOTE: This script is meant to directly compare Approach 1 with Approaches 2-3 
## It has the following steps:
##      - Identify SustHerb sites with (1) LiDAR data and (2) tree measurements (height + DGL) which 
##        MATCH the year of the LiDAR data (this allows for direct comparison of the allometric approach
##        with the LiDAR-based approaches)
##      - Calculate albedo measurements for each site 

##PACKAGES ----------------------------------------------------------------------------------------

        #Packages for general data manipulation + visualization
        library(ggplot2)
        library(ggpubr)
        library(dplyr)
        library(RColorBrewer)
        library(wesanderson)

###END PACKAGES ----------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#STEP 1 - IDENTIFY SITES WITH DETAILED TREE DATA WHICH MATCHES LIDAR YEAR ----------------------------------------------
## Ex. does 'bratsberg' have detailed tree data (DGL + height) for the same year in which LiDAR measurements were taken?

        #IMPORT DATA

                #Site Data
                site_data <- read.csv("1_Albedo_Exclosures/Data/SustHerb_Site_Data/cleaned_data/cleaned_data.csv", header = T)

                #Tree Species Data
                tree_data <- read.csv("1_Albedo_Exclosures/Data/Tree_Data/sustherb_tree_data.csv", header = T)
                
                        #Set date column to proper class
                        tree_data$X_Date <- as.Date(tree_data$X_Date, "%m/%d/%y")
                
        #IDENTIFY WHETHER DETAILED SITE DATA EXISTS FOR CORRESPONDING LIDAR YEAR
        
                #Blank vector to store usable LocalityCodes
                usable <- c()
                        
                #Loop through each site code
                for(i in 1:nrow(site_data)){
                        
                        print(i)
                        
                        #Get site code
                        sc <- site_data[i, "LocalityCode"]
                        
                        #Get LiDAR year
                        ly <- site_data[i, "LiDAR.data.from.year"]
                        
                        #Isolate tree data for site i to corresponding LiDAR year
                        df <- tree_data[tree_data$X_Date >= as.Date(paste(ly, "-01-01", sep = ""))
                                        & tree_data$X_Date <= as.Date(paste(ly, "-12-31", sep = ""))
                                        & tree_data$LocalityCode == sc,]
                        
                        #If df not empty and detailed DGL measurements exist (which allow use of allometric equations),
                        ## add LocalityCode to 'usable' vector
                        if( nrow(df) != 0 & !is.na(sum(df$Diameter_at_base_mm)) ){
                                
                                #Add LocalityCode to usable vector
                                usable <- c(usable, sc)
                        }
                }


#END STEP 1 -----------------------------------------------------------------------------------------------------------
        
        
        
        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

