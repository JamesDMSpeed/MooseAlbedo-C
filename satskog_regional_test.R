#Script to test spatial data from big processing loop
  
#Define kommune and desired month to view      
        kommune <- "Fitjar"
        month <- 1

#Import shapefile
        test <- st_read( paste("2_Albedo_Regional/Data/Spatial_Data/Output/", kommune, "/", kommune, "_processed.shp", sep = ""))
        test_sp <- as(test, Class = "Spatial")
        
#Plot
        spplot(test_sp[paste("Mnt_", month, "_A", sep = "")], main = paste(kommune, " - Month ", month, sep = ""), lwd = 0.5)
