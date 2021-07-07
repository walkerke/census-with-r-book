library(tidycensus)
library(tidyverse)
library(geofacet)
library(stringr)

df <- load_variables(2016, "acs1", cache = TRUE)

# Get the full table

age <- get_acs(geography = "state", year = 2016, 
               survey = "acs1", table = "B01001", 
               summary_var = "B01001_001") %>%
  mutate(variable = str_replace(variable, "B01001_0", "")) %>%
  filter(!variable %in% c("01", "02", "26"))

# Wrangle it
agegroups <- c("0-4", "5-9", "10-14", "15-19", "15-19", "20-24", "20-24", 
               "20-24", "25-29", "30-34", "35-39", "40-44", "45-49", "50-54", 
               "55-59", "60-64", "60-64", "65-69", "65-69", "70-74", "75-79", 
               "80-84", "85+")

agesex <- c(paste("Male", agegroups), 
            paste("Female", agegroups))

agefull <- rep(agesex, 52)

age$group <- agefull

age2 <- age %>%
  group_by(NAME, group) %>%
  mutate(group_est = sum(estimate)) %>%
  distinct(NAME, group, .keep_all = TRUE) %>%
  ungroup() %>%
  mutate(percent = 100 * (group_est / summary_est)) %>%
  select(name = NAME, group, percent) %>%
  separate(group, into = c("sex", "age"), sep = " ") %>%
  mutate(age = factor(age, levels = unique(age))) %>%
  filter(name != "Puerto Rico")

# Test plot for Alabama

al <- filter(age2, name == "Alabama")

al %>%
  ggplot(aes(x = age, fill = sex)) +
  geom_bar(data = filter(al, sex == "Female"), stat = "identity", 
           aes(y = percent)) + 
  geom_bar(data = filter(al, sex == "Male"), stat = "identity", 
           aes(y = -1 * percent)) + 
  scale_y_continuous(breaks=seq(-4,4,2),labels=paste0(abs(seq(-4,4,2)), "%")) + 
  coord_flip() + 
  theme_minimal() + 
  labs(x = "", y = "", fill = "")

# Test plot for geo_facet

ggplot(data = age2, aes(x = age, fill = sex)) +
  geom_bar(data = filter(age2, sex == "Female"), stat = "identity", 
           aes(y = percent), width = 1) + 
  geom_bar(data = filter(age2, sex == "Male"), stat = "identity", 
           aes(y = -1 * percent), width = 1) + 
  scale_y_continuous(breaks=c(-4, 0, 4),labels=c("4%", "0%", "4%")) + 
  coord_flip() + 
  theme_minimal() + 
  labs(x = "", y = "", fill = "") + 
  facet_geo(~ name) + 
  theme(axis.text.y = element_blank())


xlabs = c("0-4" = "0-4", "5-9" = "", "10-14" = "", "15-19" = "", "20-24" = "", 
          "25-29" = "", "30-34" = "", "35-39" = "", "40-44" = "", "45-49" = "", 
          "50-54" = "", "55-59" = "", "60-64" = "", "65-69" = "", "70-74" = "", 
          "75-79" = "", "80-84" = "", "85+" = "85+")

ggplot(data = age2, aes(x = age, fill = sex)) +
  geom_bar(data = filter(age2, sex == "Female"), stat = "identity", 
           aes(y = percent), width = 1) + 
  geom_bar(data = filter(age2, sex == "Male"), stat = "identity", 
           aes(y = -1 * percent), width = 1) + 
  scale_y_continuous(breaks=c(-4, 0, 4),labels=c("4%", "0%", "4%")) + 
  coord_flip() + 
  theme_minimal() + 
  scale_x_discrete(labels = xlabs) + 
  scale_fill_manual(values = c("red", "navy")) + 
  labs(x = "", y = "", fill = "", 
       title = "Demographic structure of Alabama counties", 
       caption = "Data source: 2011-2015 ACS.  Chart by @kyle_e_walker.") + 
  facet_wrap(~ name) 




# Counties

library(tidycensus)
library(tidyverse)
library(geofacet)
library(stringr)
library(extrafont)

