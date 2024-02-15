#### Preamble ####
# Purpose: Replicated graphs from Jack and Oster's paper titled "COVID-19, School Closures, and
# Outcomes" found at https://www.aeaweb.org/articles?id=10.1257/jep.37.4.51. In particular, we aimed
# to replicate Figure 1, Figure 2, and Figure 4, as denoted in their paper.
# Author: Krishiv Jain, Julia Kim, Abbass Sleiman
# Date: 12 February 2024 

#### Workspace setup ####
library(tidyverse)
library(janitor)
library(dplyr)
library(knitr)
library(here)
library(readxl)
library(ggplot2)

#### FIGURE 1 ####

data <- read_excel("data/raw_data/Tracker-of-national-education-response-to-COVID-19_-21May2020.xlsx", 
                   sheet = "Continuity of Learning")

master_data <- data[30:36, c(1) ]

master_data <- data[30:36, c(1, 3) ]
master_data$...3 <- as.numeric(master_data$...3) * 100
master_data$new_column <- "Digital Platforms"

tv_data <- data[95:101, c(1, 3)]
tv_data$...3 <- as.numeric(tv_data$...3) * 100
tv_data$new_column <- "TV Programming"
master_data <- rbind(master_data, tv_data)

radio_data <- data[107:113, c(1, 3)]
radio_data$...3 <- as.numeric(radio_data$...3) * 100
radio_data$new_column <- "Radio Programming"
master_data <- rbind(master_data, radio_data)

printed_data <- data[119:125, c(1, 3)]
printed_data$...3 <- as.numeric(printed_data$...3) * 100
printed_data$new_column <- "Printed take-home resouces"
master_data <- rbind(master_data, printed_data)

one_data <- data[17:23, c(1, 3)]
one_data$...3 <- (1 - as.numeric(one_data$...3)) * 100
one_data$new_column <- "Any/at least one method"
master_data <- rbind(master_data, one_data)

colnames(master_data) <- c("Region", 
                           "Percentage", 
                           "Thing")

master_data$Region <- factor(master_data$Region)
master_data$Region <- str_wrap(master_data$Region, width = 15)
master_data$Thing <- as.factor(master_data$Thing)

master_graph <- master_data |>
  ggplot(mapping = aes(x = Region, y = Percentage, fill = Thing)) +
  geom_col(position = "dodge2") +
  ggtitle("Education Delivery Method by Region") +
  geom_text(aes(label = sprintf("%.0f", Percentage)), 
            position = position_dodge(width = 0.9), 
            vjust = -0.5, size = 3) +  # Add data labels on top of each bar
  labs(x = "Region", y = "Percentage of Countries in Regions (%)", fill = "Education Delivery Method") +
  theme(legend.position = "bottom") +
  theme(plot.title = element_text(hjust = 0.5))

master_graph <- master_graph + guides(fill = guide_legend(nrow = 2))  # Set the number of rows in the legend
master_graph <- master_graph + theme(legend.key.height = unit(0.5, "cm"))  # Adjust height of legend keys
master_graph <- master_graph + theme(legend.text = element_text(lineheight = 0.5))  # Adjust line height of legend text

master_graph

#### FIGURE 2 ####

# Calculate the number of days schools were closed for each country
days_closed_per_country <- cleaned_region_data |>
  group_by(region_name, country_name) |>
  summarize(days_closed = sum(covid_score > 1))

# Calculate the mean number of days closed for each region
mean_days_closed_per_region <- days_closed_per_country |>
  group_by(region_name) |>
  summarize(mean_days_closed = mean(days_closed))

# Sort regions in ascending order by mean_days_closed
mean_days_closed_per_region <- mean_days_closed_per_region |>
  arrange(mean_days_closed)

# Create a bar chart
ggplot(mean_days_closed_per_region, 
       aes(x = reorder(region_name, mean_days_closed), y = mean_days_closed)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  geom_text(aes(label = round(mean_days_closed)), vjust = -0.5, color = "black", size = 2.5) +
  labs(x = "Region", y = "Mean Days Closed") +
  scale_y_continuous(
    limits = c(0, 600),
    breaks = seq(0, 600, by = 100)
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

#### FIGURE 3 ####

# Calculate the total number of enrollments overall
total_enrollment <- sum(cleaned_test_score_data$enrollment)

# Filter for Math
filtered_test_data <- cleaned_test_score_data |>
  filter(subject == "Math")

# Define in-person percent learning categories
inperson_group <- c("0-25", "25-50", "50-75", "75-100")

# Change data format into long format from wide format and categorize the in-person share
long_filtered_test_data <- filtered_test_data |>
  pivot_longer(cols = starts_with("change_"),
               names_to = "year_group",
               values_to = "change_in_pass_rate") |>
  mutate(inperson_category = cut(share_inperson, breaks = c(-Inf, 0.25, 0.5, 0.75, Inf), labels = inperson_group))

# Group by year and calculate summary statistics
summary_test_data <- long_filtered_test_data |>
  group_by(year_group, inperson_category) |>
  summarize(weighted_avg_change_pass = weighted.mean(change_in_pass_rate, 
                                                     w = enrollment/total_enrollment, 
                                                     na.rm = TRUE)) |>
  ungroup()

# Calculate the overall weighted average pass rate change
overall_summary_test_data <- long_filtered_test_data |>
  group_by(year_group) |>
  summarize(weighted_avg_change_pass = weighted.mean(change_in_pass_rate,
                                                     w = enrollment/total_enrollment,
                                                     na.rm = TRUE),
            inperson_category = "Overall")

# Bind both sets of rows together
summary_test_data <- bind_rows(summary_test_data, overall_summary_test_data)

# Plot the resultant graph
ggplot(summary_test_data, aes(x = weighted_avg_change_pass * 100, y = inperson_category, color = year_group)) +
  geom_point(size = 3) + 
  geom_vline(xintercept = 0, color = "darkgrey") +
  scale_x_continuous(limits = c(-17, 3)) +
  scale_y_discrete(limits = c("75-100", "50-75", "25-50", "0-25", "Overall")) +
  labs(x = "Average Change in Pass Rate (Percentage Points)", y = "Percent In-Person",
       title = "Average Change in Pass Rate by Year in Math") +
  scale_color_discrete(labels = c("Spring 2018", "Spring 2019", "Spring 2021")) +
  labs(color = "Year Category") +
  theme_minimal()