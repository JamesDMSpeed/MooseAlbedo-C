## This is script to analyze all relevant SatSkog spatial data in Norway


#PACKAGES ----------------------------------------------------------------------

        #Spatial Data Packages
        library(sf)
        library(tmap)
        library(broom)
        
        #Data Manipulation + Visualization
        library(ggplot2)
        library(raster)
        library(dplyr)
        library(hexbin)
        library(RColorBrewer)

        #Analysis
        library(spdep)
        library(spatialreg)
        library(spam)
        library(randomForest)
        library(caTools)
        library(GGally)
        
      
#END PACKAGES ----------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#IMPORT + FORMAT DATA --------------------------------------------------------------------------------------------------

        #Load unified shapefile w/ all variables
        data <- st_read("2_Albedo_Regional/Data/Final_Shapefile/Output/ready_for_analysis/full_resolution/final_shapefile.shp")
        
        #Format data correctly
        data$bon1_n <- as.factor(data$bon1_n)
        data$treslag <- as.factor(data$treslag)
        data$Mnt_1_A <- as.numeric(data$Mnt_1_A)
        data$Mnt_2_A <- as.numeric(data$Mnt_2_A)
        data$Mnt_3_A <- as.numeric(data$Mnt_3_A)
        data$Mnt_4_A <- as.numeric(data$Mnt_4_A)
        data$Mnt_5_A <- as.numeric(data$Mnt_5_A)
        data$Mnt_6_A <- as.numeric(data$Mnt_6_A)
        data$Mnt_7_A <- as.numeric(data$Mnt_7_A)
        data$Mnt_8_A <- as.numeric(data$Mnt_8_A)
        data$Mnt_9_A <- as.numeric(data$Mnt_9_A)
        data$Mn_10_A <- as.numeric(data$Mn_10_A)
        data$Mn_11_A <- as.numeric(data$Mn_11_A)
        data$Mn_12_A <- as.numeric(data$Mn_12_A)
        data$Ms_Dnst <- as.numeric(data$Ms_Dnst)
        
        #Remove rows w/ albedo values <0 
        data <- data[data$Mnt_1_A >= 0 &
                             data$Mnt_2_A >= 0 &
                             data$Mnt_3_A >= 0 &
                             data$Mnt_4_A >= 0 &
                             data$Mnt_5_A >= 0 &
                             data$Mnt_6_A >= 0 &
                             data$Mnt_7_A >= 0 &
                             data$Mnt_8_A >= 0 &
                             data$Mnt_9_A >= 0 &
                             data$Mn_10_A >= 0 &
                             data$Mn_11_A >= 0 &
                             data$Mn_12_A >= 0, ]
        
        #Remove rows w/ albedo values >1 
        data <- data[data$Mnt_1_A <= 1 &
                             data$Mnt_2_A <= 1 &
                             data$Mnt_3_A <= 1 &
                             data$Mnt_4_A <= 1 &
                             data$Mnt_5_A <= 1 &
                             data$Mnt_6_A <= 1 &
                             data$Mnt_7_A <= 1 &
                             data$Mnt_8_A <= 1 &
                             data$Mnt_9_A <= 1 &
                             data$Mn_10_A <= 1 &
                             data$Mn_11_A <= 1 &
                             data$Mn_12_A <= 1, ]
        
        #Remove rows where Moose Density or kommune name is missing
        data <- data[!is.na(data$Ms_Dnst),]
        data <- data[!is.na(data$NAVN),]
        
        #Remove rows that aren't wooded ('ikke tresatt')
        data <- data[data$treslag != "Ikke tresatt",]
        
        #Add column w/ arbitrary IDs (for use in spatial analysis below)
        ids <- as.vector(1:nrow(data))
        data <- cbind(data, ids)

