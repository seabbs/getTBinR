library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(shinycssloaders)
library(plotly)
library(magrittr)
library(dplyr)
library(tibble)
library(getTBinR)


shinyServer(function(input, output) {
  
  ## Get data
  tb_df <- reactive({
    tb_df <- get_tb_burden(download_data = TRUE, save = TRUE)
  })
  
  dict <- reactive({
    dict <- get_data_dict(download_data = TRUE, save = TRUE)
  })
  
  unique_metrics <- reactive({
    df <- tibble(variable_name = colnames(tb_df())) %>% 
      left_join(dict(), by = c("variable_name")) %>% 
      filter(!(variable_name %in% c("country", "iso2", "iso3", 
                                    "g_whoregion", "year",
                                    "iso_numeric")),
             !grepl("_lo", variable_name),
             !grepl("_hi", variable_name)) %>% 
      na.omit()
      
  })

  ## Set up input options
  ## Metric
  output$select_metric <- renderUI({
    
    choices <- unique_metrics()$variable_name
    
    names(choices) <- unique_metrics()$definition
    
    ## Filter out confidence intvervals
    selectInput(inputId = 'metric', 
                label = 'Select the metric to display',
                choices = choices,
                selected = "e_inc_100k")
  })
  
  metric <- reactive({
    if (is.null(input$metric)) {
      metric <- "e_inc_100k"
    }else{
      metric <- input$metric
    }
  })
  
  ## Country
  output$select_year <- renderUI({
    
    choices <- unique(tb_df()$year)

    ## Filter out confidence intvervals
    sliderInput(inputId = 'year', 
                label = 'Select the year to map',
                value = max(choices),
                min = min(choices),
                max = max(choices),
                step = 1,
                sep = "",
                animate = animationOptions(interval = 5000,
                                           playButton = icon('play', "fa-3x"),
                                           pauseButton = icon('pause', "fa-3x"),
                                           loop = TRUE))
  })
  
  year <- reactive({
    if (is.null(input$year)) {
      year <- 2016
    }else{
      year <- input$year
    }
  })
  
  country <- "United Kingdom"
  
  ## Filter date based on year selected
  tb_df_filt <- reactive({
    tb_df <- tb_df() %>% 
      filter(year <= year())
  })
  
  # Make map of metric
  output$map_tb_burden <- renderPlotly({
    map_tb_burden(tb_df_filt(), dict(), metric = metric(), 
                  year = year(), interactive = TRUE)
  })
  
  # Regional comparision of a chosen metric
  output$plot_region_com <- renderPlotly({
    plot_tb_burden_overview(tb_df_filt(), dict(), metric = metric(),
                            countries = country, interactive = TRUE,
                            compare_to_region = TRUE)
  })
  
  # Plot country metric
  output$plot_country_metric <- renderPlotly({
    plot_tb_burden(tb_df_filt(), dict(), metric = metric(),
                   countries = country, interactive = TRUE)
  })

    

  
})