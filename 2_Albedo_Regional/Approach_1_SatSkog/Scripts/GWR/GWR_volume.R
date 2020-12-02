#PACKAGES ----------------------------------------------------------------------

        #Spatial Data Packages
        library(sf)
        
        #Data Manipulation + Visualization
        library(ggplot2)
        library(raster)
        library(lattice)
        library(dplyr)
        library(wesanderson)
        library(beepr)
        library(zoo)
        library(GGally)
        
        #GWR packages
        library(car)
        library(GWmodel)
        library(raster)
        
        
        #Define beepr path
        b <- "4_Misc/beepr_sound.wav"


#END PACKAGES ----------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#IMPORT  --------------------------------------------------------------------------------------------------

        #SATSKOG ALBEDO DATASET ----------
        
                #Load unified & FILTERED shapefile w/ all variables (from all years)
                data <- st_read("2_Albedo_Regional/Data/Final_Shapefile/Output/attempt_3/all_data/corrected_shapefile.shp")
                
                #Correct classes of data
                data$Snrg_yr <- as.factor(data$Snrg_yr)
                data$bonitet <- as.factor(data$bonitet)
                data$treslag <- as.factor(data$treslag)
                
                #Remove duplicate geometries
                data_filt <- distinct(data, .keep_all = T)
                
                #Filter out data with negative elevation
                data_filt <- data_filt[data_filt$dem >= 0,]


#END IMPORT DATA ----------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#RE-CALCULATE ALBEDO FOR EACH OBSERVATION IN PLOTS ----------------------------------------------------------------------

        #BIRCH ALBEDO (Months 1-12)
        
        data_filt$M_1_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_1 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_1 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_1))
        data_filt$M_2_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_2 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_2 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_2))
        data_filt$M_3_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_3 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_3 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_3))
        data_filt$M_4_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_4 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_4 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_4))
        data_filt$M_5_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_5 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_5 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_5))
        data_filt$M_6_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_6 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_6 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_6))
        data_filt$M_7_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_7 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_7 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_7))
        data_filt$M_8_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_8 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_8 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_8))
        data_filt$M_9_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_9 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_9 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_9))
        data_filt$M_10_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_10 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_10 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_10))
        data_filt$M_11_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_11 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_11 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_11))
        data_filt$M_12_A_B <- 0.085+0.089*(1-1/(1+exp(-2.414*(data_filt$Tmp_M_12 - 273.393))))+0.169*(1/(1+exp(-0.107*(data_filt$SWE_M_12 - 37.672))))+0.245*exp(-0.023*data_filt$vuprhal)*(1-0.7*exp(-0.004*data_filt$SWE_M_12))
        
        
        #SPRUCE ALBEDO (Months 1-12)
        
        data_filt$M_1_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_1 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_1 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_1))
        data_filt$M_2_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_2 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_2 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_2))
        data_filt$M_3_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_3 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_3 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_3))
        data_filt$M_4_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_4 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_4 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_4))
        data_filt$M_5_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_5 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_5 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_5))
        data_filt$M_6_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_6 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_6 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_6))
        data_filt$M_7_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_7 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_7 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_7))
        data_filt$M_8_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_8 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_8 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_8))
        data_filt$M_9_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_9 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_9 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_9))
        data_filt$M_10_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_10 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_10 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_10))
        data_filt$M_11_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_11 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_11 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_11))
        data_filt$M_12_A_S <- 0.077+0.072*(1-1/(1+exp(-2.354*(data_filt$Tmp_M_12 - 273.433))))+0.074*(1/(1+exp(-0.191*(data_filt$SWE_M_12 - 33.093))))+0.252*exp(-0.023*data_filt$vuprhag)*(1-0.7*exp(-0.011*data_filt$SWE_M_12))
        
        
        #PINE ALBEDO (Months 1-12)
        
        data_filt$M_1_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_1 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_1 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_1))
        data_filt$M_2_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_2 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_2 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_2))
        data_filt$M_3_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_3 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_3 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_3))
        data_filt$M_4_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_4 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_4 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_4))
        data_filt$M_5_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_5 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_5 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_5))
        data_filt$M_6_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_6 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_6 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_6))
        data_filt$M_7_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_7 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_7 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_7))
        data_filt$M_8_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_8 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_8 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_8))
        data_filt$M_9_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_9 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_9 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_9))
        data_filt$M_10_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_10 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_10 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_10))
        data_filt$M_11_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_11 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_11 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_11))
        data_filt$M_12_A_P <- 0.069+0.084*(1-1/(1+exp(-1.965*(data_filt$Tmp_M_12 - 273.519))))+0.106*(1/(1+exp(-0.134*(data_filt$SWE_M_12 - 30.125))))+0.251*exp(-0.016*data_filt$vuprhaf)*(1-0.7*exp(-0.008*data_filt$SWE_M_12))
        
        #Remove initial df
        rm(data)

