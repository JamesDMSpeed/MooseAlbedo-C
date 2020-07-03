## This script contains code for the longitudinal analysis of albedo estimates using the 'age-based' variant of the model

##PACKAGES ----------------------------------------------------------------------------------------

        #Packages for general data manipulation + visualization
        library(ggplot2)
        library(dplyr)
        library(RColorBrewer)
        library(wesanderson)
        library(sp)
        library(raster)
        library(GGally)
        library(lattice)
        library(sjPlot)
        
        #Packages for analysis
        library(lme4)
        library(lmerTest)


###END PACKAGES ----------------------------------------------------------------------------------------




#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#INITIAL DATA IMPORT ----------------------------------------------------------------------

        ## ALBEDO ESTIMATES
        
                #Get CSV of albedo estimates
                model_data <- read.csv('1_Albedo_Exclosures/Approach_Longitudinal/Plot_Age/Output/Albedo_Estimates/albedo_estimates_approach_longitudinal_age.csv', header = TRUE)
                
                #Format columns
                model_data$Month <- as.factor(model_data$Month)
                model_data$Year <- as.factor(model_data$Year)
                model_data$LocalityCode <- as.factor(model_data$LocalityCode)
                model_data$LocalityName <- as.factor(model_data$LocalityName)
                
#END INITIAL DATA IMPORT ----------------------------------------------------------------------
                
                
                
                
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#ANALYSIS ----------------------------------------------------------------------                

        #MIXED EFFECTS MODEL #1
                
                #Investigate correlation between explanatory variables
                corr_matrix1 <- ggpairs(data = model_data, columns = 11:14)
                
                #Visualize correlation between explanatory variables
                ggcorr(data = model_data[,11:14])
                
                ## Run Mixed Effects Model
                ## NOTE: Random Effect - Site (LocalityName) is the main grouping variable, w/ month nested below
                model <- lmer(log(Composite_Albedo) ~ Treatment +
                                      Productivity_Index +
                                      Moose_Density +
                                      Red_Deer_Density +
                                      (1 | Month/LocalityName) +
                                      (1 | Year),
                              data = model_data)
                
                #Summarize model
                summary(model)
                plot(model)

                #Explore model
                
                        #Define residuals and fitted values in df for plots
                        model_res <- data.frame("Residuals" = residuals(model))
                        model_fitted <- data.frame("Fitted" = fitted(model))
                        model_actual <- data.frame("Actual" = model_data$Composite_Albedo)
                        model_meta <- cbind(model_res, model_fitted, model_actual)
                
                        #Plot of residuals
                        resid <- ggplot(model_meta, aes(Fitted, Residuals)) +
                                geom_point(size = 4) +
                                ggtitle("Model Residuals")
                                theme(plot.title = element_text(hjust = 0.5, size = 60, margin = margin(t = 40, b = 40)),
                                      legend.title = element_text(size = 40),
                                      legend.text = element_text(size = 36),
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

                        #Plot actual vs fitted
                        relationship <- ggplot(model_meta, aes(Actual, Fitted)) +
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
                                

                        #plot(model_data$Month, fitted(model))
                        
                        #Spaghetti Plot
                        
                
#END ANALYSIS ----------------------------------------------------------------------  
                        
                        
                        
                        
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\




#WRITE OUTPUT --------------------------------------------------------------------------
                        
        #Print correlation matrix
        png(filename = "1_Albedo_Exclosures/Approach_4/Output/Analysis/corr_matrix_approach_4.png",
            width = 1000,
            height = 1000,
            units = "px",
            bg = "white")
        corr_matrix1
        dev.off()
        
        #Print correlation heatmap
        png(filename = "1_Albedo_Exclosures/Approach_4/Output/Analysis/corr_heatmap_approach_4.png",
            width = 1000,
            height = 1000,
            units = "px",
            bg = "white")
        ggcorr(data = model_data[,8:12])
        dev.off()
        
        #Print residuals scatterplot
        png(filename = "1_Albedo_Exclosures/Approach_4/Output/Analysis/residuals_plot_approach_4.png",
            width = 2000,
            height = 2000,
            units = "px",
            bg = "white")
        resid
        dev.off()
        
        #Print residuals distribution
        png(filename = "1_Albedo_Exclosures/Approach_4/Output/Analysis/residuals_hist_approach_4.png",
            width = 2000,
            height = 1600,
            units = "px",
            bg = "white")
        hist
        dev.off()
        
        #Print residuals qqplot
        png(filename = "1_Albedo_Exclosures/Approach_4/Output/Analysis/residuals_qq_approach_4.png",
            width = 1000,
            height = 1000,
            units = "px",
            bg = "white")
        qqnorm(model_meta$Residuals)
        dev.off()
        
        #Print actual vs fitted values
        png(filename = "1_Albedo_Exclosures/Approach_4/Output/Analysis/actual_fitted_approach_4.png",
            width = 2000,
            height = 2000,
            units = "px",
            bg = "white")
        relationship
        dev.off()
        
        #Print model summary table
        tab_model(model, digits = 5, file = "1_Albedo_Exclosures/Approach_4/Output/Analysis/model_approach_4.html")
   
        
        
                        
                        
#END WRITE OUTPUT ----------------------------------------------------------------------