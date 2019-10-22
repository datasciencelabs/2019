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
            ggplot(aes(x = population/10^6, y = total)) +
            geom_point() +
            scale_x_log10(limits = c(1, 30), breaks = c(1, 3, 10, 30)) +
            scale_y_log10(limits = c(1, 1000), breaks = c(10, 100, 300, 500, 1000)) +
            xlab("Population in Millions(log scale)") +
            ylab("Total Number of Murders (log scale)")
    })
}

shinyApp(ui = ui, server = server)