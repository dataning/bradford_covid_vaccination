pacman::p_load(tidyverse, data.table, workflowr, usethis, here,
               httr, jsonlite, rvest, stringr)
usethis::use_git()
usethis::use_github()
##%######################################################%##
#                                                          #
####                  Workflow set up                   ####
#                                                          #
##%######################################################%##

wflow_start(here(), existing = TRUE)

usethis::edit_file('code/read_data.R')

wflow_build()

wflow_publish(c("analysis/index.Rmd", 
                "analysis/about.Rmd", 
                "analysis/license.Rmd"), 
              "first_try")

##%######################################################%##
#                                                          #
####                  New beginning                     ####
#                                                          #
##%######################################################%##


wflow_open("analysis/data_job_findajob.Rmd")

usethis::edit_file('code/get_vaccination.R')

wflow_build()

wflow_publish(c("analysis/data_job_findajob.Rmd", 
                "code/data_job_findajob.R"), 
              "first_try")

##%######################################################%##
#                                                          #
####                     Automation                     ####
#                                                          #
##%######################################################%##

usethis::edit_file('code/automation_runner.R')

##%######################################################%##
#                                                          #
####                    Git one line                    ####
#                                                          #
##%######################################################%##

git add . && git commit -a -m "commit" && git push