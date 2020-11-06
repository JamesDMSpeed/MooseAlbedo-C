## Script to calculate albedo estimates for all sites in Trøndelag across all years

##PACKAGES ----------------------------------------------------------------------------------------

        #Packages for data processing + visualization
        library(dplyr)
        library(tidyr)
        library(ggplot2)
        library(sf)
        library(raster)
        
###END PACKAGES ----------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#INITIAL DATA IMPORT ----------------------------------------------------------------------------------------------

        ## SITE DATA
        
                #Get 'cleaned' site data from adjacent 'Sites' folder
                site_data <- read.csv('1_Albedo_Exclosures/Data/SustHerb_Site_Data/cleaned_data/cleaned_data.csv', header = TRUE)


        #PLOT STAND VOLUME (m3/ha) (Trondelag: 2009-2019)

                #Load plot volumes
                plot_volumes <- read.csv('1_Albedo_Exclosures/Approach_1A/Output/tree_volumes/tree_volumes.csv', header = TRUE)
        
        
        #SENORGE SWE and TEMP (2009-2018)    
                
                #Add monthly SWE averages from seNorge
                swe <- read.csv('1_Albedo_Exclosures/Universal/Output/SWE/monthly_avg_swe_mm_all_years.csv', header = TRUE)
                
                #Add monthly temperature averages from seNorge
                temps <- read.csv('1_Albedo_Exclosures/Universal/Output/Temperature/monthly_avg_temp_C_all_years.csv', header = TRUE)
                
                        #Convert temps from celsius (C) to kelvin (K)
                        for( i in 1:length(temps$X)){
                                #K = C + 273.15
                                temps[i, "Avg_Temp_C"] <- temps[i, "Avg_Temp_C"] + 273.15
                        }
                        
                        #Rename column from C to K
                        colnames(temps)[5] <- "Avg_Temps_K"
                        
                        
        #HERBIVORE DENSITY DATA (2015 - MUNICIPALITY RESOLUTION)
                        
                #Read in herbivore biomass data (2015) from SpatialPolygons object (isolate dataframe)
                hbiomass_shp <- shapefile("2_Albedo_Regional/Data/Herbivore_Densities/NorwayLargeHerbivores")
                
                #Pull out dataframe
                hbiomass <- hbiomass_shp@data
                
                #Isolate to 2015 data
                hbiomass2015<- cbind(hbiomass[,c(1:10)], hbiomass$Ms_2015, hbiomass$Rd__2015, hbiomass$R_d_2015)
                
                
        ## SUSTHERB SITE PRODUCTIVITY INDICES
                
                #Productivity Data
                productivity <- read.csv('1_Albedo_Exclosures/Data/SustHerb_Site_Data/productivity_all_sites.csv', header = TRUE)
                productivity$LocalityName <- tolower(productivity$LocalityName)
                
                #Correct LocalityName items in productivity CSV
                
                        #Didrik Holmsen
                        productivity$LocalityName[productivity$LocalityName == "didrik holmsen"] <- "didrik_holmsen"
                        
                        #Fet 3
                        productivity$LocalityName[productivity$LocalityName == "fet 3"] <- "fet_3"
                        
                        #Fritsøe 1
                        productivity$LocalityName[productivity$LocalityName == "fritsøe1"] <- "fritsoe1"
                        
                        #Fritsøe 2
                        productivity$LocalityName[productivity$LocalityName == "fritsøe2"] <- "fritsoe2"
                        
                        #Halvard Pramhus
                        productivity$LocalityName[productivity$LocalityName == "halvard pramhus"] <- "halvard_pramhus"
                        
                        #Singsaas
                        productivity$LocalityName[productivity$LocalityName == "singsås"] <- "singsaas"
                        
                        #Stangeskovene Aurskog
                        productivity$LocalityName[productivity$LocalityName == "stangeskovene aurskog"] <- "stangeskovene_aurskog"
                        
                        #Stangeskovene Eidskog
                        productivity$LocalityName[productivity$LocalityName == "stangeskovene eidskog"] <- "stangeskovene_eidskog"
                        
                        #Stig Dahlen
                        productivity$LocalityName[productivity$LocalityName == "stig dæhlen"] <- "stig_dahlen"
                        
                        #Truls Holm
                        productivity$LocalityName[productivity$LocalityName == "truls holm"] <- "truls_holm"
                        
                        
        ## SUSTHERB TREE SPECIES PROPORTIONS (PLOT LEVEL - 2009-2019)
                        
                #Tree density data for Trøndelag, Telemark, and Hedmark
                ##NOTE: THIS DATA IS CURRENTLY LIMITED TO 2018, SINCE ADDITIONAL SENORGE DATA NEEDS TO BE PULLED TO ALLOW ANALYSIS
                ## OF 2019 AND 2020
                tree_data <- read.csv('1_Albedo_Exclosures/Universal/Output/Tree_Species_Proportions/tree_species_proportions_plot_level.csv', header = TRUE)
                tree_data <- tree_data[tree_data$Year <= 2018, 2:7]
                
                        #Filter out unused SustHerb sites
                        
                        #Convert site codes to factors
                        tree_data$LocalityCode <- as.factor(tree_data$LocalityCode)
                        site_data$LocalityCode <- as.factor(site_data$LocalityCode)
                        
                        #Get vector of levels for sites that will be used (n = 74)
                        used_sites <- levels(site_data$LocalityCode)
                        
                        #Filter tree data to used sites
                        tree_data <- tree_data[tree_data$LocalityCode %in% used_sites,]
                        tree_data$LocalityCode <- as.factor(as.character(tree_data$LocalityCode))

