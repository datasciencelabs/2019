library(shiny)
library(dslabs)
library(dplyr)
library(ggplot2)
data("murders")

# Define ui
ui <- fluidPage( 
    titlePanel("Data Exploration with Murder Data"),
    
    sidebarLayout(
        sidebarPanel(
            # Dropdown menu that allows the user to choose a region
            selectInput(inputId = "region", label = "Select a region",
                        choices = as.list(levels(murders$region))),
            
            # Dropdown menu that allows user to choose a color
            selectInput(inputId = "color", label = "Choose a color",
                        choices = c("black", "blue", "red", "green")
            ),
            
            # Radio buttons for the user to choose a scatter plot or boxplot
            radioButtons(inputId = "type", label = "What kind of plot?",
                         choices = c("Scatter plot", "Boxplot"))
        ),
        
        mainPanel(
            # I changed the name of the output since it can be 2 different things
            plotOutput("Plot") 
        )
    )
)

# Define server
server <- function(input, output){
        output$Plot <- renderPlot({
            if (input$type == "Scatter plot"){
                murders %>% filter(region == input$region) %>%
                    ggplot(aes(x = population/10^6, y = total)) +
                    geom_point(color = input$color) +
                    scale_x_log10(limits = c(1, 30), breaks = c(1, 3, 10, 30)) +
                    scale_y_log10(limits = c(1, 1000), breaks = c(10, 100, 300, 500, 1000)) +
                    xlab("Population in Millions(log scale)") +
                    ylab("Total Number of Murders (log scale)")
            } else{
                murders %>% filter(region == input$region) %>%
                    ggplot(aes(x = region, y = total)) +
                    geom_boxplot(color = input$color) +
                    xlab("") +
                    ylab("Number of murders")
            }
        })
    
}

shinyApp(ui = ui, server = server)

