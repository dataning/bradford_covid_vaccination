pacman::p_load(tidyverse, data.table, here, readxl)

##%######################################################%##
#                                                          #
####                Get vaccination data                ####
#                                                          #
##%######################################################%##

# Fix the location
source <- "data/COVID-19-weekly-announced-vaccinations-4-March-2021-1.xlsx"

# Find all the sheet names
readxl::excel_sheets(source)

# Read the sheet name 
df <- readxl::read_excel(source, "MSOA") %>% 
  janitor::clean_names() 

head(df, 15)

# Clean excel headers
df2 <- df %>% 
  slice(-c(1:9, 12:13)) %>% 
  rowid_to_column() %>% 
  mutate(rowid = sub("2", "1", rowid)) %>% 
  group_by(rowid) %>%
  summarise_all(na.omit) %>% 
  janitor::row_to_names(row_number = 1) %>% 
  janitor::clean_names() %>% 
  ungroup() %>% 
  select(-x1) %>% 
  slice(-1) %>% 
  rename(one_dose = number_of_people_vaccinated_with_at_least_1_dose,
         msoa_names = msoa_name) 

colnames(df2) <- sub("x", "dosed_", colnames(df2))
df2[7:11] <- df2[7:11] %>% mutate_if(is.character, as.numeric) 

df2 %>% arrange(one_dose)
glimpse(df2)

saveRDS(df2, "data/vacc_Dec08_Feb28.rds")

# Modify value
### df2$rowid[c(2)] <- 1

# Remove the first 9 rows
### df2 <- tail(df,-9)

##%######################################################%##
#                                                          #
####            Get local population weight             ####
#                                                          #
##%######################################################%##

# https://www.ons.gov.uk/peoplepopulationandcommunity/populationandmigration/populationestimates/datasets/middlesuperoutputareamidyearpopulationestimates

# Fix the location
source <- "/Users/goal/Downloads/temp_data/msoa_population_weight_2019.xlsx"

# Find all the sheet names
readxl::excel_sheets(source)

df_excel <- readxl::read_excel(source, "Mid-2019 Persons") %>% 
  janitor::clean_names() %>% 
  slice(-c(1:3)) %>% 
  janitor::row_to_names(row_number = 1) 

glimpse(df_excel)

colnames(df_excel)[8:98] <- paste("age", colnames(df_excel)[8:98], sep = "_")
df_excel <- df_excel %>% janitor::clean_names()
df_excel[7:98] <- df_excel[7:98] %>% mutate_if(is.character, as.numeric)
saveRDS(df_excel, "data/msoa_pop_weight.rds")

df_excel %>% arrange(all_ages)
glimpse(df_excel)

##%######################################################%##
#                                                          #
####          Combine dosed pop and local pop           ####
#                                                          #
##%######################################################%##

glimpse(df2)

grep("age_70", colnames(df_excel))
grep("age_79", colnames(df_excel))

df3 <- df2 %>% 
  left_join(df_excel) %>% 
  mutate(rate = one_dose/all_ages) %>% 
  rowwise() %>% 
  mutate(rate_65_69 = dosed_65_69/sum(c(73:77)),
         rate_70_74 = dosed_70_74/sum(c(78:82)),
         rate_75_79 = dosed_75_79/sum(c(83:87)),
         rate_80 = dosed_80/sum(c(88:98)))

glimpse(df3)

esquisse::esquisser()

saveRDS(df3, "data/msoa_vacc_dec_feb.rds")
