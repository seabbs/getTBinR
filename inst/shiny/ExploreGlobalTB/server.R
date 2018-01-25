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
    tb_df <- get_tb_burden(download_data = TRUE, save = TRUE) %>% 
      mutate(g_whoregion = ifelse(is.na(g_whoregion), "Asia", g_whoregion))
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
    map <- map_tb_burden(tb_df_filt(), dict(), metric = metric(), 
                  year = year(), interactive = FALSE) + 
      ggplot2::theme(legend.position = "none") 
    
      ggplotly(map, source = "WorldMap")
  })
  
  #Get country clicked on map
  country <- reactive({
    country <- event_data(event = "plotly_click", source = "WorldMap")
    
    country <- country$key[[1]]
  })
  
  output$country <- renderText({
    if (is.null(country())) {
      "Select a country for more information"
    } else {
      paste0("Showing data for ", country())
    }
  })
  
  # Plot country metric
  output$plot_country_metric <- renderPlotly({
    validate(
      need(!is.null(country()), "Select a country using the map to see trends over time.")
    )
    
    if (is.null(country())) {
      stop("A country is required")
    }
    
    plot_tb_burden(tb_df_filt(), dict(), metric = metric(),
                   countries = country(), interactive = TRUE)
  })
  
  
  
  # Regional comparision of a chosen metric
  output$plot_region_com <- renderPlotly({
    validate(
      need(!is.null(country()), "Select a country using the map to see a regional comparision.")
    )
    
    if (is.null(country())) {
      stop("A country is required")
    }
    
    plot_tb_burden_overview(tb_df_filt(), dict(), metric = metric(),
                            countries = country(), interactive = TRUE,
                            compare_to_region = TRUE)
  })

  
  # Plot country metric
  output$plot_region_trend <- renderPlotly({
    validate(
      need(!is.null(country()), "Select a country using the map to see trends over time in the region.")
    )
    
    if (is.null(country())) {
      stop("A country is required")
    }
    
    plot_tb_burden(tb_df_filt(), dict(), metric = metric(),
                   countries = country(), interactive = TRUE,
                   compare_to_region = TRUE, facet = "country", scales = "free_y")
  })
  
})