library(tidycensus)
library(shiny)
library(leaflet)
library(tidyverse)

hennepin_race <- get_acs(
  geography = "tract",
  variables = c(
    hispanic = "DP05_0071P",
    white = "DP05_0077P",
    black = "DP05_0078P",
    native = "DP05_0079P",
    asian = "DP05_0080P"
  ),
  state = "MN",
  county = "Hennepin",
  geometry = TRUE
) 

groups <- c("Hispanic" = "hispanic",
            "White" = "white",
            "Black" = "black",
            "Native American" = "native",
            "Asian" = "asian")

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "group",
        label = "Select a group to map",
        choices = groups
      )
    ),
    mainPanel(
      leafletOutput("map")
    )
  )
)

server <- function(input, output) {
  
  group_to_map <- reactive({
    filter(hennepin_race, variable == input$group)
  })
  
  output$map <- renderLeaflet({
    
    pal <- colorNumeric("viridis", group_to_map()$estimate)
    
    leaflet() %>%
      addProviderTiles(providers$Stamen.TonerLite) %>%
      addPolygons(data = group_to_map(),
                  color = ~pal(estimate),
                  weight = 0.5,
                  fillOpacity = 0.5,
                  smoothFactor = 0.2,
                  label = ~estimate) %>%
      addLegend(
        position = "bottomright",
        pal = pal,
        values = group_to_map()$estimate,
        title = "% of population"
      )
      
  })
  
}

shinyApp(ui = ui, server = server)

