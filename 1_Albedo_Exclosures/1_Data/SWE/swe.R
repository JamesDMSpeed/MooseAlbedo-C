##Script to collect, format, and process spatial snow water equivalent data (SWE) for relevant SUSTHERB sites
####SWE historical time series for each site manually pulled from senorge.no 

##NOTE: This script is designed specifically to clean time series CSV files from senorge.no
######  It will not work with other data sources


##Load relevant packages
library(dplyr)
library(tidyr)
library(ggplot2)

#Get cleaned site data from adjacent 'Sites' folder and add as DF
site_data <- read.csv('1_Albedo_Exclosures/1_Data/Sites/cleaned_data/cleaned_data.csv', header = TRUE)

#Initialize blank data frame for storage of average SWE
avg_swe <- data.frame("Location" = character(), "Treatment" = factor(), "Month" = integer(),"Year" = integer(),"Avg_SWE_mm" = double())

#Loop through all SWE data files in 'senorge_data' folder
swe_files <- list.files(path="1_Albedo_Exclosures/1_Data/SWE/senorge_data", pattern="*.csv", full.names=TRUE, recursive=FALSE)

for(t in swe_files){
        
       
        #Get split filename w/o extension
        filename <- strsplit( sub( '.csv', '', basename(t) ), '-', fixed = FALSE)
        filename <- unlist(filename)
        
        #Pull variables from filename
        loc <- filename[1]
        treatment <- filename[2]
        
        #Get Year of LiDAR data from main site data (based on site name and treatment - contained within filename)
        lidar_year <- site_data$LiDAR.data.from.year[site_data$LocalityName == loc & site_data$Treatment == treatment]
        
        #Read in as data frame + clean up into usable format
        data <- read.csv(t, header = FALSE)
        data <- data[3:nrow(data),]
        data <-data.frame(data)
        
        #Separate values into distinct columns; filter down to relevant year (matches LiDAR data year)
        data <- as.data.frame(data) %>% separate(data, into = c('Day','Month','Year','Time','SWE'), sep = '[. ;]' )
        data <- data %>% filter(Year == lidar_year & is.na(SWE) == FALSE)
        data$Month <- as.numeric(as.character(data$Month))
        data$SWE <- as.numeric(as.character(data$SWE))
        data$Year <- as.numeric(as.character(data$Year))
        
        #Get monthly averages
        i <- as.numeric(1)
        while( i <= max(data$Month) ){
                
                #Get mean SWE for the month
                mean_swe <- mean(data$SWE[data$Month == i])
                
                #Append data to final avg SWE DF
                row <- data.frame("Location" = loc, "Treatment" = treatment, "Month" = i, "Year" = lidar_year, "Avg_SWE_mm" = mean_swe)
                avg_swe <- rbind(avg_swe, row)
                
                i = i+1
        }
        
}

##Write final CSV to directory
write.csv(avg_swe, file = '1_Albedo_Exclosures/1_Data/SWE/monthly_avg_swe_mm.csv', row.names = TRUE)
