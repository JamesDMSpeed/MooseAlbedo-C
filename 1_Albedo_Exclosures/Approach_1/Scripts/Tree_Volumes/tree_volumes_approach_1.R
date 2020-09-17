##Script to process annual tree data from SUSTHERB sites


##PACKAGES ----------------------------------------------------------------------------------------

        #Packages for data processing + visualization
        library(dplyr)
        library(tidyr)
        library(ggplot2)

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
        ##NOTE: This reduces the number of study sites (LocalityName) to 15 (w/ 30 total plots)
        trondelag <- data[data$Region == 'Trøndelag',]
        
        #Format date column properly (to R date format)
        trondelag$X_Date <- as.Date(as.character(trondelag$X_Date), format = "%m/%d/%y")
        
        #Format LocalityName and LocalityCode as factors
        trondelag$LocalityCode <- as.factor(trondelag$LocalityCode)
        trondelag$LocalityName <- as.factor(trondelag$LocalityName)
        
        #LocalityName to lowercase
        trondelag$LocalityName <- tolower(trondelag$LocalityName)
        
        #Filter to data from year 2016 only 
        t2016 <- trondelag[trondelag$X_Date >= "2016-01-01" & trondelag$X_Date <= "2016-12-31",]
        
        #Remove rows that are missing diameter-at-base data (3 total)
        removed <- t2016[is.na(t2016$Diameter_at_base_mm), ]
        t2016 <- t2016[! is.na(t2016$Diameter_at_base_mm), ]
        
        #Convert LocalityCode, Treatment, & Plot to character
        #t2016$LocalityCode <- as.character(t2016$LocalityCode)
        #t2016$Treatment <- as.character(t2016$Treatment)
        #t2016$Plot <- as.character(t2016$Plot)
        
        #Exclude trees > 6m (600cm)
        t2016 <- t2016[t2016$Height_cm <= 600,]
        
        #Check on Juniperus communis distribution between treatments - does one treatment have much more than the other?
        table(t2016$Taxa, t2016$Treatment)
        
                #Mostly in browsed plots - may confound results. How should I handle this?
        
        
        #Add blank columns to hold tree volume estimates
                
                #Volume
                t2016$Volume_m3 <- as.numeric(c(''))
        
                
                #Biomass
                t2016$Biomass_g <- as.numeric(c(''))

        
#END DATA FILTERING --------------------------------------------------------------------------------



        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\



        
