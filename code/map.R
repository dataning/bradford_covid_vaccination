pacman::p_load(tidyverse, data.table, here, sf, tmap, databradford, readxl)

##%######################################################%##
#                                                          #
####                      Mapping                       ####
#                                                          #
##%######################################################%##

df <- readRDS("data/msoa_vacc_dec_feb.rds")
df_msoa <- msoa() %>% select(msoa11cd)

glimpse(df_msoa)

msoa_map <- df_msoa %>% 
  left_join(df, by = c("msoa11cd" = "msoa_code"))

# Check missing data by variables
naniar::gg_miss_var(msoa_map)
View(msoa_map)

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

tm_shape(msoa_map) +
  tm_polygons("rate", style ="cont", palette = "-inferno", n = 5,
              border.alpha = 0, 
              title = "Bradford Vaccination Rate by MSOA") +
  tm_style("cobalt") + 
  tm_text("msoa_names", remove.overlap = TRUE, size = 0.8) + 
  tm_layout(legend.outside = TRUE, 
            frame = FALSE, frame.lwd = NA)

tmap_save(p1, "bradford_vaccine_dec_feb.png", width = 1280, height = 915, asp = 0)


tm_shape(msoa_map) +
  tm_polygons("rate_65_69", style ="cont", palette = "-inferno",
              breaks = c(0, 0.2, 0.4, 0.6, 0.8, 1),
              border.alpha = 0) +
  tm_style("cobalt") + 
  tm_text("msoa_names", remove.overlap = TRUE, size = 0.8) + 
  tm_layout(legend.outside = TRUE, 
            frame = FALSE, frame.lwd = NA, panel.label.bg.color = NA)

tm_shape(msoa_map) +
  tm_polygons("rate_70_74", style ="cont", palette = "-inferno",
              breaks = c(0, 0.2, 0.4, 0.6, 0.8, 1),
              border.alpha = 0) +
  tm_text("msoa_names", remove.overlap = TRUE, size = 0.8) + 
  tm_layout(legend.outside = TRUE, 
            frame = FALSE, frame.lwd = NA, panel.label.bg.color = NA)

tm_shape(msoa_map) +
  tm_polygons("rate_75_79", style ="cont", palette = "-inferno",
              border.alpha = 0) +
  tm_text("msoa_names", remove.overlap = TRUE, size = 0.8) + 
  tm_layout(legend.outside = TRUE, 
            frame = FALSE, frame.lwd = NA, panel.label.bg.color = NA)

tm_shape(msoa_map) +
  tm_polygons("rate_80", style ="cont", palette = "-inferno",
              border.alpha = 0) +
  tm_text("msoa_names", remove.overlap = TRUE, size = 0.8) + 
  tm_layout(legend.outside = TRUE, 
            frame = FALSE, frame.lwd = NA, panel.label.bg.color = NA)
