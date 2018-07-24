# devtools::install_github("walkerke/tidycensus")
library(tidycensus)
library(tidyverse)
library(geofacet)
library(stringr)
library(extrafont)

# 2010 Census

age <- get_decennial(geography = "county", state = "AZ", table = "P012", 
                     summary_var = "P0010001") %>%
  mutate(variable = str_replace(variable, "P01200", "")) %>%
  filter(!variable %in% c("01", "02", "26")) %>%
  arrange(NAME, variable)


# Wrangle it
agegroups <- c("0-4", "5-9", "10-14", "15-19", "15-19", "20-24", "20-24", 
               "20-24", "25-29", "30-34", "35-39", "40-44", "45-49", "50-54", 
               "55-59", "60-64", "60-64", "65-69", "65-69", "70-74", "75-79", 
               "80-84", "85+")

agesex <- c(paste("Male", agegroups), 
            paste("Female", agegroups))

agefull <- rep(agesex, length(unique(age$NAME)))

age$group <- agefull

age2 <- age %>%
  group_by(NAME, group) %>%
  mutate(group_est = sum(value)) %>%
  distinct(NAME, group, .keep_all = TRUE) %>%
  ungroup() %>%
  mutate(percent = 100 * (group_est / summary_value), 
         NAME = str_replace(NAME, " County", "")) %>%
  select(name = NAME, group, percent) %>%
  separate(group, into = c("sex", "age"), sep = " ") %>%
  mutate(age = factor(age, levels = unique(age)), 
         percent = ifelse(sex == "Female", percent, -percent)) 

xlabs = c("0-4" = "0-4", "5-9" = "", "10-14" = "", "15-19" = "", "20-24" = "", 
          "25-29" = "", "30-34" = "", "35-39" = "", "40-44" = "", "45-49" = "", 
          "50-54" = "", "55-59" = "", "60-64" = "", "65-69" = "", "70-74" = "", 
          "75-79" = "", "80-84" = "", "85+" = "85+")

mygrid <- data.frame(
  row = c(1, 1, 1, 1, 2, 2, 2, 3, 3, 3, 3, 3, 4, 4, 4),
  col = c(1, 2, 3, 4, 1, 2, 3, 1, 2, 3, 4, 5, 2, 3, 4),
  code = c("Mohave", "Coconino", "Navajo", "Apache", "La Paz", "Yavapai", "Gila", "Yuma", "Maricopa", "Pinal", "Graham", "Greenlee", "Pima", "Santa Cruz", "Cochise"),
  name = c("Mohave", "Coconino", "Navajo", "Apache", "La Paz", "Yavapai", "Gila", "Yuma", "Maricopa", "Pinal", "Graham", "Greenlee", "Pima", "Santa Cruz", "Cochise"),
  stringsAsFactors = FALSE
)

ggplot(data = age2, aes(x = age, y = percent, fill = sex)) +
  geom_bar(stat = "identity", width = 1) + 
  scale_y_continuous(breaks=c(-5, 0, 5),labels=c("5%", "0%", "5%")) + 
  coord_flip() + 
  theme_minimal(base_family = "Tahoma") + 
  scale_x_discrete(labels = xlabs) + 
  scale_fill_manual(values = c("red", "navy")) + 
  theme(panel.grid.major = element_blank(), 
        panel.grid.minor = element_blank()) + 
  labs(x = "", y = "", fill = "", 
       title = "Demographic structure of Arizona counties", 
       caption = "Data source: 2010 US Census, tidycensus R package.  Chart by @kyle_e_walker.") + 
  facet_geo(~ name, grid = mygrid) 

ggsave("plots/arizona.png", dpi = 300, width = 8, height = 8)