#END IMPORT + FORMAT DATA --------------------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#DATA EXPLORATION --------------------------------------------------------------------------------------------------

        #Define color palette
        myPalette <- colorRampPalette(rev(brewer.pal(11, "Spectral")))
        
        #EXPLANATORY VARIABLES
        
                #Age
                ggplot(data = data, aes(x = alder)) +
                        geom_histogram(bins = 30) +
                        ggtitle("Age of Forest Plots")
                
                #Area (hectacres)
                ggplot(data = data, aes(x = arl_hkt)) +
                        geom_histogram(bins = 100) +
                        ggtitle("Area of Forest Plots (Ha)")
                
                #Bonitet code
                ggplot(data = data, aes(x = bonitet)) +
                        geom_histogram(bins = 15) +
                        ggtitle("Bonitet (Site Quality)")
                
                #Productive vs non-productive forest
                ggplot(data = data, aes(x = clss_ms)) +
                        geom_bar() +
                        ggtitle("Forest Productivity Classification")
                
                #NDVI
                ggplot(data = data, aes(x = ndvi)) +
                        geom_histogram() +
                        ggtitle("NDVI")
                
                #Moose Density
                ggplot(data = data, aes(x = Ms_Dnst)) +
                        geom_histogram() +
                        ggtitle("Moose Density (kg/km-2)")
                

        #ALBEDO
        
                #JAN -----------
        
                        #vs. Moose Density
                        ggplot(data = data, aes(x = Ms_Dnst, y = Mnt_1_A)) +
                                geom_bin2d() +
                                scale_fill_gradientn(colours = myPalette(100))
                
                                #Faceted by age (using cut interval)
                                ggplot(data = data, aes(x = Ms_Dnst, y = Mnt_1_A)) +
                                        geom_bin2d() +
                                        facet_wrap(~ cut_interval(alder, length = 5)) +
                                        scale_fill_gradientn(colours = myPalette(100))
                                
                                                #Similar trend between age groups
                                
                                #Faceted by dominant tree
                                ggplot(data = data, aes(x = Ms_Dnst, y = Mnt_1_A)) +
                                        geom_bin2d() +
                                        facet_wrap(~ treslag) +
                                        scale_fill_gradientn(colours = myPalette(100))


                #MAY -----------
                                
                        #vs. Moose Density
                        ggplot(data = data, aes(x = Ms_Dnst, y = Mnt_5_A)) +
                                geom_bin2d() +
                                scale_fill_gradientn(colours = myPalette(100))
                                
                                #Faceted by age (using cut interval)
                                ggplot(data = data, aes(x = Ms_Dnst, y = Mnt_5_A)) +
                                        geom_bin2d() +
                                        facet_wrap(~ cut_interval(alder, length = 5)) +
                                        scale_fill_gradientn(colours = myPalette(100))
                                
                                        #Similar trend between age groups
                                
                                #Faceted by dominant tree
                                ggplot(data = data, aes(x = Ms_Dnst, y = Mnt_5_A)) +
                                        geom_bin2d() +
                                        facet_wrap(~ treslag) +
                                        scale_fill_gradientn(colours = myPalette(100))
                                
                #OCT -----------
                                
                        #vs. Moose Density
                        ggplot(data = data, aes(x = Ms_Dnst, y = Mn_10_A)) +
                                geom_bin2d() +
                                scale_fill_gradientn(colours = myPalette(100))
                                
                                #Faceted by age (using cut interval)
                                ggplot(data = data, aes(x = Ms_Dnst, y = Mn_10_A)) +
                                        geom_bin2d() +
                                        facet_wrap(~ cut_interval(alder, length = 5)) +
                                        scale_fill_gradientn(colours = myPalette(100))
                                
                                #Faceted by dominant tree
                                ggplot(data = data, aes(x = Ms_Dnst, y = Mn_10_A)) +
                                        geom_bin2d() +
                                        facet_wrap(~ treslag) +
                                        scale_fill_gradientn(colours = myPalette(100))
                   
                                             
        ##  KEY POINT - difficult to identify any obvious trends (this makes sense, since the estimated effect size of exclosure
        ##  was very small). Probably just need to run an appropriate model (data visualization won't be super useful here)
                           
                                        
              
                

#END DATA EXPLORATION --------------------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


                                

