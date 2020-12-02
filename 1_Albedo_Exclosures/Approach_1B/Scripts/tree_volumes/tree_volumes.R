## Script to calculate tree volumes for all sites in Trøndelag (across)
## using biomass estimates calculated from the backfitted "height-only" allometric models and height class only

##PACKAGES ----------------------------------------------------------------------------------------

        #Packages for data processing + visualization
        library(dplyr)
        library(tidyr)
        library(ggplot2)
        library(grid)
        library(wesanderson)
        
###END PACKAGES ----------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#INITIAL DATA IMPORT ----------------------------------------------------------------------------------------------

        #Import CSV to dataframe
        data <- read.csv('1_Albedo_Exclosures/Approach_1B/Output/tree_biomass/tree_biomass.csv', header = TRUE)

#END INITIAL DATA IMPORT --------------------------------------------------------------------------------
        
        
        
        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\



        
#CALCULATE VOLUME FOR EACH TREE ---------------------------------------------------
        
        #Calculate volume for each tree
        
                #SPECIFIC WOOD DENSITIES TO CONVERT BIOMASS TO VOLUME
                ##Note: These are average wood densities for spruce, pine, and birch - provided by Repola (2006)
                
                        #This will likely be a major source of error - according to Repola (2006), density varies widely vertically
                
                        #Spruce density (kg/m3 converted to g/cm3)
                        s_density <- 385.3 / 1000
                        
                        #Pine density (kg/m3 converted to g/cm3)
                        p_density <- 412.6 / 1000
                        
                        #Birch density (kg/m3 converted to g/cm3)
                        b_density <- 475 / 1000
                        
                #Based on species, calculate volume & assign to either birch, pine, or spruce
                        
                        #Add blank column for volume
                        data$Volume_m3 <- ''
                        
                        #Add blank column for group
                        data$Group <- ''
                        
                        #Birch -----
                        
                                #Calculate volume
                                data$Volume_m3[data$Taxa == "Betula pubescens (Bjørk)" |
                                                       data$Taxa == "Betula pendula (Lavlandbjørk)" |
                                                       data$Taxa == "Salix caprea (Selje)"] <- (data$Biomass_g[data$Taxa == "Betula pubescens (Bjørk)" |
                                                                                                                       data$Taxa == "Betula pendula (Lavlandbjørk)" |
                                                                                                                       data$Taxa == "Salix caprea (Selje)"] / b_density) / 1e06
                                #Assign group to birch
                                data$Group[data$Taxa == "Betula pubescens (Bjørk)" |
                                                       data$Taxa == "Betula pendula (Lavlandbjørk)" |
                                                       data$Taxa == "Salix caprea (Selje)"] <- "Birch"
                                
                        
                        #Spruce ------
                                
                                #Calculate volume
                                data$Volume_m3[data$Taxa == "Picea abies (Gran)" |
                                                data$Taxa == "Juniperus communis (Einer)"] <- (data$Biomass_g[data$Taxa == "Picea abies (Gran)" |
                                                                                                                      data$Taxa == "Juniperus communis (Einer)"] / s_density) / 1e06
                                
                                #Assign group to spruce
                                data$Group[data$Taxa == "Picea abies (Gran)" |
                                                       data$Taxa == "Juniperus communis (Einer)"] <- "Spruce"
                                
                                
                        #Pine -------
                                
                                #Calculate volume
                                data$Volume_m3[data$Taxa == "Pinus sylvestris (Furu)"] <- (data$Biomass_g[data$Taxa == "Pinus sylvestris (Furu)"] / p_density) / 1e06
                                
                                #Assign group to pine
                                data$Group[data$Taxa == "Pinus sylvestris (Furu)"] <- "Pine"
                                
                                
                        #Rowan (NOTE: using birch-specific density due to lack of rowan-specific density) ------
                                
                                #Calculate volume
                                data$Volume_m3[data$Taxa == "Sorbus aucuparia (Rogn)"] <- (data$Biomass_g[data$Taxa == "Sorbus aucuparia (Rogn)"] / b_density) / 1e06
                        
                                #Assign group
                                data$Group[data$Taxa == "Sorbus aucuparia (Rogn)"] <- "Birch"
        
                                
                #Ensure that 'Volume' column is numeric
                data$Volume_m3 <- as.numeric(data$Volume_m3)
                
                #Ensure that "Group' column is factor
                data$Group <- as.factor(data$Group)
                
        

        #Calculate plot sampling area in hectares (used to convert m3 to m3/ha) -------
                
                #Each subplot has a radius of 2m - A = pi*r^2
                subplot_area <- pi*(2^2) #12.57m2
                
                #Convert m2 to hectares (ha) - 1m2 = 0.0001 ha (divide by 10,000)
                subplot_area_ha <- subplot_area/10000
                
        
        #Aggregate volume (m3) for each species by subplots within main plots
                
                vol <- aggregate(data$Volume_m3, by = list(data$Region,
                                                                 data$LocalityName,
                                                                 data$LocalityCode,
                                                                 data$Treatment,
                                                                 data$Plot,
                                                                 data$Years_Since_Exclosure,
                                                                 data$Group), FUN = sum)
                
                colnames(vol) <- c("Region", "LocalityName", "LocalityCode", "Treatment", "Subplot", "Years_Since_Exclosure", "Group", "Volume_m3")
                
        #Create volume/area (m3/ha) column - divide m3 by subplot area 
                
                vol$Volume_m3ha <- vol$Volume_m3 / subplot_area_ha
                
                
                
        #Mean volume (m3/ha) and SE for each species and treatment ---------
                
                #Aggregate means
                vol_means <- aggregate(vol$Volume_m3ha, by = list(vol$Treatment, vol$Years_Since_Exclosure, vol$Group), FUN = mean)
                colnames(vol_means) <- c("Treatment", "Years_Since_Exclosure", "Group", "Average_vol_m3_ha")
                
                #Calculate standard error for each mean
                
                        #Define function
                        std <- function(x) sd(x)/sqrt(length(x))
                        
                        #Add placeholder columns
                        vol_means$SE <- as.numeric('')
                
                        #Calculate SEs for each year
                        
                        for(i in min(vol_means$Years_Since_Exclosure):max(vol_means$Years_Since_Exclosure)){
                                
                                #Birch volume SE
                                
                                        #Browsed
                                        vol_means$SE[vol_means$Group == "Birch" & vol_means$Years_Since_Exclosure == i & vol_means$Treatment == "B"] <- std(vol$Volume_m3ha[vol$Years_Since_Exclosure == i & vol$Group == "Birch" & vol$Treatment == "B"])
                                
                                        #Unbrowsed
                                        vol_means$SE[vol_means$Group == "Birch" & vol_means$Years_Since_Exclosure == i & vol_means$Treatment == "UB"] <- std(vol$Volume_m3ha[vol$Years_Since_Exclosure == i & vol$Group == "Birch" & vol$Treatment == "UB"])
                                
                                        
                                #Spruce volume SE
                                        
                                        #Browsed
                                        vol_means$SE[vol_means$Group == "Spruce" & vol_means$Years_Since_Exclosure == i & vol_means$Treatment == "B"] <- std(vol$Volume_m3ha[vol$Years_Since_Exclosure == i & vol$Group == "Spruce" & vol$Treatment == "B"])
                                        
                                        #Unbrowsed
                                        vol_means$SE[vol_means$Group == "Spruce" & vol_means$Years_Since_Exclosure == i & vol_means$Treatment == "UB"] <- std(vol$Volume_m3ha[vol$Years_Since_Exclosure == i & vol$Group == "Spruce" & vol$Treatment == "UB"])
                                        
                                        
                                #Pine volume SE
                                        
                                        #Browsed
                                        vol_means$SE[vol_means$Group == "Pine" & vol_means$Years_Since_Exclosure == i & vol_means$Treatment == "B"] <- std(vol$Volume_m3ha[vol$Years_Since_Exclosure == i & vol$Group == "Pine" & vol$Treatment == "B"])
                                        
                                        #Unbrowsed
                                        vol_means$SE[vol_means$Group == "Pine" & vol_means$Years_Since_Exclosure == i & vol_means$Treatment == "UB"] <- std(vol$Volume_m3ha[vol$Years_Since_Exclosure == i & vol$Group == "Pine" & vol$Treatment == "UB"])
                                        
                        }
       

