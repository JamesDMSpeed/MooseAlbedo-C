## This is a script to identify/create three regions of SatSkog data for comparison of trends in moose data

# Per the last meeting, this will substitute for the clustering approaches previously attempted


#PACKAGES ----------------------------------------------------------------------

        #Spatial Data Packages
        library(sf)
        
        #Data Manipulation + Visualization
        library(ggplot2)
        library(raster)
        library(lattice)
        library(dplyr)
        library(wesanderson)
        library(beepr)
        library(zoo)
        
        
        #Define beepr path
        b <- "4_Misc/beepr_sound.wav"


#END PACKAGES ----------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#IMPORT  --------------------------------------------------------------------------------------------------

        #SATSKOG ALBEDO DATASET ----------
        
                #Load unified & FILTERED shapefile w/ all variables (from all years)
                data <- st_read("2_Albedo_Regional/Data/Final_Shapefile/Output/attempt_3/all_data/corrected_shapefile.shp")
                beep(b)
                
                #What years of data are there?
                data$Snrg_yr <- as.factor(data$Snrg_yr)
                years <- levels(data$Snrg_yr) #Data from 1999, 2000, 2001, 2002, 2004, and 2007
                
                #Plot by years
                ggplot() +
                        geom_sf(data = data, aes(fill = Snrg_yr, color = Snrg_yr), lwd = 0.1) +
                        ggtitle("Data by SatSkog Photo Year")
                beep(b)
                        
                        #Which years do I need to keep? Should I keep all years?
                
                        ## LOOKS like I definitely need to use 2007 data (Hedmark) and 1999 data
                        ## (Central + Southern Norway). Should probably include 2004 data (central Norway)
                
                #Remove duplicate geometries
                data <- distinct(data, .keep_all = T)
                beep(b)
                
                #Filter to 1999, 2004, and 2007 for further analysis
                data_filt <- data[data$Snrg_yr %in% c(1999, 2004, 2007),]
                
                        #Plot filtered data for verification
                        ggplot() +
                                geom_sf(data = data_filt, aes(fill = Snrg_yr, color = Snrg_yr), lwd = 0.1) +
                                coord_sf(datum = st_crs(data_filt)) +
                                ggtitle("Data by SatSkog Photo Year\n(Filtered to 1999, 2004, & 2007)")
                        beep(b)
                        
                #Plot by moose density
                ggplot() +
                        geom_sf(data = data_filt, aes(fill = Ms_Dnst, color = Ms_Dnst), lwd = 0.1) +
                        coord_sf(datum = st_crs(data_filt)) +
                        ggtitle("Filtered Satskog Data (1999, 2004, & 2007)\nMoose Density (kg/km2)")
                beep(b)
                
#END IMPORT DATA ----------------------------------------------------------------------------------
                
                
                
                
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                
                
                
                
#RE-CALCULATE ALBEDO FOR EACH OBSERVATION IN PLOTS ----------------------------------------------------------------------

        #BIRCH ALBEDO (Months 1-12)
                
                data_filt$M_1_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_1 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_1 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_1))
                data_filt$M_2_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_2 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_2 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_2))
                data_filt$M_3_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_3 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_3 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_3))
                data_filt$M_4_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_4 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_4 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_4))
                data_filt$M_5_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_5 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_5 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_5))
                data_filt$M_6_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_6 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_6 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_6))
                data_filt$M_7_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_7 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_7 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_7))
                data_filt$M_8_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_8 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_8 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_8))
                data_filt$M_9_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_9 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_9 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_9))
                data_filt$M_10_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_10 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_10 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_10))
                data_filt$M_11_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_11 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_11 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_11))
                data_filt$M_12_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_12 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_12 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_12))
                

        #SPRUCE ALBEDO (Months 1-12)
                
                data_filt$M_1_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_1 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_1 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_1))
                data_filt$M_2_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_2 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_2 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_2))
                data_filt$M_3_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_3 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_3 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_3))
                data_filt$M_4_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_4 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_4 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_4))
                data_filt$M_5_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_5 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_5 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_5))
                data_filt$M_6_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_6 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_6 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_6))
                data_filt$M_7_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_7 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_7 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_7))
                data_filt$M_8_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_8 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_8 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_8))
                data_filt$M_9_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_9 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_9 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_9))
                data_filt$M_10_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_10 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_10 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_10))
                data_filt$M_11_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_11 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_11 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_11))
                data_filt$M_12_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_12 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_12 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_12))
                

        #PINE ALBEDO (Months 1-12)
                
                data_filt$M_1_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_1 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_1 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_1))
                data_filt$M_2_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_2 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_2 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_2))
                data_filt$M_3_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_3 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_3 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_3))
                data_filt$M_4_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_4 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_4 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_4))
                data_filt$M_5_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_5 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_5 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_5))
                data_filt$M_6_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_6 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_6 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_6))
                data_filt$M_7_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_7 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_7 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_7))
                data_filt$M_8_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_8 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_8 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_8))
                data_filt$M_9_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_9 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_9 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_9))
                data_filt$M_10_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_10 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_10 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_10))
                data_filt$M_11_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_11 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_11 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_11))
                data_filt$M_12_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_12 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_12 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_12))
            
                
        #SAVE UPDATED SHAPEFILE
                
                #Write ESRI shapefile
                st_write(data_filt, "2_Albedo_Regional/Approach_1_SatSkog/Output/Final_Approach/corrected_shapefile", driver = "ESRI Shapefile")
                
        
                    
#END RE-CALCULATE ALBEDO FOR EACH OBSERVATION IN PLOTS ----------------------------------------------------------------------
                
                
                
                
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                
                
                
                
