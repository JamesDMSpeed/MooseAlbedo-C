##Script to collect, format, and process spatial snow water equivalent data (SWE) for relevant SUSTHERB sites
####SWE historical time series for each site manually pulled from senorge.no 

##NOTE: This script is designed specifically to clean time series CSV files from senorge.no
######  It will not work with other data sources


##Load relevant packages
library(dplyr)
library(tidyr)
library(ggplot2)


#INITIAL DATA IMPORT --------------------------------------------------

        #Get cleaned site data from adjacent 'Sites' folder and add as DF
        site_data <- read.csv('1_Albedo_Exclosures/Data/SustHerb_Site_Data/cleaned_data/cleaned_data.csv', header = TRUE)
        
        #Load in SeNorge temp data from 'SeNorge_temp_swe_data' folder (2001-2019 data)
        senorge_swe <- read.csv('1_Albedo_Exclosures/Data/SeNorge/tro_hed_tel_utm33_2001_2019.csv', header = TRUE)
        
        #Filter down to relevant columns
        senorge_swe <- senorge_swe[,c(1,4,5,6,10)]
        
        #Load in SeNorge sites data from 'SeNorge_temp_swe_data' folder (Localities file)
        sites <- read.csv('1_Albedo_Exclosures/Data/SeNorge/tro_hed_tel_utm33_localities.csv', header = TRUE)
        
        #Initialize blank data frame for storage of average temps
        avg_swe <- data.frame("LocalityName" = character(), "Region" = character(), "LocalityCode" = character(), "FID" = character(), "Experiment" = character(), "Month" = integer(),"Year" = integer(),"SWE_mm" = double())

#END INITIAL DATA IMPORT --------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#DATA PROCESSING #1  --------------------------------------------------
##NOTE: This section of code produces monthly SWE averages for the years in which LiDAR data was obtained for corresponding sites.
##Ex. if Bratsberg's LiDAR data was obtained in 2016, then this code produces monthly SWE averages for Bratsberg in 2016.

i <- as.integer(0)
while ( i <= max(senorge_swe$trondelag_) ){
        
        #Get locality code from senorge site list
        localityCode <- as.character(sites$LocalityCode[sites$FID == i])
        
        #Get LiDAR data year for correct site (via locality code)
        lidarYear <- as.integer(site_data$LiDAR.data.from.year[site_data$LocalityCode == localityCode])
        
        #Do following steps ONLY if LiDAR year isn't empty (i.e. LiDAR exists for the site)
        if( length(lidarYear) > 0 ){
                
                #Create temporary dataframe to calculate mean temps
                temp_frame <- data.frame(senorge_swe[senorge_swe$trondelag_ == i & senorge_swe$X_Year == lidarYear,])
                
                #Calculate mean temps by month
                m <- as.numeric(1)
                while( m <= max(senorge_swe$X_Month) ){
                        
                        #Get mean temperature for the month
                        mean_swe <- mean(temp_frame$swe_mm[temp_frame$X_Month == m])
                        
                        #Round to 3 digits
                        mean_swe <- round(mean_swe, digits = 3)
                        
                        #Append data to final avg temp DF
                        loc <- as.character(sites$LocalityNa[sites$FID == i])
                        reg <- as.character(sites$Region[sites$FID == i])
                        exp <- as.character(sites$Experiment[sites$FID == i])
                        row <- data.frame("LocalityName" = loc,
                                          "Region" = reg,
                                          "LocalityCode" = localityCode,
                                          "FID" = i,
                                          "Experiment" = exp,
                                          "Month" = m,
                                          "Year" = lidarYear,
                                          "SWE_mm" = mean_swe)
                        
                        avg_swe <- rbind(avg_swe, row)
                        
                        #Iterate
                        m = m+1
                }
                
        }
        
        #Iterate
        i = i+1
        
}

#END OF DATA PROCESSING #1--------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#DATA PROCESSING #2  --------------------------------------------------
##NOTE: This section of code produces monthly SWE averages for each site and in all years starting with 2008 
##The output from this section can be used in the longitudinal analysis of albedo
        
        #Aggregate
        senorge_swe_2 <- aggregate(senorge_swe$swe_mm, by = list(Site = senorge_swe$trondelag_, Year = senorge_swe$X_Year, Month = senorge_swe$X_Month), FUN = mean)
        names(senorge_swe_2)[4] <- "SWE_mm"
        
        #Add placeholder columns
        senorge_swe_2$LocalityName <- ''
        senorge_swe_2$Region <- ''
        senorge_swe_2$LocalityCode <- ''

        #Loop through and add other data columns
        for(i in 1:nrow(senorge_swe_2)){
                
                #Get variables corresponding to FID code
                site <- senorge_swe_2[i, "Site"]
                loc <- as.character(sites$LocalityNa[sites$FID == site])
                reg <- as.character(sites$Region[sites$FID == site])
                code <- as.character(sites$LocalityCode[sites$FID == site])
                
                #Add variables to columns of row i
                senorge_swe_2[i, "LocalityName"] <- loc
                senorge_swe_2[i, "Region"] <- reg
                senorge_swe_2[i, "LocalityCode"] <- code

        }

#END OF DATA PROCESSING #2--------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#WRITE OUTPUT ------------------------------------------------------

        #Write Data Processing #1 to CSV
        write.csv(avg_swe, file = '1_Albedo_Exclosures/Universal/Output/SWE/monthly_avg_swe_mm.csv', row.names = TRUE)

        #Write Data Processing #2 to CSV
        write.csv(senorge_swe_2, file = '1_Albedo_Exclosures/Universal/Output/SWE/monthly_avg_swe_mm_all_years.csv', row.names = TRUE)

#END WRITE OUTPUT --------------------------------------------------

