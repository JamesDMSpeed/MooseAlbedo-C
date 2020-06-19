##Script to process annual tree data from SUSTHERB sites


##PACKAGES ----------------------------------------------------------------------------------------

#Packages for data processing + visualization
library(dplyr)
library(tidyr)
library(ggplot2)

#Packages for calculating volume using NFI allometric equations (same equations used in NFI and Sat-Skog product)
library(sitree)
library(sitreeE)

###END PACKAGES ----------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#INITIAL DATA IMPORT ----------------------------------------------------------------------------------------------

#Import CSV to dataframe
data <- read.csv('1_Albedo_Exclosures/Data/Tree_Data/sustherb_tree_data.csv', header = TRUE)

#END INITIAL DATA IMPORT --------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#DATA FILTERING ----------------------------------------------------------------------------------------------

#Summary: 
##  The code below filters data to that is from Trøndelag, the year 2016, and trees under 6m in height.
##  This is done since 2016 is the only year with 'Diameter at Ground Level' (DGL) measurements for all trees
##  Additionally, Trøndelag is the only region with these complete measurements
##  Also, there is not an allometric equation for Juniperus communis (or other shrubs) available
##  Finally, as in Kolstad et al. (2017), trees over 6m in 2016 are likely leftover from forestry operations - thus they
##  are excluded.


#Filter to 'Trøndelag' region only
trondelag <- data[data$Region == 'Trøndelag',]

#Format date column properly (to R date format)
trondelag$X_Date <- as.Date(as.character(trondelag$X_Date), format = "%m/%d/%y")

#Filter to data from year 2016 only 
t2016 <- trondelag[trondelag$X_Date >= "2016-01-01" & trondelag$X_Date <= "2016-12-31",]

#Remove rows that are missing diameter-at-base data (3 total)
t2016 <- t2016[! is.na(t2016$Diameter_at_base_mm), ]

#Convert LocalityCode, Treatment, & Plot to character
t2016$LocalityCode <- as.character(t2016$LocalityCode)
t2016$Treatment <- as.character(t2016$Treatment)
t2016$Plot <- as.character(t2016$Plot)

#Exclude trees > 6m (600cm)
t2016 <- t2016[t2016$Height_cm <= 600,]

#Check on Juniperus communis distribution between treatments - does one treatment have much more than the other?
table(t2016$Taxa, t2016$Treatment)

#Mostly in browsed plots - may confound results. How should I handle this?


#Add blank columns to hold tree volume estimates

#Volume With Bark
t2016$VolumeB_cm3 <- c('')

#Volume Without Bark
t2016$VolumeNB_cm3 <- c('')


#END DATA FILTERING --------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#VOLUME ESTIMATES FOR EACH TREE ---------------------------------------------------

#Summary:
##   This script uses allometric volume equations used by the Norwegian National Forest Inventory (NFI).
##   These allometric equations are also used to produce volume estimates in NIBIO data products (such as Sat-Skog)
##   Specific equations correspond to specific tree species.

#Key limitation:
##   These allometric equations use 'Diameter at Breast Height' (DBH) instead of 'Diameter at Ground Level' (DGL),
##   which is used for SUSTHERB measurements. Thus, this analysis removes all trees below 150cm (which don't have a DBH
##   measurement at 150cm)

#Filter to only trees that have DBH measurement at 150cm
t2016 <- t2016[!is.na(t2016$Diameter_at_150cm_mm),]

#Volume Calculations Using sitreeE package:

