## This is script to perform a Geographically Weighted Regression (GWR) on 
## ONE MONTH of albedo data (January)


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
        library(spgwr)
        library(beepr)

        
      
#END PACKAGES ----------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#IMPORT + FORMAT DATA --------------------------------------------------------------------------------------------------

        #Load unified shapefile w/ all variables 
        ## NOTE: This shapefile was filtered and saved in initial_visualization.R

        data <- st_read("2_Albedo_Regional/Data/Final_Shapefile/Output/ready_for_analysis/full_resolution/final_shapefile_FILTERED.shp")
        

#END IMPORT + FORMAT DATA --------------------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#GWR (JANUARY ALBEDO) --------------------------------------------------------------------------------------------------

        #Define color palette
        myPalette <- colorRampPalette(rev(brewer.pal(11, "Spectral")))
        
        #MORAN'S I TEST FOR SPATIAL AUTOCORRELATION ------------
        
                #KEY ISSUE - Can't use most common R method to calculate Moran's I (polygons aren't adjacent, so
                #  poly2nb() won't work). Will try to compute centroids of each polygon and then use to
                #  calculate Moran's I.
                                        
                        #Compute centroids of polygons & get nearest neighbors (k = 4)
                        centroids <- st_centroid(st_geometry(data), of_largest_polygon=TRUE)
                        
                        #K-nearest neighbors matrix of centroids
                        col.knn_all <- knearneigh(centroids, k=4)
                        
                        #Create nb object from k-nearest neighbors matrix
                        nb_all <- knn2nb(col.knn_all)
                        
                        #Create "listw" spatial weights matrix from nb object (for use w/ Moran's I function)
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
                        
## ----------- RESULTS FROM MORAN'S: SPATIAL AUTOCORRELATION IS PRESENT
                

        #CORRELATION MATRIX (TO IDENTIFY CORRELATED CONTINUOUS EXPLANATORY VARIABLES) ------------
                
                #Construct correlation matrix
                corr_sub <- st_drop_geometry(data[,c(1,2,11,27,85:101)])
                
                #Generate correlation matrix
                res <- cor(corr_sub)
                
                #Plot
                corrplot(res,
                         type = "upper",
                         tl.col = "black",
                         tl.cex = 1,
                         tl.srt = 30,
                         number.cex = 0.8,
                         title = "Correlogram of Numeric Variables",
                         mar=c(0,0,5,0)) 
                
                
## ----- SOME STRONG CORRELATIONS BETWEEN DIFFERENT HERBIVORE DENSITIES
##       Moose density is strongly correlated w/ WP_Density and Wl_Density, so I'll probably remove these from final model
  

#RUN A GEOGRAPHICALLY WEIGHTED REGRESSION (GWR) --------------------------
                
        #Using matrix of polygon centroids above, create df w/ coordinates (UTM33N and UTM33E)
        
                #Use st_coordinates to create matrix of coordinates
                #NOTE: These coordinates are for centroids of the largest polygon in a given geometry for a single observation
                ## (since some observations are multipolygons)
                data_coords <- st_coordinates(centroids)
                
                #Verify number of rows in coords (does this match data?)
                nrow(data_coords) #Looks good
                        
