#### Preamble ####
# Purpose: Downloads and saves the data from [...UPDATE THIS...]
# Author: Krishiv Jain, Julia Kim, Abbass Sleiman
# Date: 12 February 2024
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]


#### Workspace setup ####
library(haven)
library(tidyverse)
library(arrow)


#### DATASETS FOR FIGURE 2 ####

## Download Data sets ##

zip_file <- "/Users/krishiv/Documents/New Folder STA302/nces_district_enrollment_2018_2020.csv.zip"
# Unzip the file
data <- unzip(zip_file)
race_data <- read_csv(data[1], col_types = cols())

broadband_data <-
  read_csv(
    file = "data/raw_data/broadband_data_2020October.csv",
    show_col_types = FALSE
  )

shares_data <-
  read_csv(
    file = "data/raw_data/District_Overall_Shares.csv",
    show_col_types = FALSE
  )

county_district_data <-
  read_dta(
    file = "data/raw_data/nces_district_directory_2018.dta",
  )

#### DATASETS FOR FIGURE 3 ####

## Download Data ##
test_scores_data <- read_dta(here::here("data/raw_data/scores_lm_demographics.dta"))

## Save data ##
write_csv(test_scores_data, "data/raw_data/scores_lm_demographics.csv")