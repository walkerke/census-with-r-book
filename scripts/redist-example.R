library(redist)
library(dplyr)
library(ggplot2)
library(patchwork) # for plotting

data(iowa)

iowa_map = redist_map(iowa, existing_plan=cd_2010, pop_tol=0.0001, total_pop = pop)

set.seed(1983)
iowa_plans = redist_smc(iowa_map, nsims=250, verbose=FALSE)


redist.plot.plans(iowa_plans, draws=c("cd_2010", "1", "2", "3"),
                  geom=iowa_map)

library(sf)

fw_data <- sf::st_read("~/Dropbox/Research/tx2020/data-raw/POL_VOTER_PRECINCTS.shp")