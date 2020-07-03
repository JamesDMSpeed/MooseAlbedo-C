##Script to identify model w/ best fit for Approach 1


##PACKAGES ----------------------------------------------------------------------------------------

        #Packages for data processing + visualization
        library(dplyr)
        library(tidyr)
        library(ggplot2)
        library(lme4)
        library(lmerTest)
        library(sjPlot)

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
        
        #BASE MODEL
        
                #Base Model
                model <- lmer(Composite_Albedo ~
                                      Treatment + 
                                      Productivity_Index +
                                      Canopy_Height_MAD +
                                      Years_Since_Clearcut +
                                      Moose_Density +
                                      Red_Deer_Density +
                                      (1 | Month/LocalityName),
                              data = model_data)
                
                        #Examine model
                        summary(model)
                        plot(model) #Bit of a fan outwards at higher albedo values
                        
                #Log transformed model
                log_model <- lmer(log(Composite_Albedo) ~
                                          Treatment + 
                                          Productivity_Index +
                                          Canopy_Height_MAD +
                                          Years_Since_Clearcut +
                                          Moose_Density +
                                          Red_Deer_Density +
                                          (1 | Month/LocalityName),
                                  data = model_data)
                
                        #Examine model
                        summary(log_model)
                        plot(log_model) #Looks much more evenly distributed
        
        
        #SIMPLIFIED MODEL (removed obviously non-significant terms from base model)
                        
                        #Simple model
                        simple_model <- lmer(Composite_Albedo ~
                                                     Treatment + 
                                                     Canopy_Height_MAD +
                                                     Years_Since_Clearcut +
                                                     Moose_Density +
                                                     (1 | Month/LocalityName),
                                             data = model_data)
                                
                                #Examine model
                                summary(simple_model)
                                plot(simple_model) #Same as base model - bit of a fan outwards
                                
                        #Log-transformed model
                        log_simple_model <- lmer(log(Composite_Albedo) ~
                                                        Treatment + 
                                                        Canopy_Height_MAD +
                                                        Years_Since_Clearcut +
                                                        Moose_Density +
                                                        (1 | Month/LocalityName),
                                                data = model_data)
                        
                                #Examine model
                                summary(log_simple_model)
                                plot(log_simple_model) #Looks much more evenly distributed
                                
                                
                
        
        #MODELS W/ INTERACTION EFFECTS
        #Note: using simplified model here, since effect size of treatment is identical between two models
                
                #MI1 - Treatment*Canopy Height
                        
                        #Normal 
                        mi1 <- lmer(Composite_Albedo ~
                                            Treatment + 
                                            Canopy_Height_MAD +
                                            Years_Since_Clearcut +
                                            Moose_Density +
                                            Treatment*Canopy_Height_MAD +
                                            (1 | Month/LocalityName),
                                    data = model_data)
                        
                                #Examine model
                                summary(mi1)
                                plot(mi1)
                        
                        #Log-transformed
                        mi1_log <- lmer(log(Composite_Albedo) ~
                                            Treatment + 
                                            Canopy_Height_MAD +
                                            Years_Since_Clearcut +
                                            Moose_Density +
                                            Treatment*Canopy_Height_MAD +
                                            (1 | Month/LocalityName),
                                    data = model_data)
                        
                                #Examine model
                                summary(mi1_log)
                                plot(mi1_log) 
                        
                #MI2 - Treatment*Moose Density
                        
                        #Normal
                        mi2 <- lmer(Composite_Albedo ~
                                            Treatment + 
                                            Canopy_Height_MAD +
                                            Years_Since_Clearcut +
                                            Moose_Density +
                                            Treatment*Moose_Density +
                                            (1 | Month/LocalityName),
                                    data = model_data)
                        
                                #Examine model
                                summary(mi2)
                                plot(mi2)
                                
                        #Normal
                        mi2_log <- lmer(log(Composite_Albedo) ~
                                            Treatment + 
                                            Canopy_Height_MAD +
                                            Years_Since_Clearcut +
                                            Moose_Density +
                                            Treatment*Moose_Density +
                                            (1 | Month/LocalityName),
                                    data = model_data)
                        
                                #Examine model
                                summary(mi2_log)
                                plot(mi2_log)
                
                #MI3 - Treatment*Years_Since_Clearcut
                        
                        #Normal
                        mi3 <- lmer(Composite_Albedo ~
                                            Treatment + 
                                            Canopy_Height_MAD +
                                            Years_Since_Clearcut +
                                            Moose_Density +
                                            Treatment*Years_Since_Clearcut +
                                            (1 | Month/LocalityName),
                                    data = model_data)
                                
                                #Examine model
                                summary(mi3)
                                plot(mi3)
                                
                        #Log-transformed
                        mi3_log <- lmer(log(Composite_Albedo) ~
                                                Treatment + 
                                                Canopy_Height_MAD +
                                                Years_Since_Clearcut +
                                                Moose_Density +
                                                Treatment*Years_Since_Clearcut +
                                                (1 | Month/LocalityName),
                                        data = model_data)
                                
                                #Examine model
                                summary(mi3_log)
                                plot(mi3_log)
                
                                
                #MI4 - All interaction effects
                                
                        #Normal
                        mi4 <- lmer(Composite_Albedo ~
                                            Treatment + 
                                            Canopy_Height_MAD +
                                            Years_Since_Clearcut +
                                            Moose_Density +
                                            Treatment*Canopy_Height_MAD +
                                            Treatment*Years_Since_Clearcut +
                                            Treatment*Moose_Density +
                                            (1 | Month/LocalityName),
                                    data = model_data)
                        
                                #Examine model
                                summary(mi4)
                                plot(mi4)
                                
                        #Log-transformed
                        mi4_log <- lmer(log(Composite_Albedo) ~
                                            Treatment + 
                                            Canopy_Height_MAD +
                                            Years_Since_Clearcut +
                                            Moose_Density +
                                            Treatment*Canopy_Height_MAD +
                                            Treatment*Years_Since_Clearcut +
                                            Treatment*Moose_Density +
                                            (1 | Month/LocalityName),
                                    data = model_data)
                        
                        #Examine model
                        summary(mi4_log)
                        plot(mi4_log)
        
        
