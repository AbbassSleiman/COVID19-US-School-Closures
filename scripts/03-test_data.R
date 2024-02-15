#### Preamble ####
# Purpose: Testing our data sets 
# Author: Krishiv Jain, Julia Kim, Abbass Sleiman
# Date: 12 February 2024
# Contact: krishiv.jain@mail.utoronto.ca, abbass.sleiman@mail.utoronto.ca, juliaym.kim@mail.utoronto.ca
# License: MIT
# Pre-requisites: Downloaded the data files through 01-download_data.R and through the instructions in the README


#### Workspace setup ####
library(tidyverse)
library(here)

#### Read Data ####
cleaned_region_data <- read_csv(here("data/analysis_data/cleaned_region_data.csv"))
cleaned_test_score_data <- read_csv(here("data/analysis_data/cleaned_test_score_data.csv"))

#### TESTING DATA FOR FIGURE ON REGIONS ####
# Check that there are exactly 185 unique countries present in the dataset
length(unique(cleaned_region_data$country_name)) == 185

# Check that there are exactly 7 regions to which a country can belong to
length(unique(cleaned_region_data$region_name)) == 7

# Check that there are exactly 731 unique days (2 years - 2020 was a leap year) in the dataset
length(unique(cleaned_region_data$date)) == 731

# Check that the covid scores are between 0 and 3 inclusive
cleaned_region_data$covid_score |> min() == 0
cleaned_region_data$covid_score |> max() == 3

# Verify that each column is of the appropriate class
cleaned_region_data$country_name |> class() == "character"
cleaned_region_data$region_name |> class() == "character"
cleaned_region_data$date |> class() == "Date"
cleaned_region_data$covid_score |> class() == "numeric"


#### TESTING DATA FOR FIGURE 2 ####

##Check the minimum number is equal, or greater than, 0 ##
#Based on: https://tellingstorieswithdata.com/02-drinking_from_a_fire_hose.html#simulate
final_broadband_data$`BROADBAND USAGE` |> min() >= 0

##Check the class of the column is numeric##
final_broadband_data$QUANTILE_LABEL |> class() == "character"
final_broadband_data$`BROADBAND USAGE` |> "numeric"

#### TESTING DATA FOR FIGURES ON TEST SCORES ####
# Check that there are exactly 21 unique states to which a school district can belong
length(unique(cleaned_test_score_data$state)) == 21

# Check that enrollment is a positive value
cleaned_test_score_data$enrollment |> min() >= 0

# Check that the changes in test pass rates are between -1 and 1 inclusive
na.omit(cleaned_test_score_data$change_2017_2018) |> min() >= -1
na.omit(cleaned_test_score_data$change_2017_2018) |> max() <= 1

na.omit(cleaned_test_score_data$change_2018_2019) |> min() >= -1
na.omit(cleaned_test_score_data$change_2018_2019) |> max() <= 1

na.omit(cleaned_test_score_data$change_2019_2021) |> min() >= -1
na.omit(cleaned_test_score_data$change_2019_2021) |> max() <= 1

# Check that the subject is exactly one of ELA or Math
unique(cleaned_test_score_data$subject) %in% c("Math", "ELA")

# Check that the share of in-person learning is between 0 and 1 inclusive
cleaned_test_score_data$share_inperson |> min() >= 0
cleaned_test_score_data$share_inperson |> max() <= 1

# Check that the share enrollment of each of the three races is between 0 and 1
cleaned_test_score_data$share_enroll_white |> min() >= 0
cleaned_test_score_data$share_enroll_white |> max() <= 1

cleaned_test_score_data$share_enroll_black |> min() >= 0
cleaned_test_score_data$share_enroll_black |> max() <= 1

cleaned_test_score_data$share_enroll_hispanic |> min() >= 0
cleaned_test_score_data$share_enroll_hispanic |> max() <= 1

