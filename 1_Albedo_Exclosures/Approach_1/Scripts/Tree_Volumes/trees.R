##Script to process annual tree data from SUSTHERB sites

##Load relevant packages
library(dplyr)
library(tidyr)
library(ggplot2)

#INITIAL DATA IMPORT --------------------------------------------------
data <- read.csv('1_Albedo_Exclosures/Data/Tree_Data/sustherb_tree_data.csv', header = TRUE)


#DATA FILTERING --------------------------------------------------

        #Filter to 'Trøndelag' region only
        trondelag <- data[data$Region == 'Trøndelag',]
        
        #Format date column
        trondelag$X_Date <- as.Date(as.character(trondelag$X_Date), format = "%m/%d/%y")
        
        #Filter to 2016 only (since 2016 is only year with consistent height and diameter-at-base data)
        t2016 <- trondelag[trondelag$X_Date >= "2016-01-01" & trondelag$X_Date <= "2016-12-31",]
        
        #Remove rows that are missing diameter-at-base data (3 total)
        t2016 <- t2016[! is.na(t2016$Diameter_at_base_mm), ]
        
        #Convert LocalityCode, Treatment, & Plot to character
        t2016$LocalityCode <- as.character(t2016$LocalityCode)
        t2016$Treatment <- as.character(t2016$Treatment)
        t2016$Plot <- as.character(t2016$Plot)
        
        #Exclude trees > 6m (600cm), as in Kolstad et al. (2017)
        t2016 <- t2016[t2016$Height_cm < 600,]
        
        #Add blank row to hold biomass estimates
        t2016$Biomass <- c('')

            
#BIOMASS ESTIMATES FOR EACH TREE ---------------------------------------------------

#NOTE: This script uses allometric biomass equations previously developed by Kolstad et al. (2017)
## As in the methods used by Kolstad et al. (2017), the model for Betula pubesecens is used for
## Betula pendula and Salix caprea, while the model for Picea abies is used for Juniperus communis


for(row in 1:nrow(t2016)){
        
        #Species
        species <- as.character(t2016[row, "Taxa"])
        
        #Diameter (converted to meters)
        dgl <- as.numeric(t2016[row, "Diameter_at_base_mm"])/1000
        
        #Height (converted to meters)
        height <- as.numeric(t2016[row, "Height_cm"])/100
        
        #Betula pubescens model (Birch)
        if( species == "Betula pubescens (Bjørk)" || species == "Betula pendula (Lavlandbjørk)" || species == "Salix caprea (Selje)" ){
                
                biomass <- (0.078843)*(dgl^2) + (0.009197)*(height^2)
                
        }
        
        #Picea abies model (Spruce)
        else if( species == "Picea abies (Gran)" || species == "Juniperus communis (Einer)"){
               
                biomass <- (0.020293)*(dgl^2) + (0.006092)*(height^3)
                
        }
        
        #Pinus sylvestris model (Pine)
        else if( species == "Pinus sylvestris (Furu)" ){
                
                biomass <- (0.325839)*(dgl^2) + (0.0007434)*(height^3)
                
        }
        
        #Sorbus aucuparia model (Rowan)
        else if( species == "Sorbus aucuparia (Rogn)" ){
               
                #Treatment
                treatment <- as.character(t2016[row, "Treatment"])
                
                #Browsed Model
                if( treatment == "B" ){
                        
                        biomass <- (0.006664)*(dgl^2) + (0.082983)*(height^2)
                        
                }
                
                #Unbrowsed Model
                if( treatment == "UB" ){
                        
                        biomass <- (0.0053962)*(height^2)
                        
                }
                
        }
        
        #Add calculated biomass to 'Biomass' column
        t2016[row, "Biomass"] <- biomass
        
}

t2016$Biomass <- as.numeric(t2016$Biomass)
        
#SUMMED BIOMASS ESTIMATES FOR EACH SUBPLOT ---------------------------------------------------

#NOTE: 'NH' subplot for 'UB' treatment at '1NSUB' had no observations (this is why subplot_sums has 119 rows instead of 120)
subplot_sums <- aggregate(t2016$Biomass, by = list(LocalityCode= t2016$LocalityCode, Treatment = t2016$Treatment, Plot = t2016$Plot), FUN = sum)
names(subplot_sums)[4] <- "Biomass"

#Explore the data
ggplot(subplot_sums, aes(Biomass)) +
        geom_histogram(bins = 20)

#WRITE FINAL DATAFRAME TO CSV --------------------------------------------------
write.csv(subplot_sums, file = '1_Albedo_Exclosures/Approach_1/Output/Tree_Volumes/sustherb_biomass_2016.csv', row.names = TRUE)

