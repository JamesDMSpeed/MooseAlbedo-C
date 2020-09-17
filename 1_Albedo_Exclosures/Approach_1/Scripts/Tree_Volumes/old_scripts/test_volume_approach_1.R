##This script is meant to provide a 'closer look' at specific site (LocalityName)
## Should allow for diagnosing of why the tree volumes from approach 1 are much different than expected


##PACKAGES ----------------------------------------------------------------------------------------

        #Packages for data processing + visualization
        library(dplyr)
        library(tidyr)
        library(ggplot2)
        library(formattable)

###END PACKAGES ----------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#INITIAL DATA IMPORT ----------------------------------------------------------------------------------------------

        #Import CSV to dataframe
        data <- read.csv('1_Albedo_Exclosures/Data/Tree_Data/sustherb_tree_data.csv', header = TRUE)

#END INITIAL DATA IMPORT --------------------------------------------------------------------------------
        
        
        
        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  
        
              
        
#FUNCTION TO PROVIDE OUTPUT FOR SPECIFIC SITE (LOCALITYNAME) ---------------------------------------------
        
        #Declare function
        volOutput <- function(x){
                
                #FILTER DATA
                
                        #Get data for relevant LocalityName
                        df <- data[tolower(data$LocalityName) == x,]
                        
                        #Format date column properly (to R date format)
                        df$X_Date <- as.Date(as.character(df$X_Date), format = "%m/%d/%y")
                        
                        #Format LocalityName and LocalityCode as factors
                        df$LocalityCode <- as.factor(df$LocalityCode)
                        df$LocalityName <- as.factor(df$LocalityName)
                        
                        #Filter to data from year 2016 only 
                        df <- df[df$X_Date >= "2016-01-01" & df$X_Date <= "2016-12-31",]
                        
                        #Remove rows that are missing diameter-at-base data (3 total)
                        df <- df[! is.na(df$Diameter_at_base_mm), ]
                        
                        #Exclude trees > 6m (600cm)
                        df <- df[df$Height_cm <= 600,]
                        
                        #Volume
                        df$Volume_m3 <- as.numeric(c(''))
                        
                        #Biomass
                        df$Biomass_g <- as.numeric(c(''))
                        
                #CALCULATE VOLUME + BIOMASS
                        
                        #Spruce density (kg/m3 converted to g/cm3)
                        s_density <- 385.3 / 1000
                        
                        #Pine density (kg/m3 converted to g/cm3)
                        p_density <- 412.6 / 1000
                        
                        #Birch density (kg/m3 converted to g/cm3)
                        b_density <- 475 / 1000
                        
                        #Loop through each row of the dataframe
                        for(row in 1:nrow(df)){
                                
                                #IDENTIFY SPECIES + HEIGHT
                                
                                #Get tree species
                                species <- as.character(df[row, "Taxa"])
                                
                                #Get 'Diameter at Ground Level' (mm)
                                dgl <- as.numeric(df[row, "Diameter_at_base_mm"])
                                
                                #Get height (cm)
                                height <- as.numeric(df[row, "Height_cm"])
                                
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
                                        biomass <- (0.020293)*(dgl^2) + (0.006092)*(height^3)
                                        
                                        #Volume (cm3 converted to m3)
                                        volume <- (biomass / s_density) / 1e06
                                        
                                }
                                
                                #Pinus sylvestris model (Pine)
                                else if( species == "Pinus sylvestris (Furu)" ){
                                        
                                        #Biomass (g)
                                        biomass <- (0.325839)*(dgl^2) + (0.0007434)*(height^3)
                                        
                                        #Volume (cm3 converted to m3)
                                        volume <- (biomass / p_density) / 1e06
                                        
                                }
                                
                                #Sorbus aucuparia model (Rowan)
                                else if( species == "Sorbus aucuparia (Rogn)" ){
                                        
                                        #Treatment
                                        treatment <- as.character(df[row, "Treatment"])
                                        
                                        #Browsed Model
                                        if( treatment == "B" ){
                                                
                                                #Biomass (g)
                                                biomass <- (0.006664)*(dgl^2) + (0.082983)*(height^2)
                                                
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
                                df[row, "Biomass_g"] <- biomass
                                
                                #Add calculated volume to 'Volume' column
                                df[row, "Volume_m3"] <- volume
                                
                                
                                
                        }
                        
                        #Ensure that 'Volume' & 'Biomass' columns are numeric
                        df$Volume_m3 <- as.numeric(df$Volume_m3)
                        df$Biomass_g <- as.numeric(df$Biomass_g)
                        
                        
                #DATA OUTPUT
                        
                        #Total count table
                        print("Total tree counts")
                        print(table(df$Treatment))

                        #Taxa count table
                        cat("\nTree species counts by treatment")
                        print(table(df$Taxa, df$Treatment))
                        
                        #Biomass table
                        bsb <- sum(df$Biomass_g[df$Treatment == "B"])
                        bsub <- sum(df$Biomass_g[df$Treatment == "UB"])
                        cat("\nBiomass by treatment")
                        print(table(bsb, bsub))
                        
                        #Volume table
                        vsb <- sum(df$Volume_m3[df$Treatment == "B"])
                        vsub <- sum(df$Volume_m3[df$Treatment == "UB"])
                        cat("\nVolume by treatment")
                        print(table(vsb, vsub))
                        
                        #Max biomass & volume
                        cat("Max biomass: ", max(df$Biomass_g))
                        cat("Max volume: ", max(df$Volume_m3))
                        
                        #Histogram of tree heights by treatment
                        print(ggplot(df, aes(x = Height_cm, group = Treatment, fill = Treatment)) +
                                      geom_histogram(aes(y=..density..), bins = 30, alpha=1, position="identity") +
                                      geom_density(alpha= 0.5))
                        
                        #Histogram of biomass by treatment
                        print(ggplot(df, aes(x = Biomass_g, group = Treatment, fill = Treatment)) +
                                      geom_histogram(aes(y=..density..), bins = 30, alpha=1, position="identity") +
                                      geom_density(alpha= 0.5))
                        
                        #Histogram of volume by treatment
                        print(ggplot(df, aes(x = Volume_m3, group = Treatment, fill = Treatment)) +
                                      geom_histogram(aes(y=..density..), bins = 30, alpha=1, position="identity") +
                                      geom_density(alpha= 0.5))
                        
                        #Return df
                        return(df)
                        
                        
                        

                        

                        
                
                
        }
 
#END FUNCTION TO PROVIDE OUTPUT FOR SPECIFIC SITE (LOCALITYNAME) ---------------------------------------------       
        
        
        
        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        
        
        

#RUN FUNCTION HERE:
        
        output <- volOutput("bratsberg")
