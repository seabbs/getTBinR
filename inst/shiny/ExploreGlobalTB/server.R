library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(shinycssloaders)
library(plotly)
library(magrittr)
library(dplyr)
library(tibble)
library(getTBinR)


shinyServer(function(input, output, session) {
  
  ## Get data
  tb_df <- reactive({
    tb_df <- try(get_tb_burden(download_data = TRUE, save = TRUE) %>% 
      mutate(g_whoregion = ifelse(is.na(g_whoregion), "Asia", g_whoregion)))
    
    validate(
      need(!(class(tb_df) %in% "try-error"), "There has been an issue downloading the TB burden data please contact the app author.")
    )

    tb_df
  })
  
  dict <- reactive({
    dict <- try(get_data_dict(download_data = TRUE, save = TRUE))
    
    validate(
      need(!(class(dict) %in% "try-error"), "There has been an issue downloading the data dictionary please contact the app author.")
    )
    
    dict
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
                label = 'Select the metric to display (note: some metrics have incomplete data)',
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
  
  ## Set up confidence intervals
  conf <- reactive({
    if (any(grepl(paste0(metric(), "_lo"), colnames(tb_df())))) {
      conf <-  c("_lo", "_hi")
    }else{
      conf <- NULL
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
                  year = year(), interactive = TRUE)
        
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
    
    plot_tb_burden(tb_df_filt(), dict(), metric = metric(), conf = conf(),
                   countries = country(), interactive = TRUE, facet = "country")
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
                   countries = country(), interactive = TRUE, conf = conf(),
                   compare_to_region = TRUE, facet = "country", scales = "free_y")
  })
  
  # Generate Country Level Report
  output$report <- downloadHandler(
    # For PDF output, change this to "report.pdf"
    filename = "country-report.html",
    content = function(file) {
      
      render_country_report(country = country(), filename = file)
    })
  
})