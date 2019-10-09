library(shiny)

# Define UI
ui <- fluidPage(
  sliderInput(inputId = "num",
              label = "Choose a number",
              value = 25, min = 1, max = 100),
  plotOutput(outputId = "hist")
)

# Define server
server <- function(input, output){
    output$hist <- renderPlot({
        hist(rnorm(input$num))
    })
}

shinyApp(ui = ui, server = server)