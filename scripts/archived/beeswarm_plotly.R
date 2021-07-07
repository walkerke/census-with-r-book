library(tidycensus)
library(tidyverse)
library(tigris)
library(sf)
library(ggbeeswarm)
library(viridis)
library(extrafont)
library(plotly)
library(leaflet)
library(crosstalk)
options(tigris_use_cache = TRUE)

df <- get_acs(geography = "tract", state = "TX",   
              variables = c("B03002_012", "B03002_003", "B03002_004", "B03002_006", 
                            "B03002_007"), 
              summary_var = "B19013_001", geometry = TRUE) %>%
  mutate(variable = recode(variable, B03002_003 = "White", 
                           B03002_004 = "Black", 
                           B03002_006 = "Asian", 
                           B03002_012 = "Hispanic", 
                           B03002_007 = "Pacific Islander")) %>%
  group_by(GEOID) %>%
  filter(estimate == max(estimate, na.rm = TRUE)) %>%
  ungroup() %>%
  filter(estimate != 0)

metro <- core_based_statistical_areas(cb = TRUE, class = "sf") %>%
  filter(str_detect(NAME, "Austin-Round Rock"))

sub <- df[metro, op = st_within] %>%
  st_transform(4326)

sub$Income <- sub$summary_est

sub <- SharedData$new(sub, key = ~GEOID)

p <- ggplot(sub, aes(x = variable, y = summary_est, 
                     color = summary_est)) +
  geom_quasirandom(alpha = 0.75) + 
  coord_flip() + 
  theme_minimal(base_family = "Tahoma") + 
  scale_color_viridis(guide = FALSE) + 
  scale_y_continuous(labels = scales::dollar) + 
  labs(x = "Largest group in Census tract", 
       y = "Median household income", 
       title = "Household income distribution by largest racial/ethnic group, Austin, TX", 
       subtitle = "Census tracts, Austin metropolitan area", 
       caption = "Data source: 2012-2016 ACS")

gg <- ggplotly(p, tooltip = "Income") %>% 
  toWebGL() %>%
  layout(dragmode = "select") %>%
  highlight("plotly_selected")

map <- ggplot(sub, aes(fill = Income)) + 
  geom_sf() + 
  scale_fill_viridis() + 
  labs(fill = "Median h.h.\nincome")

maply <- ggplotly(map)

library(htmltools)
browsable(tagList(maply, gg))

browsable(
  tagList(list(
    tags$div(
      style = 'width:50%;display:block;float:left;',
      gg
    ),
    tags$div(
      style = 'width:50%;display:block;float:left;',
      maply
    )
  ))
)