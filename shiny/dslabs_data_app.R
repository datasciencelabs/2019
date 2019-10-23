# Shiny app using data from the dslabs package

# Load packages
library(shiny)
library(shinythemes)
library(dslabs)
library(dplyr)
library(ggplot2)
library(RColorBrewer)

# Load datasets
data(gapminder)
data(us_contagious_diseases)


ui = fluidPage(
        # Change theme to darkly
        theme = shinythemes::shinytheme("darkly"),
        # Application title
        titlePanel("My More Advanced Shiny App"),
        
        # Create an app with 2 tabs
        tabsetPanel(
            # First tab: the Hans Rosling plot from TED talk
            # Scatter plot that compares life expectancy and fertility
            # for each country over time with an animated bar for the years
            tabPanel("Gapminder",
                     sidebarLayout(
                         sidebarPanel(
                             # Add some text and a couple of hyper links before the slider for year
                             p("The plots generated here are inspired by the", a("TED talk given by
                   Hans Rosling.", 
                                                                                 href="https://www.ted.com/talks/hans_rosling_shows_the_best_stats_you_ve_ever_seen"),
                               "The data used was created using a number of spreadsheets 
                   available from the", a("Gapminder Foundation", href="http://www.gapminder.org/")),
                             
                             # Add some space between the text above and animated
                             # slider bar below
                             br(),
                             
                             # Input: year slider with basic animation
                             sliderInput("year", "Year:",
                                         min = 1960, max = 2015,
                                         value = 1960, 
                                         step = 1,
                                         sep = "",       # keep years in year format and not 1,960 format
                                         ticks = FALSE,  # don't show tick marks on slider bar
                                         animate = TRUE) # add play button to animate
                         ),
                         
                         # Show a scatter plot for all countries
                         mainPanel(
                             plotOutput("scatterPlot")
                         )
                     )),
            
            # Second tab: tile plot of infectious diseases
            # Include dropdown menu of diseases to choose from 
            tabPanel("Vaccines",
                     sidebarLayout(
                         sidebarPanel(
                             # Paragraph with some text about vaccines and the data source
                             # strong("Vaccines") makes the word Vaccines bold
                             p(strong("Vaccines"), "have helped save millions of lives. In the 19th century, 
                   before herd immunization was achieved through vaccination programs, 
                   deaths from infectious diseases, like smallpox and polio, were common. 
                   However, today, despite all the scientific evidence for their importance, 
                   vaccination programs have become somewhat controversial. Effective 
                   communication of data is a strong antidote to misinformation and fear mongering.
                   The data used for these plots were collected, organized and distributed by the 
                   Tycho Project."),
                             
                             # Adding br() will add space between the text above and the dropdown
                             # menu below
                             br(),
                             
                             # Dropdown menu that allows the user to choose a disease
                             selectInput("disease", label = "Select contagious disease",
                                         choices = as.list(levels(us_contagious_diseases$disease)))
                         ),
                         
                         # Show a tile plot of disease rate across states and years
                         mainPanel(
                             plotOutput("tilePlot")
                         )
                     ))
        )
    )
    
    server = function(input, output) {
        
        # Scatterplot of fertility rate vs life expectancy
        output$scatterPlot = renderPlot({
            # Filter year to be the input year from the slider
            gapminder %>% filter(year %in% input$year & !is.na(fertility)) %>%
                ggplot(aes(fertility, life_expectancy, color = continent, size = population/10^6)) +
                geom_point(alpha = 0.5) +
                xlab("Fertility (Average number of children per woman)") +
                ylab("Life expectancy (Years)") +
                
                # Set x and y axis limits to keep the same for each year
                scale_x_continuous(breaks = seq(0, 9), limits = c(1, 8)) +
                scale_y_continuous(breaks = seq(30, 85, 5), limits = c(30, 85)) +
                # Make the legend titles nicer
                scale_color_discrete(name = "Continent") +
                scale_size_continuous(name = "Population in millions") +
                
                # Change the title of the plot for each year
                # Returns a character vector containing a formatted combination 
                # of text and variable values
                ggtitle(sprintf("Life expectancy vs. fertility in %d", input$year)) +
                theme_bw()
        })
        
        # Tile plot for contagious disease rates across states
        
        output$tilePlot = renderPlot({
            # Filter to disease specified from dropdown menu
            the_disease <- input$disease
            dat <- us_contagious_diseases %>%
                filter(!state %in% c("Hawaii","Alaska"), disease == the_disease) %>%
                mutate(rate = (count / weeks_reporting) * 52 / (population / 100000))
            
            # Create a list of years corresponding to the years each vaccine was 
            # introduced in the US (will use this to add a vertical line to the plot
            # showing when the vaccine was introduced)
            vaccines <- c("Hepatitis A" = 1995, "Measles" = 1963, "Mumps" = 1967,
                          "Pertussis" = 1945, "Polio" = 1955, "Rubella" = 1969, "Smallpox" = 1939)
            
            dat %>% 
                ggplot(aes(x = year, y = state,  fill = rate)) +
                geom_tile(color = "grey50") +
                scale_x_continuous(expand = c(0,0)) +
                scale_fill_gradientn("Cases per\n100,000", 
                                     colors = brewer.pal(9, "Reds"), 
                                     trans = "sqrt") +
                # Use list above for vertical line intercept
                geom_vline(xintercept = vaccines[the_disease], col = "blue") +
                theme_minimal() +  
                theme(panel.grid = element_blank()) +
                
                # Another way to change the text of the title
                ggtitle(input$disease, "Cases per 100,000 by State") + 
                ylab("") + xlab("") })
        
}

shinyApp(ui = ui, server = server)