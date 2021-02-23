library(tidycensus)
library(tidyverse)
library(srvyr)
library(ggridges)

View(pums_variables)

age_marst <- get_pums(
  variables = c(
    "PUMA", "AGEP", "SEX", "MARHM", "MARHT"
  ),
  state = "all",
  survey = "acs5",
  recode = TRUE
)

write_rds(age_marst, "data/age_marst.rds")

age_marst <- read_rds("data/age_marst.rds")

marriage_age <- age_marst %>%
  filter(MARHM == "1", MARHT == "1") %>%
  uncount(weights = PWGTP) %>%
  group_by(ST_label, SEX_label) %>%
  summarize(
    mdn_age = median(AGEP, na.rm = TRUE)
  )

marriage_age_pct <- age_marst %>%
  filter(MARHM == "1", MARHT == "1") %>%
  uncount(weights = PWGTP) %>%
  group_by(ST_label, SEX_label, AGEP) %>%
  summarize(n_age = n()) %>%
  group_by(ST_label, SEX_label) %>%
  mutate(prop_age = n_age / sum(n_age)) %>%
  ungroup()

merged_age_male <- marriage_age_pct %>%
  left_join(marriage_age, by = c("ST_label", "SEX_label")) %>%
  filter(SEX_label == "Female") %>%
  arrange(mdn_age)

ggplot(merged_age_male, aes(x = AGEP, y = reorder(ST_label, mdn_age))) + 
  geom_density_ridges(scale = 4)

# Identify median age for first-time married people by state
# marriage_age <- age_marst %>%
#   to_survey(design = "cluster") %>%
#   filter(MARHM == "1", MARHT == "1") %>%
#   group_by(ST_label, SEX_label) %>%
#   summarize(
#     mdn_age = survey_median("AGEP")
#   )
#   