#CALCULATE VOLUME & BIOMASS ESTIMATES FOR EACH TREE ---------------------------------------------------
  
        #SPECIFIC WOOD DENSITIES TO CONVERT BIOMASS TO VOLUME
        ##Note: These are average wood densities for spruce, pine, and birch - provided by Repola (2006)
        
                #This will likely be a major source of error - according to Repola (2006), density varies widely vertically
        
                #Spruce density (kg/m3 converted to g/cm3)
                s_density <- 385.3 / 1000
                
                #Pine density (kg/m3 converted to g/cm3)
                p_density <- 412.6 / 1000
                
                #Birch density (kg/m3 converted to g/cm3)
                b_density <- 475 / 1000
        
        #Loop through each row of the dataframe (2016, Trøndelag, <6m height) and produce a volume estimate
        for(row in 1:nrow(t2016)){
                
                #IDENTIFY SPECIES + HEIGHT
                
                        #Get tree species
                        species <- as.character(t2016[row, "Taxa"])

                        #Get 'Diameter at Ground Level' (mm)
                        dgl <- as.numeric(t2016[row, "Diameter_at_base_mm"])
        
                        #Get height (cm)
                        height <- as.numeric(t2016[row, "Height_cm"])

                #CALCULATE BIOMASS FOR EACH TREE USING SUSTHERB ALLOMETRIC EQUATIONS
                
                        #Betula pubescens model (Birch)
                        if( species == "Betula pubescens (Bjørk)" || species == "Betula pendula (Lavlandbjørk)" || species == "Salix caprea (Selje)" ){
                                
                                #Biomass (g)
                                biomass <- (0.078843)*(dgl^2) + (0.009197)*(height^2)
                                
                                #Volume (cm3 converted to m3)
                                volume <- (biomass / b_density) / 1e06
                                
                        }
                        
                        #Picea abies model (Spruce)
                        else if( species == "Picea abies (Gran)" || species == "Juniperus communis (Einer)"){
                                
                                #Biomass (g)
                                biomass <- (0.020293)*(height^2) + (0.006092)*(dgl^3)
                                
                                #Volume (cm3 converted to m3)
                                volume <- (biomass / s_density) / 1e06
                                
                        }
                        
                        #Pinus sylvestris model (Pine)
                        else if( species == "Pinus sylvestris (Furu)" ){
                                
                                #Biomass (g)
                                biomass <- (0.325839)*(dgl^2) + (0.0007434)*(dgl^3)
                                
                                #Volume (cm3 converted to m3)
                                volume <- (biomass / p_density) / 1e06
                                
                        }
                        
                        #Sorbus aucuparia model (Rowan)
                        else if( species == "Sorbus aucuparia (Rogn)" ){
                                
                                #Treatment
                                treatment <- as.character(t2016[row, "Treatment"])
                                
                                #Browsed Model
                                if( treatment == "B" ){
                                        
                                        #Biomass (g)
                                        biomass <- (0.006664)*(height^2) + (0.082983)*(dgl^2)
                                        
                                }
                                
                                #Unbrowsed Model
                                if( treatment == "UB" ){
                                        
                                        #Biomass (g)
                                        biomass <- (0.0053962)*(height^2)
                                        
                                }
                                
                                #Volume (cm3 converted to m3)
                                #Using birch average specific wood density from Repola (2006)
                                volume <- (biomass / b_density) / 1e06
                                
                        }
                        
                        #Add calculated biomass to 'Biomass' column
                        t2016[row, "Biomass_g"] <- biomass
                        
                        #Add calculated volume (m3) to 'Volume' column
                        t2016[row, "Volume_m3"] <- volume
                        
                                
                
        }
        
        #Ensure that 'Volume' & 'Biomass' columns are numeric
        t2016$Volume_m3 <- as.numeric(t2016$Volume_m3)
        t2016$Biomass_g <- as.numeric(t2016$Biomass_g)
        
#END CALCULATE VOLUME & BIOMASS ESTIMATES FOR EACH TREE --------------------------------------------------------
        
        
        
        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        
        
        
        
#CALCULATE TOTAL VOLUME FOR EACH SUBPLOT -------------------------------------------------------------------------

        #NOTE: 'NH' subplot for 'UB' treatment at '1NSUB' had no observations 
        
        #Sum all subplots together to produce a PLOT-LEVEL estimate of volume
        plot_sums <- aggregate(t2016$Volume_m3, by = list(LocalityName = t2016$LocalityName, LocalityCode= t2016$LocalityCode, Treatment = t2016$Treatment), FUN = sum)
        names(plot_sums)[4] <- "Volume_m3"
        
        #Calculate volume/area (which is used in the albedo model)
        
                #Create placeholder column
                plot_sums$Volume_m3_ha <- as.numeric("")
                
                #Convert summed area of all circular subplots for a given plot to hectares (ha)
                
                        #Each subplot has a radius of 2m - A = pi*r^2
                        subplot_area <- pi*(2^2) #12.57m2
                        
                        #Sum 4 subplots together to get total plot area in m2
                        plot_area <- 4*subplot_area #50.26548m2
                        
                        #Convert m2 to hectares (ha) - 1m2 = 0.0001 ha (divide by 10,000)
                        plot_area_ha <- plot_area/10000
                        
                #Divide total summed plot volume (m3) by summed plot area (ha)
                plot_sums$Volume_m3_ha <- plot_sums$Volume_m3 / plot_area_ha
        
        
        
        
#END CALCULATE TOTAL VOLUME FOR EACH SUBPLOT -------------------------------------------------------------------------
        
        
        
        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        
        
        
        
