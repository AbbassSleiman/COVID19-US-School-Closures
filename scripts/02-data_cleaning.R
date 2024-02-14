#### Preamble ####
# Purpose: Cleans the various raw data sets that have been used prior to analysis and creation of figures
# Author: Krishiv Jain, Julia Kim, Abbass Sleiman
# Date: 14 February 2024
# Contact: krishiv.jain@mail.utoronto.ca, abbass.sleiman@mail.utoronto.ca, juliaym.kim@mail.utoronto.ca
# License: MIT
# Pre-requisites: run 01-download_data.R, and download the relevant data as outlined in the README. 

#### Workspace setup ####
library(tidyverse)
library(data.table)
library(janitor)
library(dplyr)
library(knitr)
library(here)
library(haven)
library(labelled)

#### FIGURE 1 DATA CLEANING - REGION DATA ####

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


#### FIGURE 2 DATA CLEANING - AVERAGE VIRTUAL DAYS BY CHARACTERISTIC ####

# CLEANING BROADBAND RAW DATA #

broadband_data <-
  read_csv(
    file = "data/raw_data/broadband_data_2020October.csv",
    show_col_types = FALSE
  )

broadband_data$`COUNTY ID` <- as.numeric(broadband_data$`COUNTY ID`)
broadband_data$`BROADBAND AVAILABILITY PER FCC` <- NULL
broadband_data$`BROADBAND USAGE` <- as.numeric(broadband_data$`BROADBAND USAGE`)

## Removing Rows with no data on broadband usage
broadband_data <- na.omit(broadband_data)

## Creating Quantiles 
broadband_data <- broadband_data |>
  group_by(ST) |>
  # Create a new column for quantiles of 'BROADBAND USAGE' variable
  mutate(QUANTILE = ntile(`BROADBAND USAGE`, 2)) %>%
  # Convert quantile groups to 'Low' and 'High'
  mutate(QUANTILE_LABEL = ifelse(QUANTILE == 1, "Low", "High"))

# CLEANING RACE SHARE RAW DATA #

## Read in the raw data ##

race_data <- read_dta(
  file = "/Users/krishiv/Documents/New Folder STA302/Raw/nces_district_enrollment_2018_2020.dta")

#Only keeping data for the year 2020, and for total for each race
race_data$grade <- as_factor(race_data$grade)
race_data$race <- as_factor(race_data$race)
race_data$year <- as_factor(race_data$year)

race_data <- subset(race_data, year == "2020")
race_data <- subset(race_data, grade == "Total")
race_data <- subset(race_data, race != "Total")
race_data$leaid <- as.numeric(race_data$leaid)

race_data <- race_data |>
  mutate(enrollment = replace_na(enrollment, 0))

#Summing sex to get total for each race
total_enrollment <- race_data |>
  group_by(fips, leaid, race) |>
  summarise(total_enrollment = sum(enrollment))

# Group by leaid and calculate the total enrollment
total_leaid_enrollment <- race_data |>
  group_by(leaid) |>
  summarise(total_leaid_enrollment = sum(enrollment, na.rm = TRUE))

# Join the total enrollment for each race with the total enrollment for each leaid
combined_data <- total_enrollment |>
  left_join(total_leaid_enrollment, by = "leaid")
# Calculate the percentage of total enrollment for each race
combined_data <- combined_data |>
  mutate(percentage = (total_enrollment / total_leaid_enrollment) * 100)


# White Share #
white_share <- combined_data[combined_data$race == "White", ]

## Creating Quantiles 
white_share <- white_share |>
  group_by(fips) |>
  # Create a new column for quantiles of 'BROADBAND USAGE' variable
  mutate(QUANTILE = ntile(percentage, 2)) %>%
  # Convert quantile groups to 'Low' and 'High'
  mutate(QUANTILE_LABEL = ifelse(QUANTILE == 1, "Low", "High"))


# Black Share #
black_share <- combined_data[combined_data$race == "Black", ]

## Creating Quantiles 
black_share <- black_share |>
  group_by(fips) |>
  # Create a new column for quantiles of 'BROADBAND USAGE' variable
  mutate(QUANTILE = ntile(percentage, 2)) %>%
  # Convert quantile groups to 'Low' and 'High'
  mutate(QUANTILE_LABEL = ifelse(QUANTILE == 1, "Low", "High"))

# Asian Share #
asian_share <- combined_data[combined_data$race == "Asian", ]

## Creating Quantiles 
asian_share <- asian_share |>
  group_by(fips) |>
  # Create a new column for quantiles of 'BROADBAND USAGE' variable
  mutate(QUANTILE = ntile(percentage, 2)) %>%
  # Convert quantile groups to 'Low' and 'High'
  mutate(QUANTILE_LABEL = ifelse(QUANTILE == 1, "Low", "High"))