#SUBSET TEST ANALYSIS -------------------------------------------------------------------------------------------

        #Import + format data
                                
                #Load in processed shapefiles for Oslo, Trondheim, and Vik
                oslo <- st_read("2_Albedo_Regional/Data/Spatial_Data/Output/Oslo/Oslo_processed.shp")
                trondheim <- st_read("2_Albedo_Regional/Data/Spatial_Data/Output/Trondheim/Trondheim_processed.shp")
                vik <- st_read("2_Albedo_Regional/Data/Spatial_Data/Output/Vik/Vik_processed.shp")
                
                #Join sf objects together
                test <- rbind(oslo, trondheim, vik)
                
                #Remove rows w/ albedo values <0 
                test <- test[test$Mnt_1_A >= 0 &
                                     test$Mnt_2_A >= 0 &
                                     test$Mnt_3_A >= 0 &
                                     test$Mnt_4_A >= 0 &
                                     test$Mnt_5_A >= 0 &
                                     test$Mnt_6_A >= 0 &
                                     test$Mnt_7_A >= 0 &
                                     test$Mnt_8_A >= 0 &
                                     test$Mnt_9_A >= 0 &
                                     test$Mn_10_A >= 0 &
                                     test$Mn_11_A >= 0 &
                                     test$Mn_12_A >= 0, ]
                
                #Remove rows w/ albedo values >1 
                test <- test[test$Mnt_1_A <= 1 &
                                     test$Mnt_2_A <= 1 &
                                     test$Mnt_3_A <= 1 &
                                     test$Mnt_4_A <= 1 &
                                     test$Mnt_5_A <= 1 &
                                     test$Mnt_6_A <= 1 &
                                     test$Mnt_7_A <= 1 &
                                     test$Mnt_8_A <= 1 &
                                     test$Mnt_9_A <= 1 &
                                     test$Mn_10_A <= 1 &
                                     test$Mn_11_A <= 1 &
                                     test$Mn_12_A <= 1, ]
                

                #Remove rows where Moose Density or kommune name is missing
                test <- test[!is.na(test$Ms_Dnst) || !is.na(data$NAVN),]
                
                #Plot joined sf object          
                plot(test["alder"])                
        
        #Any overlapping polygons? If so, remove from sf object
        
        #Moran's I test for spatial autocorrelation
        
                #KEY ISSUE - Can't use typical method to calculate Moran's I (polygons aren't adjacent, so
                #  poly2nb() won't work). Will try to compute centroids of each polygon and then use to
                #  calculate Moran's I.
        
                        #Compute centroids of polygons & get nearest neighbors (k = 4)
                        test_centroids <- st_centroid(st_geometry(test), of_largest_polygon=TRUE)
                        col.knn <- knearneigh(test_centroids, k=4)
                        nb <- knn2nb(col.knn)
                        
                                #Visualize
                                plot(st_geometry(test), border="grey")
                                plot(nb, test_centroids, add=TRUE)
                        

                #Create "listw" spatial weights matrix from nb object
                ww <-  nb2listw(nb, style='B')
                
                #Run Monte-Carlo simulation of Moran I (using Month 1 Albedo as test value)
                test$Mnt_1_A <- as.numeric(test$Mnt_1_A)
                moran <- moran.mc(test$Mnt_1_A, ww, nsim=99)

                        #Print results
                        if(moran[[1]] > 0){
                                print(paste("Spatial autocorrelation may be present. Moran's I statistic: ", moran[[1]], sep = ""))
                        } else {
                                print("No spatial autocorrelation likely present.")
                        }
               
        #TEST ANALYSIS OF JANUARY ALBEDO -----------------------------
                
                #BASIC OLS MODEL --------------------------------
                        
                        #Specify the model w/ potentially important variables
                        m1 <- lm(Mnt_1_A ~ Ms_Dnst + alder + bonitet + Snrg_yr, data = test)
                        summary(m1)
                        
                        #Investigate whether spatial correlation exists in residuals
                        
                                #Add residuals of OLS model to test_data
                                test$residuals <- residuals(m1)
                                
                                #Correlation b/t model residuals and mean adjacent residuals
                                resnb <- sapply(nb, function(x) mean(test$residuals[x]))
                                cor(test$residuals, resnb)
                                plot(test$residuals, resnb, xlab='Residuals', ylab='Mean adjacent residuals')
                                
                                #Run Moran's I on residuals
                                ols_res_moran <- moran.mc(test$residuals, ww, 999)
                                ols_moran_stat <- ols_res_moran[[1]]
                        
                                        
                                
                #SPATIAL LAG MODEL --------------------------------
                
                        #Specify model        
                        m1s <- lagsarlm(Mnt_1_A ~ Ms_Dnst + alder + bonitet + Snrg_yr + Ms_Dnst*alder,
                                       data = test,
                                       ww,
                                       tol.solve=1.0e-30)
                                
                        summary(m1s) #CAN SEE THAT THE PARAMETER ESTIMATE FOR MOOSE DENSITY DECREASES AND BECOMES NON-SIGNIFICANT
                        
                                #Investigate spatial autocorrelation by looking at residuals
                                test$slm_residuals <- residuals(m1s)
                                slm_res_moran <- moran.mc(test$slm_residuals, ww, 999)
                                slm_moran_stat <- slm_res_moran[[1]] #MUCH SMALLER STATISTIC THAN BASIC OLS
                        
                        
                        
                #SPATIAL ERROR MODEL --------------------------------
                        
                        #Specify model
                        m1e <- errorsarlm(Mnt_1_A ~ Ms_Dnst + alder + bonitet + Snrg_yr + Ms_Dnst*alder,
                                          data = test,
                                          ww,
                                          tol.solve=1.0e-30)
                        summary(m1e) #SIMILAR TO SPATIAL LAG MODEL
                        
                                #Investigate spatial autocorrelation by looking at residuals
                                test$sle_residuals <- residuals(m1e)
                                sle_res_moran <- moran.mc(test$sle_residuals, ww, 999)
                                sle_moran_stat <- sle_res_moran[[1]] #NEGATIVE MORAN STAT, BETTER THAN SPATIAL LAG MODEL
                                
                        #MIGHT FOCUS ON SPATIAL ERROR MODEL FOR BIG ANALYSIS
                      
                                
                #GWR ------------------------------------------------
                        
                        
                
                
        
        