#END RE-CALCULATE ALBEDO FOR EACH OBSERVATION IN PLOTS ----------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#INVESTIGATE VARIABLES FOR GWR ---------------------------------------------------------------------

        #Determine predictor variables to include in GWR model
        
                #Based on system knowledge, it might be relevant to include:
                
                        #Moose density (Ms_Dnst)
                        #Red deer density (Rd_Dnst)
                        #Roe deer density (R_d_dns)
                        #Age (alder)
                        #Elevation (dem)
        
                #Recommended by ArcGIS Pro NOT to include categorical variables:
        
                        #Dominant tree type (treslag)
                        #Year of observations and climate data (Snrg_yr)

        #Investigate global multicollinearity between potential continuous covariates

                #Correlation matrix

                        #Define df for correlation matrix
                        test <- st_drop_geometry(data_filt[,c(1,14,114:116)])
        
                        #Export correlogram as PNG
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/GWR/model_selection/global_correlogram.png",
                            bg = "white",
                            width = 800,
                            height = 800,
                            units = "px")
                        
                        ggcorr(test)
                        
                        dev.off()
                        
                        
                        #Export correlation matrix w/ correlation coefficients as PNG
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/GWR/model_selection/global_correlation_matrix.png",
                            bg = "white",
                            units = "px",
                            width = 1000,
                            height = 1000)
                        
                        ggpairs(test)
                        
                        dev.off()
                        rm(test)
                        beep(8)
                        
                        
        #Investigate VIFs for global linear model
                        
                #Birch volume, for example
                model1 <- lm(vuprhal ~ Ms_Dnst + dem + alder + R_d_Dns + Rd_Dnst, data = data_filt)
                
                #Assess VIFs in model
                vif(model1)
                        
        #RESULTS FOR GLOBAL MULTICOLLINEARITY:
                #Age (alder) is not strongly correlated with other variables
                #Elevation (dem) has weak correlation (r = ~-0.2) with deer densities
                #Moose density is moderately correlated with deer densities (r = ~0.3)
                #VIFs for these variables are low (<1.3) - seems OK
                

        #Investigate global distributions of selected covariates
                
                #Age
                ggplot(data = test, aes(x = alder)) +
                        geom_histogram() +
                        theme_bw() +
                        labs(x = "Age (Years)", y = "Frequency")
                
                #Elevation
                ggplot(data = test, aes(x = dem)) +
                        geom_histogram() +
                        theme_bw() +
                        labs(x = "Elevation (m)", y = "Frequency")
                
                #Moose Density
                ggplot(data = test, aes(x = Ms_Dnst)) +
                        geom_histogram() +
                        theme_bw() +
                        labs(x = "Moose Density (kg/km2)", y = "Frequency")
                
                #Roe Deer Density
                ggplot(data = test, aes(x = R_d_Dns)) +
                        geom_histogram() +
                        theme_bw() +
                        labs(x = "Roe Deer Density (kg/km2)", y = "Frequency")
                

        #Examine residuals for covariates in simple global model - is distribution normal?
                
                #Get model residuals in a vector
                res <- model1$residuals
                test <- test[!is.na(test$Ms_Dnst) &
                                !is.na(test$alder) &
                                !is.na(test$dem) &
                                !is.na(test$R_d_Dns) &
                                !is.na(test$Rd_Dnst),]
                                     
                test$Global_Residuals <- res
        
                #Age (alder)
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/GWR/model_selection/global_model_res_age.png",
                    bg = "white",
                    width = 800,
                    height = 800,
                    units = "px")
                
                ggplot(data = test, aes(x = alder, y = Global_Residuals)) +
                        geom_point() +
                        theme_bw() +
                        labs(x = "Actual Values - Age (Years)", y = "Model Residuals")
                
                dev.off()
                
                
                #Moose Density
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/GWR/model_selection/global_model_res_moose.png",
                    bg = "white",
                    width = 800,
                    height = 800,
                    units = "px")
                
                ggplot(data = test, aes(x = Ms_Dnst, y = Global_Residuals)) +
                        geom_point() +
                        theme_bw() +
                        labs(x = "Actual Values - Moose Density (kg/km2)", y = "Model Residuals")
                
                dev.off()
                
                
                #Elevation (dem)
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/GWR/model_selection/global_model_res_elevation.png",
                    bg = "white",
                    width = 800,
                    height = 800,
                    units = "px")
                
                ggplot(data = test, aes(x = dem, y = Global_Residuals)) +
                        geom_point() +
                        theme_bw() +
                        labs(x = "Actual Values - Elevation (m)", y = "Model Residuals")
                
                dev.off()
                
                
                #Deer densities
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/GWR/model_selection/global_model_res_red_deer.png",
                    bg = "white",
                    width = 800,
                    height = 800,
                    units = "px")
                
                ggplot(data = test, aes(x = R_d_Dns, y = Global_Residuals)) +
                        geom_point() +
                        theme_bw() +
                        labs(x = "Actual Values - Red Deer Density (kg/km2)", y = "Model Residuals")
                
                dev.off()
                
                #Roe deer density
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/GWR/model_selection/global_model_res_roe_deer.png",
                    bg = "white",
                    width = 800,
                    height = 800,
                    units = "px")
                
                ggplot(data = test, aes(x = Rd_Dnst, y = Global_Residuals)) +
                        geom_point() +
                        theme_bw() +
                        labs(x = "Actual Values - Roe Deer Density (kg/km2)", y = "Model Residuals")
                
                dev.off()
                
                
        #RESULTS OF RESIDUAL ANALYSIS FOR GLOBAL LM
                #Heteroscadasticity in plots for residuals vs elevation and age
                #Moose density looks good - let's try log transforming elevation and age
                

        #Global model w/ log-transformed variables to attempt to correct for heteroscedasticity
        
                #Birch volume, for example
                data_filt$log_dem <- log(data_filt$dem)
                data_filt$log_dem[! data_filt$log_dem > 0] <- NA
                data_filt$log_alder <- log(data_filt$alder)
                model2 <- lm(vuprhal ~ Ms_Dnst + log_dem + log_alder + R_d_Dns + Rd_Dnst, data = data_filt)
                
                #Get model residuals in a vector
                res <- model2$residuals
                
                #Plot residuals vs variables
                test2 <- st_drop_geometry(data_filt[,c(1,14,114:116,132:133)])
                test2 <- test2[!is.na(test2$Ms_Dnst) &
                                     !is.na(test2$alder) &
                                     !is.na(test2$dem) &
                                     !is.na(test2$R_d_Dns) &
                                     !is.na(test2$Rd_Dnst) &
                                     !is.na(test2$log_dem),]
                
                test2$Global_Residuals <- res
                
                #log(Elevation) (dem)
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/GWR/model_selection/global_model_res_log_elevation.png",
                    bg = "white",
                    width = 800,
                    height = 800,
                    units = "px")
                
                ggplot(data = test2, aes(x = log_dem, y = Global_Residuals)) +
                        geom_point() +
                        theme_bw() +
                        labs(x = "Actual Values - log(Elevation) (m)", y = "Model Residuals")
                
                dev.off()
                        
                #log(Age) (alder)
                png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/GWR/model_selection/global_model_res_log_age.png",
                    bg = "white",
                    width = 800,
                    height = 800,
                    units = "px")
                
                ggplot(data = test2, aes(x = log_alder, y = Global_Residuals)) +
                        geom_point() +
                        theme_bw() +
                        labs(x = "Actual Values - log(Age) (Years)", y = "Model Residuals")
                
                dev.off()
                                    
        
        #RESULTS OF LOG TRANSFORMATIONS
                #Elevation residuals look better
                #Age residuals don't looks much better - such an important variable, going to include anyways
                        
                
                #FINAL MODEL FORM:
                #   lm(vuprhal ~ Ms_Dnst + log(alder) + log(dem) + R_d_Dns + Rd_Dnst)
                

