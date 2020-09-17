## This is a script to visualize the processed and unified atSkog spatial dataset in Norway (attempt #2)
## It also has some steps to attempt to cluster the data based on SWE/Temp, age, and elevation


#PACKAGES ----------------------------------------------------------------------

        #Spatial Data Packages
        library(sf)
        library(tmap)
        library(broom)
        
        #Data Manipulation + Visualization
        library(ggplot2)
        library(raster)
        library(lattice)
        library(dplyr)
        library(data.table)
        library(hexbin)
        library(RColorBrewer)
        library(wesanderson)
        library(foreach)
        library(beepr)
        library(rgl)
        library(corrgram)
        library(corrplot)
        library(feather)

        #Clustering
        library(clusterSim)
        library(factoextra)
        

      
#END PACKAGES ----------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#IMPORT DATA --------------------------------------------------------------------------------------------------

        #Load unified & FILTERED shapefile w/ all variables
        data <- st_read("2_Albedo_Regional/Data/Final_Shapefile/Output/attempt_2/full_resolution/final_shapefile_v2.shp")
        
        #Looks like there are some null values for elevation (-9999) - reassign as NA
        data$dem[data$dem < 0] <- NA
        

#END IMPORT DATA --------------------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#INITIAL DATA EXPLORATION -------------------------------------------------------------------------

        #What are the most important variables for albedo?
        #SWE, Temperature, and Plot Volume - these are probably strongly correlated with elevation, though
        
                #Are these variables correlated with each other?
                cortest <- st_drop_geometry(data[,c(14,37,42,43)])
                corrgram(cortest)
                beep(2)
                                
                                #SWE (Jan) has a strong positive correlation with elevation
                                #Temp (Jan) has a strong negative correlation with elevation
                                #Volume has no strong correlations with other variables
        
        #So, ELEVATION is probably a very important parameter to fix - by fixing elevation, there should
        #be much less variation in SWE and Temp.
                
        #Any variation in SWE and Temp should be relatively independent of volume, since SWE/Temp are at
        #a larger spatial resolution (1km2) - additionally, SWE and Temp have a very weak correlations with 
        #volume
                
        #If I fix elevation, I'll still have a lot of variation in albedo due to DIFFERENCES IN AGE - young
        #plots will probably have LOWER VOLUME than older plots. 
                
                #Is volume correlated with age?
                cortest <- st_drop_geometry(data[,c(1,37)])
                
                ggplot(data = cortest, aes(x = alder, y = vuprha)) +
                        geom_point() +
                        geom_smooth() +
                        ggtitle("Forest age vs. volume/ha")
                
                cor.test(cortest$alder, cortest$vuprha) #Weak/moderate correlation of 0.36
                beep(2)
                
                        #Definitely some kind of trend here - Therefore, it is also necessary to
                        #FIX AGE as a parameter
                
                
                #However still a lot of variation in volume across all ages - 
                #COULD ANOTHER VARIABLE AFFECT VOLUME?
                
                        #Maybe "productive skog" vs "regular skog"? Volume may be limited at 
                        #older ages in forest that isn't very productive
                        ggplot(data = data, aes(x = alder, y = vuprha, color = clss_ms)) +
                                geom_point() +
                                geom_smooth()
                        beep(2)
                        
                                #Not really a clear trend and still a lot of variation - maybe a different variable?
                        
                        
                        #Maybe dependent on "dominant tree type?"
                        ggplot(data = data, aes(x = alder, y = vuprha, color = treslag)) +
                                geom_point() +
                                geom_smooth() +
                                facet_wrap(~ treslag)
                        beep(2)
                        
                                #No clear trend - still a LOT of variation between the different tree types
                                #This variation looks very similar between tree types, as well
                        
                                        #Maybe a bit more variation in deciduous ("lauvdominert") forest
                        
                        
                        #Maybe dependent on site productivity? ("bonitet" code)
                        ggplot(data = data, aes(x = alder, y = vuprha)) +
                                geom_point() +
                                geom_smooth() +
                                facet_wrap(~ bonitet)
                        beep(2)
                        
                                        #Still similar trend and a lot of variation
                        
                        
                        #Maybe dependent on elevation? Tree volume might be smaller at higher elevations
                        ggplot(data = data, aes(x = alder, y = vuprha)) +
                                geom_point() +
                                geom_smooth() +
                                facet_wrap(~ cut_interval(dem, 20))
                        beep(2)
                        
                                #Still similar type of trend! What other variable can explain variation 
                                #age increase?
                        
                        
                        #Try looking at low elevation forest with moose density and productivity as 3rd/4th variables
                        data$bonitet <- as.factor(data$bonitet)
                        ggplot(data = subset(data, dem < 200 & treslag == "Grandominert"), aes(x = alder, y = vuprha, color = bonitet)) +
                                geom_point() +
                                geom_smooth() +
                                facet_wrap(~ cut_interval(Ms_Dnst, 10))
                        beep(2)
                        
                                #LOOKS LIKE there might be some separation between different productivities 
                        
                        
                        #Bonitet and tree species
                        ggplot(data = data, aes(x = alder, y = vuprha, color = bonitet)) +
                                geom_point() +
                                geom_smooth() +
                                facet_wrap(~ treslag)
                        beep(2)
                        
                                #Bonitet seems like it might have a huge impact on variation (high
                                #bonitet sites have a lot more variation then lower quality sites)
                        
                        

