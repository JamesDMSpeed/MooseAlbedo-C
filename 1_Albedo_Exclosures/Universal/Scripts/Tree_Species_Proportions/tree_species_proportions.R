##Script to provide proportions of the 3 classes of trees used in the albedo model (spruce, pine, and birch/deciduous)
##NOTE: These proportions are on the PLOT LEVEL (i.e. LocalityCode) - NOT on the subplot level

##PACKAGES ----------------------------------------------------------------------------------------

        #Packages for general data manipulation + visualization
        library(ggplot2)
        library(dplyr)
        library(RColorBrewer)
        library(wesanderson)

###END PACKAGES ----------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#INITIAL DATA IMPORT + FILTERING --------------------------------------------------------------------------

        #Import SustHerb tree density data
        data <- read.csv('1_Albedo_Exclosures/Data/Tree_Data/sustherb_tree_data.csv', header = TRUE)
        
        #Remove rows that aren't identified or have no trees present
        data <- data[data$Taxa != 'Not identified (Ukjent)' & data$Taxa != 'No occurrence (Ingen)' & data$Quantity != 0,]
        data$Taxa <- as.factor(as.character(data$Taxa))
        
        #Convert date column to 'date' class
        data$X_Date <- as.Date(data$X_Date, format = "%m/%d/%y")
        
        #Remove trailing space in 'Stangeskovene Eidskog' LocalityName
        data$LocalityName <- as.character(data$LocalityName)
        data$LocalityName[data$LocalityName == 'Stangeskovene Eidskog '] <- 'Stangeskovene Eidskog'

#END INITIAL DATA IMPORT + FILTERING ----------------------------------------------------------------------
        
        
        
        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#CALCULATE SPECIES PROPORTIONS BY YEAR -----------------------------------------------------------------------
        
        #Add a year column to make aggregation step below easier
                
                #Add a blank placeholder column
                data$Year <- ''
        
                #For each row, add year to 'Year' column
                for(i in 1:nrow(data)){
                        data[i, "Year"] <- format(data[i, "X_Date"], "%Y")
                }
        
        #Aggregate
        agg <- aggregate(data$Quantity, by = list(Region = data$Region, LocalityName = data$LocalityName, LocalityCode = data$LocalityCode, Year = data$Year, Treatment = data$Treatment, Taxa = data$Taxa), FUN = sum)
        names(agg)[7] <- "Quantity"
        
        #Calculate species proportions in new dataframe
        
                #Get list of site codes in a vector
                agg$LocalityCode <- as.factor(agg$LocalityCode)
                site_codes <- levels(agg$LocalityCode)
                
                #Create placeholder column for totals by site and year
                agg$Total_trees <- ''
                
                #For each site code (for each year), calculate total # of trees
                for(i in 1:length(site_codes)){
                        
                        print(site_codes[i])
                        
                        #Get min and max years for study site 'i'
                        min_year <- min(agg$Year[agg$LocalityCode == site_codes[i]])
                        max_year <- max(agg$Year[agg$LocalityCode == site_codes[i]])
                        
                        #For each year, sum total trees and add to 'totals' column
                        for(j in min_year:max_year){
                                
                                print(j)
                                
                                #Sum trees
                                yearly_total <- sum(agg$Quantity[agg$LocalityCode == site_codes[i] & agg$Year == j])
                                
                                #Add to 'totals column'
                                agg$Total_trees[agg$LocalityCode == site_codes[i] & agg$Year == j] <- yearly_total
                        }
                        
                }
                
                #Ensure 'Total trees' column is numeric
                agg$Total_trees <- as.numeric(agg$Total_trees)
                
                #Create new dataframe to hold final proportions for 3 'classes' of trees used in albedo model
                final <- data.frame("LocalityName" = '', "LocalityCode" = '', "Year" = '', "Prop_spruce" = '', "Prop_pine" = '', "Prop_birch" = '')
        
                #For each site code (for each year), calculate proportions of each class of tree
                for(i in 1:length(site_codes)){
                        
                        print(site_codes[i])
                        
                        #Get min and max years for study site 'i'
                        min_year <- min(agg$Year[agg$LocalityCode == site_codes[i]])
                        max_year <- max(agg$Year[agg$LocalityCode == site_codes[i]])
                        
                        #Get LocalityName
                        local <- agg$LocalityName[agg$LocalityCode == site_codes[i]][1]
                        
                        #For each year, get proportions for each tree class
                        for(j in min_year:max_year){
                                
                                print(j)
                                
                                #Spruce proportion (NOTE: Includes Juniperus communis)
                                spruce_prop <- sum(agg$Quantity[agg$LocalityCode == site_codes[i] & agg$Year == j & (agg$Taxa == "Picea abies (Gran)" | agg$Taxa == "Juniperus communis (Einer)")]) / agg$Total_trees[agg$LocalityCode == site_codes[i] & agg$Year == j][1] 
                                
                                #Pine proportion
                                pine_prop <- sum(agg$Quantity[agg$LocalityCode == site_codes[i] & agg$Year == j & agg$Taxa == "Pinus sylvestris (Furu)"]) / agg$Total_trees[agg$LocalityCode == site_codes[i] & agg$Year == j][1] 

                                #Birch/Deciduous proportion (i.e. all other species)
                                decid_prop <- sum(agg$Quantity[agg$LocalityCode == site_codes[i] & agg$Year == j & agg$Taxa != "Picea abies (Gran)" & agg$Taxa != "Juniperus communis (Einer)" & agg$Taxa != "Pinus sylvestris (Furu)"]) / agg$Total_trees[agg$LocalityCode == site_codes[i] & agg$Year == j][1]
                        
                                temp <- data.frame("LocalityName" = local, "LocalityCode" = site_codes[i], "Year" = j, "Prop_spruce" = spruce_prop, "Prop_pine" = pine_prop, "Prop_birch" = decid_prop)
                                final <- rbind(final, temp)
                                
                        }
                        
                }
                
        #Final Data Cleanup
        final$Prop_spruce <- as.numeric(final$Prop_spruce)
        final$Prop_pine <- as.numeric(final$Prop_pine)                
        final$Prop_birch <- as.numeric(final$Prop_birch)
        final <- final[! is.na(final$Prop_spruce),]
        
#END CALCULATE SPECIES PROPORTIONS BY YEAR ----------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#WRITE TO OUTPUT --------------------------------------------------------------------------
        
        #Write CSV to Output Folder
        write.csv(final, file = '1_Albedo_Exclosures/Universal/Output/Tree_Species_Proportions/tree_species_proportions_plot_level.csv', row.names = TRUE)
        
#END WRITE TO OUTPUT ----------------------------------------------------------------------
        