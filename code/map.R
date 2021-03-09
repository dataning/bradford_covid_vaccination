pacman::p_load(tidyverse, data.table, here, sf, tmap, databradford, readxl)

df <- readRDS("data/vacc_Dec08_Feb28.rds") %>% 
  rename(one_dose = number_of_people_vaccinated_with_at_least_1_dose) %>% 
  select(msoa_code, msoa_name, one_dose)

# Fix the location
source <- "data/msoa_population_weight.xlsx"

# Find all the sheet names
readxl::excel_sheets(source)

# Read the sheet name 
df_excel <- readxl::read_excel(source, "Mid-2019 Persons") %>% 
  janitor::clean_names() %>% 
  slice(-c(1:3)) %>% 
  janitor::row_to_names(row_number = 1) 

colnames(df_excel)[8:98] <- paste("age", colnames(df2)[8:98], sep = "_")
df_excel <- df_excel %>% janitor::clean_names()

head(df_excel, 15)
saveRDS(df_excel, "msoa_pop_weight.rds")

# Clean excel headers
df2 <- df_excel %>% 


saveRDS(df2, "vacc_Dec08_Feb28.rds")
head(df2, 10)

glimpse(df)

msoa_map <- msoa() %>% select(msoa11cd)

glimpse(msoa_map)

msoa_map2 <- msoa_map %>% left_join(df, by = c("msoa11cd" = "msoa_code"))

msoa_map2$one_dose <- as.integer(msoa_map2$one_dose)



# Check missing data by variables
naniar::gg_miss_var(msoa_map2)
glimpse(msoa_map2)

palette = "YlOrRd", n = 4, contrast = c(0, 1)
style ="cont", palette = "-inferno", n = 4, contrast = c(0, 0.5)
palette = "viridis", n = 4, contrast = c(0.57, 1)
palette = "Blues", n = 4, contrast = c(0.5, 1)
style ="cont", palette = "-RdYlGn"

pal <- brewer.pal(10, "Set3")[c(10, 8, 4, 5)]
Mypal <- c('#e6e6ea','#fed766','#2ab7ca','#fe4a49')
Mypal <- c('#64c5eb','#7f58af','#e84d8a','#feb326')
Mypal <- c('#64c5eb','#7f58af','#e84d8a','#feb326') # Good
Mypal <- c('#000000','#14213d','#fca311','#d90429') # Black
Mypal <- c('#000000','#fca311','#e5383b','#e71d36')
Mypal <- c('#000000','#fca311','#bf0603','#8d0801')

tm_shape(msoa_map2) +
  tm_polygons("one_dose", style ="cont", palette = "-inferno",
              border.alpha = 0) +
  tm_text("msoa_name", remove.overlap = TRUE, size = 0.8) + 
  tm_layout(legend.outside = TRUE, 
            frame = FALSE, frame.lwd = NA, panel.label.bg.color = NA)