age <- get_acs(geography = "county", state = "AL", table = "B01001", 
               summary_var = "B01001_001") %>%
  mutate(variable = str_replace(variable, "B01001_0", "")) %>%
  filter(!variable %in% c("01", "02", "26"))

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
  mutate(group_est = sum(estimate)) %>%
  distinct(NAME, group, .keep_all = TRUE) %>%
  ungroup() %>%
  mutate(percent = 100 * (group_est / summary_est), 
         NAME = str_replace(NAME, " County, Alabama", "")) %>%
  select(name = NAME, group, percent) %>%
  separate(group, into = c("sex", "age"), sep = " ") %>%
  mutate(age = factor(age, levels = unique(age)), 
         percent = ifelse(sex == "Female", percent, -percent)) 
  
xlabs = c("0-4" = "0-4", "5-9" = "", "10-14" = "", "15-19" = "", "20-24" = "", 
          "25-29" = "", "30-34" = "", "35-39" = "", "40-44" = "", "45-49" = "", 
          "50-54" = "", "55-59" = "", "60-64" = "", "65-69" = "", "70-74" = "", 
          "75-79" = "", "80-84" = "", "85+" = "85+")

mygrid <- data.frame(
  row = c(1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7, 7, 7, 8, 8, 8, 8, 8, 8, 8, 9, 9, 9, 9, 9, 9, 10, 10, 10, 10, 10, 11, 11, 11),
  col = c(3, 4, 5, 6, 3, 2, 4, 5, 6, 7, 2, 3, 4, 5, 6, 7, 2, 3, 5, 6, 7, 8, 4, 2, 3, 4, 6, 7, 8, 5, 1, 2, 3, 5, 6, 7, 8, 4, 1, 2, 3, 5, 6, 7, 8, 4, 1, 2, 5, 6, 7, 4, 3, 2, 5, 6, 4, 7, 3, 4, 5, 2, 3, 6, 5, 2, 1),
  code = c("Lauderdale", "Limestone", "Madison", "Jackson", "Colbert", "Franklin", "Lawrence", "Morgan", "Marshall", "DeKalb", "Marion", "Winston", "Cullman", "Blount", "Etowah", "Cherokee", "Lamar", "Fayette", "Jefferson", "St. Clair", "Calhoun", "Cleburne", "Walker", "Pickens", "Tuscaloosa", "Bibb", "Talladega", "Clay", "Randolph", "Shelby", "Sumter", "Greene", "Hale", "Chilton", "Coosa", "Tallapoosa", "Chambers", "Perry", "Choctaw", "Marengo", "Wilcox", "Autauga", "Elmore", "Macon", "Lee", "Dallas", "Washington", "Clarke", "Montgomery", "Bullock", "Russell", "Lowndes", "Butler", "Monroe", "Pike", "Barbour", "Crenshaw", "Henry", "Conecuh", "Coffee", "Dale", "Escambia", "Covington", "Houston", "Geneva", "Baldwin", "Mobile"),
  name = c("Lauderdale", "Limestone", "Madison", "Jackson", "Colbert", "Franklin", "Lawrence", "Morgan", "Marshall", "DeKalb", "Marion", "Winston", "Cullman", "Blount", "Etowah", "Cherokee", "Lamar", "Fayette", "Jefferson", "St. Clair", "Calhoun", "Cleburne", "Walker", "Pickens", "Tuscaloosa", "Bibb", "Talladega", "Clay", "Randolph", "Shelby", "Sumter", "Greene", "Hale", "Chilton", "Coosa", "Tallapoosa", "Chambers", "Perry", "Choctaw", "Marengo", "Wilcox", "Autauga", "Elmore", "Macon", "Lee", "Dallas", "Washington", "Clarke", "Montgomery", "Bullock", "Russell", "Lowndes", "Butler", "Monroe", "Pike", "Barbour", "Crenshaw", "Henry", "Conecuh", "Coffee", "Dale", "Escambia", "Covington", "Houston", "Geneva", "Baldwin", "Mobile"),
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
       title = "Demographic structure of Alabama counties", 
       caption = "Data source: 2011-2015 ACS.  Chart by @kyle_e_walker.") + 
  facet_geo(~ name, grid = mygrid) 

ggsave("plots/alabama.png", height = 12, width = 10)

geofacet::grid_preview(mygrid)




# Texas

library(tidycensus)
library(tidyverse)
library(geofacet)
library(stringr)
library(extrafont)

