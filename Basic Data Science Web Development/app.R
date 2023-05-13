# Include libraries
library(shiny)
library(dplyr)
library(tidyr)
library(readr)
library(plotly)
library(ggpubr)

# Initial actions
## Source scripts, load libraries, and read data sets at the beginning of app.R outside of the server function.
gapminder_clean <- read_csv("gapminder_clean.csv", show_col_types = FALSE)
list_years <- c(1962, 1967, 1972, 1977, 1982, 1987, 1992, 1997, 2002, 2007)
list_dataChoices <- c("Agriculture, value added (% of GDP)", "CO2 emissions (metric tons per capita)", "Domestic credit provided by financial sector (% of GDP)", "Electric power consumption (kWh per capita)", "Energy use (kg of oil equivalent per capita)", "Exports of goods and services (% of GDP)", "Fertility rate, total (births per woman)", "GDP growth (annual %)", "Imports of goods and services (% of GDP)", "Industry, value added (% of GDP)", "Inflation, GDP deflator (annual %)", "Life expectancy at birth, total (years)", "Population density (people per sq. km of land area)", "Services, etc., value added (% of GDP)", "pop", "gdpPercap")

# Define UI
ui <- fluidPage(
  titlePanel("Exploring the Gapminder Dataset"), 
  sidebarLayout(
    sidebarPanel(
      selectInput("dropdown_year", label = "Year to display", choices = list_years), 
      selectInput("dropdown_xData", label = "Data on x axis", choices = list_dataChoices, selected = "CO2 emissions (metric tons per capita)"), 
      checkboxInput("checkbox_xUseLogAxis", label = "Use log scale on x axis", value = FALSE), 
      selectInput("dropdown_yData", label = "Data on y axis", choices = list_dataChoices, selected = "gdpPercap"), 
      checkboxInput("checkbox_yUseLogAxis", label = "Use log scale on y axis", value = FALSE), 
      selectInput("dropdown_color", label = "Data to display with point color (optional)", choices = c(NA, "continent", list_dataChoices)), 
      selectInput("dropdown_size", label = "Data to display with point size (optional)", choices = c(NA, list_dataChoices))
    ), 
    mainPanel(
      h3("Output plot"), br(),
      plotlyOutput("output_plot"), 
      br(), br(), 
      p("ps. Hover over each point for more information.", style="text-align: center; color: #C0C0C0;")
    )
  )
)


# Define server side function
server <- function(input, output) {
  ## Define user specific objects inside server function, but outside of any render calls.
  
  ## Only place code that Shiny must rerun to build an object inside of a render* function.
  # Render data table
  output$output_plot <- renderPlotly({
    dataToPlot <- gapminder_clean %>% 
      filter(Year == input$dropdown_year)
    
    if(input$dropdown_color != "NA" && input$dropdown_size != "NA") {
      toPlot <- dataToPlot %>% 
        filter(!is.na(.data[[input$dropdown_color]]), !is.na(.data[[input$dropdown_size]])) %>% 
        ggplot(aes(x=.data[[input$dropdown_xData]], y=.data[[input$dropdown_yData]], color = .data[[input$dropdown_color]],
                   size = .data[[input$dropdown_size]])) + 
        geom_point(na.rm = TRUE, 
                   aes(text = paste0("country: ", `Country Name`, "\ncontinent: ", continent))) + 
        labs(color = "", size = "")
    } else if (input$dropdown_color != "NA") {
      toPlot <- dataToPlot %>% 
        filter(!is.na(.data[[input$dropdown_color]])) %>%
        ggplot(aes(x=.data[[input$dropdown_xData]], y=.data[[input$dropdown_yData]], color = .data[[input$dropdown_color]])) + 
        geom_point(na.rm = TRUE, 
                   aes(text = paste0("country: ", `Country Name`, "\ncontinent: ", continent))) + 
        labs(color = "")
    } else if (input$dropdown_size != "NA") {
      toPlot <- dataToPlot %>% 
        filter(!is.na(.data[[input$dropdown_size]])) %>% 
        ggplot(aes(x=.data[[input$dropdown_xData]], y=.data[[input$dropdown_yData]], size = .data[[input$dropdown_size]])) + 
        geom_point(na.rm = TRUE, 
                   aes(text = paste0("country: ", `Country Name`, "\ncontinent: ", continent))) + 
        labs(size = "")
    } else {
      toPlot <- dataToPlot %>% 
        ggplot(aes(x=.data[[input$dropdown_xData]], y=.data[[input$dropdown_yData]])) + 
        geom_point(na.rm = TRUE, 
                   aes(text = paste0("country: ", `Country Name`, "\ncontinent: ", continent)))
    }

    if(input$checkbox_xUseLogAxis == TRUE) {
      toPlot <- toPlot + scale_x_log10()
    }
    if(input$checkbox_yUseLogAxis == TRUE) {
      toPlot <- toPlot + scale_y_log10()
    }
    
    toPlot <- toPlot + 
      labs(title = paste0("Data in Year ", input$dropdown_year))
      
    
    ggplotly(toPlot)
  })
}


# Run the app
shinyApp(ui = ui, server = server)
