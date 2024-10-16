# ----------------------------------------------------------------------------------------
# Title:        feature_engineering.R
# Author:       Christoph Hartleb
# Date:         2024-10-16
# Description:  Preparation and transformation of raw version data into a more usable
#               format for modeling or analysis.
# Version:      1.0
# 
# © 2024 Christoph Hartleb. All rights reserved.
# 
# This work is licensed under the Creative Commons Attribution-NonCommercial-NoDerivatives
# 4.0 International License. To view a copy of this license, visit
# http://creativecommons.org/licenses/by-nc-nd/4.0/
#
# You are free to:
# - Share — copy and redistribute the material in any medium or format.
#
# Under the following terms:
# - Attribution — You must give appropriate credit, provide a link to the license, and 
#   indicate if changes were made. You may do so in any reasonable manner, but not in any 
#   way that suggests the licensor endorses you or your use.
# - NonCommercial — You may not use the material for commercial purposes.
# - NoDerivatives — If you remix, transform, or build upon the material, you may not 
#   distribute the modified material.
#
# No additional restrictions — You may not apply legal terms or technological measures 
# that legally restrict others from doing anything the license permits.
# ----------------------------------------------------------------------------------------

# Source utility functions.
source("scripts/utils.R")

# Check if required packages are installed and install them if necessary.
check_pkg_status(c("jsonlite","ggplot2","dplyr","tidyr"))

# Load the necessary libraries.
library(jsonlite)
library(ggplot2)
library(dplyr)
library(tidyr)

dataset = load_dataset("data/raw/major_minor_versions.csv")

#' Check for missing values in the dataset
#'
#' This function calculates the total number of missing values (NA) in the dataset
#' and prints the result to the console.
#'
#' @return None. Prints the number of missing values in the dataset.
check_missing_values <- function() {
    # This will return the total number of missing values.
    num_missing_values <- sum(is.na(dataset))

    return(cat(paste("Number of missing values: ", num_missing_values)))
}

#' Identify columns with missing values
#'
#' This function checks each column in the dataset and counts how many missing values (NA) exist in each column.
#'
#' @return A named vector with the total number of missing values in each column of the dataset.
columns_missing_in_row <- function() {
    total_cl_num <- colSums(is.na(dataset))

    return(total_cl_num)
}

#' Remove rows with missing values from the dataset
#'
#' This function removes any rows from the dataset that contain missing values in any column.
#'
#' @return A data frame with all rows containing missing values removed.
removed_rows <- function() {
    removed_rows <- dataset %>% filter(complete.cases(.))

    return(removed_rows)
}

#' Convert 'major' and 'minor' version columns to integers
#'
#' This step ensures that the 'major' and 'minor' columns, which represent version numbers, are converted to integer data types.
#' This is necessary for proper numerical operations and feature engineering.
dataset <- dataset %>% mutate(major = as.integer(major), minor = as.integer(minor))

# Write the cleaned and feature-engineered dataset to a new CSV file
# This dataset is now ready for further processing or model building.
write.csv(dataset, "data/preprocessed/feature_engineered_versions.csv", row.names = FALSE)