#KEY POINT: Volume seems to be a complex combination of several variables - NOT SURE that
#I can choose additional variables to reduce variation in volume
                
#DESPITE THIS, ELEVATION AND AGE will be two important parameters to fix
                        
        
        #Let's try to break up some elevation intervals and then further divide by age
        
                #What are the max and min elevations in the dataset?
                min(data$dem, na.rm = T) #0m
                max(data$dem, na.rm = T) #1144m
                
                #Dividing 1144m into 20 intervals gives us intervals of ~58m - that seems like a reasonable
                #range to group plots of forest into
                
                        #Let's try exploring albedo across 30 elevation intervals. We're looking specifically
                        #at spruce albedo in January (which should have high variation due to SWE/Temp)
                        ggplot(data = data, aes(x = M_1_A_S)) +
                                geom_histogram() +
                                facet_wrap(~ cut_interval(dem, 20))
                        beep(2)
                        
                                #So, pretty large variation in albedo for all elevation intervals. There's 
                                #clearly another variable that is important to fix here.
                        
                        #Let's look at albedo again, but only in YOUNG FOREST (1-5 years) across 20
                        #elevation intervals
                        ggplot(data = subset(data, alder <= 5), aes(x = M_1_A_S)) +
                                geom_histogram() +
                                facet_wrap(~ cut_interval(dem, 20))
                        beep(2)
                        
                                #STILL a ton of variation across most elevation intervals
                        
                        #Same thing, but in slightly older forest (6-10 years)
                        ggplot(data = subset(data, alder > 5 & alder <= 10), aes(x = M_1_A_S)) +
                                geom_histogram() +
                                facet_wrap(~ cut_interval(dem, 20))
                        beep(2)
                        
                                #Same thing - still a ton of variation

                        
#LET'S TRY REDUCING/SIMPLIFYING DATA FURTHER - FILTER TO ONLY 1999 DATA --------------------------
                        
        #Filter to 1999 only
        data1999 <- data[data$Snrg_yr == 1999,]  #This reduced the dataset by >40%
                        
                #Plot 1999 data geometry (exporting as PNG because normal plotting is very slow)
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_2_Visualization/Initial_Plots/fixed_parameters/1999_geometry.png",
                    width = 1500,
                    height = 1500,
                    units = "px",
                    bg = "white")
                
                plot(data1999["Ms_Dnst"], main = "Moose Density for 1999 Data")
                
                dev.off()
                beep(3)
        
                #Let's now try looking at the plot of moose density vs. albedo for 1999 data 
                        
                        #Spruce albedo (January) - still a LOT of variation
                        ggplot(data = data1999, aes(x = Ms_Dnst, y = M_1_A_S)) +
                                geom_bin2d()
                        
                        #Try cutting by elevation interval
                        ggplot(data = data1999, aes(x = Ms_Dnst, y = M_1_A_S)) +
                                geom_point() +
                                geom_smooth() +
                                facet_wrap(~ cut_interval(dem, 20))
                        
                                #Still a LOT OF VARIATION

                        
                        
