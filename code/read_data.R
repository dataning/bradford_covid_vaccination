pacman::p_load(tidyverse, data.table, here, readxl, janitor)

https://dominicroye.github.io/en/2019/import-excel-sheets-with-r/
  
##%######################################################%##
#                                                          #
####                Get vaccination data                ####
#                                                          #
##%######################################################%##

# Get all the expected spreadsheets in the folder
files_to_read_new <- list.files(
  path = here("data"),        # directory to search within
  pattern = "*March.*xlsx$", # regex pattern, some explanation below
  recursive = TRUE,          # search subdirectories
  full.names = TRUE          # return the full path
)

files_to_read_new

# Get spreadsheet name 
excel_sheets(files_to_read_new[1])
excel_sheets(files_to_read_new[1])
excel_sheets(files_to_read_new[1])

sheets_to_keep <- "MSOA"

# Load all the MSOA sheet into one list
df_list <- map(files_to_read_new, function(x){  
  raw_data <- map_df(sheets_to_keep, ~ read_excel(x, sheet = .x))})
df_list

# Name the dataframes on the list
names(df_list) = gsub("COVID-19-weekly-announced-vaccinations-", "", basename(files_to_read_new))

# Cleaning all the dataframes on the list
df_list <- df_list %>% 
  map(slice, -c(1:9, 12:13)) %>% 
  map(~rowid_to_column(.x, "id")) %>% 
  map(~mutate(.x, id = sub("2", "1", id))) %>% 
  map(~group_by(.x, id)) %>% 
  map(~summarise_all(.x, na.omit)) %>% 
  map(~row_to_names(.x, row_number = 1)) %>% 
  map(~clean_names(.x)) %>%
  map(~ungroup(.x)) %>% 
  map(~select(.x, -x1)) %>% 
  map(~slice(.x, -1)) %>% 
  map(~rename(.x, one_dose = number_of_people_vaccinated_with_at_least_1_dose, 
              msoa_names = msoa_name))

### map(~mutate(.x, x1 = as.integer(x1))) - convert column type
### map(~arrange(.x, x1)) - sort by column 
### df <- map_df(files_to_read_new, function(x){  
###   raw_data <- map_df(sheets_to_keep, ~read_excel(x, sheet = .x)) 
###   return(raw_data)})

### read_multiple_excel <- function(path) {
###   path %>%
###     excel_sheets() %>% 
###     set_names() %>% 
###     map_df(read_excel, path = path, sheet = .x)
### }

### # Clean excel headers
### df2 <- df %>% 
###   slice(-c(1:9, 12:13)) %>% 
###   rowid_to_column() %>% 
###   mutate(rowid = sub("2", "1", rowid)) %>% 
###   group_by(rowid) %>%
###   summarise_all(na.omit) %>% 
###   janitor::row_to_names(row_number = 1) %>% 
###   janitor::clean_names() %>% 
###   ungroup() %>% 
###   select(-x1) %>% 
###   slice(-1) %>% 
###   rename(one_dose = number_of_people_vaccinated_with_at_least_1_dose,
###          msoa_names = msoa_name) 

# Add a column of dataframe names
df_list <- Map(cbind, df_list, souce = names(df_list))

# Combine the list
df <- rbindlist(df_list, fill=TRUE)
View(df)
glimpse(df)

# Clean column names
colnames(df) <- sub("x", "dosed_", colnames(df))
df <- df %>%  select(sort(names(.))) 
saveRDS(df, "data/vacc_msoa.rds")

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

df <- readRDS("data/vacc_msoa.rds")

naniar::gg_miss_var(df)

# Cleaning NA value
df$dosed_55_59 <- gsub("NA", "0", df$dosed_55_59)
df$dosed_60_64 <- gsub("NA", "0", df$dosed_60_64)
df[1:6] <- df[1:6] %>% mutate_if(is.character, as.integer)

glimpse(df)

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
