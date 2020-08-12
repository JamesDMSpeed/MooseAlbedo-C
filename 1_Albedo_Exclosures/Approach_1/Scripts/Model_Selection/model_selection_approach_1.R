##Script to identify model w/ best fit for Approach 1


##PACKAGES ----------------------------------------------------------------------------------------

        #Packages for data processing + visualization
        library(dplyr)
        library(tidyr)
        library(ggplot2)
        library(lme4)
        library(lmerTest)
        library(sjPlot)
        library(GGally)

###END PACKAGES ----------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#INITIAL DATA IMPORT + FORMATTING ----------------------------------------------------------------------------------------------

        #Import CSV to dataframe
        model_data <- read.csv('1_Albedo_Exclosures/Approach_1/Output/Albedo_Estimates/albedo_estimates_approach_1.csv', header = TRUE)
        
        #Format columns
        model_data$Month <- as.factor(model_data$Month)
        model_data$Treatment <- as.factor(model_data$Treatment)
        model_data$LocalityCode <- as.factor(model_data$LocalityCode)
        model_data$LocalityName <- as.factor(model_data$LocalityName)
        

#END INITIAL DATA IMPORT + FORMATTING --------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#DEFINE + EXAMINE MODELS ----------------------------------------------------------------------------------------------
        
        #CORRELATION MATRIX
        ggpairs(data = model_data, columns = c(8:12)) 
        
                #High correlation between moose density and roe deer density (0.729) - remove roe deer density as variable
        
        #BASE MODEL WITH ALL POTENTIAL VARIABLES + 2-WAY INTERACTIONS
        
                #Define model
                model <- lmer(Composite_Albedo ~
                                      Treatment*Month +
                                      Productivity_Index +
                                      Canopy_Height_MAD +
                                      Years_Since_Clearcut +
                                      Moose_Density +
                                      Red_Deer_Density +
                                      Treatment*Productivity_Index +
                                      Treatment*Canopy_Height_MAD +
                                      Treatment*Years_Since_Clearcut +
                                      Treatment*Moose_Density +
                                      Treatment*Red_Deer_Density +
                                      Productivity_Index*Canopy_Height_MAD +
                                      Productivity_Index*Years_Since_Clearcut +
                                      Productivity_Index*Moose_Density +
                                      Productivity_Index*Red_Deer_Density +
                                      Canopy_Height_MAD*Years_Since_Clearcut +
                                      Canopy_Height_MAD*Moose_Density +
                                      Canopy_Height_MAD*Red_Deer_Density +
                                      Years_Since_Clearcut*Moose_Density +
                                      Years_Since_Clearcut*Red_Deer_Density +
                                      Moose_Density*Red_Deer_Density +
                                      (1 | LocalityName),
                              data = model_data)
                
                        #Explore model
                        summary(model)
                        plot(model)
                        qqnorm(resid(model))
                        tab_model(model)
                
                        #Residuals + qqplot of base model don't look great - what's going on?
                
                
                #Simplified model (removed obviously non-significant terms + interactions)
                model2 <- lmer(Composite_Albedo ~
                                       Treatment*Month +
                                       Years_Since_Clearcut +
                                       Moose_Density +
                                       Red_Deer_Density +
                                       Productivity_Index +
                                       Productivity_Index*Years_Since_Clearcut +
                                       Productivity_Index*Red_Deer_Density +
                                       Years_Since_Clearcut*Moose_Density +
                                       Years_Since_Clearcut*Red_Deer_Density +
                                       Moose_Density*Red_Deer_Density +
                                       (1 | LocalityName),
                               data = model_data)
                
                        #Explore simplified model
                        summary(model2)
                        plot(model2)
                        qqnorm(resid(model2))
                        
                #Very simple model (primary variables of interest only)
                model3 <- lmer(Composite_Albedo ~
                                       Treatment*Month +
                                       Years_Since_Clearcut +
                                       Moose_Density +
                                       Red_Deer_Density +
                                       Productivity_Index +
                                       (1 | LocalityName),
                               data = model_data)
                
                #Explore simplified model
                summary(model3)
                plot(model3)
                qqnorm(resid(model3))
        

        

#DEFINE + EXAMINE MODELS ------------------------------------------------------------------------------------------
                        
                        
                        
                        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#AIC MODEL SELECTION ----------------------------------------------------------------------------------------------
        
        #Compare base model w/ simplified model
        AIC(model, model2, model3) #MODEL 3 has lowest AIC value
       
