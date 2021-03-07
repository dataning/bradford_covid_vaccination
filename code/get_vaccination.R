pacman::p_load(tidyverse, data.table, workflowr, usethis, here,
               httr, rvest, stringr)

get_spreadsheets <- function(url){
           url %>% read_html() %>%
           html_nodes("a") %>%       # find all links
           html_attr("href") %>%
           str_subset("COVID-19-weekly") %>% 
           str_subset("\\.xls") %>%  # find those that end in xls/xlsx
           map(., ~ download(.x, destfile = file.path("data", basename(.x))))  # download them with their file name
}

link <- "https://www.england.nhs.uk/statistics/statistical-work-areas/covid-19-vaccinations/"
get_spreadsheets(link) 
