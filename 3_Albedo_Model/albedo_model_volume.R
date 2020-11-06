##This script contains the 'R' version of Cherubini et al. (2019)'s albedo model


#Albedo Model (Accepts Forest 'Biomass Volume' as an Input)
#----------------------------------------------------------
       
        #ARGUMENTS
                #site = site code (LocalityCode)
                #localityName = site name (LocalityName)
                #Region = region
                #birch_vol = forest volume of birch (m3/ha)
                #pine_vol = forest volume of pine (m3/ha)
                #spruce_vol = forest volume of spruce (m3/ha)
                #temp = vector of monthly average temperatures for site (K) - 12 total
                #swe = vector of monthly average SWE values for site (mm) - 12 total
                #species = spruce, pine, or birch (character)
                
albedoVol <- function(site, localityName, region, treatment, birch_vol, pine_vol, spruce_vol, temp, swe){
        
        #CREATE OUTPUT DF
        df <- data.frame("Month" = integer(),
                         "Birch_Albedo" = numeric(),
                         "Pine_Albedo" = numeric(),
                         "Spruce_Albedo" = numeric(),
                         "SWE_mm" = numeric(),
                         "Temp_K" = numeric())
        
        df[nrow(df)+12,] <- NA
        
        #CALCULATE ALBEDO VALUES FOR EACH MONTH OF THE YEAR
        for(i in 1:12){
                
                #Spruce albedo estimates --------
                
                        #Calculate monthly 'spruce albedo' using spruce-specific equation
                        s_alb <- 0.077+0.072*(1-1/(1+exp(-2.354*(temp[i]-273.433))))+0.074*(1/(1+exp(-0.191*(swe[i]-33.093))))+0.252*exp(-0.023*spruce_vol)*(1-0.7*exp(-0.011*swe[i]))
                
                #Pine albedo estimates --------
                
                        #Calculate monthly 'pine albedo' using pine-specific equation
                        p_alb <- 0.069+0.084*(1-1/(1+exp(-1.965*(temp[i]-273.519))))+0.106*(1/(1+exp(-0.134*(swe[i]-30.125))))+0.251*exp(-0.016*pine_vol)*(1-0.7*exp(-0.008*swe[i]))
                
                #Birch/deciduous albedo estimates --------
                
                        #Calculate monthly 'birch albedo' using birch-specific equation
                        ## NOTE: This includes all other deciduous species present in plots
                        b_alb <- 0.085+0.089*(1-1/(1+exp(-2.414*(temp[i]-273.393))))+0.169*(1/(1+exp(-0.107*(swe[i]-37.672))))+0.245*exp(-0.023*birch_vol)*(1-0.7*exp(-0.004*swe[i]))
                

                #Add values to df for month i --------
                df[i, "Month"] <- i
                df[i, "Birch_Albedo"] <- b_alb
                df[i, "Pine_Albedo"] <- p_alb
                df[i, "Spruce_Albedo"] <- s_alb
                df[i, "SWE_mm"] <- swe[i]
                df[i, "Temp_K"] <- temp[i]
                        
        }
        

        #Clean up final dataframe
        
                #Add site code as column in dataframe
                df$LocalityCode <- site
                
                #Add locality name as column in dataframe
                df$LocalityName <- localityName
                
                #Add region as column in dataframe
                df$Region <- region
                
                #Add treatment as column in dataframe
                df$Treatment <- treatment
                

        #Return df as function output
        return(df)
                
}