##This script processes SatSkog data files and automates the creation of relevant sub-directories
## in the SatSkog data folder

#PACKAGES ----------------------------------------------------------------------

        #Data Manipulation
        library(dplyr)
        library(sf)


#END PACKAGES ----------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#CREATE DIRECTORIES ------------------------------------------------------------------------------

        #Import CSV w/ list of kommunes + associated IDs
        kommunes <- read.csv("/Volumes/JS_Ext_HD/kommune_ids.csv")
        
                #Fix lost leading 0 for Oslo
                kommunes$Kommune_Name <- as.character(kommunes$Kommune_Name)
                kommunes$ID[kommunes$Kommune_Name == "Oslo"] <- "0301"

        #Create a list of netCDF files (stored in directory of External HD)
        files <- list.files(path="2_Albedo_Regional/Data/Spatial_Data/SatSkog_Zips", pattern="*.zip", full.names=TRUE, recursive=FALSE)

        #Define function to get last n characters of a string (used in loop below)
        substrLeft <- function(x, n){
                substr(x, 1, n)
        }
        
        #Blank df to hold names of successfully added SatSkog kommunes (i.e. see what's missing)
        uploaded <- data.frame("Kommune_name" = character(), "Kommune_ID" = integer()) #All good
        
        #Loop through each zip file
        for(file in files){
                
                #Get Kommune ID from first 4 characters of zip file name
                
                        #Read in base file name        
                        basename <- tools::file_path_sans_ext(basename(file))
                        
                        #Get last 2 characters of filename string
                        kommune_id <- substrLeft(basename, 4)
                
                #Get corresponding Kommune name (from kommunes df)
                        
                        kommune_name <- kommunes$Kommune_Name[kommunes$ID == kommune_id]
                        
                #Create subdirectory w/ Kommune name in '2_Albedo_Regional/Data/Spatial_Data/SatSkog'
                        
                        #Define directory name
                        d <- paste("2_Albedo_Regional/Data/Spatial_Data/SatSkog", "/", kommune_name, sep = "")
                        dir.create(path = d)
                
                #Unzip the zip file into this subdirectory
                
                        unzip(zipfile = file, exdir = d)
                        
                #Unzip file
                unzip(file)
        
                
        }

#END CREATE DIRECTORIES ------------------------------------------------------------------------------