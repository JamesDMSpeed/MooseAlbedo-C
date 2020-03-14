#DATA_FUNCTIONS.R

## This document contains functions relevant to the 'data' folder of the albedo-exclosures portion of the project.
## ---------------------------------------------------------------------------------------------------------------


#Process SeNorge.no data
senorge <- function(var){
        
        #DATA LOADING --------------------------------------------------
        
        #Read in relevant site data
        site_data <- read.csv('1_Albedo_Exclosures/1_Data/Sites/cleaned_data/cleaned_data.csv', header = TRUE)
        return(site_data)
        
        #Load in SeNorge temp data from 'SeNorge_temp_swe_data' folder (2001+ file)
        senorge <- read.csv('1_Albedo_Exclosures/1_Data/SeNorge_temp_swe_data/tro_hed_tel_utm33_2001_2018.csv', header = TRUE)
        
        #Filter down to relevant columns
        senorge_data <- senorge[, c(1,4,5,6)]
        
        #Load in SeNorge sites data from 'SeNorge_temp_swe_data' folder (Localities file)
        sites <- read.csv('1_Albedo_Exclosures/1_Data/SeNorge_temp_swe_data/tro_hed_tel_utm33_localities.csv', header = TRUE)
        
        #Initialize blank data frame for storage of average temps
        avg_temps <- data.frame("LocalityName" = character(), "Region" = character(), "LocalityCode" = character(), "FID" = character(), "Experiment" = character(), "Month" = integer(),"Year" = integer(),"Avg_Temp_C" = double())
        
        #END OF DATA LOADING --------------------------------------------------
        
}
