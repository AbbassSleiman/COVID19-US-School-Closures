#### Preamble ####
# Purpose: Downloads the required raw data to use in data cleaning
# Author: Krishiv Jain, Julia Kim, Abbass Sleiman
# Date: 14 February 2024
# Contact: krishiv.jain@mail.utoronto.ca, abbass.sleiman@mail.utoronto.ca, juliaym.kim@mail.utoronto.ca
# License: MIT
# Pre-requisites: In order to run this code, scores_lm_demographics.dta must be downloaded in advance.
# This can be done either by downloading the file directly from data/raw_data in this paper's repository,
# or by downloading directly from Jack and Oster's replication package at 
# https://www.openicpsr.org/openicpsr/project/193523/version/V1/view


#### Workspace setup ####
library(haven)
library(tidyverse)
library(arrow)


#### DATASETS FOR FIGURE 3 ####

## Download Data ##
test_scores_data <- read_dta(here::here("data/raw_data/scores_lm_demographics.dta"))

## Save data ##
write_csv(test_scores_data, "data/raw_data/scores_lm_demographics.csv")