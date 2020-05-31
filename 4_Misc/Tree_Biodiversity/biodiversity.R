##Analysis of SUSTHERB Tree Biodiversity

#Load relevant packages
library(ggplot2)
library(dplyr)
library(sp)
library(raster)
library(vegan)
library(GGally)
library(lme4)

#Main Data handling

        #Read in CSV files
        data <- read.csv('3_Tree_Biodiversity/1_Data/CSV/sustherb_trees.csv', header = TRUE)
        hedmark_2019 <- read.csv('3_Tree_Biodiversity/1_Data/CSV/hedmark_trees_2019.csv', header = TRUE)
        telemark_2019 <- read.csv('3_Tree_Biodiversity/1_Data/CSV/telemark_trees_2019.csv', header = TRUE)
        
        #Define main dataframe
        data <-rbind(data, hedmark_2019, telemark_2019)
        
        #Remove rows that aren't identified or have no trees present
        data <- data[data$Taxa != 'Not identified (Ukjent)' & data$Taxa != 'No occurrence (Ingen)',]
        data$Taxa <- as.factor(as.character(data$Taxa))
        
        #Convert date column to 'date' class
        data$X_Date <- as.Date(data$X_Date, format = "%m/%d/%y")
        
        #Remove trailing space in 'Stangeskovene Eidskog' LocalityName
        data$LocalityName <- as.character(data$LocalityName)
        data$LocalityName[data$LocalityName == 'Stangeskovene Eidskog '] <- 'Stangeskovene Eidskog'
        
#Secondary Data Handling
        
        #Productivity Data
        productivity <- read.csv('3_Tree_Biodiversity/1_Data/CSV/productivity_all_sites.csv', header = TRUE)
        
                #Add LocalityCode column
                productivity$Region <- as.character(productivity$Region)
                productivity$LocalityName <- as.character(productivity$LocalityName)

        #Treatment Duration Data
        duration <- read.csv('3_Tree_Biodiversity/1_Data/CSV/sustherb_sites_summary.csv', header = TRUE)
        duration <- duration[! is.na(duration$DistrictID),]
        duration$LocalityName <- as.character(duration$LocalityName)
        duration$LocalityCode <- as.character(duration$LocalityCode)
        
        #Herbivore Density Data

                #Read in herbivore biomass data (2015) from SpatialPolygons object (isolate dataframe)
                hbiomass_shp <- shapefile("2_Albedo_Regional/1_Data/Herbivore_density/NorwayLargeHerbivores")
                hbiomass <- hbiomass_shp@data
                hbiomass2015<- cbind(hbiomass[,c(1:10)], hbiomass$Ms_2015, hbiomass$Rd__2015, hbiomass$R_d_2015)

                        
        

