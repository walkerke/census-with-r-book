#### Chapter 5 interactives
library(tigris)
library(mapview)
library(sf)
library(tidyverse)

la_tracts <- tracts("NM", "Los Alamos")

l1 <- mapview(la_tracts)

htmlwidgets::saveWidget(l1@map, "img/leaflet/la_tracts.html")

fl_counties <- counties("FL", cb = TRUE)

fl_projected <- sf::st_transform(fl_counties, crs = 3087)

lee <- fl_projected %>%
  filter(NAME == "Lee")

lee1 <- mapview(lee)

htmlwidgets::saveWidget(lee1@map, "img/leaflet/lee_county.html")

lee_singlepart <- st_cast(lee, "POLYGON")

sanibel <- lee_singlepart[2,]

san1 <- mapview(sanibel)

htmlwidgets::saveWidget(san1@map, "img/leaflet/sanibel.html")


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
    mutate(est100 = as.integer(estimate / 100)) %>%
    st_sample(size = .$est100, exact = TRUE) %>%
    st_sf() %>%
    mutate(group = .x)
}) %>%
  slice_sample(prop = 1)

background_tracts <- filter(hennepin_race, variable == "White")

td1 <- tm_shape(background_tracts, 
                projection = sf::st_crs(26915)) + 
  tm_polygons(col = "white", 
              border.col = "grey") + 
  tm_shape(hennepin_dots) +
  tm_dots(col = "group", 
          palette = "Set1",
          size = 0.005, 
          title = "Race/ethnicity")

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

# Chapter 12
library(cancensus)
library(tidyverse)
options(cancensus.api_key = Sys.getenv("CANCENSUS_API_KEY"))

montreal_english <- get_census(
  dataset = "CA16",
  regions = list(CMA = "24462"),
  vectors = "v_CA16_1364",
  level = "CT",
  geo_format = "sf",
  labels = "short"
) 

library(tmap)
tmap_mode("view")

montreal_pct <- montreal_english %>%
  mutate(pct_english = 100 * (v_CA16_1364 / Population))

c1 <- tm_shape(montreal_pct) + 
  tm_polygons(
    col = "pct_english", 
    alpha = 0.5, 
    palette = "viridis",
    style = "jenks", 
    n = 7, 
    title = "Percent speaking<br/>English at home"
  )

tmap_save(c1, "img/leaflet/montreal_english.html")