#CROP DATA ---------------------------------------------------------------------------    
        
        #LOAD CORRECTED SHAPEFILE
        data_filt <- st_read("2_Albedo_Regional/Approach_1_SatSkog/Output/Final_Approach/corrected_shapefile/corrected_shapefile.shp")
        beep(4)
        
        #Get all kommune names
        data_filt$kommnvn <- as.factor(data_filt$kommnvn)
        kommunes <- levels(data_filt$kommnvn)
        
        #HEDMARK ONLY SHAPEFILE
        hedmark_kommunes <- c("Ringsaker",
                              "Hamar",
                              "Elverum",
                              "Stange",
                              "Kongsvinger",
                              "Sør-Odal",
                              "Løten",
                              "Åsnes",
                              "Trysil",
                              "Eidskog",
                              "Tynset",
                              "Nord-Odal",
                              "Grue",
                              "Åmot",
                              "Våler",
                              "Stor-Elvdal",
                              "Alvdal",
                              "Os",
                              "Rendalen",
                              "Folldal",
                              "Tolga",
                              "Engerdal")
        
        hedmark <- subset(data_filt, kommnvn %in% hedmark_kommunes)
        
        
        #TRØNDELAG ONLY SHAPEFILE
        trondelag_kommunes <- c("Trondheim",
                                "Steinkjer",
                                "Namsos",
                                "Frøya",
                                "Osen",
                                "Oppdal",
                                "Rennebu",
                                "Røros",
                                "Holtålen",
                                "Midtre Gauldal",
                                "Melhus",
                                "Skaun",
                                "Malvik",
                                "Selbu",
                                "Tydal",
                                "Meråker",
                                "Stjørdal",
                                "Frosta",
                                "Levanger",
                                "Verdal",
                                "Snåsa",
                                "Lierne",
                                "Røyrvik",
                                "Namsskogan",
                                "Grong",
                                "Overhalla",
                                "Flatanger",
                                "Leka",
                                "Inderøy",
                                "Indre Fosen",
                                "Heim",
                                "Hitra",
                                "Ørland",
                                "Åfjord",
                                "Orkland",
                                "Nærøysund",
                                "Rindal")
        
        trondelag <- subset(data_filt, kommnvn %in% trondelag_kommunes)
        
        

#END CROP DATA --------------------------------------------------------------------------------------------------
        
        
        
        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


                        
                        
