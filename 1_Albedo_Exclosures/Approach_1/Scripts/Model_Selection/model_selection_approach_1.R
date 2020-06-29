##Script to identify model w/ best fit for Approach 1


##PACKAGES ----------------------------------------------------------------------------------------

        #Packages for data processing + visualization
        library(dplyr)
        library(tidyr)
        library(ggplot2)

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
        
        #Base Model
        model <- lmer(Composite_Albedo ~
                              Treatment + 
                              Productivity_Index +
                              Canopy_Height_MAD +
                              Years_Since_Clearcut +
                              Moose_Density +
                              Red_Deer_Density +
                              (1 | LocalityName/Month),
                      data = model_data)
        
                #Examine model
                summary(model)
                plot(model)
        
        
        #SIMPLIFIED MODEL (based on summary of base model - remove )
        simple_model <- lmer(Composite_Albedo ~
                                     Treatment + 
                                     Canopy_Height_MAD +
                                     Moose_Density +
                                     (1 | LocalityName/Month),
                             data = model_data)
                
                #Examine model
                summary(simple_model)
                plot(simple_model)
                
        
        #MODELS W/ INTERACTION TERMS
        #Note: using simplified model here, since effect size of treatment is identical between two models
                
                #MI1 - Treatment*Canopy Height
                mi1 <- lmer(Composite_Albedo ~
                                    Treatment + 
                                    Treatment*Canopy_Height_MAD +
                                    Canopy_Height_MAD +
                                    Moose_Density +
                                    (1 | LocalityName/Month),
                            data = model_data)
                
                        #Examine model
                        summary(mi1)
                        plot(mi1)
                        
                #MI2 - Treatment*Moose Density
                mi2 <- lmer(Composite_Albedo ~
                                    Treatment + 
                                    Treatment*Moose_Density +
                                    Canopy_Height_MAD +
                                    Moose_Density +
                                    (1 | LocalityName/Month),
                            data = model_data)
                
                        #Examine model
                        summary(mi2)
                        plot(mi2)
                
                #MI3 - Treatment*Month
                mi3 <- lmer(Composite_Albedo ~
                                    Treatment + 
                                    Treatment*Month +
                                    Canopy_Height_MAD +
                                    Moose_Density +
                                    (1 | LocalityName/Month),
                            data = model_data)
                
                        #Examine model
                        summary(mi3)
                        plot(mi3)
                        
                #MI4 - Treatment*Canopy_Height + Treatment*Month
                mi4 <- lmer(Composite_Albedo ~
                                    Treatment + 
                                    Treatment*Canopy_Height_MAD +
                                    Treatment*Month +
                                    Canopy_Height_MAD +
                                    Moose_Density +
                                    (1 | LocalityName/Month),
                            data = model_data)
                
                        #Examine model
                        summary(mi4)
                        plot(mi4)
                
                #MI5 - All interaction effects
                mi5 <- lmer(Composite_Albedo ~
                                    Treatment + 
                                    Treatment*Canopy_Height_MAD +
                                    Treatment*Moose_Density +
                                    Treatment*Month +
                                    Canopy_Height_MAD +
                                    Moose_Density +
                                    (1 | LocalityName/Month),
                            data = model_data)
                
                        #Examine model
                        summary(mi5)
                        plot(mi5)
        
#DEFINE + EXAMINE MODELS ------------------------------------------------------------------------------------------
                        
                        
                        
                        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#AIC MODEL SELECTION ----------------------------------------------------------------------------------------------
        
        #Define dataframe to hold AIC criterion
        aic_values <- data.frame("Model_name" = character(), "AIC_value" = double())
                        
        #Run AIC and add values to df
                
                #Base model
                aic_values <- rbind(aic_values, data.frame("Model_name" = "Base Model", "AIC_value" = AIC(model, k = 2)))
                        
                #Simple model
                aic_values <- rbind(aic_values, data.frame("Model_name" = "Simple Model", "AIC_value" = AIC(simple_model, k = 2)))
                
                #Interaction effect models
                aic_values <- rbind(aic_values, data.frame("Model_name" = "MI1", "AIC_value" = AIC(mi1, k = 2)))
                aic_values <- rbind(aic_values, data.frame("Model_name" = "MI2", "AIC_value" = AIC(mi2, k = 2)))
                aic_values <- rbind(aic_values, data.frame("Model_name" = "MI3", "AIC_value" = AIC(mi3, k = 2)))
                aic_values <- rbind(aic_values, data.frame("Model_name" = "MI4", "AIC_value" = AIC(mi4, k = 2)))
                aic_values <- rbind(aic_values, data.frame("Model_name" = "MI5", "AIC_value" = AIC(mi5, k = 2)))
        
        #Identify model w/ lowest AIC value
        best_model <- aic_values$Model_name[aic_values$AIC_value == min(aic_values$AIC_value)]
        print(best_model)
                     
#END AIC MODEL SELECTION ----------------------------------------------------------------------------------------------
                        
                        
                        
                        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#INVESTIGATE BEST MODEL ----------------------------------------------------------------------------------------------
        
        
        
#END INVESTIGATE BEST MODEL ------------------------------------------------------------------------------------------
        
        
        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\


        
        
#WRITE OUTPUT ----------------------------------------------------------------------------------------------
#END WRITE OUTPUT ----------------------------------------------------------------------------------------------