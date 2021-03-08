pacman::p_load(tidyverse, data.table, here, readxl)

##%######################################################%##
#                                                          #
####                   Load one file                    ####
#                                                          #
##%######################################################%##

# Fix the location
source <- "data/COVID-19-weekly-announced-vaccinations-4-March-2021-1.xlsx"

# Find all the sheet names
readxl::excel_sheets(source)

# Read the sheet name 
df <- readxl::read_excel(source, "MSOA") %>% 
  janitor::clean_names()

# Remove the first 9 rows
df2 <- tail(df,-9) %>% rowid_to_column()
head(df2, 10)

df2 %>%
  group_by(rowid) %>%
  summarise_all(na.omit)

df2 %>%
  group_by(rowid) %>%
  summarise_each(funs(sum(., na.rm = TRUE))) 

setDT(df2)[, lapply(.SD, na.omit), by = rowid]


df2 %>% 
  summarise_all(funs(trimws(paste(., collapse = ''))))

aggregate(.~name, df2[-1], FUN=function(x) paste(x[x!=''], collapse=', '))

sum_NA <- function(x) {if (all(is.na(x))) x[NA_integer_] else sum(x, na.rm = TRUE)}

df3 <- df2 %>% rowid_to_column()
df3[, lapply(.SD, paste0, collapse=""), by=rowid]

https://stackoverflow.com/questions/41068734/r-collapse-multiple-rows-into-1-row-same-columns

##%######################################################%##
#                                                          #
####                 Try to load bunch                  ####
#                                                          #
##%######################################################%##

excel_sheets <- readxl::excel_sheets(excel_source) 
print(excel_sheets)

files_to_read <- list.files(
  path = here::here("data"),        # directory to search within
  pattern = ".*xlsx$", # regex pattern, some explanation below
  recursive = TRUE,          # search subdirectories
  full.names = TRUE          # return the full path
)

read_vaccination <- function(x) {
  
  files_to_read <- list.files(
    path = here::here("data"),        # directory to search within
    pattern = ".*xlsx$", # regex pattern, some explanation below
    recursive = TRUE,          # search subdirectories
    full.names = TRUE          # return the full path
  )
  
  read_data <- function(z){
    dat <- readxl::read_xlsx(z, sheet = MSOA)
  }
  
  data.table::rbindlist(lapply(files_to_read, read_data))
  
}

df <- read_vaccination()


read_data <- function(z){
  dat <- data.table::fread(z, select = c(x), fill=TRUE)
}

files_to_read %>%
  purrr::map(function(sheet){ # iterate through each sheet name
    readxl::read_xlsx(path = excel_source, sheet = "MSOA")
  })

wb_sheets %>%
  purrr::map(function(sheet){ # iterate through each sheet name
    assign(x = sheet,
           value = readxl::read_xlsx(path = wb_source, sheet = sheet),
           envir = .GlobalEnv)
  })

data.table::rbindlist(lapply(files_to_read, read_data))
