# Homework #3 Shiny app
# Due November 1, 2019

library(shiny)
library(tidyverse)
library(forcats)
library(dslabs)
data(gapminder)

ui <- fluidPage()

server <- function(input, output) {}

# Run the application 
shinyApp(ui = ui, server = server)
