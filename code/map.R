pacman::p_load(tidyverse, data.table, here, sf, tmap, databradford)

df <- readRDS("data/vacc_Dec08_Feb28.rds") %>% 
  rename(one_dose = number_of_people_vaccinated_with_at_least_1_dose) %>% 
  select(msoa_code, msoa_name, one_dose)

glimpse(df)

msoa_map <- msoa() %>% select(msoa11cd)

glimpse(msoa_map)

msoa_map2 <- msoa_map %>% left_join(df, by = c("msoa11cd" = "msoa_code"))

# Check missing data by variables
naniar::gg_miss_var(msoa_map2)
