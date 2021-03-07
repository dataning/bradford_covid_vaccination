get_spreadsheets <- function(url){
  
  if (!requireNamespace("xfun")) install.packages("xfun")
  
  xfun::pkg_attach2("rvest", "purrr", "stringr", "downloader")
  
  dcat <- read_html(url) %>%
    html_nodes("a") %>%       # find all links
    html_attr("href") %>%     # get the url
    str_subset("\\.xls") %>%  # find those that end in xls/xlsx
    map(., ~download(.x, destfile = basename(.x)))  # download them with their file name
  
  return(dcat)
  
}

urls <- "https://www.england.nhs.uk/statistics/statistical-work-areas/bed-availability-and-occupancy/bed-data-day-only/"
get_spreadsheets(urls)

AandE <- "https://www.england.nhs.uk/statistics/statistical-work-areas/ae-waiting-times-and-activity/ae-attendances-and-emergency-admissions-"
Year <- list()
Year[[1]] <- "2019-20"
Year[[2]] <- "2018-19"
Year[[3]] <- "2017-18"
Year[[4]] <- "2016-17"
Year[[5]] <- "2015-16"
Year[[6]] <- "2014-15"
Year[[7]] <- "2013-14"
Year[[8]] <- "2012-13"
Year[[9]] <- "2011-12"
requests <- lapply(Year, function(x){as.list(paste0(urls, x))})
requests

urls <- "https://www.england.nhs.uk/statistics/statistical-work-areas/bed-availability-and-occupancy/bed-data-day-only/"
products <- c("2019-20", 
              "2018-19", 
              "2017-18", 
              "2016-17", 
              "2015-16", 
              "2014-15", 
              "2013-14", 
              "2012-13", 
              "2011-12")
requests <- lapply(products, function(x){as.list(paste0(urls, x))})
requests

get_spreadsheets(requests)


https://stackoverflow.com/questions/40666406/loop-across-multiple-urls-in-r-with-rvest

AandE_urls <- paste0(AandE, Y1)

AandE_urls

xfun::pkg_attach2("rvest", "purrr", "stringr", "downloader", "tidyverse")

head_link <- "https://www.england.nhs.uk/statistics/statistical-work-areas/ae-waiting-times-and-activity/"
tail_link <- c("ae-attendances-and-emergency-admissions-2019-20", 
               "ae-attendances-and-emergency-admissions-2018-19", 
               "ae-attendances-and-emergency-admissions-2017-18", 
               "statistical-work-areasae-waiting-times-and-activityae-attendances-and-emergency-admissions-2016-17", 
               "weekly-ae-sitreps-2014-15", 
               "weekly-ae-sitreps-2013-14", 
               "weekly-ae-sitreps-2012-13", 
               "weekly-ae-sitreps-2011-12", 
               "weekly-ae-sitreps-2010-11")

lapply(paste0(head_link, tail_link),
       function(url){
         url %>% read_html() %>% 
           html_nodes("a") %>% 
           html_attr("href") %>%
           str_subset("\\.xls") %>%  # find those that end in xls/xlsx
           map(., ~download(.x, destfile = basename(.x)))  # download them with their file name
       })
