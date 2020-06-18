##This script contains the 'R' version of Cherubini et al. (2019)'s albedo model


#Albedo Model (Accepts Forest 'Biomass Volume' as an Input)
#----------------------------------------------------------
       
        #ARGUMENTS
                #site = site code (LocalityCode)
                #vol = forest volume (UNITS?)
                #temp = vector of monthly average temperatures for site (K) - 12 total
                #swe = vector of monthly average SWE values for site (mm) - 12 total
                #spruce = % of spruce forest
                #pine = % of pine forest
                #birch = % of birch forest (or other deciduous species)
                
albedoVol <- function(site, localityName, treatment, vol, temp, swe, spruce, pine, birch){
        
        #Spruce albedo estimates
        
                #Create temp df
                s_albedo <- data.frame("Month" = integer(), "Albedo" = double())
                
                #Calculate albedo for each month of the year
                for(i in 1:12){
                        
                        #Calculate monthly 'spruce albedo' using spruce-specific equation
                        s_alb <- 0.077+0.072*(1-1/(1+exp(-2.354*(temp[i]-273.433))))+0.074*(1/(1+exp(-0.191*(swe[i]-33.093))))+0.252*exp(-0.023*vol)*(1-0.7*exp(-0.011*swe[i]))
                        
                        #Calculate 'composite' albedo values for each month (based on site % of spruce)
                        s_alb <- s_alb*spruce
                        
                        #Add 'composites' to dataframe
                        s_albedo[i, "Month"] <- i
                        s_albedo[i, "Albedo"] <- s_alb
                        
                }
                
        #Pine albedo estimates
        
                #Create temp df
                p_albedo <- data.frame("Month" = integer(), "Albedo" = double())
        
                #Calculate albedo for each month of the year
                for(i in 1:12){
                        
                        #Calculate monthly 'pine albedo' using pine-specific equation
                        p_alb <- 0.069+0.084*(1-1/(1+exp(-1.965*(temp[i]-273.519))))+0.106*(1/(1+exp(-0.134*(swe[i]-30.125))))+0.251*exp(-0.016*vol)*(1-0.7*exp(-0.008*swe[i]))
                        
                        
                        #Calculate 'composite' albedo values for each month (based on site % of pine)
                        p_alb <- p_alb*pine
                        
                        #Add 'composites' to dataframe
                        p_albedo[i, "Month"] <- i
                        p_albedo[i, "Albedo"] <- p_alb
                        
                }
        
        #Birch/deciduous albedo estimates
                
                #Create temp df
                b_albedo <- data.frame("Month" = integer(), "Albedo" = double())
                
                #Calculate albedo for each month of the year
                for(i in 1:12){
                        
                        #Calculate monthly 'birch albedo' using birch-specific equation
                        ## NOTE: This includes all other deciduous species
                        b_alb <- 0.085+0.089*(1-1/(1+exp(-2.414*(temp[i]-273.393))))+0.169*(1/(1+exp(-0.107*(swe[i]-37.672))))+0.245*exp(-0.023*vol)*(1-0.7*exp(-0.004*swe[i]))
                        
                        #Calculate 'composite' albedo values for each month (based on site % of birch/deciduous)
                        b_alb <- b_alb*birch
                        
                        #Add 'composites' to dataframe
                        b_albedo[i, "Month"] <- i
                        b_albedo[i, "Albedo"] <- b_alb
                        
                }
                
        #Compile all 'composites' in a single dataframe
        main_albedo <- rbind(s_albedo, p_albedo, b_albedo)
        
        #Sum 'composites' to produce 'composite' albedo value for the entire plot per month
        main_albedo <- aggregate(main_albedo$Albedo, by = list(main_albedo$Month), FUN = sum)
                
        #Clean up final dataframe
        
                #Rename columns
                colnames(main_albedo)[1] <- "Month"
                colnames(main_albedo)[2] <- "Composite_Albedo"
                
                #Add site code as column in dataframe
                main_albedo$LocalityCode <- site
                
                #Add locality name as column in dataframe
                main_albedo$LocalityName <- localityName
                
                #Add treatment as column in dataframe
                main_albedo$Treatment <- treatment
                

        #Calculate composite albedo estimate for each month
        return(main_albedo)
}