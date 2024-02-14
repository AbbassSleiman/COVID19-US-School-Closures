#### Preamble ####
# Purpose: Simulates 3 data sets 
# Author: Krishiv Jain, Julia Kim, Abbass Sleiman
# Date: 12 February 2024
# Contact: krishiv.jain@mail.utoronto.ca, abbass.sleiman@mail.utoronto.ca, juliaym.kim@mail.utoronto.ca
# License: MIT
# Pre-requisites: none

#### Workspace setup ####
library(tidyverse)

#### SIMULATE DATA ####

set.seed(555) #random seed

## DATASET 1 ##






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

## Check that first and third columns only have whole numbers ##
#Based on: https://stackoverflow.com/q/3476782/23271634
is.wholenumber <- function(x, tol = .Machine$double.eps^0.5) abs(x - round(x)) < tol
is.wholenumber(simulated_data2$white_students)
is.wholenumber(simulated_data2$black_students)