#END INVESTIGATE VARIABLES FOR GWR ---------------------------------------------------------------------
                
                
                
                
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
                
                
                
                
#RUN GWR FOR VOLUME -------------------------------------------------------------------------------
                
        #Free up memory and reload data
        rm(model1)
        rm(model2)
        rm(test)
        rm(test2)
        rm(res)
        rm(data_filt)
        
                #Load unified & FILTERED shapefile w/ all variables (from all years)
                data <- st_read("2_Albedo_Regional/Data/Final_Shapefile/Output/attempt_3/all_data/corrected_shapefile.shp")
                
                #Remove duplicate geometries
                data_filt <- distinct(data, .keep_all = T)
                rm(data)
                
                #Filter out data with negative elevation
                data_filt <- data_filt[data_filt$dem >= 0,]
                
        #Calculate natural log for alder and dem
                
                data_filt$log_dem <- log(data_filt$dem)
                data_filt$log_dem[! data_filt$log_dem > 0] <- NA
                data_filt$log_alder <- log(data_filt$alder)
                
        #Filter to covariates for model (including volumes)
                
                data_filt <- data_filt[,c(1,14,38:40,114:116,132:133)]
        
        #Filter out rows w/ NA values (for GWR model - can't handle NAs)
                data_filt <- data_filt[!is.na(data_filt$alder) &
                                               !is.na(data_filt$log_alder) &
                                               !is.na(data_filt$dem) &
                                               !is.na(data_filt$log_dem) &
                                               !is.na(data_filt$Ms_Dnst) &
                                               !is.na(data_filt$R_d_Dns) &
                                               !is.na(data_filt$Rd_Dnst) &
                                               !is.na(data_filt$vuprhag) &
                                               !is.na(data_filt$vuprhal) &
                                               !is.na(data_filt$vuprhaf),]
                
        #Scalable GWR for each tree species

                #Birch Volume GWR --------
        
                        #Convert to Spatial object for use w/ GWR function
                        data_sp <- as(data_filt, "Spatial")
                        rm(data_filt)
                        beep(b)
                        
                        #Run GWR
                        birch_gwr <- gwr.scalable(formula = vuprhal ~ Ms_Dnst + log_alder + log_dem + Rd_Dnst + R_d_Dns,
                                                  data = data_sp,
                                                  bw.adapt = 200,
                                                  kernel = "gaussian")
                        beep(8)

                        #Plot
                        birch_r <- st_as_sf(birch_gwr$SDF)
                        
                        #Coefficient Estimates
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/GWR/gwr_maps/birch_volume_gwr_coefficients.png",
                            bg = "white",
                            width = 2000,
                            height = 2000,
                            units = "px")
                        
                        ggplot() +
                                geom_sf(data = birch_r, aes(color = Ms_Dnst), lwd = 0.1) +
                                coord_sf(datum = st_crs(birch_r)) +
                                theme(
                                        legend.title = element_text(size = 50),
                                        legend.text = element_text(size = 30)
                                ) +
                                theme_dark() +
                                scale_color_continuous(name = "Coefficient Estimate") +
                                scale_color_gradient2(low = "red", mid = "white", high = "blue", name = "Coefficient Estimate")
                        
                        dev.off()
                        

                        #Standard Error
                        png(filename = "2_Albedo_Regional/Approach_1_SatSkog/Output/GWR/gwr_maps/birch_volume_gwr_se.png",
                            bg = "white",
                            width = 2000,
                            height = 2000,
                            units = "px")
                        
                        ggplot() +
                                geom_sf(data = birch_r, aes(fill = Ms_Dnst_SE, color = Ms_Dnst_SE), alpha = 0.3, lwd = 0.1) +
                                coord_sf(datum = st_crs(birch_r)) +
                                theme_bw() +
                                
                        
                        dev.off()
                        
                        
                                


#END RUN GWR FOR VOLUME -------------------------------------------------------------------