#CREATE UNIFIED DATASET OF HEDMARK AND TRONDELAG ------------------------------------------------------------------------------
        
        #Add "cluster" variable to each cropped df
        hedmark$Plot <- "Hedmark"
        trondelag$Plot <- "Trondelag"

        #Row bind three plots
        unified <- rbind(hedmark, trondelag)
        
        #Remove initial dataset to free up memory
        rm(data_filt)
        
        #Melt/expand the dataset
        
                #Create 12 copies of each row
                unified_exp <- unified[rep(seq_len(nrow(unified)), each = 12), ]

                #Create vector with repeating sequence of 1:12 (to add as month variable)
                months <- rep(c(1:12), times = (nrow(unified_exp) / 12))
                unified_exp$Month <- months
                unified_exp$SWE <- as.numeric('')
                unified_exp$Temp <- as.numeric('')
                
                #SWE
                unified_exp$SWE[unified_exp$Month == 1] <- unified_exp$SWE_M_1[unified_exp$Month == 1]
                unified_exp$SWE[unified_exp$Month == 2] <- unified_exp$SWE_M_2[unified_exp$Month == 2]
                unified_exp$SWE[unified_exp$Month == 3] <- unified_exp$SWE_M_3[unified_exp$Month == 3]
                unified_exp$SWE[unified_exp$Month == 4] <- unified_exp$SWE_M_4[unified_exp$Month == 4]
                unified_exp$SWE[unified_exp$Month == 5] <- unified_exp$SWE_M_5[unified_exp$Month == 5]
                unified_exp$SWE[unified_exp$Month == 6] <- unified_exp$SWE_M_6[unified_exp$Month == 6]
                unified_exp$SWE[unified_exp$Month == 7] <- unified_exp$SWE_M_7[unified_exp$Month == 7]
                unified_exp$SWE[unified_exp$Month == 8] <- unified_exp$SWE_M_8[unified_exp$Month == 8]
                unified_exp$SWE[unified_exp$Month == 9] <- unified_exp$SWE_M_9[unified_exp$Month == 9]
                unified_exp$SWE[unified_exp$Month == 10] <- unified_exp$SWE_M_10[unified_exp$Month == 10]
                unified_exp$SWE[unified_exp$Month == 11] <- unified_exp$SWE_M_11[unified_exp$Month == 11]
                unified_exp$SWE[unified_exp$Month == 12] <- unified_exp$SWE_M_12[unified_exp$Month == 12]
                
                #TEMP
                unified_exp$Temp[unified_exp$Month == 1] <- unified_exp$Tmp_M_1[unified_exp$Month == 1]
                unified_exp$Temp[unified_exp$Month == 2] <- unified_exp$Tmp_M_2[unified_exp$Month == 2]
                unified_exp$Temp[unified_exp$Month == 3] <- unified_exp$Tmp_M_3[unified_exp$Month == 3]
                unified_exp$Temp[unified_exp$Month == 4] <- unified_exp$Tmp_M_4[unified_exp$Month == 4]
                unified_exp$Temp[unified_exp$Month == 5] <- unified_exp$Tmp_M_5[unified_exp$Month == 5]
                unified_exp$Temp[unified_exp$Month == 6] <- unified_exp$Tmp_M_6[unified_exp$Month == 6]
                unified_exp$Temp[unified_exp$Month == 7] <- unified_exp$Tmp_M_7[unified_exp$Month == 7]
                unified_exp$Temp[unified_exp$Month == 8] <- unified_exp$Tmp_M_8[unified_exp$Month == 8]
                unified_exp$Temp[unified_exp$Month == 9] <- unified_exp$Tmp_M_9[unified_exp$Month == 9]
                unified_exp$Temp[unified_exp$Month == 10] <- unified_exp$Tmp_M_10[unified_exp$Month == 10]
                unified_exp$Temp[unified_exp$Month == 11] <- unified_exp$Tmp_M_11[unified_exp$Month == 11]
                unified_exp$Temp[unified_exp$Month == 12] <- unified_exp$Tmp_M_12[unified_exp$Month == 12]
                
                #Expand 3x (one duplicate for each tree species)
                unified_exp <- unified_exp[rep(seq_len(nrow(unified_exp)), each = 3), ]
                
                #Add species column
                unified_exp$Species <- ''
                
                #Create species vector
                spec <- rep(c("Spruce","Birch","Pine"), times = (nrow(unified_exp) / 3))
                unified_exp$Species <- spec
                
                
                #ALBEDO
                
                        #Blank column
                        unified_exp$Albedo <- ''
                
                        #Spruce
                        unified_exp$Albedo[unified_exp$Month == 1 & unified_exp$Species == "Spruce"] <- unified_exp$M_1_A_S[unified_exp$Month == 1 & unified_exp$Species == "Spruce"]
                        unified_exp$Albedo[unified_exp$Month == 2 & unified_exp$Species == "Spruce"] <- unified_exp$M_2_A_S[unified_exp$Month == 2 & unified_exp$Species == "Spruce"]
                        unified_exp$Albedo[unified_exp$Month == 3 & unified_exp$Species == "Spruce"] <- unified_exp$M_3_A_S[unified_exp$Month == 3 & unified_exp$Species == "Spruce"]
                        unified_exp$Albedo[unified_exp$Month == 4 & unified_exp$Species == "Spruce"] <- unified_exp$M_4_A_S[unified_exp$Month == 4 & unified_exp$Species == "Spruce"]
                        unified_exp$Albedo[unified_exp$Month == 5 & unified_exp$Species == "Spruce"] <- unified_exp$M_5_A_S[unified_exp$Month == 5 & unified_exp$Species == "Spruce"]
                        unified_exp$Albedo[unified_exp$Month == 6 & unified_exp$Species == "Spruce"] <- unified_exp$M_6_A_S[unified_exp$Month == 6 & unified_exp$Species == "Spruce"]
                        unified_exp$Albedo[unified_exp$Month == 7 & unified_exp$Species == "Spruce"] <- unified_exp$M_7_A_S[unified_exp$Month == 7 & unified_exp$Species == "Spruce"]
                        unified_exp$Albedo[unified_exp$Month == 8 & unified_exp$Species == "Spruce"] <- unified_exp$M_8_A_S[unified_exp$Month == 8 & unified_exp$Species == "Spruce"]
                        unified_exp$Albedo[unified_exp$Month == 9 & unified_exp$Species == "Spruce"] <- unified_exp$M_9_A_S[unified_exp$Month == 9 & unified_exp$Species == "Spruce"]
                        unified_exp$Albedo[unified_exp$Month == 10 & unified_exp$Species == "Spruce"] <- unified_exp$M_10_A_S[unified_exp$Month == 10 & unified_exp$Species == "Spruce"]
                        unified_exp$Albedo[unified_exp$Month == 11 & unified_exp$Species == "Spruce"] <- unified_exp$M_11_A_S[unified_exp$Month == 11 & unified_exp$Species == "Spruce"]
                        unified_exp$Albedo[unified_exp$Month == 12 & unified_exp$Species == "Spruce"] <- unified_exp$M_12_A_S[unified_exp$Month == 12 & unified_exp$Species == "Spruce"]
                
                        #Pine
                        unified_exp$Albedo[unified_exp$Month == 1 & unified_exp$Species == "Pine"] <- unified_exp$M_1_A_P[unified_exp$Month == 1 & unified_exp$Species == "Pine"]
                        unified_exp$Albedo[unified_exp$Month == 2 & unified_exp$Species == "Pine"] <- unified_exp$M_2_A_P[unified_exp$Month == 2 & unified_exp$Species == "Pine"]
                        unified_exp$Albedo[unified_exp$Month == 3 & unified_exp$Species == "Pine"] <- unified_exp$M_3_A_P[unified_exp$Month == 3 & unified_exp$Species == "Pine"]
                        unified_exp$Albedo[unified_exp$Month == 4 & unified_exp$Species == "Pine"] <- unified_exp$M_4_A_P[unified_exp$Month == 4 & unified_exp$Species == "Pine"]
                        unified_exp$Albedo[unified_exp$Month == 5 & unified_exp$Species == "Pine"] <- unified_exp$M_5_A_P[unified_exp$Month == 5 & unified_exp$Species == "Pine"]
                        unified_exp$Albedo[unified_exp$Month == 6 & unified_exp$Species == "Pine"] <- unified_exp$M_6_A_P[unified_exp$Month == 6 & unified_exp$Species == "Pine"]
                        unified_exp$Albedo[unified_exp$Month == 7 & unified_exp$Species == "Pine"] <- unified_exp$M_7_A_P[unified_exp$Month == 7 & unified_exp$Species == "Pine"]
                        unified_exp$Albedo[unified_exp$Month == 8 & unified_exp$Species == "Pine"] <- unified_exp$M_8_A_P[unified_exp$Month == 8 & unified_exp$Species == "Pine"]
                        unified_exp$Albedo[unified_exp$Month == 9 & unified_exp$Species == "Pine"] <- unified_exp$M_9_A_P[unified_exp$Month == 9 & unified_exp$Species == "Pine"]
                        unified_exp$Albedo[unified_exp$Month == 10 & unified_exp$Species == "Pine"] <- unified_exp$M_10_A_P[unified_exp$Month == 10 & unified_exp$Species == "Pine"]
                        unified_exp$Albedo[unified_exp$Month == 11 & unified_exp$Species == "Pine"] <- unified_exp$M_11_A_P[unified_exp$Month == 11 & unified_exp$Species == "Pine"]
                        unified_exp$Albedo[unified_exp$Month == 12 & unified_exp$Species == "Pine"] <- unified_exp$M_12_A_P[unified_exp$Month == 12 & unified_exp$Species == "Pine"]
                        
                
                        #Birch
                        unified_exp$Albedo[unified_exp$Month == 1 & unified_exp$Species == "Birch"] <- unified_exp$M_1_A_B[unified_exp$Month == 1 & unified_exp$Species == "Birch"]
                        unified_exp$Albedo[unified_exp$Month == 2 & unified_exp$Species == "Birch"] <- unified_exp$M_2_A_B[unified_exp$Month == 2 & unified_exp$Species == "Birch"]
                        unified_exp$Albedo[unified_exp$Month == 3 & unified_exp$Species == "Birch"] <- unified_exp$M_3_A_B[unified_exp$Month == 3 & unified_exp$Species == "Birch"]
                        unified_exp$Albedo[unified_exp$Month == 4 & unified_exp$Species == "Birch"] <- unified_exp$M_4_A_B[unified_exp$Month == 4 & unified_exp$Species == "Birch"]
                        unified_exp$Albedo[unified_exp$Month == 5 & unified_exp$Species == "Birch"] <- unified_exp$M_5_A_B[unified_exp$Month == 5 & unified_exp$Species == "Birch"]
                        unified_exp$Albedo[unified_exp$Month == 6 & unified_exp$Species == "Birch"] <- unified_exp$M_6_A_B[unified_exp$Month == 6 & unified_exp$Species == "Birch"]
                        unified_exp$Albedo[unified_exp$Month == 7 & unified_exp$Species == "Birch"] <- unified_exp$M_7_A_B[unified_exp$Month == 7 & unified_exp$Species == "Birch"]
                        unified_exp$Albedo[unified_exp$Month == 8 & unified_exp$Species == "Birch"] <- unified_exp$M_8_A_B[unified_exp$Month == 8 & unified_exp$Species == "Birch"]
                        unified_exp$Albedo[unified_exp$Month == 9 & unified_exp$Species == "Birch"] <- unified_exp$M_9_A_B[unified_exp$Month == 9 & unified_exp$Species == "Birch"]
                        unified_exp$Albedo[unified_exp$Month == 10 & unified_exp$Species == "Birch"] <- unified_exp$M_10_A_B[unified_exp$Month == 10 & unified_exp$Species == "Birch"]
                        unified_exp$Albedo[unified_exp$Month == 11 & unified_exp$Species == "Birch"] <- unified_exp$M_11_A_B[unified_exp$Month == 11 & unified_exp$Species == "Birch"]
                        unified_exp$Albedo[unified_exp$Month == 12 & unified_exp$Species == "Birch"] <- unified_exp$M_12_A_B[unified_exp$Month == 12 & unified_exp$Species == "Birch"]
                        
                        
        #Explore the data
        unified_exp$Albedo <- as.numeric(unified_exp$Albedo)
        unified_exp$Species <- as.factor(unified_exp$Species)
        unified_exp$Plot <- as.factor(unified_exp$Plot)
        rm(data)
        rm(months)
        rm(spec)
        
        beep(8)
        
        