#FINDINGS SO FAR: Fixing elevation as a parameter isn't very effective (still a TON of variation within
#each elevation interval)
                        
        #I'm thinking that SWE is probably the most important factor to fix - topography/relief and 
        #high variation in snowfall over a given area (due to complex climate patterns) may lead to
        #the variation in albedo for a given age + elevation
                        
        #Let's try fixing SWE as a parameter (STILL USING 1999 SATSKOG, SENORGE, AND HERBIVORE DATA)
        
                #Try plotting data by 20x SWE intervals (spruce albedo in Jan)
                ggplot(data = data1999, aes(x = Ms_Dnst, y = M_1_A_S)) +
                        geom_bin2d() +
                        geom_smooth(span = 2) +
                        facet_wrap(~ cut_interval(SWE_M_1, 20)) +
                        scale_y_continuous(limits = c(0,0.6))
                
                        #Still some variation, but noticeably less than when elevation or age were fixed
                
                #Try plotting data by 30x SWE intervals (spruce albedo in Jan)
                ggplot(data = data1999, aes(x = Ms_Dnst, y = M_1_A_S)) +
                        geom_bin2d() +
                        geom_smooth(span = 2) +
                        facet_wrap(~ cut_interval(SWE_M_1, 30)) +
                        scale_y_continuous(limits = c(0,0.6))
                
                        #Even less variation, especially at lower intervals - HOWEVER, still more than I'd like
                
                
        
                
                
                #What happens when I fix SWE to a lower value (0-20mm) and then facet by age?
                ggplot(data = subset(data1999, SWE_M_1 <= 20), aes(x = Ms_Dnst, y = M_1_A_S)) +
                        geom_bin2d() +
                        geom_smooth(span = 500) +
                        facet_wrap(~ cut_interval(alder, 15)) +
                        scale_y_continuous(limits = c(0,0.6)) +
                        ggtitle("Spruce Albedo in January (plots with SWE 0-20mm)\nFaceted by age (years)")
                
                        ##MUCH LESS variation in albedo
                
                #Let's try another random interval of SWE (60-80mm) - do the trends look similar
                ggplot(data = subset(data1999, SWE_M_1 >= 60 & SWE_M_1 <= 80), aes(x = Ms_Dnst, y = M_1_A_S)) +
                        geom_bin2d() +
                        geom_smooth(span = 500) +
                        facet_wrap(~ cut_interval(alder, 15)) +
                        scale_y_continuous(limits = c(0,0.6)) +
                        ggtitle("Spruce Albedo in January (plots with SWE 60-80mm)\nFaceted by age (years)")
                
                #More variation than when less snow, and a different trend
                
                #Let's try another random interval of SWE (100-120mm) - do the trends look similar
                ggplot(data = subset(data1999, SWE_M_1 >= 100 & SWE_M_1 <= 120), aes(x = Ms_Dnst, y = M_1_A_S)) +
                        geom_bin2d() +
                        geom_smooth(span = 500) +
                        facet_wrap(~ cut_interval(alder, 15)) +
                        scale_y_continuous(limits = c(0,0.6)) +
                        ggtitle("Spruce Albedo in January (plots with SWE 100-120mm)\nFaceted by age (years)")
                
                                #More variation than when less snow, and a different trend
                
                #Let's try an even higher interval of SWE (160-180mm) - how do the trends look?
                ggplot(data = subset(data1999, SWE_M_1 >= 160 & SWE_M_1 <= 180), aes(x = Ms_Dnst, y = M_1_A_S)) +
                        geom_bin2d() +
                        geom_smooth(span = 500) +
                        facet_wrap(~ cut_interval(alder, 15)) +
                        scale_y_continuous(limits = c(0,0.6)) +
                        ggtitle("Spruce Albedo in January (plots with SWE 180-200mm)\nFaceted by age (years)")
                
                                #*Similar trend to with moderate amount of snow
                