age <- get_acs(geography = "county", state = "AZ", table = "B01001", 
               summary_var = "B01001_001") %>%
  mutate(variable = str_replace(variable, "B01001_0", "")) %>%
  filter(!variable %in% c("01", "02", "26"))

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
  mutate(group_est = sum(estimate)) %>%
  distinct(NAME, group, .keep_all = TRUE) %>%
  ungroup() %>%
  mutate(percent = 100 * (group_est / summary_est), 
         NAME = str_replace(NAME, " County, Texas", "")) %>%
  select(name = NAME, group, percent) %>%
  separate(group, into = c("sex", "age"), sep = " ") %>%
  mutate(age = factor(age, levels = unique(age)), 
         percent = ifelse(sex == "Female", percent, -percent)) 

xlabs = c("0-4" = "0-4", "5-9" = "", "10-14" = "", "15-19" = "", "20-24" = "", 
          "25-29" = "", "30-34" = "", "35-39" = "", "40-44" = "", "45-49" = "", 
          "50-54" = "", "55-59" = "", "60-64" = "", "65-69" = "", "70-74" = "", 
          "75-79" = "", "80-84" = "", "85+" = "85+")

# mygrid <- data.frame(
#   row = c(1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 4, 4, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6, 7, 7, 7, 7, 7, 7, 7, 7, 8, 8, 8, 8, 8, 8, 8, 9, 9, 9, 9, 9, 9, 10, 10, 10, 10, 10, 11, 11, 11),
#   col = c(3, 4, 5, 6, 3, 2, 4, 5, 6, 7, 2, 3, 4, 5, 6, 7, 2, 3, 5, 6, 7, 8, 4, 2, 3, 4, 6, 7, 8, 5, 1, 2, 3, 5, 6, 7, 8, 4, 1, 2, 3, 5, 6, 7, 8, 4, 1, 2, 5, 6, 7, 4, 3, 2, 5, 6, 4, 7, 3, 4, 5, 2, 3, 6, 5, 2, 1),
#   code = c("Lauderdale", "Limestone", "Madison", "Jackson", "Colbert", "Franklin", "Lawrence", "Morgan", "Marshall", "DeKalb", "Marion", "Winston", "Cullman", "Blount", "Etowah", "Cherokee", "Lamar", "Fayette", "Jefferson", "St. Clair", "Calhoun", "Cleburne", "Walker", "Pickens", "Tuscaloosa", "Bibb", "Talladega", "Clay", "Randolph", "Shelby", "Sumter", "Greene", "Hale", "Chilton", "Coosa", "Tallapoosa", "Chambers", "Perry", "Choctaw", "Marengo", "Wilcox", "Autauga", "Elmore", "Macon", "Lee", "Dallas", "Washington", "Clarke", "Montgomery", "Bullock", "Russell", "Lowndes", "Butler", "Monroe", "Pike", "Barbour", "Crenshaw", "Henry", "Conecuh", "Coffee", "Dale", "Escambia", "Covington", "Houston", "Geneva", "Baldwin", "Mobile"),
#   name = c("Lauderdale", "Limestone", "Madison", "Jackson", "Colbert", "Franklin", "Lawrence", "Morgan", "Marshall", "DeKalb", "Marion", "Winston", "Cullman", "Blount", "Etowah", "Cherokee", "Lamar", "Fayette", "Jefferson", "St. Clair", "Calhoun", "Cleburne", "Walker", "Pickens", "Tuscaloosa", "Bibb", "Talladega", "Clay", "Randolph", "Shelby", "Sumter", "Greene", "Hale", "Chilton", "Coosa", "Tallapoosa", "Chambers", "Perry", "Choctaw", "Marengo", "Wilcox", "Autauga", "Elmore", "Macon", "Lee", "Dallas", "Washington", "Clarke", "Montgomery", "Bullock", "Russell", "Lowndes", "Butler", "Monroe", "Pike", "Barbour", "Crenshaw", "Henry", "Conecuh", "Coffee", "Dale", "Escambia", "Covington", "Houston", "Geneva", "Baldwin", "Mobile"),
#   stringsAsFactors = FALSE
# )

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
       title = "Demographic structure of Texas counties", 
       caption = "Data source: 2011-2015 ACS.  Chart by @kyle_e_walker.") + 
  facet_wrap(~ name) 

ggsave("plots/alabama.png", height = 12, width = 10)