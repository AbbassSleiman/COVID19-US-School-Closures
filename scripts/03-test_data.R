#### Preamble ####
# Purpose: Testing our data sets 
# Author: Krishiv Jain, Julia Kim, Abbass Sleiman
# Date: 12 February 2024
# Contact: krishiv.jain@mail.utoronto.ca, abbass.sleiman@mail.utoronto.ca, juliaym.kim@mail.utoronto.ca
# License: MIT
# Pre-requisites: Downloaded the data files through 01-download_data.R and through the instructions in the README


#### Workspace setup ####
library(tidyverse)

#### TESTING DATA FOR FIGURE 2 ####

##Check the minimum number is equal, or greater than, 0 ##
#Based on: https://tellingstorieswithdata.com/02-drinking_from_a_fire_hose.html#simulate
broadband_data$`COUNTY ID` |> min() >= 0

##Check the class of the column is numeric##
broadband_data$`COUNTY ID` |> class() == "numeric"
race_data$enrollment |> class() == "numeric"




