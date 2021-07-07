#### Chapter 6 interactives + dot-density
library(tidycensus)
library(tidyverse)
library(leaflet)
library(mapview)
library(htmlwidgets)
library(tmap)
library(sf)

hennepin_race <- get_acs(
  geography = "tract",
  state = "MN",
  county = "Hennepin",
  variables = c(White = "B03002_003",
                Black = "B03002_004",
                Native = "B03002_005",
                Asian = "B03002_006",
                Hispanic = "B03002_012"),
  summary_var = "B03002_001",
  geometry = TRUE
) %>%
  mutate(percent = 100 * (estimate / summary_est))

groups <- unique(hennepin_race$variable)
hennepin_dots <- map_dfr(groups, ~{
  hennepin_race %>%
    filter(variable == .x) %>%
    st_transform(26915) %>%
    mutate(est200 = as.integer(estimate / 200)) %>%
    st_sample(size = .$est200, exact = TRUE) %>%
    st_sf() %>%
    mutate(group = .x)
}) %>%
  slice_sample(prop = 1)

td1 <- tm_shape(filter(hennepin_race, variable == "White")) + 
  tm_polygons(col = "white", border.col = "grey") + 
  tm_shape(hennepin_dots) +
  tm_dots(col = "group", palette = "Set1",
          size = 0.005)

tmap_save(td1, "img/hennepin_dots.png")



dallas_bachelors <- get_acs(
  geography = "tract",
  variables = "DP02_0068P",
  year = 2019,
  state = "TX",
  county = "Dallas",
  geometry = TRUE
)

# mapviewOptions(fgb = FALSE)

m1 <- mapview(dallas_bachelors, zcol = "estimate")

saveWidget(m1@map, "img/leaflet/dallas_mapview.html")

tmap_mode("view")

tm1 <- tm_shape(dallas_bachelors) + 
  tm_fill(col = "estimate", palette = "magma",
          alpha = 0.5)

tmap_save(tm1, "img/leaflet/dallas_tmap.html")

library(leaflet)

pal <- colorNumeric(
  palette = "magma",
  domain = dallas_bachelors$estimate
)

pal(c(10, 20, 30, 40, 50))

l1 <- leaflet() %>%
  addProviderTiles(providers$Stamen.TonerLite) %>%
  addPolygons(data = dallas_bachelors,
              color = ~pal(estimate),
              weight = 0.5,
              smoothFactor = 0.2,
              fillOpacity = 0.5,
              label = ~estimate) %>%
  addLegend(
    position = "bottomright",
    pal = pal,
    values = dallas_bachelors$estimate,
    title = "% with bachelor's<br/>degree"
  )

saveWidget(l1, "img/leaflet/dallas_leaflet.html")


us_value <- get_acs(
  geography = "state",
  variables = "B25077_001",
  year = 2019,
  survey = "acs1",
  geometry = TRUE,
  resolution = "20m"
)

us_pal <- colorNumeric(
  palette = "plasma",
  domain = us_value$estimate
)

l2 <- leaflet() %>%
  addProviderTiles(providers$Stamen.TonerLite) %>%
  addPolygons(data = us_value,
              color = ~us_pal(estimate),
              weight = 0.5,
              smoothFactor = 0.2,
              fillOpacity = 0.5,
              label = ~estimate) %>%
  addLegend(
    position = "bottomright",
    pal = us_pal,
    values = us_value$estimate,
    title = "Median home value"
  )

saveWidget(l2, "img/leaflet/us_leaflet.html")