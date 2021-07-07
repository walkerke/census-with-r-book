library(tigris)
library(purrr)
options(tigris_use_cache = TRUE)

my_counties <- c("015", "021", "037", "043", "111", "119", "147", "149", "159", "165", "169", "187", "189")

tn_rivers <- map(my_counties, ~{
  linear_water("TN", .x, class = "sf")
}) %>%
  rbind_tigris()

plot(tn_rivers$geometry)


library(tidyverse)

irs_data <- read_csv("https://www.irs.gov/pub/irs-soi/18zpallnoagi.csv")

cdc_data <- read_csv("https://data.cdc.gov/api/views/5h56-n989/rows.csv")