#END AIC MODEL SELECTION ----------------------------------------------------------------------------------------------
                        
                        
                        
                        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#INVESTIGATE BEST MODEL ----------------------------------------------------------------------------------------------
        
        #Define residuals and fitted values in df for plots
        model_res <- data.frame("Residuals" = residuals(model1))
        model_fitted <- data.frame("Fitted" = fitted(model1))
        model_actual <- data.frame("Actual" = model_data$Composite_Albedo)
        model_meta <- cbind(model_res, model_fitted, model_data)
        
        
        #Plot of residuals
        resid <- ggplot(model_meta, aes(x = Fitted, y = Residuals)) +
                        geom_point(size = 4) +
                        ggtitle("Model Residuals vs Fitted") +
                        theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                              axis.text.x = element_text(size = 44, margin = margin(t=16)),
                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                              axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                              axis.title.y = element_text(size = 60, margin = margin(r=40)))
        resid
        
        #Check normality of residuals w/ Q-Q plot
        qqnorm(model_meta$Residuals)
        
        #Check distribution of residuals w/ density plot
        hist <- ggplot(model_meta, aes(Residuals)) +
                geom_histogram(aes(y=..density..), bins = 30, alpha=1, position="identity") +
                geom_density(alpha= 0.5) +
                ggtitle("Density Plot - Model Residuals") +
                theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                      legend.title = element_text(size = 40),
                      legend.text = element_text(size = 36),
                      axis.text.x = element_text(size = 44, margin = margin(t=16)),
                      axis.text.y = element_text(size = 40, margin = margin(r=16)),
                      axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                      axis.title.y = element_text(size = 60, margin = margin(r=40)))
        hist
        
        #Plot actual vs fitted
        relationship <- ggplot(model_meta, aes(Composite_Albedo, Fitted)) +
                geom_point(size = 4) +
                geom_abline() +
                ggtitle("Actual vs. Fitted") +
                theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                      legend.title = element_text(size = 40),
                      legend.text = element_text(size = 36),
                      axis.text.x = element_text(size = 44, margin = margin(t=16)),
                      axis.text.y = element_text(size = 40, margin = margin(r=16)),
                      axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                      axis.title.y = element_text(size = 60, margin = margin(r=40)))
        relationship
        
        #Explore residuals vs explanatory variables to look for patterns
        
               
                #Canopy Height MAD
                rv2 <- ggplot(model_meta, aes(Canopy_Height_MAD, Fitted)) +
                        geom_point(size = 4) +
                        geom_abline() +
                        ggtitle("Canopy Height MAD vs Fitted Values") +
                        theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                              legend.title = element_text(size = 40),
                              legend.text = element_text(size = 36),
                              axis.text.x = element_text(size = 44, margin = margin(t=16)),
                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                              axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                              axis.title.y = element_text(size = 60, margin = margin(r=40)))
                rv2
                
                #Moose Density
                rv3 <- ggplot(model_meta, aes(Moose_Density, Fitted)) +
                        geom_point(size = 4) +
                        geom_abline() +
                        ggtitle("Moose Density vs Fitted Values") +
                        theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                              legend.title = element_text(size = 40),
                              legend.text = element_text(size = 36),
                              axis.text.x = element_text(size = 44, margin = margin(t=16)),
                              axis.text.y = element_text(size = 40, margin = margin(r=16)),
                              axis.title.x = element_text(size = 60, margin = margin(t=40, b = 40)),
                              axis.title.y = element_text(size = 60, margin = margin(r=40)))
                rv3
                

#END INVESTIGATE BEST MODEL ------------------------------------------------------------------------------------------
        
        
        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


        
        
#WRITE OUTPUT -------------------------------------------------------------------------------------------------
                
        #Print residuals vs fitted
        png(filename = "1_Albedo_Exclosures/Approach_1/Output/Model_Selection/best_model_residuals_approach_1.png",
            width = 2000,
            height = 2000,
            units = "px",
            bg = "white")
        resid
        dev.off()
        
        #Print histogram of residuals
        png(filename = "1_Albedo_Exclosures/Approach_1/Output/Model_Selection/best_model_residuals_hist_approach_1.png",
            width = 2000,
            height = 2000,
            units = "px",
            bg = "white")
        hist
        dev.off()
        
        #Print actual vs fitted
        png(filename = "1_Albedo_Exclosures/Approach_1/Output/Model_Selection/best_model_fitted_actual_approach_1.png",
            width = 2000,
            height = 2000,
            units = "px",
            bg = "white")
        relationship
        dev.off()
        
        #Print residuals vs explanatory variables
        
                #Canopy Height MAD
                png(filename = "1_Albedo_Exclosures/Approach_1/Output/Model_Selection/best_model_rv1_approach_1.png",
                    width = 2000,
                    height = 2000,
                    units = "px",
                    bg = "white")
                rv2
                dev.off()
                
                #Moose Density
                png(filename = "1_Albedo_Exclosures/Approach_1/Output/Model_Selection/best_model_rv2_approach_1.png",
                    width = 2000,
                    height = 2000,
                    units = "px",
                    bg = "white")
                rv3
                dev.off()
                
               
        
        #Print model summary table
        tab_model(mi1, digits = 5, file = "1_Albedo_Exclosures/Approach_1/Output/Model_Selection/best_model_approach_1.html")
        
#END WRITE OUTPUT ----------------------------------------------------------------------------------------------