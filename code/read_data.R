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
  slice(-1)

saveRDS(df2, "data/vacc_Dec08_Feb28.rds")
head(df2, 10)

# Modify value
### df2$rowid[c(2)] <- 1

# Remove the first 9 rows
### df2 <- tail(df,-9)

##%######################################################%##
#                                                          #
####            Get local population weight             ####
#                                                          #
##%######################################################%##

df_excel <- readxl::read_excel(source, "Mid-2019 Persons") %>% 
  janitor::clean_names() %>% 
  slice(-c(1:3)) %>% 
  janitor::row_to_names(row_number = 1) 

colnames(df_excel)[8:98] <- paste("age", colnames(df2)[8:98], sep = "_")
df_excel <- df_excel %>% janitor::clean_names()
df_excel$all_ages <- as.integer(df_excel$all_ages)

df2 <- df %>% left_join(df_excel, by = "msoa_code") %>% 
  mutate(rate = one_dose/all_ages)

glimpse(df2)

saveRDS(df_excel, "data/msoa_pop_weight.rds")