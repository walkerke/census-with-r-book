library(tidycensus)
library(shiny)
library(leaflet)
library(tidyverse)

census_api_key("YOUR KEY HERE")

twin_cities_race <- get_acs(
  geography = "tract",
  variables = c(
    hispanic = "DP05_0071P",
    white = "DP05_0077P",
    black = "DP05_0078P",
    native = "DP05_0079P",
    asian = "DP05_0080P"
  ),
  state = "MN",
  county = c("Hennepin", "Ramsey", "Anoka", "Washington",
             "Dakota", "Carver", "Scott"),
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
      leafletOutput("map", height = "600")
    )
  )
)

server <- function(input, output) {
  
  # Reactive function that filters for the selected group in the drop-down menu
  group_to_map <- reactive({
    filter(twin_cities_race, variable == input$group)
  })
  
  # Initialize the map object, centered on the Minneapolis-St. Paul area
  output$map <- renderLeaflet({

    leaflet() %>%
      addProviderTiles(providers$Stamen.TonerLite) %>%
      setView(lng = -93.21,
              lat = 44.98,
              zoom = 8.5)

  })
  
  observeEvent(input$group, {
    
    pal <- colorNumeric("viridis", group_to_map()$estimate)
    
    leafletProxy("map") %>%
      clearShapes() %>%
      clearControls() %>%
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