#Loop through each row of the dataframe (2016, Trøndelag, <6m height) and produce a volume estimate
for(row in 1:nrow(t2016)){
        
        #Get tree species
        tree_species <- as.character(t2016[row, "Taxa"])
        spec_code <- ''
        
        #Get 'Diameter at Breast Height' - measurement at 150cm height (mm)
        d150 <- as.numeric(t2016[row, "Diameter_at_base_mm"])
        
        #Get height (converted from 'cm' to 'dm' for use in sitree functions)
        hgt <- as.numeric(t2016[row, "Height_cm"])
        print(hgt)
        
        #Species-specific volume calculations 
        #NOTE: Using DGL instead of DBH in allometric equations
        
        #Get species code (this code is found in the NFI Field Manual, and is used in the sitreeE function below)
        
        if( tree_species == "Picea abies (Gran)"){
                
                #Spruce (Picea abies) - Specific Allometric Equation from sitree package
                
                #With Bark - cm3
                volbark <- GranVol(dbh = d150,
                                   trh = hgt,
                                   bark ="mb",
                                   enhet = "c")
                
                #Without Bark - cm3
                volnobark <- GranVol(dbh = d150,
                                     trh = hgt,
                                     bark ="ub",
                                     enhet = "c")
                
                ###GranVol CHECKS OUT
                
        } else if( tree_species == "Pinus sylvestris (Furu)" || tree_species == "Juniperus communis (Einer)" ){
                
                #Pine (Pinus sylvestris) & Juniper 
                #NOTE: LIMITATION - Juniper does not have a specific allometric function for tree volume (using spruce eq.)
                
                #With Bark - cm3
                volbark <- FuruVol(dbh = d150,
                                   trh = hgt,
                                   bark ="mb",
                                   enhet = "c")
                
                #Without Bark - cm3
                volnobark <- FuruVol(dbh = d150,
                                     trh = hgt,
                                     bark ="ub",
                                     enhet = "c")
                
                ###FuruVol DOES NOT WORK
                ##No bark is larger in volume than with bark
                
        } else {
                
                #Deciduous species ('Lauv')
                ##Note: these species have an associated 'species code' (as defined by the NFI)
                ##This species code must be included in the functions below
                
                if( tree_species == "Sorbus aucuparia (Rogn)" ){
                        
                        #Rowan (Sorbus aucuparia)
                        spec_code <- 53
                        
                } else if( tree_species == "Salix caprea (Selje)" ){
                        
                        #Goat willow (Salix caprea)
                        spec_code <- 52
                        
                } else if ( tree_species == "Betula pubescens (Bjørk)" || tree_species == "Betula pendula (Lavlandbjørk)" ){
                        
                        #Birch (Betula pubescens & Betula pendula)
                        spec_code <- 30
                        
                }
                
                #Calculate volume for relevant deciduous species
                
                #With Bark - cm3
                volbark <- LauvVol(tsl = spec_code,
                                   dbh = d150,
                                   trh = hgt,
                                   bark ="mb",
                                   enhet = "c")
                
                #Without Bark - cm3
                volnobark <- LauvVol(tsl = spec_code,
                                     dbh = d150,
                                     trh = hgt,
                                     bark ="ub",
                                     enhet = "c")
                
        }
        
        
        
        #Add calculated volumes to relevant columns of main dataframe
        
        #Volume With Bark
        t2016[row, "VolumeB_cm3"] <- volbark
        
        #Volume Without Bark
        t2016[row, "VolumeNB_cm3"] <- volnobark
        
        
}

#Ensure that 'Volume' columns are numeric
t2016$VolumeB_cm3 <- as.numeric(t2016$VolumeB_cm3)
t2016$VolumeNB_cm3 <- as.numeric(t2016$VolumeNB_cm3)

#END VOLUME ESTIMATES FOR EACH TREE -----------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




##Still need to work on this below


#SUMMED BIOMASS ESTIMATES FOR EACH SUBPLOT ---------------------------------------------------

#NOTE: 'NH' subplot for 'UB' treatment at '1NSUB' had no observations (this is why subplot_sums has 119 rows instead of 120)
subplot_sums <- aggregate(t2016$Biomass, by = list(LocalityCode= t2016$LocalityCode, Treatment = t2016$Treatment, Plot = t2016$Plot), FUN = sum)
names(subplot_sums)[4] <- "Biomass"

#Explore the data
ggplot(subplot_sums, aes(Biomass)) +
        geom_histogram(bins = 20)

#WRITE FINAL DATAFRAME TO CSV --------------------------------------------------
write.csv(subplot_sums, file = '1_Albedo_Exclosures/Approach_1/Output/Tree_Volumes/sustherb_biomass_2016.csv', row.names = TRUE)

