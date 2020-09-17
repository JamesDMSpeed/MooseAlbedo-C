library(shiny)
library(ggplot2)
library(sf)
library(feather)

#Load the data ()
data1999 <- read_feather("shiny_data_1999.feather")

#Define the UI layout for the app
ui <- pageWithSidebar(
        
        # App title ----
        headerPanel("Exploring the Albedo Dataset (1999 data)"),
        
        # Sidebar panel for inputs ----
        sidebarPanel(
                
                #Add a select dropdown for SPECIES
                selectInput(inputId = "species",
                            label = "Tree Species:",
                            choices = c("Spruce",
                                        "Pine",
                                        "Birch"),
                            selected = "Spruce"),
                
                wellPanel(
                        
                        h4("Fix parameters:"),
                        hr(),
                        
                        #Add a select input for MONTH
                        selectInput(inputId = "month",
                                    label = "Month:",
                                    choices = c("January",
                                                "February",
                                                "March",
                                                "April",
                                                "May",
                                                "June",
                                                "July",
                                                "August",
                                                "September",
                                                "October",
                                                "November",
                                                "December"),
                                    selected = "January"),
                        
                        #Add a slider input for AGE
                        sliderInput("plot_age", "Plot Age (years)", value = c(0,30), min = 0, max = 30),
                        
                        #Add a slider input for ELEVATION
                        sliderInput("elevation", "Plot Elevation (m)", value = c(0,1150), min = 0, max = 1150),
                
                        #Add a slider input for SWE
                        sliderInput("swe", "SWE for Selected Month", value = c(100,120), min = 0, max = 1850, step = 10)
                        
                ),
                
        ),
        
        # Main panel for displaying outputs ----
        mainPanel(
                
                #Header + Text Parameters
                h3(textOutput("sel_month_alb")),
                hr(),
                textOutput("parameters1"),
                textOutput("parameters2"),
                textOutput("parameters3"),
                hr(),
                
                #Plot Output
                plotOutput("albedo_plot")
                
        )
)


# Define server logic ----
server <- function(input, output) {
        
        
        #Display text according to month
        output$sel_month_alb <- renderText({ 
                paste("Albedo (", input$month, ") vs. Moose Density", sep = "")
        })
        
        #Display parameters
        output$parameters1 <- renderText({

                        paste("Forest Age: ", input$plot_age[[1]], "-", input$plot_age[[2]], " years", sep = "")

        })

        output$parameters2 <- renderText({
                
                paste("Forest Within Elevation: ", input$elevation[[1]], "-", input$elevation[[2]], " meters", sep = "")

        })
        
        output$parameters3 <- renderText({
                
                paste("Forest With ", input$month, " SWE of: ", input$swe[[1]], "-", input$swe[[2]], "mm", sep = "")

        })
                
        #Albedo plot
        output$albedo_plot <- renderPlot({
                
                if(input$species == "Spruce"){
                        
                        #Albedo plot w/ defined parameters
                        ggplot(data = subset(data1999,
                                             Month_Name == input$month &
                                                     alder >= input$plot_age[[1]] &
                                                     alder <= input$plot_age[[2]] &
                                                     dem >= input$elevation[[1]] &
                                                     dem <= input$elevation[[2]] &
                                                     SWE >= input$swe[[1]] &
                                                     SWE <= input$swe[[2]]),
                               aes(x = Ms_Dnst, y = Albedo_Spruce)) +
                                geom_bin2d() +
                                geom_smooth(colour = "red") +
                                ggtitle(paste(input$species, " Albedo (", input$month, ") vs. Moose Density", sep = "")) +
                                labs(x = "Moose Density (kg/km-2)", y = paste(input$species, " Albedo", sep = "")) +
                                scale_y_continuous(limits = c(0,0.6))
                        
                } else if (input$species == "Pine"){
                        
                        #Albedo plot w/ defined parameters
                        ggplot(data = subset(data1999,
                                             Month_Name == input$month &
                                                     alder >= input$plot_age[[1]] &
                                                     alder <= input$plot_age[[2]] &
                                                     dem >= input$elevation[[1]] &
                                                     dem <= input$elevation[[2]] &
                                                     SWE >= input$swe[[1]] &
                                                     SWE <= input$swe[[2]]),
                               aes(x = Ms_Dnst, y = Albedo_Pine)) +
                                geom_bin2d() +
                                geom_smooth(colour = "red") +
                                ggtitle(paste(input$species, " Albedo (", input$month, ") vs. Moose Density", sep = "")) +
                                labs(x = "Moose Density (kg/km-2)", y = paste(input$species, " Albedo", sep = "")) +
                                scale_y_continuous(limits = c(0,0.6))
                        
                } else if (input$species == "Birch"){
                        
                        #Albedo plot w/ defined parameters
                        ggplot(data = subset(data1999,
                                             Month_Name == input$month &
                                                     alder >= input$plot_age[[1]] &
                                                     alder <= input$plot_age[[2]] &
                                                     dem >= input$elevation[[1]] &
                                                     dem <= input$elevation[[2]] &
                                                     SWE >= input$swe[[1]] &
                                                     SWE <= input$swe[[2]]),
                               aes(x = Ms_Dnst, y = Albedo_Birch)) +
                                geom_bin2d() +
                                geom_smooth(colour = "red") +
                                ggtitle(paste(input$species, " Albedo (", input$month, ") vs. Moose Density", sep = "")) +
                                labs(x = "Moose Density (kg/km-2)", y = paste(input$species, " Albedo", sep = "")) +
                                scale_y_continuous(limits = c(0,0.6))
                        
                }

                        
                        
                        
                
                
                
        })
        
}


#Use the Shiny app function to actually construct the app
shinyApp(ui, server)


#runApp("2_Albedo_Regional/Approach_1_SatSkog/Scripts/Attempt_2_Visualization/Shiny_App")