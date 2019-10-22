library(shiny)
library(dslabs)
library(dplyr)
library(ggplot2)
data("murders")

# Define ui
ui <- fluidPage( 
    titlePanel("Data Exploration with Murder Data"),
    br(), # add some space 
    # First row
    fluidRow(
        column(3,
              p("The US is a large and diverse country with 50 very different states as well as the 
              District of Columbia (DC). Here we use the", code("murders"), "dataset to gain some insight
              into the variability in number of murders by region.")
        ),
        column(3, selectInput(inputId = "region", label = "Select a region",
                              choices = as.list(levels(murders$region)))
        ),
        column(3, selectInput(inputId = "color", label = "Choose a color",
                              choices = c("black", "blue", "red", "green"))
        
        ),
        column(3, radioButtons(inputId = "type", label = "What kind of plot?",
                               choices = c("Scatter plot", "Boxplot"))
        )
    ),
    br(), # add some space 
    # Second row
    fluidRow(
        column(6, plotOutput("Plot")),
        column(6, verbatimTextOutput("mean"))
    )
)

# Define server
server <- function(input, output){
    dat <- reactive(murders %>% filter(region == input$region))
    
    output$Plot <- renderPlot({
        if (input$type == "Scatter plot"){
            dat() %>%
                ggplot(aes(x = population/10^6, y = total)) +
                geom_point(color = input$color) +
                scale_x_log10(limits = c(1, 30), breaks = c(1, 3, 10, 30)) +
                scale_y_log10(limits = c(1, 1000), breaks = c(10, 100, 300, 500, 1000)) +
                xlab("Population in Millions(log scale)") +
                ylab("Total Number of Murders (log scale)")
        } else{
            dat() %>%
                ggplot(aes(x = region, y = total)) +
                geom_boxplot(color = input$color) +
                xlab("") +
                ylab("Number of murders")
        }
    })
    
    output$mean <- renderText({
        avg <- dat() %>%
            summarize(avg = mean(total)) %>% .$avg
        
        paste0("Mean number of murders in the ", input$region, " region: ", avg)
    })
    
}

shinyApp(ui = ui, server = server)