#END INITIAL DATA IMPORT --------------------------------------------------------------------------------
        
        
        
        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\



        
#CALCULATE ALBEDO --------------------------------------------------------------------------------------

        #Source the albedo model 
        source("3_Albedo_Model/albedo_model_volume.R")                
                        
#HOW DO I HANDLE PLOTS WITH 0 VOLUME? 
                        

        #Blank dataframe to hold final albedo values
        albedo_final <- data.frame("Year" = integer(),
                                   "Years_Since_Exclosure" = integer(),
                                   "Clearcut_Year" = integer(),
                                   "Exclosure_Year" = integer(),
                                   "Month" = integer(),
                                   "Birch_Albedo" = numeric(),
                                   "Pine_Albedo" = numeric(),
                                   "Spruce_Albedo" = numeric(),
                                   "SWE_mm" = double(),
                                   "Temp_K" = double(),
                                   "Region" = factor(),
                                   "LocalityName" = factor(),
                                   "LocalityCode" = factor(),
                                   "Treatment" = factor())
        
                        
        #For each LocalityCode, run albedo model function w/ relevant arguments
        for(i in 1:length(used_sites)){
                
                #Get relevant arguments and variables
                
                        #LocalityCode
                        a <- as.character(used_sites[i])
                        
                        #LocalityName
                        b <- site_data$LocalityName[site_data$LocalityCode == a]
                        
                        #Treatment (open or exclosure)
                        c <- site_data$Treatment[site_data$LocalityCode == a]
                        
                        #Region
                        reg <- site_data$Region[site_data$LocalityCode == a]
                        
                        #First available year of tree data for this site
                        first_year <- min(plot_volumes$Year[plot_volumes$LocalityCode == a])
                        
                        #Last available year of tree data for this site
                        last_year <- max(plot_volumes$Year[plot_volumes$LocalityCode == a])
                        
                        #Clearcut year
                        clearcut_year <- site_data$Clear.cut[site_data$LocalityCode == a]
                        
                        #Years since exclosure
                        exclosure_year <- site_data$Year.initiated[site_data$LocalityCode == a]
                        
                        
                #Define dataframe to hold albedo estimates for site i (across all years)
                site_all_years <- data.frame("Year" = integer(),
                                             "Years_Since_Exclosure" = integer(),
                                             "Clearcut_Year" = integer(),
                                             "Exclosure_Year" = integer(),
                                             "Month" = integer(),
                                             "Birch_Albedo" = numeric(),
                                             "Pine_Albedo" = numeric(),
                                             "Spruce_Albedo" = numeric(),
                                             "SWE_mm" = double(),
                                             "Temp_K" = double(),
                                             "Region" = factor(),
                                             "LocalityName" = factor(),
                                             "LocalityCode" = factor(),
                                             "Treatment" = factor())
                
                #Loop from first year to last year and calculate albedo for each
                for(j in first_year:last_year){
                        
                        #VOLUME (M3/HA)
                        
                                #Grab volumes
                        
                                        #Birch volume
                                        b_vol <- plot_volumes$Birch_Volume_m3_ha[plot_volumes$Year == j & plot_volumes$LocalityCode == a]
                                        
                                        #Pine volume
                                        p_vol <- plot_volumes$Pine_Volume_m3_ha[plot_volumes$Year == j & plot_volumes$LocalityCode == a]
                                        
                                        #Spruce volume
                                        s_vol <- plot_volumes$Spruce_Volume_m3_ha[plot_volumes$Year == j & plot_volumes$LocalityCode == a]
                                        
                                
                                #Get years since exclosure (current year - initiation of exclosure)
                                a_excl <- j - exclosure_year
                        

                        #SENORGE SWE + TEMPERATURE
                        
                                #NOTE: The SWE and Temp datasets only have data for the 'browsed' plots
                                ## However, it is assumed that the exclosures have the same SWE & Temp data
                                ### The code below handles this issue - for all exclosures, SWE/Temp data
                                #### from open plots is used
                                
                                #If exclosure, get LocalityCode for corresponding open plot
                                if(c == "exclosure"){
                                        
                                        d <- as.character(site_data$LocalityCode[site_data$LocalityName == b & site_data$Treatment == 'open'])
                                        
                                        #Temps
                                        a_temps <- temps$Avg_Temps_K[temps$LocalityCode == d & temps$Year == j]
                                        
                                        #SWE
                                        a_swe <- swe$SWE_mm[swe$LocalityCode == d & swe$Year == j]
                                        
                                } else if (c == "open"){
                                        
                                        #Temps
                                        a_temps <- temps$Avg_Temps_K[temps$LocalityCode == a & temps$Year == j]
                                        
                                        #SWE
                                        a_swe <- swe$SWE_mm[swe$LocalityCode == a & swe$Year == j]
                                        
                                }
                        
                        
                        #CALCULATE ALBEDO
                        
                                #Run function with necessary arguments
                                year_df <- albedoVol(site = a,
                                                     localityName = b,
                                                     region = reg,
                                                     treatment = c,
                                                     birch_vol = b_vol,
                                                     pine_vol = p_vol,
                                                     spruce_vol = s_vol,
                                                     temp = a_temps,
                                                     swe = a_swe)
                                
                                #Add year column (with current year)
                                year_df$Year <- j
                                
                                #Add 'years since exclosure' column
                                year_df$Years_Since_Exclosure <- a_excl
                                
                                #Add "exclosure year" column
                                year_df$Exclosure_Year <- exclosure_year
                                
                                #Add "year of clearcut" column
                                year_df$Clearcut_Year <- clearcut_year
                                
                                #Add region column
                                year_df$Region <- reg
                        
                                site_all_years <- rbind(site_all_years, year_df)
                        
                } #END OF YEAR LOOP
                
                #Bind all years for site i to final df
                albedo_final <- rbind(albedo_final, site_all_years)        
        }
        
        #Make sure data columns are of correct class
        albedo_final$Month <- as.integer(albedo_final$Month)
        albedo_final$Spruce_Albedo <- as.numeric(albedo_final$Spruce_Albedo)
        albedo_final$Birch_Albedo <- as.numeric(albedo_final$Birch_Albedo)
        albedo_final$Pine_Albedo <- as.numeric(albedo_final$Pine_Albedo)
        albedo_final$SWE_mm <- as.numeric(albedo_final$SWE_mm)
        albedo_final$Temp_K <- as.numeric(albedo_final$Temp_K)
        albedo_final$LocalityCode <- as.factor(albedo_final$LocalityCode)
        albedo_final$LocalityName <- as.factor(albedo_final$LocalityName)
        albedo_final$Treatment <- as.factor(albedo_final$Treatment)
        albedo_final$Year <- as.integer(albedo_final$Year)
        albedo_final$Years_Since_Exclosure <- as.integer(albedo_final$Years_Since_Exclosure)
        albedo_final$Region <- as.factor(albedo_final$Region)
        
        
        #CALCULATE SINGLE COMPOSITE ALBEDO VALUE
        
                #Add placeholder column for composite albedo
                albedo_final$Composite_Albedo <- as.numeric('')
        
                #Loop through all albedo observations and calculate composite albedo w/
                #weighted average of species-specific albedo values
                for(i in 1:nrow(albedo_final)){
                        
                        #Get albedo values from row i
                        b_alb <- albedo_final[i, "Birch_Albedo"]
                        s_alb <- albedo_final[i, "Spruce_Albedo"]
                        p_alb <- albedo_final[i, "Pine_Albedo"]
                        
                        #Get tree species proportions for relevant site and corresponding year
                        year <- albedo_final[i, "Year"]
                        site <- as.character(albedo_final[i, "LocalityCode"])
                        b_prop <- tree_data$Prop_birch[tree_data$LocalityCode == site & tree_data$Year == year]
                        p_prop <- tree_data$Prop_pine[tree_data$LocalityCode == site & tree_data$Year == year]
                        s_prop <- tree_data$Prop_spruce[tree_data$LocalityCode == site & tree_data$Year == year]
                        
                        #Get number of species present (as some plots don't have spruce, pine, or birch)
                        num <- 0
                        if(b_prop > 0){
                                num <- num + 1
                        }
                        
                        if(s_prop > 0){
                                num <- num + 1
                        }
                        
                        if(p_prop > 0){
                                num <- num + 1
                        }
                        
                        #Calculate composite albedo via weighted average
                        
                                #Note: some plots have 0% of one or more species - this is reflected in the 
                                #denominator of the weighted average ("num" variable)
                                comp_albedo <- (b_alb*b_prop) + (s_alb*s_prop) + (p_alb*p_prop)
                                
                                #Add composite albedo to dataframe
                                albedo_final[i, "Composite_Albedo"] <- comp_albedo
                                
                }

