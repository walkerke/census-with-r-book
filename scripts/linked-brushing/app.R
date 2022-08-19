library(tidycensus)
library(tidyverse)
library(tigris)
library(sf)
library(spdep)
library(shiny)
library(ggiraph)
options(tigris_use_cache = TRUE)

# census_api_key("YOUR KEY HERE")

dfw <- core_based_statistical_areas(cb = TRUE, year = 2019) %>%
  filter(str_detect(NAME, "Dallas"))

dfw_tracts <- get_acs(
  geography = "tract",
  variables = "B01002_001",
  state = "TX",
  year = 2019,
  geometry = TRUE
) %>%
  st_filter(dfw, .predicate = st_within) %>%
  na.omit()

neighbors <- poly2nb(dfw_tracts, queen = TRUE)

weights <- nb2listw(neighbors, style = "W")

dfw_tracts$lag_estimate <- lag.listw(weights, dfw_tracts$estimate)

set.seed(1983)

dfw_tracts$scaled_estimate <- as.numeric(scale(dfw_tracts$estimate))

dfw_lisa <- localmoran_perm(dfw_tracts$scaled_estimate, weights, nsim = 999L, 
                            alternative = "two.sided") %>%
  as_tibble() %>%
  set_names(c("local_i", "exp_i", "var_i", "z_i", "p_i",
              "p_i_sim", "pi_sim_folded", "skewness", "kurtosis"))

dfw_lisa_df <- dfw_tracts %>%
  select(GEOID, scaled_estimate) %>%
  mutate(lagged_estimate = lag.listw(weights, scaled_estimate)) %>%
  bind_cols(dfw_lisa)

dfw_lisa_clusters <- dfw_lisa_df %>%
  mutate(lisa_cluster = case_when(
    p_i >= 0.05 ~ "Not significant",
    scaled_estimate > 0 & local_i > 0 ~ "High-high",
    scaled_estimate > 0 & local_i < 0 ~ "High-low",
    scaled_estimate < 0 & local_i > 0 ~ "Low-low",
    scaled_estimate < 0 & local_i < 0 ~ "Low-high"
  ))

color_values <- c(`High-high` = "red", 
                  `High-low` = "pink", 
                  `Low-low` = "blue", 
                  `Low-high` = "lightblue", 
                  `Not significant` = "white")

library(patchwork)

lisa_plot <- ggplot(dfw_lisa_clusters, aes(x = scaled_estimate, y = lagged_estimate,
                                           fill = lisa_cluster)) + 
  geom_point_interactive(aes(data_id = GEOID, tooltip = lisa_cluster), color = "black", shape = 21, size = 2) + 
  theme_minimal() + 
  geom_hline(yintercept = 0, linetype = "dashed") + 
  geom_vline(xintercept = 0, linetype = "dashed") + 
  scale_fill_manual(values = color_values) + 
  labs(x = "Median age (z-score)",
       y = "Spatial lag of median age (z-score)",
       fill = "Cluster type")

lisa_map <- ggplot(dfw_lisa_clusters, aes(fill = lisa_cluster)) + 
  geom_sf_interactive(aes(data_id = GEOID), size = 0.1) + 
  theme_void() + 
  scale_fill_manual(values = color_values) + 
  labs(fill = "Cluster type")


ui <- fluidPage(
  girafeOutput("plot")
)

server <- function(input, output) {
  output$plot <- renderGirafe({
    girafe(ggobj = lisa_plot + lisa_map, width_svg = 10, height_svg = 4, 
           options = list(opts_selection(type = "multiple", 
                                         css = "fill:cyan;"))) 
    })
}

shinyApp(ui = ui, server = server)