##KEY FINDING: It looks like faceting by SWE (small intervals of 20mm) and age (2 year intervals)
##reduces variation the most! So much so that clear trends in albedo are visible across different densities
                
        #Let's try looking at albedos for pine and birch, too (in January)
                
                #PINE
                        
                        #Low SWE (0-20mm) & Jan pine albedo (faceted by age)
                        ggplot(data = subset(data1999, SWE_M_1 <= 20), aes(x = Ms_Dnst, y = M_1_A_P)) +
                                geom_bin2d() +
                                geom_smooth(span = 500) +
                                facet_wrap(~ cut_interval(alder, 15)) +
                                scale_y_continuous(limits = c(0,0.6)) +
                                ggtitle("Pine Albedo in January (plots with SWE 0-20mm)\nFaceted by age (years)")
                        
                                #No real trend, similar to spruce
                        
                        #Moderate SWE (100-120mm)
                        ggplot(data = subset(data1999, SWE_M_1 >= 100 & SWE_M_1 <= 120), aes(x = Ms_Dnst, y = M_1_A_P)) +
                                geom_bin2d() +
                                geom_smooth(span = 500) +
                                facet_wrap(~ cut_interval(alder, 15)) +
                                scale_y_continuous(limits = c(0,0.6)) +
                                ggtitle("Pine Albedo in January (plots with SWE 100-120mm)\nFaceted by age (years)")
                        
                                #Less of a clear trend, but slightly downwards
        
                        #High SWE (160-180mm)
                        ggplot(data = subset(data1999, SWE_M_1 >= 160 & SWE_M_1 <= 180), aes(x = Ms_Dnst, y = M_1_A_P)) +
                                geom_bin2d() +
                                geom_smooth(span = 500) +
                                facet_wrap(~ cut_interval(alder, 15)) +
                                scale_y_continuous(limits = c(0,0.6)) +
                                ggtitle("Pine Albedo in January (plots with SWE 160-180mm)\nFaceted by age (years)")
                        
                                #Appears to be a noticeable downwards trend!
                        
                #BIRCH
                        
                        #Low SWE (0-20mm) & Jan birch albedo (faceted by age)
                        ggplot(data = subset(data1999, SWE_M_1 <= 20), aes(x = Ms_Dnst, y = M_1_A_B)) +
                                geom_bin2d() +
                                geom_smooth(span = 500) +
                                facet_wrap(~ cut_interval(alder, 15)) +
                                scale_y_continuous(limits = c(0,0.6)) +
                                ggtitle("Birch Albedo in January (plots with SWE 0-20mm)\nFaceted by age (years)")
                        
                                #No real trend, similar to spruce and pine
                        
                        #Moderate SWE (100-120mm)
                        ggplot(data = subset(data1999, SWE_M_1 >= 100 & SWE_M_1 <= 120), aes(x = Ms_Dnst, y = M_1_A_B)) +
                                geom_bin2d() +
                                geom_smooth(span = 500) +
                                facet_wrap(~ cut_interval(alder, 15)) +
                                scale_y_continuous(limits = c(0,0.6)) +
                                ggtitle("Birch Albedo in January (plots with SWE 100-120mm)\nFaceted by age (years)")
                        
                                #Less of a clear trend, but slightly downwards
                        
                        #High SWE (160-180mm)
                        ggplot(data = subset(data1999, SWE_M_1 >= 160 & SWE_M_1 <= 180), aes(x = Ms_Dnst, y = M_1_A_B)) +
                                geom_bin2d() +
                                geom_smooth(span = 500) +
                                facet_wrap(~ cut_interval(alder, 15)) +
                                scale_y_continuous(limits = c(0,0.6)) +
                                ggtitle("Birch Albedo in January (plots with SWE 160-180mm)\nFaceted by age (years)")
                        
                                #Appears to be a noticeable downwards trend, more noticeable as age increases
                        
                        
#KEY FINDING - IN JANUARY, I've found that albedo decreases as moose density increases (for all 3 tree species), 
#ONLY AFTER faceting by small intervals of age and SWE
                        
        #SWE introduces a LOT of variation into albedo
                        
                        