#2018 TEST ANALYSIS ---------------------------------------------------------------
        
        #Filter to 2018
        df2018 <- data[data$X_Date >= "2018-01-01" & data$X_Date <= "2018-12-31",]
        
        #Aggregate
        plot_sums_2018 <- aggregate(df2018$Quantity, by = list(Region = df2018$Region, LocalityName = df2018$LocalityName, LocalityCode = df2018$LocalityCode, Treatment = df2018$Treatment, Taxa = df2018$Taxa), FUN = sum)
        names(plot_sums_2018)[6] <- "Quantity"
        
                #Create blank columns to hold data
        
                        #Blank column for 'diversity index values'
                        plot_sums_2018$Inverse_Simpsons <- ''
                        
                        #Blank column for total number of trees
                        plot_sums_2018$Total_trees <- ''
                        
                        #Blank columns for each tree species
                        species_names <- levels(plot_sums_2018$Taxa)
                        
                        for(i in levels(plot_sums_2018$Taxa)){
                                plot_sums_2018[i] <- ''
                        }
                        
                        #Add blank columns to hold productivity, herbivore density, duration, and 'species number' values
                        plot_sums_2018["Productivity"] <- ''
                        plot_sums_2018["Moose_density"] <- ''
                        plot_sums_2018["Red_deer_density"] <- ''
                        plot_sums_2018["Roe_deer_density"] <- ''
                        plot_sums_2018["Duration_treatment"] <- ''
                        
                        #Create blank dataframe to hold final columns
                        final_2018 <- data.frame()
                        
                #Fix factor issues
                plot_sums_2018$Region <- as.character(plot_sums_2018$Region)
                plot_sums_2018$LocalityCode <- as.factor(as.character(plot_sums_2018$LocalityCode))
                plot_sums_2018$LocalityName <- as.factor(as.character(plot_sums_2018$LocalityName))
                
                #Loop through each locality code and calculate inv simpson's index
                for(i in levels(plot_sums_2018$LocalityCode)){
                        
                        #Subset to specific locality code
                        temp <- plot_sums_2018$Quantity[plot_sums_2018$LocalityCode == i]
                        
                        #Get current site 'locality name'
                        sn <- plot_sums_2018$LocalityName[plot_sums_2018$LocalityCode == i][1]
                        
                        #Get current treatment
                        tr <- plot_sums_2018$Treatment[plot_sums_2018$LocalityCode == i][1]
                        
                        #Get current site 'District ID' (Kommune ID)
                        district <- duration$DistrictID[duration$LocalityCode == i]
                        
                        #Set current year
                        year <- 2018
                        
                        #Calculate diversity index -----------------
                                
                                #Diversity Function
                                results <- diversity(temp, index = "invsimpson")
                        
                                #Add to column
                                plot_sums_2018$Inverse_Simpsons[plot_sums_2018$LocalityCode == i] <- as.numeric(results)
                        
                        #Calculate total number of trees ------------------
                        
                                #Sum quantities specific to locality code
                                tree_sum <- sum(plot_sums_2018$Quantity[plot_sums_2018$LocalityCode == i])
                                
                                #Add to column
                                plot_sums_2018$Total_trees[plot_sums_2018$LocalityCode == i] <- tree_sum
                                
                        #Calculate tree proportions for all observed species -----------------
                                
                                #Loop through all species and calculate proportions
                                for(x in species_names){
                                        plot_sums_2018[plot_sums_2018$LocalityCode == i, x] <- sum(plot_sums_2018$Quantity[plot_sums_2018$LocalityCode == i & plot_sums_2018$Taxa == x]) / tree_sum
                                }
                        
                  
                        #Add corresponding productivity, herbivore density, and durations
                                
                                #Get corresponding productivity index value
                                p <- productivity[productivity$LocalityName == sn, "Productivity"]
                                
                                #Get corresponding moose density value
                                md <- hbiomass2015$`hbiomass$Ms_2015`[hbiomass$KOMMUNE == district]
                                
                                #Get corresponding red deer density value
                                red <- hbiomass2015$`hbiomass$Rd__2015`[hbiomass$KOMMUNE == district]
                                
                                #Get corresponding roe deer density value
                                roe <- hbiomass2015$`hbiomass$R_d_2015`[hbiomass$KOMMUNE == district]
                                
                                #Get duration of treatment
                                dur <- duration[duration$LocalityCode == i, "Year.initiated"]
                                dur <- year - dur
                                
                                #Add values to existing dataframe
                                plot_sums_2018$Productivity[plot_sums_2018$LocalityCode == i] <- p
                                plot_sums_2018$Duration_treatment[plot_sums_2018$LocalityCode == i] <- dur 
                                
                                #Add densities based on treatment
                                if( tr == "B" ){
                                        plot_sums_2018$Moose_density[plot_sums_2018$LocalityCode == i] <- md
                                        plot_sums_2018$Red_deer_density[plot_sums_2018$LocalityCode == i] <- red
                                        plot_sums_2018$Roe_deer_density[plot_sums_2018$LocalityCode == i] <- roe
                                } else if ( tr == "UB") {
                                        plot_sums_2018$Moose_density[plot_sums_2018$LocalityCode == i] <- 0
                                        plot_sums_2018$Red_deer_density[plot_sums_2018$LocalityCode == i] <- 0
                                        plot_sums_2018$Roe_deer_density[plot_sums_2018$LocalityCode == i] <- 0
                                }
                                
                        #Bind and simplify 1st row from each locality code to final df
                        temp_row <- plot_sums_2018[plot_sums_2018$LocalityCode == i, c(1:4, 7:25)][1,]
                        final_2018 <- rbind(final_2018, temp_row)
                        
                }
        
        #Data fixes before plotting
                
                #Ensure columns are numeric
                final_2018$Inverse_Simpsons <- as.numeric(final_2018$Inverse_Simpsons)
                final_2018$Productivity <- as.numeric(final_2018$Productivity)
                final_2018$Moose_density <- as.numeric(final_2018$Moose_density)
                final_2018$Red_deer_density <- as.numeric(final_2018$Red_deer_density)
                final_2018$Roe_deer_density <- as.numeric(final_2018$Roe_deer_density)
                final_2018$Duration_treatment <- as.numeric(final_2018$Duration_treatment)
        
        #Plot initial data
        ggplot(final_2018, aes(x = Treatment, y = Inverse_Simpsons, fill = Treatment)) +
                geom_boxplot()
        
        #Correlation Matrix w/ Explanatory Variables (Productivity, Herbivore Densities, and Duration of Treatment)
        ggpairs(data = final_2018, columns = c(19:23))
        
                #Roe deer density is slightly correlated with moose density (0.454)
        
        
        #Data Exploration/Visualization ---------------------------------
        
                #Histograms
                hist(final_2018$Inverse_Simpsons) #Pretty normal distribution
                hist(final_2018$Productivity) #A few outliers
                hist(final_2018$Moose_density)
        
                #Paired Histograms
                ggplot(final_2018, aes(final_2018$Productivity, fill = final_2018$Treatment)) +
                        geom_histogram()
        
        #Model 1 ---------------------------------
                
                #Mixed Effects Model (Random intercept for 'LocalityName')
                m1 <- lmer(Inverse_Simpsons ~ Treatment + Productivity + Moose_density + Red_deer_density + Roe_deer_density + Duration_treatment + (1 | LocalityName), final_2018)
                isSingular(m1)
                summary(m1)
        
                        #Not significant and high std. error
                
                        #Plot residuals
                        plot(m1) 
                
                        #Residuals here indicate that something is going on (positive linear trend)
        
#--------------- QUESTION: Would moose density be 0 in unbrowsed treatments?
        
        #Model 2 (No Densities)
                
                #Mixed Effects Model (Random intercept for 'LocalityName')
                m2 <- lmer(Inverse_Simpsons ~ Treatment + Productivity + Duration_treatment + (1 | LocalityName), final_2018)
                summary(m2)
                
                #Plot residuals
                plot(m2)
                
        #Model 3 (Treatment + Random Intercept)
                
                #Mixed Effects Model (Random intercept for 'LocalityName')
                m3 <- lmer(Inverse_Simpsons ~ Treatment + (1 | LocalityName), final_2018)
                summary(m3)
                
                #Plot residuals
                plot(m3)
        
        #Model 4 (Treatment + Interaction Terms + Site Term)
               
                #Mixed Effects Model (Random intercept for 'LocalityName')
                m4 <- lmer(Inverse_Simpsons ~ Treatment + Productivity + Duration_treatment + Productivity*Duration_treatment + Productivity*Treatment +  Moose_density + Red_deer_density + Roe_deer_density + (1 | LocalityName), final_2018)
                summary(m4)
                
                #Plot residuals
                plot(m4)
                
                             
##END OF 2018 TEST ANALYSIS----------------------------------------------------------
