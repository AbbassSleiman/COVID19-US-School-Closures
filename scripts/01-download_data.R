#### Preamble ####
# Purpose: Downloads the required raw data to use in data cleaning
# Author: Krishiv Jain, Julia Kim, Abbass Sleiman
# Date: 14 February 2024
# Contact: krishiv.jain@mail.utoronto.ca, abbass.sleiman@mail.utoronto.ca, juliaym.kim@mail.utoronto.ca
# License: MIT
# Pre-requisites: Follow instructions in README to download data on race enrollment


#### Workspace setup ####
library(haven)
library(tidyverse)
library(arrow)


#### DATASETS FOR FIGURE 3 ####

## Download Data ##
test_scores_data <- read_dta(here::here("data/raw_data/scores_lm_demographics.dta"))

## Save data ##
write_csv(test_scores_data, "data/raw_data/scores_lm_demographics.csv")