#PLOTS ----------------------------------------------------
        
        
        #INVESTIGATE VOLUME -----------
        #NOTE: For each species, filtering to plots with 75% or greater coverage of that species
        #(i.e. homogeneous plots)
        
                #HEDMARK ------
        
                        #Volume vs. moose density scatterplots
                        unified$Ms_Dnst <- as.numeric(as.character(unified$Ms_Dnst))
                
                                #Spruce
                                ggplot(data = subset(hedmark, grn_pct >= 75), aes(x = Ms_Dnst, y = vuprhag)) +
                                        geom_point(alpha = 0.3) +
                                        geom_smooth(method = "loess", span = 50, se = F) +
                                        theme_bw() +
                                        labs(x = "Moose Density (kg/km2)", y = "Spruce Stand Volume (m3/ha)")
                                
                                #Pine
                                ggplot(data = subset(hedmark, fur_pct >= 75), aes(x = Ms_Dnst, y = vuprhaf)) +
                                        geom_point(alpha = 0.3) +
                                        geom_smooth(method = "loess", span = 50, se = F) +
                                        theme_bw() +
                                        labs(x = "Moose Density (kg/km2)", y = "Pine Stand Volume (m3/ha)")
                                
                                #Birch (Deciduous)
                                ggplot(data = subset(hedmark, lav_pct >= 75), aes(x = Ms_Dnst, y = vuprhal)) +
                                        geom_point(alpha = 0.3) +
                                        geom_smooth(method = "loess", span = 50, se = F) +
                                        theme_bw() +
                                        labs(x = "Moose Density (kg/km2)", y = "Deciduous Stand Volume (m3/ha)")
                                
                                
                        
                #Plot volume vs. means for moose density (w/ SE)
                unified$Ms_Dnst <- as.factor(unified$Ms_Dnst)
                
                        #Define Southeast plot as new df
                        hedmark_birch <- subset(hedmark, lav_pct >= 75)
                        hedmark_spruce <- subset(hedmark, grn_pct >= 75)
                        hedmark_pine <- subset(hedmark, fur_pct >= 75)
                        
                        #Plot by age
                        
                                #Birch
                                ggplot(data = hedmark_birch, aes(x = Ms_Dnst, y = vuprhal)) +
                                        geom_point() +
                                        geom_smooth() +
                                        facet_wrap(~ cut_interval(alder, n = 5))
                
                        birch_vol <- aggregate(hedmark_birch$vuprhal, by = list(hedmark_birch$Ms_Dnst), FUN = mean)
                        spruce_vol <- aggregate(hedmark_spruce$vuprhag, by = list(hedmark_spruce$Ms_Dnst), FUN = mean)
                        pine_vol <- aggregate(hedmark_pine$vuprhaf, by = list(hedmark_pine$Ms_Dnst), FUN = mean)
                
                        #Birch
                        birch_vol$Group.1 <- as.numeric(as.character(birch_vol$Group.1))
                        ggplot(data = birch_vol, aes(x = Group.1, y = x)) +
                                geom_point() +
                                geom_line() + 
                                labs(x = "Moose Density (kg/km2)", y = "Mean Birch Stand Volume (m3/ha)")
                        
                        
                        #Pine
                        pine_vol$Group.1 <- as.numeric(as.character(pine_vol$Group.1))
                        ggplot(data = pine_vol, aes(x = Group.1, y = x)) +
                                geom_point() +
                                geom_line() + 
                                labs(x = "Moose Density (kg/km2)", y = "Mean Pine Stand Volume (m3/ha)")
                        
                        
                        #Spruce
                        spruce_vol$Group.1 <- as.numeric(as.character(spruce_vol$Group.1))
                        ggplot(data = spruce_vol, aes(x = Group.1, y = x)) +
                                geom_point() +
                                geom_line() + 
                                labs(x = "Moose Density (kg/km2)", y = "Mean Spruce Stand Volume (m3/ha)")
        
                  
                #ROLLING MEANS FOR VOLUME ------------
                        
                        #Rolling means for Spruce        
                        roll_spruce <- as.data.frame(rollmean(spruce_vol, 5, align = "center"))
                        ggplot(data = roll_spruce, aes(x = Group.1, y = x)) +
                                geom_point() +
                                geom_line() +
                                labs(x = "Moose Density (kg/km2)", y = "Mean Spruce Stand Volume (m3/ha)\nRolling Average")
                        
                
                        #Rolling means for Pine        
                        roll_pine <- as.data.frame(rollmean(pine_vol, 5, align = "center"))
                        ggplot(data = roll_pine, aes(x = Group.1, y = x)) +
                                geom_point() +
                                geom_line() +
                                labs(x = "Moose Density (kg/km2)", y = "Mean Pine Stand Volume (m3/ha)\nRolling Average")
                        
                        
                        #Rolling means for Birch
                        roll_birch <- as.data.frame(rollmean(birch_vol, 5, align = "center"))
                        ggplot(data = roll_birch, aes(x = Group.1, y = x)) +
                                geom_point() +
                                geom_line() +
                                labs(x = "Moose Density (kg/km2)", y = "Mean Birch Stand Volume (m3/ha)\nRolling Average")
                        
                        
        
                        
                        
                        
                        
                        
                        
        #CENTRAL PLOT SUMMARY ---------------
                        
                #Define Southeast plot as new df
                central <- unified[unified$Plot == "Central",]
                birch_vol_c <- aggregate(central$vuprhal, by = list(central$Ms_Dnst), FUN = mean)
                spruce_vol_c <- aggregate(central$vuprhag, by = list(central$Ms_Dnst), FUN = mean)
                pine_vol_c <- aggregate(central$vuprhaf, by = list(central$Ms_Dnst), FUN = mean)
                
                        #Birch
                        birch_vol_c$Group.1 <- as.numeric(as.character(birch_vol_c$Group.1))
                        ggplot(data = birch_vol_c, aes(x = Group.1, y = x)) +
                                geom_point() +
                                geom_line() + 
                                labs(x = "Moose Density (kg/km2)", y = "Mean Birch Stand Volume (m3/ha)")
                        
                        
                        #Pine
                        pine_vol_c$Group.1 <- as.numeric(as.character(pine_vol_c$Group.1))
                        ggplot(data = pine_vol_c, aes(x = Group.1, y = x)) +
                                geom_point() +
                                geom_line() + 
                                labs(x = "Moose Density (kg/km2)", y = "Mean Pine Stand Volume (m3/ha)")
                        
                        
                        #Spruce
                        spruce_vol_c$Group.1 <- as.numeric(as.character(spruce_vol_c$Group.1))
                        ggplot(data = spruce_vol_c, aes(x = Group.1, y = x)) +
                                geom_point() +
                                geom_line() + 
                                labs(x = "Moose Density (kg/km2)", y = "Mean Spruce Stand Volume (m3/ha)")
                
                
                #ROLLING MEANS FOR VOLUME ------------
                
                        
                        #Rolling means for Spruce        
                        roll_spruce_c <- as.data.frame(rollmean(spruce_vol_c, 5, align = "center"))
                        ggplot(data = roll_spruce_c, aes(x = Group.1, y = x)) +
                                geom_point() +
                                geom_line() +
                                labs(x = "Moose Density (kg/km2)", y = "Mean Spruce Stand Volume (m3/ha)\nRolling Average")
                        
                        
                        #Rolling means for Pine        
                        roll_pine_c <- as.data.frame(rollmean(pine_vol_c, 5, align = "center"))
                        ggplot(data = roll_pine_c, aes(x = Group.1, y = x)) +
                                geom_point() +
                                geom_line() +
                                labs(x = "Moose Density (kg/km2)", y = "Mean Pine Stand Volume (m3/ha)\nRolling Average")
                        
                        
                        #Rolling means for Birch
                        roll_birch_c <- as.data.frame(rollmean(birch_vol_c, 5, align = "center"))
                        ggplot(data = roll_birch_c, aes(x = Group.1, y = x)) +
                                geom_point() +
                                geom_line() +
                                labs(x = "Moose Density (kg/km2)", y = "Mean Birch Stand Volume (m3/ha)\nRolling Average")
                        
                                
                                
                        