##NOW, LET'S LOOK AT APRIL TRENDS
                        
        #SPRUCE
                        
                        
                #Low SWE (0-20mm)
                ggplot(data = subset(data1999, SWE_M_4 <= 20), aes(x = Ms_Dnst, y = M_4_A_S)) +
                        geom_bin2d() +
                        geom_smooth(span = 500) +
                        facet_wrap(~ cut_interval(alder, 15)) +
                        scale_y_continuous(limits = c(0,0.6)) +
                        ggtitle("Spruce Albedo in April (plots with SWE 0-20mm)\nFaceted by age (years)")
                
                        #Slight downward trend, looks pretty reasonable
                
                #Moderate SWE (100-120mm)
                ggplot(data = subset(data1999, SWE_M_4 >= 100 & SWE_M_4 <= 120), aes(x = Ms_Dnst, y = M_4_A_S)) +
                        geom_bin2d() +
                        geom_smooth(span = 500) +
                        facet_wrap(~ cut_interval(alder, 15)) +
                        scale_y_continuous(limits = c(0,0.6)) +
                        ggtitle("Spruce Albedo in April (plots with SWE 100-120mm)\nFaceted by age (years)")
                
                        #Downward trend, more variation
                
                #High SWE (160-180mm)
                ggplot(data = subset(data1999, SWE_M_4 >= 160 & SWE_M_4 <= 180), aes(x = Ms_Dnst, y = M_4_A_S)) +
                        geom_bin2d() +
                        geom_smooth(span = 500) +
                        facet_wrap(~ cut_interval(alder, 15)) +
                        scale_y_continuous(limits = c(0,0.6)) +
                        ggtitle("Spruce Albedo in January (plots with SWE 160-180mm)\nFaceted by age (years)")
                
                        #Definitely a downward trend
              
                  
        #PINE

                #Low SWE (0-20mm)
                ggplot(data = subset(data1999, SWE_M_4 <= 20), aes(x = Ms_Dnst, y = M_4_A_P)) +
                        geom_bin2d() +
                        geom_smooth(span = 500) +
                        facet_wrap(~ cut_interval(alder, 15)) +
                        scale_y_continuous(limits = c(0,0.6)) +
                        ggtitle("Pine Albedo in April (plots with SWE 0-20mm)\nFaceted by age (years)")
                
                        #No strong trend, little variation
                
                #Moderate SWE (100-120mm)
                ggplot(data = subset(data1999, SWE_M_4 >= 100 & SWE_M_4 <= 120), aes(x = Ms_Dnst, y = M_4_A_P)) +
                        geom_bin2d() +
                        geom_smooth(span = 500) +
                        facet_wrap(~ cut_interval(alder, 15)) +
                        scale_y_continuous(limits = c(0,0.6)) +
                        ggtitle("Pine Albedo in April (plots with SWE 100-120mm)\nFaceted by age (years)")
                
                        #Maybe a slight downward trend, more variation
                
                #High SWE (160-180mm)
                ggplot(data = subset(data1999, SWE_M_4 >= 160 & SWE_M_4 <= 180), aes(x = Ms_Dnst, y = M_4_A_P)) +
                        geom_bin2d() +
                        geom_smooth(span = 500) +
                        facet_wrap(~ cut_interval(alder, 15)) +
                        scale_y_continuous(limits = c(0,0.6)) +
                        ggtitle("Pine Albedo in January (plots with SWE 160-180mm)\nFaceted by age (years)")
                
                        #Definitely a downward trend

        #BIRCH
                
                #Low SWE (0-20mm)
                ggplot(data = subset(data1999, SWE_M_4 <= 20), aes(x = Ms_Dnst, y = M_4_A_B)) +
                        geom_bin2d() +
                        geom_smooth(span = 500) +
                        facet_wrap(~ cut_interval(alder, 15)) +
                        scale_y_continuous(limits = c(0,0.6)) +
                        ggtitle("Birch Albedo in April (plots with SWE 0-20mm)\nFaceted by age (years)")
                
                        #No strong trend, little variation
                
                #Moderate SWE (100-120mm)
                ggplot(data = subset(data1999, SWE_M_4 >= 100 & SWE_M_4 <= 120), aes(x = Ms_Dnst, y = M_4_A_B)) +
                        geom_bin2d() +
                        geom_smooth(span = 500) +
                        facet_wrap(~ cut_interval(alder, 15)) +
                        scale_y_continuous(limits = c(0,0.6)) +
                        ggtitle("Birch Albedo in April (plots with SWE 100-120mm)\nFaceted by age (years)")
                
                        #Maybe a slight downward trend, more variation
                
                #High SWE (160-180mm)
                ggplot(data = subset(data1999, SWE_M_4 >= 160 & SWE_M_4 <= 180), aes(x = Ms_Dnst, y = M_4_A_B)) +
                        geom_bin2d() +
                        geom_smooth(span = 500) +
                        facet_wrap(~ cut_interval(alder, 15)) +
                        scale_y_continuous(limits = c(0,0.6)) +
                        ggtitle("Birch Albedo in January (plots with SWE 160-180mm)\nFaceted by age (years)")
                
                        #Very similar trends to spruce and pine                       
        
                