# Hispanic Share #
hispanic_share <- combined_data[combined_data$race == "Hispanic", ]

## Creating Quantiles 
hispanic_share <- hispanic_share |>
  group_by(fips) |>
  # Create a new column for quantiles of 'BROADBAND USAGE' variable
  mutate(QUANTILE = ntile(percentage, 2)) %>%
  # Convert quantile groups to 'Low' and 'High'
  mutate(QUANTILE_LABEL = ifelse(QUANTILE == 1, "Low", "High"))

# CLEANING DISTRICT VIRTUAL DAYS DATA #

shares_data <-
  read_csv(
    file = "data/raw_data/District_Overall_Shares.csv",
    show_col_types = FALSE
  )

shares_data <- select(shares_data, NCESDistrictID, StateAbbrev, DistrictName, share_virtual)

shares_data$share_virtual <- shares_data$share_virtual * 180
shares_data$NCESDistrictID <- as.numeric(shares_data$NCESDistrictID)

# CLEANING DISTRICT AND COUNTY CLASSIFICATION DATA #

county_district_data <-
  read_dta(
    file = "data/raw_data/nces_district_directory_2018.dta",
  )

county_district_data <- select(county_district_data, leaid, county_code)
county_district_data$leaid <- as.numeric(county_district_data$leaid)

# AVERAGING DATA FOR COUNTIES #

## Combining the 2 datasets by martching their districtID
merged_data <- inner_join(shares_data, county_district_data, 
                          by = c("NCESDistrictID" = "leaid"))

merged_data <- select(merged_data, StateAbbrev, DistrictName, share_virtual, county_code)

averaged_data <- merged_data |>
  group_by(county_code) |>
  summarise(average_share_virtual = mean(share_virtual, na.rm = TRUE))

# AVERAGING BROADBAND DATA BASED ON QUANTILES #

final_broadband_data <- inner_join(averaged_data, broadband_data, 
                                   by = c("county_code" = "COUNTY ID"))

averaged_broadband <- final_broadband_data |>
  group_by(QUANTILE_LABEL) |>
  summarise(average = mean(average_share_virtual, na.rm = TRUE))

write_csv(averaged_broadband, "data/analysis_data/averaged_broadband.csv")

# AVERAGING RACE DATA BASED ON QUANTILES #

#White
white_share <- inner_join(shares_data, white_share, 
                          by = c("NCESDistrictID" = "leaid"))
averaged_white_share <- white_share |>
  group_by(QUANTILE_LABEL) |>
  summarise(average = mean(share_virtual, na.rm = TRUE))

averaged_white_share <- averaged_white_share |>
  filter(QUANTILE_LABEL != "NA")

write_csv(averaged_white_share, "data/analysis_data/averaged_white_share.csv")

#Black
black_share <- inner_join(shares_data, black_share, 
                          by = c("NCESDistrictID" = "leaid"))
averaged_black_share <- black_share |>
  group_by(QUANTILE_LABEL) |>
  summarise(average = mean(share_virtual, na.rm = TRUE))

averaged_black_share <- averaged_black_share |>
  filter(QUANTILE_LABEL != "NA")

write_csv(averaged_black_share, "data/analysis_data/averaged_black_share.csv")


#Asian
asian_share <- inner_join(shares_data, asian_share, 
                          by = c("NCESDistrictID" = "leaid"))
averaged_asian_share <- asian_share |>
  group_by(QUANTILE_LABEL) |>
  summarise(average = mean(share_virtual, na.rm = TRUE))

averaged_asian_share <- averaged_asian_share |>
  filter(QUANTILE_LABEL != "NA")

write_csv(averaged_asian_share, "data/analysis_data/averaged_asian_share.csv")

#Hispanic
hispanic_share <- inner_join(shares_data, hispanic_share, 
                             by = c("NCESDistrictID" = "leaid"))
averaged_hispanic_share <- hispanic_share |>
  group_by(QUANTILE_LABEL) |>
  summarise(average = mean(share_virtual, na.rm = TRUE))

averaged_hispanic_share <- averaged_hispanic_share |>
  filter(QUANTILE_LABEL != "NA")

write_csv(averaged_hispanic_share, "data/analysis_data/averaged_hispanic_share.csv")


#### FIGURE 3 DATA CLEANING - TEST SCORE DATA ####

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
    share_enroll_hispanic,
    state
  )

#### Save data ####
fwrite(cleaned_region_data, "data/analysis_data/cleaned_region_data.csv", row.names = FALSE)
write_csv(cleaned_test_score_data, "data/analysis_data/cleaned_test_score_data.csv")