#DEFINE + EXAMINE MODELS ------------------------------------------------------------------------------------------
                        
                        
                        
                        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#AIC MODEL SELECTION ----------------------------------------------------------------------------------------------
        
        #Define dataframe to hold AIC criterion
        aic_values <- data.frame("Model_name" = character(), "AIC_value" = double())
                        
        #Run AIC and add values to df
                
                #Base models
                aic_values <- rbind(aic_values, data.frame("Model_name" = "Base Model", "AIC_value" = AIC(model, k = 2)))
                aic_values <- rbind(aic_values, data.frame("Model_name" = "Base Model Log", "AIC_value" = AIC(log_model, k = 2)))
                        
                #Simple models
                aic_values <- rbind(aic_values, data.frame("Model_name" = "Simple Model", "AIC_value" = AIC(simple_model, k = 2)))
                aic_values <- rbind(aic_values, data.frame("Model_name" = "Simple Model Log", "AIC_value" = AIC(log_simple_model, k = 2)))
                
                #Interaction effect models
                aic_values <- rbind(aic_values, data.frame("Model_name" = "MI1", "AIC_value" = AIC(mi1, k = 2)))
                aic_values <- rbind(aic_values, data.frame("Model_name" = "MI1_Log", "AIC_value" = AIC(mi1_log, k = 2)))
                aic_values <- rbind(aic_values, data.frame("Model_name" = "MI2", "AIC_value" = AIC(mi2, k = 2)))
                aic_values <- rbind(aic_values, data.frame("Model_name" = "MI2_Log", "AIC_value" = AIC(mi2_log, k = 2)))
                aic_values <- rbind(aic_values, data.frame("Model_name" = "MI3", "AIC_value" = AIC(mi3, k = 2)))
                aic_values <- rbind(aic_values, data.frame("Model_name" = "MI3_Log", "AIC_value" = AIC(mi3_log, k = 2)))
                aic_values <- rbind(aic_values, data.frame("Model_name" = "MI4", "AIC_value" = AIC(mi4, k = 2)))
                aic_values <- rbind(aic_values, data.frame("Model_name" = "MI4_Log", "AIC_value" = AIC(mi4_log, k = 2)))
                
                
        
        #Identify model w/ lowest AIC value
        best_model <- aic_values$Model_name[aic_values$AIC_value == min(aic_values$AIC_value)]
        print(best_model)
                     
#END AIC MODEL SELECTION ----------------------------------------------------------------------------------------------
                        
                        
                        
                        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#INVESTIGATE BEST MODEL ----------------------------------------------------------------------------------------------
        
        #Define residuals and fitted values in df for plots
        model_res <- data.frame("Residuals" = residuals(mi1))
        model_fitted <- data.frame("Fitted" = fitted(mi1))
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