##ALBEDO (FOR ALL SPECIES) SEEMS TO DECREASE AS MOOSE DENSITY INCREASES FOR BOTH JANUARY AND APRIL
                
#WHAT SHOULD I PLOT?? ----------------------
                
        #I'm most interested in seeing how albedo of each species changes with moose density
        #I'm also interested in seeing how this relationship CHANGES THROUGHOUT THE YEAR, as well
        #as how it CHANGES WITH AGE
                
                #I'm not interested in seeing how SWE affects this relationship (since SWE is highly variable)
                
        #CHANGES THROUGHOUT THE YEAR (MONTH TO MONTH)
                
                
                
        #CHANGES THROUGHOUT AGE
        
                
##CAN I MAKE 3D PLOTS FOR THESE?? (1 PLOT FOR A GIVEN SPECIES, MONTH, AND SWE INTERVAL)
                        
        #I could also do 3D plots with three variables - moose density, albedo, and SWE for each month of each species
##I SHOULD also make an R Shiny app where the user can select SWE interval and Month, and 3 plots (one per species)
##are available
                        
#I could also do Ms_Dnst x Albedo, color by species, facet by age, and then do SWE and month as the two selectors (R shiny)

                #Draggable Scatterplot
                test <- subset(data1999, SWE_M_1 >= 100 & SWE_M_1 <= 120)
                
                plot3d(x = test$Ms_Dnst,
                       z = test$M_1_A_S,
                       y = test$alder)
                
#These 3D plots aren't easily readable - I actually don't think these will be a good solution

#Maybe I can stick to faceted plots, w/ (1) Species, (2) Age, and (3) SWE interval as selectors
        
                #Can facet by month
                

#END INITIAL DATA EXPLORATION --------------------------------------------------------------------------    
                
                
                
                
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                
                
                
                
