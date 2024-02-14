#### Preamble ####
# Purpose: Simulates 3 data sets 
# Author: Krishiv Jain, Julia Kim, Abbass Sleiman
# Date: 14 February 2024
# Contact: krishiv.jain@mail.utoronto.ca, abbass.sleiman@mail.utoronto.ca, juliaym.kim@mail.utoronto.ca
# License: MIT
# Pre-requisites: none

#### Workspace setup ####
library(tidyverse)

#### SIMULATE DATA ####

set.seed(555) #random seed

## DATASET 1 ##

# Define the countries and their respective regions
countries <- c("USA", "UK", "Germany", "South Korea", "Ethiopia")
regions <- c("North America", "Europe and Central Asia", "Europe and Central Asia", "East Asia and Pacific", "Sub-Saharan Africa")

# Create a data frame to store the simulated data
simulated_data1 <- data.frame(
  country = character(),
  region = character(),
  date = as.Date(character()),
  covid_tracker_score = integer()
)

# Generate random dates between March 1st and December 31st, 2020
start_date <- as.Date("2020-03-01")
end_date <- as.Date("2020-12-31")
all_dates <- seq(start_date, end_date, by = "day")

# For each country, generate 10 unique random dates and assign covid tracker scores
for (i in seq_along(countries)) {
  country_dates <- sample(all_dates, size = 10, replace = FALSE)
  country <- rep(countries[i], length(country_dates))
  region <- rep(regions[i], length(country_dates))
  covid_tracker_score <- sample(0:3, size = length(country_dates), replace = TRUE)
  
  # Append the data to the simulated data frame
  simulated_data1 <- bind_rows(simulated_data1, data.frame(country, region, date = country_dates, covid_tracker_score))
}

### TESTS ###

# Check that the covid score is a value between 0 and 3 inclusive
simulated_data1$covid_tracker_score |> min() >= 0
simulated_data1$covid_tracker_score |> max() <= 3

# Check that there are 5 countries present in the dataset
test_country1 <- simulated_data1$country %in% c("USA", "UK", "Germany", "South Korea", "Ethiopia")
all(test_country)

# Verify that each column type is as it should
simulated_data1$country |> class() == "character"
simulated_data1$region |> class() == "character"
simulated_data1$date |> class() == "Date"
simulated_data1$covid_tracker_score |> class() == "integer"

## DATASET 2 - local characteristics for districts ##

simulated_data2 <-  
  tibble(
    state = paste("State", rep(1:50, each = 5)),
    district = paste("District", rep(1:5, times = 50)),    
    virtual_days = round(runif(250, min = 0, max = 180)),
    white_students = round(runif(250, min = 0, max = 5000)),
    black_students = round(runif(250, min = 0, max = 5000)), 
    broadband_usage = runif(250, min = 0, max = 1))

### TESTS ###

##Check the minimum number is equal, or greater than, 0 ##
#Based on: https://tellingstorieswithdata.com/02-drinking_from_a_fire_hose.html#simulate
simulated_data2$virtual_days |> min() >= 0
simulated_data2$white_students |> min() >= 0
simulated_data2$black_students |> min() >= 0
simulated_data2$broadband_usage |> min() >= 0

##Check the class of the column is numeric##
simulated_data2$virtual_days |> class() == "numeric"
simulated_data2$white_students |> class() == "numeric"
simulated_data2$black_students |> class() == "numeric"
simulated_data2$broadband_usage |> class() == "numeric"

## Check that the columns only have whole numbers ##
#Based on: https://stackoverflow.com/q/3476782/23271634
is.wholenumber <- function(x, tol = .Machine$double.eps^0.5) abs(x - round(x)) < tol
is.wholenumber(simulated_data2$white_students)
is.wholenumber(simulated_data2$black_students)

## DATASET 3 ##

# Define the number of schools
num_schools <- 1000

# Simulate data for each school
simulated_data3 <- data.frame(
  School_Number = 1:num_schools,
  share_in_person = runif(num_schools, min = 0, max = 1),  # Uniformly generate share of in-person learning
  change_in_test_score_percent = runif(num_schools, min = -10, max = 10),  # Uniformly generate change in test scores
  enrollment_white = sample(100:1000, num_schools, replace = TRUE),  # Randomly choose enrollment of White students
  enrollment_black = sample(100:1000, num_schools, replace = TRUE),  # Randomly choose enrollment of Black students
  enrollment_hispanic = sample(100:1000, num_schools, replace = TRUE)  # Randomly choose enrollment of Hispanic students
)

### TESTS ###

# Check that there are exactly 1000 schools present in the dataset
length(simulated_data3$School_Number) == 1000

# Check that share_in_person is between 0 and 1 inclusive
simulated_data3$share_in_person |> min() >= 0
simulated_data3$share_in_person |> max() <= 1

# Check that the change in test scores is between -10 and 10
simulated_data3$change_in_test_score_percent |> min() >= -10
simulated_data3$change_in_test_score_percent |> max() <= 10

# Check that the enrollment of each race of students is between 100 and 1000
simulated_data3$enrollment_white |> min() >= 100
simulated_data3$enrollment_white |> max() <= 1000

simulated_data3$enrollment_black |> min() >= 100
simulated_data3$enrollment_black |> max() <= 1000

simulated_data3$enrollment_hispanic |> min() >= 100
simulated_data3$enrollment_hispanic |> max() <= 1000