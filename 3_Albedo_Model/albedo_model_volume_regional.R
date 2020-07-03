## This script contains the 'R' version of Cherubini et al. (2019)'s albedo model
## It is specifically for use with the regional analysis component of this project, 
## and doesn't require site or LocalityName. It produces a composite albedo value
## for a specific month, as opposed to albedo values for all months


#Albedo Model (Accepts Forest 'Biomass Volume' as an Input)
#----------------------------------------------------------
       
        #ARGUMENTS
                #month = Month of the year (integer - 1-12)
                #vol = forest volume (UNITS?)
                #temp = monthly average temperature for plot (K) - 1 month
                #swe = monthly average SWE values for plot (mm) - 1 month
                #spruce = % of spruce forest in plot
                #pine = % of pine forest in plot
                #birch = % of birch forest (or other deciduous species) in plot
                
albedoVolRegional <- function(month, vol, temp, swe, spruce, pine, birch){
        
        #Spruce albedo estimates
                
                        #Calculate monthly 'spruce albedo' using spruce-specific equation
                        s_alb <- 0.077+0.072*(1-1/(1+exp(-2.354*(temp-273.433))))+0.074*(1/(1+exp(-0.191*(swe-33.093))))+0.252*exp(-0.023*vol)*(1-0.7*exp(-0.011*swe))
                        
                        #Calculate 'composite' albedo value (based on site % of spruce)
                        s_alb <- s_alb*spruce
                
        #Pine albedo estimates
        
                        #Calculate monthly 'pine albedo' using pine-specific equation
                        p_alb <- 0.069+0.084*(1-1/(1+exp(-1.965*(temp-273.519))))+0.106*(1/(1+exp(-0.134*(swe-30.125))))+0.251*exp(-0.016*vol)*(1-0.7*exp(-0.008*swe))
                        
                        
                        #Calculate 'composite' albedo value (based on site % of pine)
                        p_alb <- p_alb*pine
        
        #Birch/deciduous albedo estimates
                
                #Calculate albedo for each month of the year

                        #Calculate monthly 'birch albedo' using birch-specific equation
                        ## NOTE: This includes all other deciduous species
                        b_alb <- 0.085+0.089*(1-1/(1+exp(-2.414*(temp-273.393))))+0.169*(1/(1+exp(-0.107*(swe-37.672))))+0.245*exp(-0.023*vol)*(1-0.7*exp(-0.004*swe))
                        
                        #Calculate 'composite' albedo value (based on site % of birch/deciduous)
                        b_alb <- b_alb*birch
                        
        #Sum composite albedo estimates to create final albedo value
        final_albedo <- s_alb + p_alb + b_alb
               
        #Put final albedo into labeled df
        final_albedo.df <- data.frame(final_albedo)
        names(final_albedo.df)[1] <- paste("Month_", month, "_Albedo", sep = "")

        #Calculate composite albedo estimate for each month
        return(final_albedo.df)
        
}