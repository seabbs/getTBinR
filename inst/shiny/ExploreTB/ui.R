library(shiny)
library(shinydashboard)
library(shinyWidgets)
library(shinycssloaders)
library(plotly)
library(magrittr)
library(dplyr)
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
                 plotlyOutput("map_tb_burden",  width = "100%") %>% withSpinner()
                 
             ),
             box(width = NULL,
                 title = "Trend over Time",
                 solidHeader = FALSE,
                 plotlyOutput("plot_country_metric", width = "100%", height = "375px") %>% withSpinner()
             )
      ),
      column(width = 5,
             box(width = NULL,
                 title = "Regional Comparision",
                 solidHeader = FALSE,
                 plotlyOutput("plot_region_com", width = "100%", height = "890px") %>% withSpinner()
             )
      )
      
      
    )
  )
)



dashboardPage(
  dashboardHeader(title = "Explore Tuberculosis"),
  sidebar,
  body,
  skin = "black"
)