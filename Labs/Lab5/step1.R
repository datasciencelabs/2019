library(shiny)
library(dslabs)
library(dplyr)
library(ggplot2)
data("murders")

# Define ui
ui <- fluidPage( # Dropdown menu that allows the user to choose a region
    selectInput(inputId = "region", label = "Select a region",
                choices = as.list(levels(murders$region))),
    plotOutput("scatterPlot")
)

# Define server
server <- function(input, output){
    output$scatterPlot <- renderPlot({
        murders %>% filter(region == input$region) %>%
            ggplot(aes(x = population, y = total)) +
            geom_point() +
            xlab("Population") +
            ylab("Total number of murders")
    })
}

shinyApp(ui = ui, server = server)