#END CALCULATE ALBEDO ---------------------------------------------------------------------------------- 
        
        
        
        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#CALCULATE ALBEDO DIFFERENCE (TREATMENT EFFECT) -----------------------------------------------------------------------------------------
        
        
        #Drangedal3 in 2010 seems erroneous (only UB but not B) - going to drop for now to plot further
        albedo_final <- albedo_final[!(albedo_final$LocalityName == "drangedal3" & albedo_final$Year == 2010),]
        
        #WRITE RAW DF OF ALBEDO ESTIMATES FOR ALL PLOTS, MONTHS, AND YEARS
        write.csv(albedo_final, "1_Albedo_Exclosures/Approach_1A/Output/albedo_estimates/albedo_estimates_all.csv")
        
        
        
        
        #Get difference between open plots and exclosures for each site (across all years)
        
                #Aggregate
                #NOTE: No problems found with the numeric(0) issue experienced w/ tree volumes
                ## Differences below should be valid
        
                        #Birch
                        albedo_diff_birch <- aggregate(albedo_final$Birch_Albedo,
                                                 by = list(Month = albedo_final$Month,
                                                           Year = albedo_final$Year,
                                                           LocalityName = albedo_final$LocalityName,
                                                           Region = albedo_final$Region,
                                                           Years_Since_Exclosure = albedo_final$Years_Since_Exclosure),
                                                 FUN = diff)
                        colnames(albedo_diff_birch)[6] <- "Birch_Albedo_Diff"
                        albedo_diff_birch$Birch_Albedo_Diff <- as.numeric(albedo_diff_birch$Birch_Albedo_Diff)
                        
                        #Spruce
                        albedo_diff_spruce <- aggregate(albedo_final$Spruce_Albedo,
                                                       by = list(Month = albedo_final$Month,
                                                                 Year = albedo_final$Year,
                                                                 LocalityName = albedo_final$LocalityName,
                                                                 Region = albedo_final$Region,
                                                                 Years_Since_Exclosure = albedo_final$Years_Since_Exclosure),
                                                       FUN = diff)
                        colnames(albedo_diff_spruce)[6] <- "Spruce_Albedo_Diff"
                        
                        #Pine
                        albedo_diff_pine <- aggregate(albedo_final$Pine_Albedo,
                                                       by = list(Month = albedo_final$Month,
                                                                 Year = albedo_final$Year,
                                                                 LocalityName = albedo_final$LocalityName,
                                                                 Region = albedo_final$Region,
                                                                 Years_Since_Exclosure = albedo_final$Years_Since_Exclosure),
                                                       FUN = diff)
                        colnames(albedo_diff_pine)[6] <- "Pine_Albedo_Diff"
                        
                        #Composite Albedo
                        albedo_diff_comp <- aggregate(albedo_final$Composite_Albedo,
                                                      by = list(Month = albedo_final$Month,
                                                                Year = albedo_final$Year,
                                                                LocalityName = albedo_final$LocalityName,
                                                                Region = albedo_final$Region,
                                                                Years_Since_Exclosure = albedo_final$Years_Since_Exclosure),
                                                      FUN = diff)
                        colnames(albedo_diff_comp)[6] <- "Composite_Albedo_Diff"
                        
                        
                        #Rbind into df for visualization
                        albedo_diff <- cbind(albedo_diff_birch, albedo_diff_pine$Pine_Albedo_Diff, albedo_diff_spruce$Spruce_Albedo_Diff, albedo_diff_comp$Composite_Albedo_Diff)
                        colnames(albedo_diff)[7] <- "Pine_Albedo_Diff"
                        colnames(albedo_diff)[8] <- "Spruce_Albedo_Diff"
                        colnames(albedo_diff)[9] <- "Composite_Albedo_Diff"
                        
                        #Ensure numeric
                        albedo_diff$Spruce_Albedo_Diff <- as.numeric(albedo_diff$Spruce_Albedo_Diff)
                        albedo_diff$Pine_Albedo_Diff <- as.numeric(albedo_diff$Pine_Albedo_Diff)
                        albedo_diff$Birch_Albedo_Diff <- as.numeric(albedo_diff$Birch_Albedo_Diff)
                        albedo_diff$Composite_Albedo_Diff <- as.numeric(albedo_diff$Composite_Albedo_Diff)
                        
        #Write CSV for differences df
        write.csv(albedo_diff, "1_Albedo_Exclosures/Approach_1A/Output/albedo_estimates/albedo_differences_all.csv")
                        
                        
        #Melt dataset (to plot by species)
                        
                #Expand by 3 (one row for each species)
                albedo_melt <- albedo_diff[rep(seq_len(nrow(albedo_diff)), each = 3), ]
                
                #Add albedo and species columns
                albedo_melt$Species <- as.character("")
                albedo_melt$Albedo_Diff <- as.numeric("")
                
                #Add species as vector
                spec <- rep(c("Spruce","Birch","Pine"), times = (nrow(albedo_melt) / 3))
                albedo_melt$Species <- spec
                
                #Add albedo values 
                for(i in 1:nrow(albedo_melt)){
                        
                        print(i)
                        
                        if( albedo_melt[i, "Species"] == "Spruce"){
                                
                                albedo_melt[i, "Albedo_Diff"] <- albedo_melt[i, "Spruce_Albedo_Diff"]
                                
                        } else if (albedo_melt[i, "Species"] == "Birch"){
                                
                                albedo_melt[i, "Albedo_Diff"] <- albedo_melt[i, "Birch_Albedo_Diff"]
                                
                        } else if (albedo_melt[i, "Species"] == "Pine"){
                                
                                albedo_melt[i, "Albedo_Diff"] <- albedo_melt[i, "Pine_Albedo_Diff"]
                                
                        }
                }
                
                #Remove old columns
                albedo_melt <- albedo_melt[,c(1:5,9:11)]
                
                
                #Write CSV for "melted" df
                write.csv(albedo_melt, "1_Albedo_Exclosures/Approach_1A/Output/albedo_estimates/albedo_diff_melted.csv")
        
        