#----------------#Test GWR steps before running on full dataset
                        
                        #Create small test set
                        test <- data[1:5000,]
                        
                        #Set relevant herbivore densities to numeric (skipping those that aren't in model)
                        test$W_Dnsty <- as.numeric(test$W_Dnsty)
                        test$S_Dnsty <- as.numeric(test$S_Dnsty)
                        test$Ms_Dnst <- as.numeric(test$Ms_Dnst)
                        test$Rd_Dnst <- as.numeric(test$Rd_Dnst)
                        test$R_d_Dns <- as.numeric(test$R_d_Dns)
                        test$Sh_Dnst <- as.numeric(test$Sh_Dnst)
                        test$Cw_Dnst <- as.numeric(test$Cw_Dnst)
                        test$Gt_Dnst <- as.numeric(test$Gt_Dnst)
                        test$Hr_Dnst <- as.numeric(test$Hr_Dnst)
                        test$Ct_Dnst <- as.numeric(test$Ct_Dnst)
                        
                        #Get test coordinates
                        test_coords <- data_coords[1:5000,]
                        test <- cbind(test, test_coords)
                        

                        #Calculate kernel bandwidth (FIXED KERNAL; adapt = F)
                        
                                ##NOTE: CAN'T have missing (NA) values for any variables in this step 
                        
                                        ## Remove all rows where any of model variables are NA
                                        test <- test[!is.na(test$Ms_Dnst) &
                                                             !is.na(test$alder) &
                                                             !is.na(test$arl_hkt) &
                                                             !is.na(test$bonitet) &
                                                             !is.na(test$dem) &
                                                             !is.na(test$ndvi) &
                                                             !is.na(test$W_Dnsty) &
                                                             !is.na(test$S_Dnsty) &
                                                             !is.na(test$Rd_Dnst) &
                                                             !is.na(test$R_d_Dns) &
                                                             !is.na(test$Sh_Dnst) &
                                                             !is.na(test$Cw_Dnst) &
                                                             !is.na(test$Gt_Dnst) &
                                                             !is.na(test$Hr_Dnst) &
                                                             !is.na(test$Ct_Dnst),]
                                        
                                                                #Lost 200 observations
                        
                                        #Calculate kernel bandwith (Fixed kernel, adapt = F)
                                        system.time({
                                                GWRbandwidth <- gwr.sel(Mnt_1_A ~ Ms_Dnst +
                                                                                alder +
                                                                                arl_hkt +
                                                                                bonitet +
                                                                                dem +
                                                                                ndvi +
                                                                                W_Dnsty +
                                                                                S_Dnsty +
                                                                                Rd_Dnst +
                                                                                R_d_Dns +
                                                                                Sh_Dnst +
                                                                                Cw_Dnst +
                                                                                Gt_Dnst +
                                                                                Hr_Dnst +
                                                                                Ct_Dnst,
                                                                        data = test,
                                                                        coords = cbind(test$X, test$Y),
                                                                        adapt = F)
                                                beep(3)
                                        })
                        
                system.time({
                        gwr.model <- gwr(Mnt_1_A ~ Ms_Dnst +
                                                 alder +
                                                 arl_hkt +
                                                 bonitet +
                                                 dem +
                                                 ndvi +
                                                 W_Dnsty +
                                                 S_Dnsty +
                                                 Rd_Dnst +
                                                 R_d_Dns +
                                                 Sh_Dnst +
                                                 Cw_Dnst +
                                                 Gt_Dnst +
                                                 Hr_Dnst +
                                                 Ct_Dnst,
                                         data = test,
                                         coords = cbind(test$X, test$Y),
                                         bandwidth = GWRbandwidth,
                                         se.fit=T,
                                         hatmatrix=T)
                        gwr.model
                        beep(8)
                })
                
                        
                #Get results of model as dataframe
                test_results <- as.data.frame(gwr.model$SDF)

                #Add moose density as coefficient to initial sf object
                test$Moose_Density_Coeff <- test_results$Ms_Dnst
                        
                #Plot moose density coefficients as points
                ggplot(data = test, aes(x = X, y = Y)) +
                        geom_point(aes(colour = Moose_Density_Coeff))
                
                        #Looks like the steps worked - run on full dataset

                
###KEY POINT### ----------------------------------------------

# I've learned that this dataset is WAY too large to run a GWR on w/ R - however,
# Li et al. (2009) developed a method to greatly speed up GWR (called 'FastGWR')
# This method uses Python, however, so I'm going to export the filtered data
# from this script as a shapefile for use with the Python implementation
                
#Prepare Full Dataset for Python GWR Implementation ------------------------------------------------
                
        #Set relevant herbivore densities to numeric (skipping those that aren't in model)
        data$W_Dnsty <- as.numeric(data$W_Dnsty)
        data$S_Dnsty <- as.numeric(data$S_Dnsty)
        data$Ms_Dnst <- as.numeric(data$Ms_Dnst)
        data$Rd_Dnst <- as.numeric(data$Rd_Dnst)
        data$R_d_Dns <- as.numeric(data$R_d_Dns)
        data$Sh_Dnst <- as.numeric(data$Sh_Dnst)
        data$Cw_Dnst <- as.numeric(data$Cw_Dnst)
        data$Gt_Dnst <- as.numeric(data$Gt_Dnst)
        data$Hr_Dnst <- as.numeric(data$Hr_Dnst)
        data$Ct_Dnst <- as.numeric(data$Ct_Dnst)
        
        #Bind data coordinates to main data sf object
        data <- cbind(data, data_coords)
        
        #Write updated sf object as shapefile to relevant data folder
        st_write(data, "2_Albedo_Regional/Data/Python_GWR_Data/python_gwr_data.shp", driver = "ESRI Shapefile")
        
        
         
                
#END GWR --------------------------------------------------------------------------------------------------
                
 