#NOT SEEING ANY TRENDS ---------------------
                        
        #DO TRENDS EXIST ACROSS ENTIRE COUNTRY?
                        
                #Calculate mean volume for each tree species by moose density
                big_means_birch <- aggregate(unified$vuprhal, by = list(unified$Ms_Dnst), FUN = mean)
                big_means_pine <- aggregate(unified$vuprhaf, by = list(unified$Ms_Dnst), FUN = mean)
                big_means_spruce <- aggregate(unified$vuprhag, by = list(unified$Ms_Dnst), FUN = mean)
                                
                #Calculate rolling averages
                big_roll_b <- as.data.frame(rollmean(big_means_birch, 5, align = "center"))
                big_roll_p <- as.data.frame(rollmean(big_means_pine, 5, align = "center"))
                big_roll_s <- as.data.frame(rollmean(big_means_spruce, 5, align = "center"))
                     
                #Plot
                
                        #Birch
                        ggplot(data = big_roll_b, aes(x = Group.1, y = x)) +
                                geom_point() +
                                geom_line() +
                                labs(x = "Moose Density (kg/km2)", y = "Mean Birch Stand Volume (m3/ha)\nRolling Average")
                        
                        #Spruce
                        ggplot(data = big_roll_s, aes(x = Group.1, y = x)) +
                                geom_point() +
                                geom_line() +
                                labs(x = "Moose Density (kg/km2)", y = "Mean Spruce Stand Volume (m3/ha)\nRolling Average")
                        
                        #Pine
                        ggplot(data = big_roll_p, aes(x = Group.1, y = x)) +
                                geom_point() +
                                geom_line() +
                                labs(x = "Moose Density (kg/km2)", y = "Mean Pine Stand Volume (m3/ha)\nRolling Average")
                        
                        
                        
                        
                              
        #VOLUME BY ELEVATION RANGE -----------------------
                        
                #Facet by elevation range

                        #Birch (Deciduous)
                        ggplot(data = subset(unified, Plot == "Southeast"), aes(x = Ms_Dnst, y = vuprhal)) +
                                geom_point(alpha = 0.3) +
                                geom_smooth(method = "loess", span = 50, se = F) +
                                theme_bw() +
                                facet_wrap(~ cut_interval(dem, n = 6)) +
                                labs(x = "Moose Density (kg/km2)", y = "Deciduous Stand Volume (m3/ha)")
                        
                        #Pine
                        ggplot(data = subset(unified, Plot == "Southeast"), aes(x = Ms_Dnst, y = vuprhag)) +
                                geom_point(alpha = 0.3) +
                                geom_smooth(method = "loess", span = 50, se = F) +
                                theme_bw() +
                                facet_wrap(~ cut_interval(dem, n = 6)) +
                                labs(x = "Moose Density (kg/km2)", y = "Pine Stand Volume (m3/ha)")
                        
                        #Spruce
                        ggplot(data = subset(unified, Plot == "Southeast"), aes(x = Ms_Dnst, y = vuprhaf)) +
                                geom_point(alpha = 0.3) +
                                geom_smooth(method = "loess", span = 50, se = F) +
                                theme_bw() +
                                facet_wrap(~ cut_interval(dem, n = 6)) +
                                labs(x = "Moose Density (kg/km2)", y = "Spruce Stand Volume (m3/ha)")
                        
                        
        #VOLUME BY PLOT AGE
                
                #Birch (Deciduous)
                ggplot(data = subset(unified, Plot == "Southeast"), aes(x = Ms_Dnst, y = vuprhal)) +
                        geom_point(alpha = 0.3) +
                        geom_smooth(method = "loess", span = 50, se = F) +
                        theme_bw() +
                        facet_wrap(~ cut_interval(alder, n = 6)) +
                        labs(x = "Moose Density (kg/km2)", y = "Deciduous Stand Volume (m3/ha)")
                        
                #Pine
                ggplot(data = subset(unified, Plot == "Southeast"), aes(x = Ms_Dnst, y = vuprhag)) +
                        geom_point(alpha = 0.3) +
                        geom_smooth(method = "loess", span = 50, se = F) +
                        theme_bw() +
                        facet_wrap(~ cut_interval(alder, n = 6)) +
                        labs(x = "Moose Density (kg/km2)", y = "Pine Stand Volume (m3/ha)")
                
                #Spruce
                ggplot(data = subset(unified, Plot == "Southeast"), aes(x = Ms_Dnst, y = vuprhaf)) +
                        geom_point(alpha = 0.3) +
                        geom_smooth(method = "loess", span = 50, se = F) +
                        theme_bw() +
                        facet_wrap(~ cut_interval(alder, n = 6)) +
                        labs(x = "Moose Density (kg/km2)", y = "Spruce Stand Volume (m3/ha)")
                        
        
        #VOLUME BY FOREST TYPE
                
                #Birch
                ggplot(data = subset(unified, Plot == "Southeast"), aes(x = Ms_Dnst, y = vuprhal)) +
                        geom_point(alpha = 0.3) +
                        geom_smooth(method = "loess", span = 50, se = F) +
                        theme_bw() +
                        facet_wrap(~ treslag) +
                        labs(x = "Moose Density (kg/km2)", y = "Deciduous Stand Volume (m3/ha)")
                
                #Pine
                ggplot(data = subset(unified, Plot == "Southeast"), aes(x = Ms_Dnst, y = vuprhag)) +
                        geom_point(alpha = 0.3) +
                        geom_smooth(method = "loess", span = 50, se = F) +
                        theme_bw() +
                        facet_wrap(~ treslag) +
                        labs(x = "Moose Density (kg/km2)", y = "Pine Stand Volume (m3/ha)")
                
                #Spruce
                ggplot(data = subset(unified, Plot == "Southeast"), aes(x = Ms_Dnst, y = vuprhaf)) +
                        geom_point(alpha = 0.3) +
                        geom_smooth(method = "loess", span = 50, se = F) +
                        theme_bw() +
                        facet_wrap(~ treslag) +
                        labs(x = "Moose Density (kg/km2)", y = "Spruce Stand Volume (m3/ha)")
                        
