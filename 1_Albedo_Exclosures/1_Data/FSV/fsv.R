##Script to collect, format, and process forest stand volume data (FSV) from existing
##SUSTHERB LiDAR data

#Load relevant packages
library(ggplot2)
library(dplyr)
library(lidR)


#Get site data from adjacent 'Sites' folder
site_data <- read.csv('1_Albedo_Exclosures/1_Data/Sites/snøan_site_data.csv', header = TRUE)


