library(tidyverse)
library(vroom)
library(shiny)

# Load data
# The goal of 'vroom' is to read and write data (like 'csv', 'tsv' and 'fwf') quickly.
# Learn more here: https://cran.r-project.org/web/packages/vroom/index.html

if (!exists("injuries")) {
  injuries   <- vroom::vroom("injuries.tsv.gz")
  products   <- vroom::vroom("products.tsv")
  population <- vroom::vroom("population.tsv")
}

ui <- fluidPage(
  # First row
  fluidRow(
    column(4, selectInput(inputId = "code", 
                       label = "Product", 
                       setNames(products$prod_code, products$title))
    ),
    column(2, selectInput(inputId = "y", 
                          label = "Y axis", 
                          c("rate", "count")))
  ),
  # Second row
  fluidRow(
    column(4, tableOutput("diag")),
    column(4, tableOutput("body_part")),
    column(4, tableOutput("location"))
  ),
  # Third row
  fluidRow(
    column(12, plotOutput("age_sex"))
  ),
  # Fourth row
  fluidRow(
    column(2, actionButton(inputId = "story", 
                           label = "Tell me a story")),
    column(10, textOutput("narrative"))
  )
  
)

count_top <- function(df, var, n = 5) {
  df %>%
    # The {{ }} syntax is called a Mustache.
    # Mustache can be used for HTML, config files, source code - anything. 
    # It works by expanding tags in a template using values provided in a hash or object.
    # We call it "logic-less" because there are no if statements, else clauses, or for loops. 
    # Instead there are only tags. Some tags are replaced with a value, some nothing, and others a series of values. 
    # You can learn more here: http://mustache.github.io/mustache.5.html
    
    # := is syntax for assigning fixed values; in contrast, = would here be used to assign a variable value.
    
    # fct_infreq: orders by frequency of occurrence
    # fct_lump: lumps together the rest of the lesser occurring categories into one "other" category
    
    mutate({{ var }} := fct_lump(fct_infreq({{ var }}), n = n)) %>%
    group_by({{ var }}) %>%
    summarise(n = as.integer(sum(weight)))
}

server <- function(input, output, session) {
  # Reactive expression
  selected <- reactive(injuries %>% filter(prod_code == input$code))

  # Tables
  output$diag      <- renderTable(count_top(selected(), diag), width = "100%")
  output$body_part <- renderTable(count_top(selected(), body_part), width = "100%")
  output$location  <- renderTable(count_top(selected(), location), width = "100%")

  # Reactive expression
  summary <- reactive({
    selected() %>%
      count(age, sex, wt = weight) %>%
      left_join(population, by = c("age", "sex")) %>%
      mutate(rate = n / population * 10^4)
  })

  # Plot
  output$age_sex <- renderPlot({
    if (input$y == "count") {
      summary() %>%
        ggplot(aes(age, n, colour = sex)) +
        geom_line() +
        labs(y = "Estimated number of injuries") +
        theme_grey(15) # Font size 15
    } else {
      summary() %>%
        ggplot(aes(age, rate, colour = sex)) +
        geom_line(na.rm = TRUE) +
        labs(y = "Injuries per 10,000 people") +
        theme_grey(15)
    }
  })

  # Narrative
  output$narrative <- renderText({
    input$story
    selected() %>% pull(narrative) %>% sample(1)
  })
}

shinyApp(ui = ui, server = server)