#DATA VISUALIZATION ------------------------------------------------------------------------------------------
        
        #Make sure data has correct class
        plot_sums$Volume_m3 <- as.numeric(plot_sums$Volume_m3)
        plot_sums$Volume_m3_ha <- as.numeric(plot_sums$Volume_m3_ha)
        plot_sums$Treatment <- as.factor(plot_sums$Treatment)
        
        
        #Boxplot to visualize difference in volume by treatment
        vol_plot <- ggplot(data = plot_sums, aes(x = Treatment, y = Volume_m3_ha, fill = Treatment)) +
                geom_boxplot() +
                ggtitle("Range of plot volumes for SustHerb study sites") +
                labs(x = "Site Treatment", y = bquote("Summed plot volume"~(m^3/ha))) +
                theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                      legend.position = "none",
                      axis.text.x = element_text(size = 44, margin = margin(t=16)),
                      axis.text.y = element_text(size = 40, margin = margin(r=16)),
                      axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                      axis.title.y = element_text(size = 60, margin = margin(r=40)))
        
        #Faceted bar plot - total plot volume for each study site, w/ comparison between treatments
        vol_plot_faceted <- ggplot(data = plot_sums, aes(x = Treatment, y = Volume_m3_ha, fill = Treatment)) +
                geom_bar(position="dodge", stat="identity") +
                facet_wrap(~ LocalityName, ncol = 5) +
                ggtitle("Plot volumes for SustHerb study sites") +
                labs(x = "Site Treatment", y = bquote("Summed blot volume"~(m^3/ha))) +
                theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                      legend.position = "none",
                      axis.text.x = element_text(size = 20, margin = margin(t=16)),
                      axis.text.y = element_text(size = 20, margin = margin(r=16)),
                      axis.title.x = element_text(size = 50, margin = margin(t=40, b = 40)),
                      axis.title.y = element_text(size = 50, margin = margin(r=40)),
                      strip.text.x = element_text(size = 20))
        
        #Histogram of volume by treatment
        vol_hist <- ggplot(data = plot_sums, aes(x = Volume_m3_ha, fill = Treatment, group = Treatment)) +
                geom_histogram(aes(y=..density..), bins = 30, alpha=1, position="identity") +
                geom_density(alpha= 0.5) +
                ggtitle("Density plot of plot volumes") +
                labs(x = "Summed plot volume (m3/ha)", y = "Density") +
                theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                      legend.title = element_text(size = 40),
                      legend.text = element_text(size = 36),
                      axis.text.x = element_text(size = 20, margin = margin(t=16)),
                      axis.text.y = element_text(size = 20, margin = margin(r=16)),
                      axis.title.x = element_text(size = 50, margin = margin(t=40, b = 40)),
                      axis.title.y = element_text(size = 50, margin = margin(r=40)),
                      strip.text.x = element_text(size = 20))

        
#END DATA VISUALIZATION ----------------------------------------------------------------------------------------------
        
        
        
        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        
        
        
        
#WRITE OUTPUT --------------------------------------------------------------------------------------------------------

        #Write CSV of SUBPLOT volumes to output folder
        write.csv(plot_sums, file = '1_Albedo_Exclosures/Approach_1/Output/Tree_Volumes/tree_volumes_approach_1.csv', row.names = TRUE)

        #Export volume boxplot as PNG
        png(filename = "1_Albedo_Exclosures/Approach_1/Output/Tree_Volumes/plot_volumes_approach_1.png",
            width = 2000,
            height = 2000,
            bg = "white")
        vol_plot
        dev.off()
        
        #Export faceted volume barplot as PNG
        png(filename = "1_Albedo_Exclosures/Approach_1/Output/Tree_Volumes/plot_volumes_faceted_approach_1.png",
            width = 2000,
            height = 3000,
            bg = "white")
        vol_plot_faceted
        dev.off()
        
        #Export density plot as PNG
        png(filename = "1_Albedo_Exclosures/Approach_1/Output/Tree_Volumes/plot_volumes_density_approach_1.png",
            width = 2000,
            height = 2000,
            bg = "white")
        vol_hist
        dev.off()
        
#END WRITE OUTPUT --------------------------------------------------------------------------------------------------------