#END CALCULATE VOLUME FOR EACH TREE --------------------------------------------------------
        


#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        
        
        
        
#DATA VISUALIZATION ------------------------------------------------------------------------------------------
        
        
        #Plots ------
                
        plot_theme <- theme(plot.title = element_text(hjust = 0.5, size = 50, margin = margin(t = 40, b = 40)),
                            legend.position = "none",
                            axis.text.x = element_text(size = 22, margin = margin(t=16)),
                            axis.text.y = element_text(size = 22, margin = margin(r=16)),
                            axis.title.x = element_text(size = 34, margin = margin(t=40, b = 40)),
                            axis.title.y = element_text(size = 34, margin = margin(r=40)),
                            strip.text.x = element_text(size = 22))
        
        plot_count_label <- c("0", "1\nn=36", "2\nn=37", "3\nn=37", "4\nn=37", "5\nn=37", "6\nn=37", "7\nn=29", "8\nn=29", "9\nn=28", "10\nn=15")
                
                
                #PLOT VOLUME
                        
                        #SCATTERPLOTS -------------
        
                                #All sites
                                png(filename = "1_Albedo_Exclosures/Approach_1B/Output/tree_volumes/scatterplots/volume_by_treatment.png",
                                    width = 1200,
                                    height = 1200,
                                    bg = "white")
                                
                                ggplot(data = vol, aes(x = Years_Since_Exclosure, y = Volume_m3ha, color = Treatment))+
                                        geom_hline(yintercept = 0, color = "gray", linetype = 2) +
                                        geom_point(size = 4.2, alpha = 0.5) +
                                        geom_jitter(size = 4.2, alpha = 0.5, width = 0.1) +
                                        geom_smooth(span = 100, lwd = 1.8) + 
                                        facet_wrap(~ Group, ncol = 1) +
                                        theme_bw() +
                                        labs(x = "Years Since Exclosure", y = expression(atop("Tree Stand Volume "~(m^3/ha))) ) +
                                        scale_x_continuous(limits = c(0, 12), breaks = c(0, 2, 4, 6, 8, 10)) +
                                        scale_color_discrete(labels = c("Browsed", "Unbrowsed")) +
                                        theme(plot.title = element_text(hjust = 0.5, size = 50, margin = margin(t = 40, b = 40)),
                                              axis.text.x = element_text(size = 22, margin = margin(t=16)),
                                              axis.text.y = element_text(size = 22, margin = margin(r=16)),
                                              axis.title.x = element_text(size = 34, margin = margin(t=40, b = 40)),
                                              axis.title.y = element_text(size = 34, margin = margin(r=40)),
                                              strip.text.x = element_text(size = 22),
                                              legend.title = element_text(size = 26),
                                              legend.text = element_text(size = 23, margin = margin(t=10)))
                                
                                dev.off()
                                
                                #Faceted by site
                                
                                        #Birch/Deciduous
                                        png(filename = "1_Albedo_Exclosures/Approach_1B/Output/tree_volumes/scatterplots/deciduous_volume_by_treatment_site.png",
                                            width = 1200,
                                            height = 1200,
                                            bg = "white")
                                        
                                        ggplot(data = subset(vol, Group == "Birch"), aes(x = Years_Since_Exclosure, y = Volume_m3ha, color = Treatment))+
                                                geom_hline(yintercept = 0, color = "gray", linetype = 2) +
                                                geom_point(size = 4.2, alpha = 0.5) +
                                                geom_jitter(size = 4.2, alpha = 0.5, width = 0.1) +
                                                geom_smooth(span = 100, lwd = 1.8) + 
                                                facet_wrap(~ LocalityName) +
                                                theme_bw() +
                                                labs(x = "Years Since Exclosure", y = expression(atop("Deciduous Stand Volume "~(m^3/ha))) ) +
                                                scale_x_continuous(limits = c(0, 12), breaks = c(0, 2, 4, 6, 8, 10)) +
                                                scale_color_discrete(labels = c("Browsed", "Unbrowsed")) +
                                                theme(plot.title = element_text(hjust = 0.5, size = 50, margin = margin(t = 40, b = 40)),
                                                      axis.text.x = element_text(size = 22, margin = margin(t=16)),
                                                      axis.text.y = element_text(size = 22, margin = margin(r=16)),
                                                      axis.title.x = element_text(size = 34, margin = margin(t=40, b = 40)),
                                                      axis.title.y = element_text(size = 34, margin = margin(r=40)),
                                                      strip.text.x = element_text(size = 22),
                                                      legend.title = element_text(size = 26),
                                                      legend.text = element_text(size = 23, margin = margin(t=10)))
                                        
                                        dev.off()
                                        
                                        
                                        #Pine
                                        png(filename = "1_Albedo_Exclosures/Approach_1B/Output/tree_volumes/scatterplots/pine_volume_by_treatment_site.png",
                                            width = 1200,
                                            height = 1200,
                                            bg = "white")
                                        
                                        ggplot(data = subset(vol, Group == "Pine"), aes(x = Years_Since_Exclosure, y = Volume_m3ha, color = Treatment))+
                                                geom_hline(yintercept = 0, color = "gray", linetype = 2) +
                                                geom_point(size = 4.2, alpha = 0.5) +
                                                geom_jitter(size = 4.2, alpha = 0.5, width = 0.1) +
                                                geom_smooth(span = 100, lwd = 1.8) + 
                                                facet_wrap(~ LocalityName) +
                                                theme_bw() +
                                                labs(x = "Years Since Exclosure", y = expression(atop("Pines Stand Volume "~(m^3/ha))) ) +
                                                scale_x_continuous(limits = c(0, 12), breaks = c(0, 2, 4, 6, 8, 10)) +
                                                scale_color_discrete(labels = c("Browsed", "Unbrowsed")) +
                                                theme(plot.title = element_text(hjust = 0.5, size = 50, margin = margin(t = 40, b = 40)),
                                                      axis.text.x = element_text(size = 22, margin = margin(t=16)),
                                                      axis.text.y = element_text(size = 22, margin = margin(r=16)),
                                                      axis.title.x = element_text(size = 34, margin = margin(t=40, b = 40)),
                                                      axis.title.y = element_text(size = 34, margin = margin(r=40)),
                                                      strip.text.x = element_text(size = 22),
                                                      legend.title = element_text(size = 26),
                                                      legend.text = element_text(size = 23, margin = margin(t=10)))
                                        
                                        dev.off()
                                        
                                        
                                        #Spruce
                                        png(filename = "1_Albedo_Exclosures/Approach_1B/Output/tree_volumes/scatterplots/spruce_volume_by_treatment_site.png",
                                            width = 1200,
                                            height = 1200,
                                            bg = "white")
                                        
                                        ggplot(data = subset(vol, Group == "Spruce"), aes(x = Years_Since_Exclosure, y = Volume_m3ha, color = Treatment))+
                                                geom_hline(yintercept = 0, color = "gray", linetype = 2) +
                                                geom_point(size = 4.2, alpha = 0.5) +
                                                geom_jitter(size = 4.2, alpha = 0.5, width = 0.1) +
                                                geom_smooth(span = 100, lwd = 1.8) + 
                                                facet_wrap(~ LocalityName) +
                                                theme_bw() +
                                                labs(x = "Years Since Exclosure", y = expression(atop("Spruce Stand Volume "~(m^3/ha))) ) +
                                                scale_x_continuous(limits = c(0, 12), breaks = c(0, 2, 4, 6, 8, 10)) +
                                                scale_color_discrete(labels = c("Browsed", "Unbrowsed")) +
                                                theme(plot.title = element_text(hjust = 0.5, size = 50, margin = margin(t = 40, b = 40)),
                                                      axis.text.x = element_text(size = 22, margin = margin(t=16)),
                                                      axis.text.y = element_text(size = 22, margin = margin(r=16)),
                                                      axis.title.x = element_text(size = 34, margin = margin(t=40, b = 40)),
                                                      axis.title.y = element_text(size = 34, margin = margin(r=40)),
                                                      strip.text.x = element_text(size = 22),
                                                      legend.title = element_text(size = 26),
                                                      legend.text = element_text(size = 23, margin = margin(t=10)))
                                        
                                        dev.off()
                                
                        

                        #MEANS
                                        
                                #All Sites
                                pd <- position_dodge(0.2)
                                
                                        png(filename = "1_Albedo_Exclosures/Approach_1B/Output/tree_volumes/means/volume_means_all_species.png",
                                            width = 1200,
                                            height = 1200,
                                            bg = "white")
                                                
                                        ggplot(vol_means, aes(x = Years_Since_Exclosure, y = Average_vol_m3_ha, color = Treatment, group = Treatment)) +
                                                geom_hline(yintercept = 0, linetype = 2, color = "gray") +
                                                geom_errorbar(aes(ymin = (Average_vol_m3_ha - SE), ymax = (Average_vol_m3_ha + SE)), colour="black", width=.2, position = pd) +
                                                geom_line(lwd = 1.3, position = pd) +
                                                geom_point(size = 2.5, position = pd) +
                                                geom_hline(yintercept = 0, color = "gray", linetype = 2) +
                                                theme_bw() +
                                                facet_wrap(~ Group, ncol = 1) +
                                                labs(x = "Years Since Exclosure", y = expression(atop("Mean Stand Volume "~(m^3/ha)))) +
                                                scale_x_continuous(limits = c(0, 12), breaks = c(0,2,4,6,8,10)) +
                                                scale_color_discrete(labels = c("Browsed", "Unbrowsed")) +
                                                theme(plot.title = element_text(hjust = 0.5, size = 50, margin = margin(t = 40, b = 40)),
                                                      axis.text.x = element_text(size = 22, margin = margin(t=16)),
                                                      axis.text.y = element_text(size = 22, margin = margin(r=16)),
                                                      axis.title.x = element_text(size = 34, margin = margin(t=40, b = 40)),
                                                      axis.title.y = element_text(size = 34, margin = margin(r=40)),
                                                      strip.text.x = element_text(size = 22),
                                                      legend.title = element_text(size = 26),
                                                      legend.text = element_text(size = 23, margin = margin(t=10)))
                
                                        dev.off()
                        

                        
                        
                
#END DATA VISUALIZATION ----------------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                
                
                
                
#EXPORT PLOTS --------------------------------------------------------------------------------------

        #WRITE CSVs
                        
                #Main Volumes Dataset
                write.csv(vol, "1_Albedo_Exclosures/Approach_1B/Output/tree_volumes/tree_volumes.csv")
                        
                #Volume means + SE by treatment and species
                write.csv(vol_means, "1_Albedo_Exclosures/Approach_1B/Output/tree_volumes/tree_volumes_means_se.csv")
                        
        

#END EXPORT PLOTS ---------------------------------------------------------------------------------- 
