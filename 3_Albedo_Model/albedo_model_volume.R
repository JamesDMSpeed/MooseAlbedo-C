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
        
        #CREATE OUTPUT DF
        df <- data.frame("Month" = integer(),
                         "Spruce_Albedo" = double(),
                         "Pine_Albedo" = double(),
                         "Birch_Albedo" = double(),
                         "Composite_Albedo" = double())
        
        df[nrow(df)+12,] <- NA
        
        #CALCULATE ALBEDO VALUES FOR EACH MONTH OF THE YEAR
        for(i in 1:12){
                
                #Spruce albedo estimates --------
                
                        #Calculate monthly 'spruce albedo' using spruce-specific equation
                        s_alb <- 0.077+0.072*(1-1/(1+exp(-2.354*(temp[i]-273.433))))+0.074*(1/(1+exp(-0.191*(swe[i]-33.093))))+0.252*exp(-0.023*vol)*(1-0.7*exp(-0.011*swe[i]))
                        
                #Pine albedo estimates --------
                
                        #Calculate monthly 'pine albedo' using pine-specific equation
                        p_alb <- 0.069+0.084*(1-1/(1+exp(-1.965*(temp[i]-273.519))))+0.106*(1/(1+exp(-0.134*(swe[i]-30.125))))+0.251*exp(-0.016*vol)*(1-0.7*exp(-0.008*swe[i]))
                        
                #Birch/deciduous albedo estimates --------
                
                        #Calculate monthly 'birch albedo' using birch-specific equation
                        ## NOTE: This includes all other deciduous species present in plots
                        b_alb <- 0.085+0.089*(1-1/(1+exp(-2.414*(temp[i]-273.393))))+0.169*(1/(1+exp(-0.107*(swe[i]-37.672))))+0.245*exp(-0.023*vol)*(1-0.7*exp(-0.004*swe[i]))
                        
                #Composite albedo estimates ---------
                c_alb <- (s_alb*spruce) + (p_alb*pine) + (b_alb*birch)
                        
                        
                #Add values to df for month i --------
                df[i, "Month"] <- i
                df[i, "Spruce_Albedo"] <- s_alb
                df[i, "Pine_Albedo"] <- p_alb
                df[i, "Birch_Albedo"] <- b_alb
                df[i, "Composite_Albedo"] <- c_alb
                        
        }
        

        #Clean up final dataframe
        
                #Add site code as column in dataframe
                df$LocalityCode <- site
                
                #Add locality name as column in dataframe
                df$LocalityName <- localityName
                
                #Add treatment as column in dataframe
                df$Treatment <- treatment
                

        #Return df as function output
        return(df)
                
}