##FINDINGS: LOOKS LIKE TRENDS MIGHT BE MOST NOTICEABLE AT LOWER ELEVATIONS (OTHER FACTORS SEEM SLIGHTLY LESS IMPORTANT)       
                        
        #CENTRAL PLOT---------
                
                #VOLUME BY ELEVATION RANGE -----------------------
                
                        #Facet by elevation range
                        
                        #Birch (Deciduous)
                        ggplot(data = subset(unified, Plot == "Central"), aes(x = Ms_Dnst, y = vuprhal)) +
                                geom_point(alpha = 0.3) +
                                geom_smooth(method = "loess", span = 50, se = F) +
                                theme_bw() +
                                facet_wrap(~ cut_interval(dem, n = 6)) +
                                labs(x = "Moose Density (kg/km2)", y = "Deciduous Stand Volume (m3/ha)")
                        
                        #Pine
                        ggplot(data = subset(unified, Plot == "Central"), aes(x = Ms_Dnst, y = vuprhag)) +
                                geom_point(alpha = 0.3) +
                                geom_smooth(method = "loess", span = 50, se = F) +
                                theme_bw() +
                                facet_wrap(~ cut_interval(dem, n = 6)) +
                                labs(x = "Moose Density (kg/km2)", y = "Pine Stand Volume (m3/ha)")
                        
                        #Spruce
                        ggplot(data = subset(unified, Plot == "Central"), aes(x = Ms_Dnst, y = vuprhaf)) +
                                geom_point(alpha = 0.3) +
                                geom_smooth(method = "loess", span = 50, se = F) +
                                theme_bw() +
                                facet_wrap(~ cut_interval(dem, n = 6)) +
                                labs(x = "Moose Density (kg/km2)", y = "Spruce Stand Volume (m3/ha)")
                        
                        
                
                
                
                
                
                
                
                
                
                
                
                
        
        #INVESTIGATE SWE WITHIN SOUTHEAST PLOT
        unified_exp$Month <- as.factor(unified_exp$Month)
        ggplot(data = subset(unified_exp, Plot == "Southeast"), aes(x = Month, y = SWE)) +
                geom_boxplot()

        
        

                        
        ## ELEVATION CAUSES HUGE VARIATION IN ALBEDO - DOES IT MAKE SENSE TO LIMIT TO ELEVATION RANGE?
                        
                        #Identify elevation ranges
                        
                                #Plot elevation
                                ggplot(data = unified_exp, aes(x = Plot, y = dem)) +
                                        geom_boxplot() +
                                        theme_bw() +
                                
                                #Explore volume vs moose density in Southeast plot
                                
                                        #Birch volume
                                        ggplot(data = subset(unified_exp, Species == "Birch" & Plot == "Southeast"), aes(x = Ms_Dnst, y = vuprhal, color = dem)) +
                                                geom_point(alpha = 0.1) +
                                                geom_smooth(method = "lm") +
                                                facet_wrap(~ Month) +
                                                theme_bw() +
                                                labs(x = "Moose Density (kg/km2)", y = "Birch Stand Volume (m3/ha)") +
                                                ggtitle("Birch Volume vs. Moose Density in Southeast Plot")
                                        
                                        #Pine volume
                                        ggplot(data = subset(unified_exp, Species == "Pine" & Plot == "Southeast"), aes(x = Ms_Dnst, y = vuprhaf, color = dem)) +
                                                geom_point(alpha = 0.1) +
                                                geom_smooth(method = "lm") +
                                                facet_wrap(~ Month) +
                                                theme_bw() +
                                                labs(x = "Moose Density (kg/km2)", y = "Pine Stand Volume (m3/ha)") +
                                                ggtitle("Pine Volume vs. Moose Density in Southeast Plot")
                                        
                                        #Spruce volume
                                        ggplot(data = subset(unified_exp, Species == "Spruce" & Plot == "Southeast"), aes(x = Ms_Dnst, y = vuprhag, color = dem)) +
                                                geom_point(alpha = 0.1) +
                                                geom_smooth(method = "lm") +
                                                facet_wrap(~ Month) +
                                                theme_bw() +
                                                labs(x = "Moose Density (kg/km2)", y = "Spruce Stand Volume (m3/ha)") +
                                                ggtitle("Spruce Volume vs. Moose Density in Southeast Plot")
                                
                                        

                        #Explore elevation and albedo within Southeast plot
        
                                #Birch Albedo
                                ggplot(data = subset(unified_exp, Species == "Birch" & Plot == "Southeast"), aes(x = Ms_Dnst, y = Albedo, color = dem)) +
                                        geom_point(alpha = 0.1) +
                                        geom_smooth(method = "lm") +
                                        facet_wrap(~ Month) +
                                        theme_bw() +
                                        labs(x = "Moose Density (kg/km2)", y = "Birch Albedo") +
                                        ggtitle("Birch Albedo vs. Moose Density in Southeast Plot")
                        
                                        #Very large stratification between elevations - seems clear that I'll need to limit to 
                                        #a specific elevation range
                                
                                #Spruce Albedo
                                ggplot(data = subset(unified_exp, Species == "Spruce" & Plot == "Southeast"), aes(x = Ms_Dnst, y = Albedo, color = dem)) +
                                        geom_point(alpha = 0.1) +
                                        geom_smooth(method = "lm") +
                                        facet_wrap(~ Month) +
                                        theme_bw() +
                                        labs(x = "Moose Density (kg/km2)", y = "Spruce Albedo") +
                                        ggtitle("Spruce Albedo vs. Moose Density in Southeast Plot")
                                
                                
                                #Pine Albedo
                                ggplot(data = subset(unified_exp, Species == "Pine" & Plot == "Southeast"), aes(x = Ms_Dnst, y = Albedo, color = dem)) +
                                        geom_point(alpha = 0.1) +
                                        geom_smooth(method = "lm") +
                                        facet_wrap(~ Month) +
                                        theme_bw() +
                                        labs(x = "Moose Density (kg/km2)", y = "Pine Albedo") +
                                        ggtitle("Pine Albedo vs. Moose Density in Southeast Plot")
        
        
                #Explore species-specific volume
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
        
                #Export plots
        
                        #Birch Albedo
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Final_Approach/unfiltered/albedo_plots/birch_albedo_by_month.png",
                            width = 2000,
                            height = 2000,
                            units = "px",
                            bg = "white")
                        
                        ggplot(data = subset(unified_exp, Species == "Birch"), aes(x = Ms_Dnst, y = Albedo, color = Plot)) +
                                geom_point(alpha = 0.1) +
                                geom_smooth(method = NULL) +
                                facet_wrap(~ Month) +
                                scale_y_continuous(limits = c(0,1), breaks = c(0,0.2,0.4,0.6,0.8,1)) +
                                ggtitle("Moose Density vs. Birch Albedo (by Month)") +
                                labs(x = "Moose Density (kg/km-2)", y = "Albedo (Birch)") +
                                theme(plot.title = element_text(hjust = 0.5, size = 50, margin = margin(t = 40, b = 40)),
                                      legend.title = element_text(size = 40),
                                      legend.text = element_text(size = 36, margin = margin(t=16)),
                                      strip.text.x = element_text(size = 32),
                                      axis.text.x = element_text(size = 38, margin = margin(t=16)),
                                      axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                      axis.title.x = element_text(size = 50, margin = margin(t=40, b = 40)),
                                      axis.title.y = element_text(size = 50, margin = margin(r=40)))
                        
                        dev.off()
                        
                        
                        #Pine Albedo
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Final_Approach/unfiltered/albedo_plots/pine_albedo_by_month.png",
                            width = 2000,
                            height = 2000,
                            units = "px",
                            bg = "white")
                        
                        ggplot(data = subset(unified_exp, Species == "Pine"), aes(x = Ms_Dnst, y = Albedo, color = Plot)) +
                                geom_point(alpha = 0.1) +
                                geom_smooth(method = NULL) +
                                facet_wrap(~ Month) +
                                scale_y_continuous(limits = c(0,1), breaks = c(0,0.2,0.4,0.6,0.8,1)) +
                                ggtitle("Moose Density vs. Pine Albedo (by Month)") +
                                labs(x = "Moose Density (kg/km-2)", y = "Albedo (Pine)") +
                                theme(plot.title = element_text(hjust = 0.5, size = 50, margin = margin(t = 40, b = 40)),
                                      legend.title = element_text(size = 40),
                                      legend.text = element_text(size = 36, margin = margin(t=16)),
                                      strip.text.x = element_text(size = 32),
                                      axis.text.x = element_text(size = 38, margin = margin(t=16)),
                                      axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                      axis.title.x = element_text(size = 50, margin = margin(t=40, b = 40)),
                                      axis.title.y = element_text(size = 50, margin = margin(r=40)))
                        
                        dev.off()
                
                        
                        #Spruce Albedo
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Final_Approach/unfiltered/albedo_plots/spruce_albedo_by_month.png",
                            width = 2000,
                            height = 2000,
                            units = "px",
                            bg = "white")
                        
                        ggplot(data = subset(unified_exp, Species == "Spruce"), aes(x = Ms_Dnst, y = Albedo, color = Plot)) +
                                geom_point(alpha = 0.1) +
                                geom_smooth(method = NULL) +
                                facet_wrap(~ Month) +
                                scale_y_continuous(limits = c(0,1), breaks = c(0,0.2,0.4,0.6,0.8,1)) +
                                ggtitle("Moose Density vs. Spruce Albedo (by Month)") +
                                labs(x = "Moose Density (kg/km-2)", y = "Albedo (Spruce)") +
                                theme(plot.title = element_text(hjust = 0.5, size = 50, margin = margin(t = 40, b = 40)),
                                      legend.title = element_text(size = 40),
                                      legend.text = element_text(size = 36, margin = margin(t=16)),
                                      strip.text.x = element_text(size = 32),
                                      axis.text.x = element_text(size = 38, margin = margin(t=16)),
                                      axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                      axis.title.x = element_text(size = 50, margin = margin(t=40, b = 40)),
                                      axis.title.y = element_text(size = 50, margin = margin(r=40)))
                        
                        dev.off()
                        
                        beep(b)
                        
                        
        #Descriptive statistics for plots
                        
                #Age
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Final_Approach/unfiltered/descriptive/age.png",
                    width = 1500,
                    height = 1500,
                    units = "px",
                    bg = "white")
                
                ggplot(data = unified, aes(x = Plot, y = alder)) +
                        geom_boxplot() +
                        ggtitle("Forest Plot Age (by Location)") +
                        labs(x = "Location", y = "Age (years)") +
                        theme(plot.title = element_text(hjust = 0.5, size = 50, margin = margin(t = 40, b = 40)),
                              legend.title = element_text(size = 40),
                              legend.text = element_text(size = 36, margin = margin(t=16)),
                              strip.text.x = element_text(size = 32),
                              axis.text.x = element_text(size = 38, margin = margin(t=16)),
                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                              axis.title.x = element_text(size = 50, margin = margin(t=40, b = 40)),
                              axis.title.y = element_text(size = 50, margin = margin(r=40)))
                
                dev.off()
                        
                #Volume
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Final_Approach/unfiltered/descriptive/volume.png",
                    width = 1500,
                    height = 1500,
                    units = "px",
                    bg = "white")
                
                ggplot(data = unified, aes(x = Plot, y = vuprha)) +
                        geom_boxplot() +
                        ggtitle("Forest Plot Volume (by Location)") +
                        labs(x = "Location", y = "Volume (m3/ha)") +
                        theme(plot.title = element_text(hjust = 0.5, size = 50, margin = margin(t = 40, b = 40)),
                              legend.title = element_text(size = 40),
                              legend.text = element_text(size = 36, margin = margin(t=16)),
                              strip.text.x = element_text(size = 32),
                              axis.text.x = element_text(size = 38, margin = margin(t=16)),
                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                              axis.title.x = element_text(size = 50, margin = margin(t=40, b = 40)),
                              axis.title.y = element_text(size = 50, margin = margin(r=40)))
                
                dev.off()
                
                #SWE
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Final_Approach/unfiltered/descriptive/swe.png",
                    width = 1800,
                    height = 1500,
                    units = "px",
                    bg = "white")
                
                unified_exp$Month <- as.factor(unified_exp$Month)
                ggplot(data = unified_exp, aes(x = Month, y = SWE, fill = Plot)) +
                        geom_boxplot() +
                        ggtitle("Forest Plot SWE\n(by Location)") +
                        labs(x = "Month", y = "Mean Plot Snow-Water Equivalent (mm)") +
                        theme(plot.title = element_text(hjust = 0.5, size = 50, margin = margin(t = 40, b = 40)),
                              legend.title = element_text(size = 40),
                              legend.text = element_text(size = 36, margin = margin(t=16)),
                              legend.position = "bottom",
                              strip.text.x = element_text(size = 32),
                              axis.text.x = element_text(size = 38, margin = margin(t=16)),
                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                              axis.title.x = element_text(size = 50, margin = margin(t=40, b = 40)),
                              axis.title.y = element_text(size = 50, margin = margin(r=40)))
                
                dev.off()
                        
                #Temp
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Final_Approach/unfiltered/descriptive/temp.png",
                    width = 1800,
                    height = 1500,
                    units = "px",
                    bg = "white")
                
                ggplot(data = unified_exp, aes(x = Month, y = Temp, fill = Plot)) +
                        geom_boxplot() +
                        ggtitle("Forest Plot Temperature\n(by Location)") +
                        labs(x = "Month", y = "Mean Plot Temperature (K)") +
                        theme(plot.title = element_text(hjust = 0.5, size = 50, margin = margin(t = 40, b = 40)),
                              legend.title = element_text(size = 40),
                              legend.text = element_text(size = 36, margin = margin(t=16)),
                              legend.position = "bottom",
                              strip.text.x = element_text(size = 32),
                              axis.text.x = element_text(size = 38, margin = margin(t=16)),
                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                              axis.title.x = element_text(size = 50, margin = margin(t=40, b = 40)),
                              axis.title.y = element_text(size = 50, margin = margin(r=40)))
                
                dev.off()
                
                #Moose Density
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Final_Approach/unfiltered/descriptive/moose_density.png",
                    width = 1500,
                    height = 1500,
                    units = "px",
                    bg = "white")
                
                ggplot(data = unified_exp, aes(x = Plot, y = Ms_Dnst)) +
                        geom_boxplot() +
                        ggtitle("Forest Plot Moose Density\n(by Location)") +
                        labs(x = "Location", y = "Moose Metabolic Biomass (kg/km2)") +
                        theme(plot.title = element_text(hjust = 0.5, size = 50, margin = margin(t = 40, b = 40)),
                              legend.title = element_text(size = 40),
                              legend.text = element_text(size = 36, margin = margin(t=16)),
                              strip.text.x = element_text(size = 32),
                              axis.text.x = element_text(size = 38, margin = margin(t=16)),
                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                              axis.title.x = element_text(size = 50, margin = margin(t=40, b = 40)),
                              axis.title.y = element_text(size = 50, margin = margin(r=40)))
                
                dev.off()
                
                
                #Filter to an elevation range (100-300m)
                se_elev <- unified_exp[unified_exp$Plot == "Southeast" &
                                       unified_exp$dem >= 100 &
                                       unified_exp$dem <= 300,]

                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Final_Approach/unfiltered/albedo_plots/se_filt_elevation.png",
                    width = 1800,
                    height = 1500,
                    units = "px",
                    bg = "white")
                
                ggplot(data = subset(se_elev, Species == "Birch"), aes(x = Ms_Dnst, y = Albedo)) +
                        geom_point(alpha = 0.1) +
                        geom_smooth(method = NULL) +
                        facet_wrap(~ Month) +
                        scale_y_continuous(limits = c(0,1), breaks = c(0,0.2,0.4,0.6,0.8,1)) +
                                ggtitle("Moose Density vs. Birch Albedo (by Month)\nSoutheast Plot Only\nFiltered to 100-300m Elevation\n(n = 18898 plots)") +
                                labs(x = "Moose Density (kg/km-2)", y = "Albedo (Birch)") +
                                theme(plot.title = element_text(hjust = 0.5, size = 50, margin = margin(t = 40, b = 40)),
                                      legend.title = element_text(size = 40),
                                      legend.text = element_text(size = 36, margin = margin(t=16)),
                                      strip.text.x = element_text(size = 32),
                                      axis.text.x = element_text(size = 38, margin = margin(t=16)),
                                      axis.text.y = element_text(size = 40, margin = margin(r=16)),
                                      axis.title.x = element_text(size = 50, margin = margin(t=40, b = 40)),
                                      axis.title.y = element_text(size = 50, margin = margin(r=40)))
                
                dev.off()
                
                

        
#END CREATE UNIFIED DATASET --------------------------------------------------------------------------------
                        
                        
                        
                        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#FILTER DATA ------------------------------------------------------------------------------

        #Note: I'm going to try to filter some of the data by the parameters that were used
        #by Hu et al. (2017) - hopefully, this will reduce some of the variation
        
                #Copy expanded dataset
                filt <- unified_exp
                
                #Filter to forest dominated by spruce, pine, or birch (no mixed)
                filt <- filt[filt$treslag %in% c("Grandominert", "Lauvdominert", "Furudominert"),]
                
                #Filter to homogenous forest (>75% coverage)
                
                        ggplot(data = subset(filt, Species == "Birch"), aes(x = Ms_Dnst, y = Albedo, color = Plot)) +
                                geom_point(alpha = 0.1) +
                                geom_smooth(method = NULL) +
                                facet_wrap(~ Month) +
                                scale_y_continuous(limits = c(0,1), breaks = c(0,0.2,0.4,0.6,0.8,1))
                        
        
                                        
#END FILTER DATA ------------------------------------------------------------------------------
                        