#END SUBSET TEST ANALYSIS -------------------------------------------------------------------------------------------                                

        
        
        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
  
        
        
              
#FULL ANALYSIS (JANUARY ALBEDO) --------------------------------------------------------------------------------------------------

        #Moran's I test for spatial autocorrelation
        
        #KEY ISSUE - Can't use typical method to calculate Moran's I (polygons aren't adjacent, so
        #  poly2nb() won't work). Will try to compute centroids of each polygon and then use to
        #  calculate Moran's I.
                                
                #Compute centroids of polygons & get nearest neighbors (k = 4)
                centroids <- st_centroid(st_geometry(data), of_largest_polygon=TRUE)
                col.knn_all <- knearneigh(centroids, k=4)
                nb_all <- knn2nb(col.knn_all)
                
                #Create "listw" spatial weights matrix from nb object
                ww_all <-  nb2listw(nb_all, style='B')
                
                #Run Monte-Carlo simulation of Moran I (using Month 1 Albedo as test value)
                data$Mnt_1_A <- as.numeric(data$Mnt_1_A)
                moran_all <- moran.mc(data$Mnt_1_A, ww_all, nsim=99)
                
                #Print results
                if(moran_all[[1]] > 0){
                        print(paste("Spatial autocorrelation may be present. Moran's I statistic: ", moran_all[[1]], sep = ""))
                } else {
                        print("No spatial autocorrelation likely present.")
                }
                
                        ##RESULTS FROM MORAN'S: VERY HIGH DEGREE OF SPATIAL AUTOCORRELATION 
                
        #CORRELATION MATRIX (TO IDENTIFY CORRELATED CONTINUOUS EXPLANATORY VARIABLES)
                
                ggpairs(data = data, columns = c(1, 11, 85:101))
                

        #BASIC OLS MODEL --------------------------------
                
                #Specify the model w/ potentially important variables
                m1_all <- lm(Mnt_1_A ~ Ms_Dnst + alder + bonitet + Snrg_yr, data = data)
                summary(m1_all)
                plot(m1_all)
                
                
                #Investigate whether spatial correlation exists in residuals
                
                #Add residuals of OLS model to test_data
                data$residuals <- residuals(m1_all)
                
                #Run Moran's I on residuals
                ols_res_moran <- moran.mc(data$residuals, ww_all, 999)
                ols_moran_stat <- ols_res_moran[[1]]  #0.788 - STILL very high spatial autocorrelation
                
                
        #SPATIAL ERROR MODEL --------------------------------
                
                #Specify model
                #NOTE: Default method for errorsarlm() quickly leads to exhausted memory error
                ## Using "Matrix" method (sparse Cholesky Jacobians), as recommended here: 
                ## https://stat.ethz.ch/pipermail/r-sig-geo/2010-June/008634.html
                
                
#CURRENT POINT                

                m1e_all <- errorsarlm(Mnt_1_A ~ Ms_Dnst + alder + bonitet + Snrg_yr + Ms_Dnst*alder,
                                  data = data,
                                  method = "spam_update",
                                  ww_all,
                                  tol.solve=1.0e-10)
                summary(m1e_all)
                
                #Investigate spatial autocorrelation by looking at residuals
                data$sle_residuals <- residuals(m1e_all)
                sle_res_moran <- moran.mc(data$sle_residuals, ww_all, 999)
                sle_moran_stat <- sle_res_moran[[1]] #NEGATIVE MORAN STAT, BETTER THAN SPATIAL LAG MODEL
                

#END FULL ANALYSIS (JANUARY ALBEDO) --------------------------------------------------------------------------------------------------
                
                
                
                
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#WRITE OUTPUT  --------------------------------------------------------------------------------------------------



#WRITE OUTPUT --------------------------------------------------------------------------------------------------

                
