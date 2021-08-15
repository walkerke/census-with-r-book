library(sf)
library(tidycensus)
library(tigris)
library(h3jsr)
library(tidyverse)

# Data layers, use Tarrant County
pop_density <- get_acs(
  geography = "tract",
  state = "TX",
  county = "Tarrant",
  variables = "B01001_001",
  geometry = TRUE,
  keep_geo_vars = TRUE
) %>%
  mutate(density = estimate / ALAND) %>%
  st_transform(32138)

tarrant_clipper <- st_union(pop_density)

# Roads
rds <- primary_secondary_roads("TX") %>%
  st_transform(32138) %>%
  st_crop(tarrant_clipper)

# Customers
grid <- st_make_grid(tarrant_clipper, cellsize = 5000, square = FALSE) %>%
  st_crop(tarrant_clipper) %>%
  st_sf()

customers <- st_sample(tarrant_clipper, 500) %>%
  st_sf()

# Graphic
library(ggplot2)
library(patchwork)

sm <- matrix(c(2, 1.2, 0, 1), 2, 2)

geo_tilt <- pop_density
geo_tilt$geometry <- geo_tilt$geometry * sm
st_crs(geo_tilt) <- st_crs(pop_density)

p1 <- ggplot(geo_tilt, aes(fill = density, color = density)) + 
  geom_sf(show.legend = FALSE) + 
  scale_fill_distiller(palette = "Greens") + 
  scale_color_distiller(palette = "Greens") + 
  theme_void()

grid_tilt <- grid %>% st_transform(st_crs(pop_density))
grid_tilt$geometry <- grid_tilt$geometry * sm
st_crs(grid_tilt) <- st_crs(pop_density)

customers_tilt <- customers %>%
  st_transform(st_crs(pop_density))

customers_tilt$geometry <- customers_tilt$geometry * sm
st_crs(customers_tilt) <- st_crs(pop_density)


p2 <- ggplot() + 
  geom_sf(data = grid_tilt, show.legend = FALSE, color = "grey20", fill = "white") + 
  geom_sf(data = customers_tilt, color = "red") + 
  theme_void()

roads_tilt <- rds %>% st_transform(st_crs(pop_density))
roads_tilt$geometry <- roads_tilt$geometry * sm
st_crs(roads_tilt) <- st_crs(pop_density)

p3 <- ggplot(roads_tilt) + 
  geom_sf(show.legend = FALSE) + 
  scale_fill_viridis_c() + 
  theme_void()

p2 / p3 / p1



# Land use
library(stars)
library(raster)
library(tidyverse)

nlcd_path <- "~/data/NLCD_2016_Land_Cover_L48_20190424.img"

nlcd <- raster(nlcd_path) 

raster_clip <- st_transform(tarrant_clipper, st_crs(nlcd)) %>%
  st_sf()

nlcd_crop <- crop(nlcd, raster_clip) %>%
  st_as_stars() %>%
  st_as_sf()

x = -141.25
color = 'gray40'

temp1 <- ggplot() +
  
  # terrain
  geom_sf(data = nlcd_crop %>% rotate_data(), aes(fill=NLCD_2016_Land_Cover_L48_20190424), color=NA, show.legend = FALSE) +
  scale_fill_distiller(palette = "YlOrRd", direction = 1) +
  annotate("text", label='Terrain', x=x, y= -8.0, hjust = 0, color=color) +
  labs(caption = "image by @UrbanDemog")