#END CALCULATE ALBEDO DIFFERENCE (TREATMENT EFFECT) --------------------------------------------------------------------------------------
                        
                        
                        
                        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#DATA EXPLORATION ---------------------------------------------------------------------------------
        
        #START HERE IF NO CHANGES ABOVE (LOAD EXISTING CSV)
        albedo_diff <- read.csv("1_Albedo_Exclosures/Approach_1A/Output/albedo_estimates/albedo_differences_all.csv")
        albedo_melt <- read.csv("1_Albedo_Exclosures/Approach_1A/Output/albedo_estimates/albedo_diff_melted.csv")
                
        #Faceted by Month
                
                #Set strip text labels
                months <- c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
                month_labs <- function(variable,value){
                        return(months[value])
                }
                
                #Birch
                png(filename = "1_Albedo_Exclosures/Approach_1A/Output/albedo_estimates/birch_diff.png",
                    width = 1400,
                    height = 1400,
                    units = "px",
                    bg = "white")
                
                ggplot(data = subset(albedo_melt, Species == "Birch"), aes(x = Years_Since_Exclosure, y = Albedo_Diff)) +
                        geom_hline(yintercept = 0, linetype = 2, color = "gray") +
                        geom_point(shape=1) +
                        facet_wrap(.~Month, ncol = 4, labeller = month_labs) +
                        geom_smooth(span = 100, color = "black") +
                        scale_x_continuous(limits=c(1,10), breaks = c(1,3,5,7,9)) + 
                        scale_y_continuous(limits=c(-0.060,0.035)) +
                        labs(x = "Years Since Exclosure", y = "Birch Albedo Difference (Excl.-Open)") +
                        theme_bw() +
                        theme(plot.title = element_text(hjust = 0.5, size = 40, margin = margin(t = 40, b = 40)),
                              legend.title = element_text(size = 24),
                              legend.position = "bottom",
                              legend.text = element_text(size = 20),
                              strip.text = element_text(size = 20),
                              axis.text.x = element_text(size = 24, margin = margin(t=16)),
                              axis.text.y = element_text(size = 20, margin = margin(r=16)),
                              axis.title.x = element_text(size = 30, margin = margin(t=40, b = 40)),
                              axis.title.y = element_text(size = 30, margin = margin(r=40)))
                
                dev.off()
                
                #Spruce
                png(filename = "1_Albedo_Exclosures/Approach_1A/Output/albedo_estimates/spruce_diff.png",
                    width = 1400,
                    height = 1400,
                    units = "px",
                    bg = "white")
                
                ggplot(data = subset(albedo_melt, Species == "Spruce"), aes(x = Years_Since_Exclosure, y = Albedo_Diff)) +
                        geom_hline(yintercept = 0, linetype = 2, color = "gray") +
                        geom_point(shape=1) +
                        facet_wrap(.~Month, ncol = 4, labeller = month_labs) +
                        geom_smooth(span = 100, color = "black") +
                        scale_x_continuous(limits=c(1,10), breaks = c(1,3,5,7,9)) + 
                        labs(x = "Years Since Exclosure", y = "Spruce Albedo Difference (Excl.-Open)") +
                        theme_bw() +
                        theme(plot.title = element_text(hjust = 0.5, size = 40, margin = margin(t = 40, b = 40)),
                              legend.title = element_text(size = 24),
                              legend.position = "bottom",
                              legend.text = element_text(size = 20),
                              strip.text = element_text(size = 20),
                              axis.text.x = element_text(size = 24, margin = margin(t=16)),
                              axis.text.y = element_text(size = 20, margin = margin(r=16)),
                              axis.title.x = element_text(size = 30, margin = margin(t=40, b = 40)),
                              axis.title.y = element_text(size = 30, margin = margin(r=40)))
                
                dev.off()
                
                #Pine
                png(filename = "1_Albedo_Exclosures/Approach_1A/Output/albedo_estimates/pine_diff.png",
                    width = 1400,
                    height = 1400,
                    units = "px",
                    bg = "white")
                
                ggplot(data = subset(albedo_melt, Species == "Pine"), aes(x = Years_Since_Exclosure, y = Albedo_Diff)) +
                        geom_hline(yintercept = 0, linetype = 2, color = "gray") +
                        geom_point(shape=1) +
                        facet_wrap(.~Month, ncol = 4, labeller = month_labs) +
                        geom_smooth(span = 100, color = "black") +
                        scale_x_continuous(limits=c(1,10), breaks = c(1,3,5,7,9)) + 
                        labs(x = "Years Since Exclosure", y = "Pine Albedo Difference (Excl.-Open)") +
                        theme_bw() +
                        theme(plot.title = element_text(hjust = 0.5, size = 40, margin = margin(t = 40, b = 40)),
                              legend.title = element_text(size = 24),
                              legend.position = "bottom",
                              legend.text = element_text(size = 20),
                              strip.text = element_text(size = 20),
                              axis.text.x = element_text(size = 24, margin = margin(t=16)),
                              axis.text.y = element_text(size = 20, margin = margin(r=16)),
                              axis.title.x = element_text(size = 30, margin = margin(t=40, b = 40)),
                              axis.title.y = element_text(size = 30, margin = margin(r=40)))
                
                dev.off()
                
                
                #All Species (Mean w/ SEs)
                pd <- position_dodge(0.5)
                
                        #Calculate means of each species for each "Year Since Exclosure"
                        means <- aggregate(albedo_melt$Albedo_Diff, by = list(albedo_melt$Month, albedo_melt$Years_Since_Exclosure, albedo_melt$Species), FUN = mean)
                        colnames(means) <- c("Month", "Years_Since_Exclosure", "Species", "Albedo_Diff")
                        
                        #Calculate standard error for each mean
                        
                                #Define function
                                std <- function(x) sd(x)/sqrt(length(x))
                                
                                #Add placeholder columns
                                means$SE <- as.numeric("")

                        #Calculate SEs for each year for each month
                        spec_list <- c("Spruce", "Pine", "Birch")
                        
                        for(i in min(albedo_melt$Years_Since_Exclosure):max(albedo_melt$Years_Since_Exclosure)){
                                
                                #For each month
                                for(j in 1:12){
                                        
                                        #For each species
                                        for(k in 1:length(spec_list)){
                                                
                                                means$SE[means$Years_Since_Exclosure == i & means$Month == j & means$Species == spec_list[k]] <- std(albedo_melt$Albedo_Diff[albedo_melt$Years_Since_Exclosure == i & albedo_melt$Month == j & albedo_melt$Species == spec_list[k]])

                                        }
                                        
                                }
                                
                        }
                        
                       
                means$Albedo_Diff <- as.numeric(means$Albedo_Diff)
                
                png(filename = "1_Albedo_Exclosures/Approach_1A/Output/albedo_estimates/mean_diff_species.png",
                    width = 1800,
                    height = 1400,
                    units = "px",
                    bg = "white")
                
                ggplot(data = means, aes(x = Years_Since_Exclosure, y = Albedo_Diff, color = Species, group = Species)) +
                        geom_hline(yintercept = 0, linetype = 2, color = "gray") +
                        geom_errorbar(aes(ymin = (Albedo_Diff - SE), ymax = (Albedo_Diff + SE)), colour="black", width=.8, position = pd) +
                        geom_line(lwd = 1.3, aes(linetype = Species)) +
                        geom_point(aes(shape = Species), position = pd, size = 4) +
                        facet_wrap(.~Month, ncol = 4, labeller = month_labs) +
                        scale_x_continuous(limits=c(0,12), breaks = c(0,2,4,6,8,10)) + 
                        scale_y_continuous(limits = c(-0.025, 0.01)) +
                        labs(x = "Years Since Exclosure", y = "Mean Albedo Difference (Excl.-Open)") +
                        theme_bw() +
                        theme(plot.title = element_text(hjust = 0.5, size = 40, margin = margin(t = 40, b = 40)),
                              legend.title = element_text(size = 24),
                              legend.position = "bottom",
                              legend.text = element_text(size = 20),
                              strip.text = element_text(size = 20),
                              axis.text.x = element_text(size = 24, margin = margin(t=16)),
                              axis.text.y = element_text(size = 20, margin = margin(r=16)),
                              axis.title.x = element_text(size = 30, margin = margin(t=40, b = 40)),
                              axis.title.y = element_text(size = 30, margin = margin(r=40)))
                
                dev.off()
                
        
                
        
                
                        
#END DATA EXPLORATION -----------------------------------------------------------------------------        