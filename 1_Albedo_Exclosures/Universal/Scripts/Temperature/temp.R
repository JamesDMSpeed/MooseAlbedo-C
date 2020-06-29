##Script to collect, format, and process spatial temperature data (T) for relevant SUSTHERB sites
####T historical time series for each site manually pulled from senorge.no 

##NOTE: This script is designed specifically to clean time series CSV files from senorge.no
## (specifically, the datasets contained within the 'SeNorge_temp_swe_data' folder)


##Load relevant packages
library(dplyr)
library(tidyr)
library(ggplot2)

##Source functions file
#source('1_Albedo_Exclosures/1_Data/data_functions.R')


#INITIAL DATA IMPORT --------------------------------------------------

        #Get cleaned site data from adjacent 'Sites' folder and add as DF
        site_data <- read.csv('1_Albedo_Exclosures/Data/SustHerb_Site_Data/cleaned_data/cleaned_data.csv', header = TRUE)
        
        #Load in SeNorge temp data from 'SeNorge_temp_swe_data' folder (2001+ file)
        senorge_temps <- read.csv('1_Albedo_Exclosures/Data/SeNorge/tro_hed_tel_utm33_2001_2018.csv', header = TRUE)
        
                #Filter down to relevant columns
                senorge_temps <- senorge_temps[,c(1,4,5,6,8)]
        
        #Load in SeNorge sites data from 'SeNorge_temp_swe_data' folder (Localities file)
        sites <- read.csv('1_Albedo_Exclosures/Data/SeNorge/tro_hed_tel_utm33_localities.csv', header = TRUE)
        
        #Initialize blank data frame for storage of average temps
        avg_temps <- data.frame("LocalityName" = character(), "Region" = character(), "LocalityCode" = character(), "FID" = character(), "Experiment" = character(), "Month" = integer(),"Year" = integer(),"Avg_Temp_C" = double())

#END INITIAL DATA IMPORT --------------------------------------------------
        
        
        
        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        
        
        
        
#DATA PROCESSING #1 --------------------------------------------------
##NOTE: This section of code produces monthly temperature averages for the years in which LiDAR data was obtained for corresponding sites.
##Ex. if Bratsberg's LiDAR data was obtained in 2016, then this code produces monthly temp averages for Bratsberg in 2016.
        
i <- as.integer(0)
while ( i <= max(senorge_temps$trondelag_) ){
        
        #Get locality code from senorge site list
        localityCode <- as.character(sites$LocalityCode[sites$FID == i])
        
        #Get LiDAR data year for correct site (via locality code)
        lidarYear <- as.integer(site_data$LiDAR.data.from.year[site_data$LocalityCode == localityCode])
        
        #Do following steps ONLY if LiDAR year isn't empty (i.e. LiDAR exists for the site)
        if( length(lidarYear) > 0 ){
        
                #Create temporary dataframe to calculate mean temps
                temp_frame <- data.frame(senorge_temps[senorge_temps$trondelag_ == i & senorge_temps$X_Year == lidarYear,])
                
                #Calculate mean temps by month
                m <- as.numeric(1)
                while( m <= max(senorge_temps$X_Month) ){
                        
                        #Get mean temperature for the month
                        mean_t <- mean(temp_frame$tm_celsius[temp_frame$X_Month == m])
                        
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
                                          "Avg_Temp_C" = mean_t)
                        
                        avg_temps <- rbind(avg_temps, row)
                        
                        #Iterate
                        m = m+1
                }
                
        }
                
        #Iterate
        i = i+1
        
}

#END DATA PROCESSING #1 --------------------------------------------------
        
        
        
        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        
        
        
        
#DATA PROCESSING #2  --------------------------------------------------
##NOTE: This section of code produces monthly temp averages for each site and in all years starting with 2008 
##The output from this section can be used in the longitudinal analysis of albedo
        
        #Aggregate
        senorge_temps_2 <- aggregate(senorge_temps$tm_celsius, by = list(Site = senorge_temps$trondelag_, Year = senorge_temps$X_Year, Month = senorge_temps$X_Month), FUN = mean)
        names(senorge_temps_2)[4] <- "Avg_Temp_C"
        
        #Add placeholder columns
        senorge_temps_2$LocalityName <- ''
        senorge_temps_2$Region <- ''
        senorge_temps_2$LocalityCode <- ''
        
        #Loop through and add other data columns
        for(i in 1:nrow(senorge_temps_2)){
                
                #Get variables corresponding to FID code
                site <- senorge_temps_2[i, "Site"]
                loc <- as.character(sites$LocalityNa[sites$FID == site])
                reg <- as.character(sites$Region[sites$FID == site])
                code <- as.character(sites$LocalityCode[sites$FID == site])
                
                #Add variables to columns of row i
                senorge_temps_2[i, "LocalityName"] <- loc
                senorge_temps_2[i, "Region"] <- reg
                senorge_temps_2[i, "LocalityCode"] <- code
                
        }
        
#END OF DATA PROCESSING #2--------------------------------------------------        
       
         
        
        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        
        
        
        
#WRITE OUTPUT --------------------------------------------------
        
        #Write Data Processing #1 to CSV
        write.csv(avg_temps, file = '1_Albedo_Exclosures/Universal/Output/Temperature/monthly_avg_temp_C.csv', row.names = TRUE)
        
        #Write Data Processing #1 to CSV
        write.csv(senorge_temps_2, file = '1_Albedo_Exclosures/Universal/Output/Temperature/monthly_avg_temp_C_all_years.csv', row.names = TRUE)

#END WRITE OUTPUT --------------------------------------------------

