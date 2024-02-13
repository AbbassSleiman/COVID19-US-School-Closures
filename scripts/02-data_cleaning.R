#### Preamble ####
# Purpose: Cleans the raw plane data recorded by two observers..... [...UPDATE THIS...]
# Author: Rohan Alexander [...UPDATE THIS...]
# Date: 6 April 2023 [...UPDATE THIS...]
# Contact: rohan.alexander@utoronto.ca [...UPDATE THIS...]
# License: MIT
# Pre-requisites: [...UPDATE THIS...]
# Any other information needed? [...UPDATE THIS...]

#### Workspace setup ####
library(tidyverse)
library(data.table)

#### Clean region data ####
raw_region_data <- read_csv("data/raw_data/region_data.csv")
country_region_data <- read_csv("data/raw_data/country_region.csv")

cleaned_region_data <-
  raw_region_data |>
  janitor::clean_names() |>
  rename(
    covid_score = c1m_school_closing 
  ) |>
  mutate(date = ymd(date)) |>
  filter(year(date) != 2022) |>
  select(
    country_name,
    region_name,
    date,
    covid_score
  ) |>
  mutate(
    country_name = gsub("Faeroe Islands", "Faroe Islands", country_name)
  )

cleaned_region_data <- as.data.table(cleaned_region_data)
country_region_data <- as.data.table(country_region_data)

# Set keys for merging
setkey(cleaned_region_data, country_name)
setkey(country_region_data, country_name)

# Perform left join
cleaned_region_data <- country_region_data[cleaned_region_data, on = "country_name", nomatch = 0]

cleaned_region_data <- as.data.frame(cleaned_region_data)


#### Clean test score data ####
raw_test_score_data <- read_csv("data/raw_data/scores_lm_demographics.csv")

cleaned_test_score_data <- raw_test_score_data |>
  janitor::clean_names() |>
  select(
    share_inperson,
    subject,
    change_2019_2021,
    change_2018_2019,
    change_2017_2018,
    enrollment,
    share_enroll_white,
    share_enroll_black,
    share_enroll_hispanic
  )

#### Save data ####
fwrite(cleaned_region_data, "data/analysis_data/cleaned_region_data.csv", row.names = FALSE)
write_csv(cleaned_test_score_data, "data/analysis_data/cleaned_test_score_data.csv")
