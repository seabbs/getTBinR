library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(shinycssloaders)
library(plotly)
library(magrittr)
library(dplyr)
library(tibble)
library(getTBinR)


sidebar <- dashboardSidebar(disable = TRUE)

body <- dashboardBody(
  fluidPage(
    fluidRow(
      column(width = 7,
             box(width = NULL,
                 title = "Map of Global Burden", 
                 solidHeader = FALSE,
                 dropdownButton(
                   uiOutput("select_metric"),
                   uiOutput("select_year"),
                   circle = FALSE, icon = icon("gear"), size = "sm",
                   width = "400px", tooltip = tooltipOptions(title = "Dashboard options")
                 ),
                 plotlyOutput("map_tb_burden",  width = "100%", height = "360px") %>% withSpinner(),
                 textOutput("country"), downloadButton("report", "Generate country report")
                 
             ),
             box(width = NULL,
                 title = "Trend over Time",
                 solidHeader = FALSE,
                 plotlyOutput("plot_country_metric", width = "95%", height = "360px") %>% withSpinner()
             )
      ),
      column(width = 5,
             tabBox(width = NULL,
                 title = "Regional Comparision",
                 side = "right",
                 tabPanel(title = "Overview",
                          plotlyOutput("plot_region_com", width = "95%", height = "885px") %>% withSpinner()
                          ),
                 tabPanel(title = "Trend over time",
                          plotlyOutput("plot_region_trend", width = "95%", height = "885px") %>% withSpinner()
                 )
                
             )
      )
      
      
    )
  )
)



dashboardPage(
  dashboardHeader(title = helpText("Explore Global Tuberculosis: Powered by", 
                                   a("getTBinR", href = "https://www.samabbott.co.uk/getTBinR/"),
                                   ", and developed by ",
                                   a("Sam Abbott", href = "http://samabbott.co.uk")),
                  titleWidth = 800),
  sidebar,
  body,
  skin = "black"
)