#PREP 1999 DATA FOR SHINY APP -------------------------------------------------------------------------- 

        #Melt dataset into expanded format
                
                #Repeat each row of main sf object ('data') into 12 rows
                data_exp <- data1999[rep(seq_len(nrow(data1999)), each = 12), ]

                #Create vector with repeating sequence of 1:12 (to add as month variable)
                months <- rep(c(1:12), times = (nrow(data_exp) / 12))
                data_exp$Month <- months
                data_exp$SWE <- as.numeric('')
                data_exp$Temp <- as.numeric('')
                data_exp$Albedo_Spruce <- as.numeric('')
                data_exp$Albedo_Pine <- as.numeric('')
                data_exp$Albedo_Birch <- as.numeric('')
                rm(months)
                
                #Re-assign columns based on month
                #NOTE: Looks clunky, but doing it this way is INFINITELY faster than loop
                
                #SWE
                data_exp$SWE[data_exp$Month == 1] <- data_exp$SWE_M_1[data_exp$Month == 1]
                data_exp$SWE[data_exp$Month == 2] <- data_exp$SWE_M_2[data_exp$Month == 2]
                data_exp$SWE[data_exp$Month == 3] <- data_exp$SWE_M_3[data_exp$Month == 3]
                data_exp$SWE[data_exp$Month == 4] <- data_exp$SWE_M_4[data_exp$Month == 4]
                data_exp$SWE[data_exp$Month == 5] <- data_exp$SWE_M_5[data_exp$Month == 5]
                data_exp$SWE[data_exp$Month == 6] <- data_exp$SWE_M_6[data_exp$Month == 6]
                data_exp$SWE[data_exp$Month == 7] <- data_exp$SWE_M_7[data_exp$Month == 7]
                data_exp$SWE[data_exp$Month == 8] <- data_exp$SWE_M_8[data_exp$Month == 8]
                data_exp$SWE[data_exp$Month == 9] <- data_exp$SWE_M_9[data_exp$Month == 9]
                data_exp$SWE[data_exp$Month == 10] <- data_exp$SWE_M_10[data_exp$Month == 10]
                data_exp$SWE[data_exp$Month == 11] <- data_exp$SWE_M_11[data_exp$Month == 11]
                data_exp$SWE[data_exp$Month == 12] <- data_exp$SWE_M_12[data_exp$Month == 12]
                
                #TEMP
                data_exp$Temp[data_exp$Month == 1] <- data_exp$Tmp_M_1[data_exp$Month == 1]
                data_exp$Temp[data_exp$Month == 2] <- data_exp$Tmp_M_2[data_exp$Month == 2]
                data_exp$Temp[data_exp$Month == 3] <- data_exp$Tmp_M_3[data_exp$Month == 3]
                data_exp$Temp[data_exp$Month == 4] <- data_exp$Tmp_M_4[data_exp$Month == 4]
                data_exp$Temp[data_exp$Month == 5] <- data_exp$Tmp_M_5[data_exp$Month == 5]
                data_exp$Temp[data_exp$Month == 6] <- data_exp$Tmp_M_6[data_exp$Month == 6]
                data_exp$Temp[data_exp$Month == 7] <- data_exp$Tmp_M_7[data_exp$Month == 7]
                data_exp$Temp[data_exp$Month == 8] <- data_exp$Tmp_M_8[data_exp$Month == 8]
                data_exp$Temp[data_exp$Month == 9] <- data_exp$Tmp_M_9[data_exp$Month == 9]
                data_exp$Temp[data_exp$Month == 10] <- data_exp$Tmp_M_10[data_exp$Month == 10]
                data_exp$Temp[data_exp$Month == 11] <- data_exp$Tmp_M_11[data_exp$Month == 11]
                data_exp$Temp[data_exp$Month == 12] <- data_exp$Tmp_M_12[data_exp$Month == 12]
                
                #ALBEDO
                
                #Spruce
                data_exp$Albedo_Spruce[data_exp$Month == 1] <- data_exp$M_1_A_S[data_exp$Month == 1]
                data_exp$Albedo_Spruce[data_exp$Month == 2] <- data_exp$M_2_A_S[data_exp$Month == 2]
                data_exp$Albedo_Spruce[data_exp$Month == 3] <- data_exp$M_3_A_S[data_exp$Month == 3]
                data_exp$Albedo_Spruce[data_exp$Month == 4] <- data_exp$M_4_A_S[data_exp$Month == 4]
                data_exp$Albedo_Spruce[data_exp$Month == 5] <- data_exp$M_5_A_S[data_exp$Month == 5]
                data_exp$Albedo_Spruce[data_exp$Month == 6] <- data_exp$M_6_A_S[data_exp$Month == 6]
                data_exp$Albedo_Spruce[data_exp$Month == 7] <- data_exp$M_7_A_S[data_exp$Month == 7]
                data_exp$Albedo_Spruce[data_exp$Month == 8] <- data_exp$M_8_A_S[data_exp$Month == 8]
                data_exp$Albedo_Spruce[data_exp$Month == 9] <- data_exp$M_9_A_S[data_exp$Month == 9]
                data_exp$Albedo_Spruce[data_exp$Month == 10] <- data_exp$M_10_A_S[data_exp$Month == 10]
                data_exp$Albedo_Spruce[data_exp$Month == 11] <- data_exp$M_11_A_S[data_exp$Month == 11]
                data_exp$Albedo_Spruce[data_exp$Month == 12] <- data_exp$M_12_A_S[data_exp$Month == 12]
                
                #Pine
                data_exp$Albedo_Pine[data_exp$Month == 1] <- data_exp$M_1_A_P[data_exp$Month == 1]
                data_exp$Albedo_Pine[data_exp$Month == 2] <- data_exp$M_2_A_P[data_exp$Month == 2]
                data_exp$Albedo_Pine[data_exp$Month == 3] <- data_exp$M_3_A_P[data_exp$Month == 3]
                data_exp$Albedo_Pine[data_exp$Month == 4] <- data_exp$M_4_A_P[data_exp$Month == 4]
                data_exp$Albedo_Pine[data_exp$Month == 5] <- data_exp$M_5_A_P[data_exp$Month == 5]
                data_exp$Albedo_Pine[data_exp$Month == 6] <- data_exp$M_6_A_P[data_exp$Month == 6]
                data_exp$Albedo_Pine[data_exp$Month == 7] <- data_exp$M_7_A_P[data_exp$Month == 7]
                data_exp$Albedo_Pine[data_exp$Month == 8] <- data_exp$M_8_A_P[data_exp$Month == 8]
                data_exp$Albedo_Pine[data_exp$Month == 9] <- data_exp$M_9_A_P[data_exp$Month == 9]
                data_exp$Albedo_Pine[data_exp$Month == 10] <- data_exp$M_10_A_P[data_exp$Month == 10]
                data_exp$Albedo_Pine[data_exp$Month == 11] <- data_exp$M_11_A_P[data_exp$Month == 11]
                data_exp$Albedo_Pine[data_exp$Month == 12] <- data_exp$M_12_A_P[data_exp$Month == 12]
                
                #Birch
                data_exp$Albedo_Birch[data_exp$Month == 1] <- data_exp$M_1_A_B[data_exp$Month == 1]
                data_exp$Albedo_Birch[data_exp$Month == 2] <- data_exp$M_2_A_B[data_exp$Month == 2]
                data_exp$Albedo_Birch[data_exp$Month == 3] <- data_exp$M_3_A_B[data_exp$Month == 3]
                data_exp$Albedo_Birch[data_exp$Month == 4] <- data_exp$M_4_A_B[data_exp$Month == 4]
                data_exp$Albedo_Birch[data_exp$Month == 5] <- data_exp$M_5_A_B[data_exp$Month == 5]
                data_exp$Albedo_Birch[data_exp$Month == 6] <- data_exp$M_6_A_B[data_exp$Month == 6]
                data_exp$Albedo_Birch[data_exp$Month == 7] <- data_exp$M_7_A_B[data_exp$Month == 7]
                data_exp$Albedo_Birch[data_exp$Month == 8] <- data_exp$M_8_A_B[data_exp$Month == 8]
                data_exp$Albedo_Birch[data_exp$Month == 9] <- data_exp$M_9_A_B[data_exp$Month == 9]
                data_exp$Albedo_Birch[data_exp$Month == 10] <- data_exp$M_10_A_B[data_exp$Month == 10]
                data_exp$Albedo_Birch[data_exp$Month == 11] <- data_exp$M_11_A_B[data_exp$Month == 11]
                data_exp$Albedo_Birch[data_exp$Month == 12] <- data_exp$M_12_A_B[data_exp$Month == 12]
                
                #Remove replaced columns
                data_exp <- data_exp[,c(1:41, 103:138)] #Shapefile output is HUGE and takes forever to load, easier to just process initial df
                

        #Filter down to columns used in Shiny app (DROP GEOMETRY)
        data_filt <- st_drop_geometry(data_exp[,c(1,14,54,72:77)])
        
        
        #Add "month name" column
        data_filt$Month_Name <- ''
        
        #Vectorized
        data_filt$Month_Name[data_filt$Month == 1] <- "January"
        data_filt$Month_Name[data_filt$Month == 2] <- "February"
        data_filt$Month_Name[data_filt$Month == 3] <- "March"
        data_filt$Month_Name[data_filt$Month == 4] <- "April"
        data_filt$Month_Name[data_filt$Month == 5] <- "May"
        data_filt$Month_Name[data_filt$Month == 6] <- "June"
        data_filt$Month_Name[data_filt$Month == 7] <- "July"
        data_filt$Month_Name[data_filt$Month == 8] <- "August"
        data_filt$Month_Name[data_filt$Month == 9] <- "September"
        data_filt$Month_Name[data_filt$Month == 10] <- "October"
        data_filt$Month_Name[data_filt$Month == 11] <- "November"
        data_filt$Month_Name[data_filt$Month == 12] <- "December"
        
        test <- data_filt[1:5,]
        
        #Save df with "Feather" package (for quick loading w/ R Shiny)
        write_feather(data_filt, "2_Albedo_Regional/Approach_1_SatSkog/Output/Attempt_2_Visualization/1999_Shiny_App_Data/df/shiny_data_1999.feather")

#END PREP 1999 DATA FOR SHINY APP -------------------------------------------------------------------------- 