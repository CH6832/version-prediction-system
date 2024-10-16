# ----------------------------------------------------------------------------------------
# Title:        explore_and_analyze.R
# Date:         2024-10-16
# Description:  Exploration and analyzation version data, specifically major and
#               minor software.
#               version numbers.
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

# Load utility functions from the 'utils.R' script
source("scripts/utils.R")

# Check and install any required packages that may not be available
# This function ensures that the required packages (jsonlite, ggplot2, dplyr) are installed
check_pkg_status(c("jsonlite","ggplot2","dplyr"))

# Load required libraries for data manipulation and visualization
library(jsonlite)
library(ggplot2)
library(dplyr)

# Load the dataset containing version information (major and minor versions) from a CSV file
dataset = load_dataset("data/raw/major_minor_versions.csv")

# Convert the dataset into a data frame for easier manipulation and disable automatic factor conversion
# 'stringsAsFactors = FALSE' ensures that character columns are not converted to factors
df <- data.frame(version = dataset, stringsAsFactors = FALSE)

# Define a function to check and return the structure of the dataset by showing its first few rows
check_data_structure <- function() {
  data_struct <- head(dataset)
  
  return(data_struct)
}

# Provide an overview summary of the dataset
# Get the total number of rows (versions) in the dataframe
total_versions <- nrow(df)
# Get the total number of columns (versions) in the dataframe
total_columns <- ncol(df)
# Calculate the number of unique major version numbers in the dataset
unique_major_versions <- length(unique(df$major))
# Calculate the number of unique minor version numbers in the dataset
unique_minor_versions <- length(unique(df$minor))

#' Get the Total Number of Versions
#'
#' This function returns the total number of version records in the dataset. 
#' It uses the pre-computed value of `total_versions`, which represents the total 
#' number of rows (i.e., version entries) in the data frame `df`. 
#' This can be useful for obtaining an overview of the size of the dataset.
#'
#' @return An integer value representing the total number of version records in the dataset.
#' @note Ensure that the dataset has been properly loaded and the `total_versions` 
#'       variable has been computed before calling this function.
#' @examples
#' total <- get_total_versions()
#' print(total)
#' @export
get_total_versions <- function() {
  
  return(total_versions)
}

#' Get the Total Number of Columns
#'
#' This function returns the total number of columns in the dataset. 
#' It uses the pre-computed value of `total_columns`, which represents the total 
#' number of rows (i.e., version entries) in the data frame `df`. 
#' This can be useful for obtaining an overview of the size of the dataset.
#'
#' @return An integer value representing the total number of version records in the dataset.
#' @note Ensure that the dataset has been properly loaded and the `total_columns` 
#'       variable has been computed before calling this function.
#' @examples
#' total_columns <- get_total_columns()
#' print(total_columns)
#' @export
get_total_columns <- function() {
  
  return(total_columns)
}

#' Retrieve and Display the Count of Unique Major Versions
#'
#' This function prints the number of unique major versions in the dataset. 
#' It uses the variable `unique_major_versions`, which stores the count of distinct 
#' major version numbers from a data frame of version information. The result is 
#' displayed as a formatted message to the console.
#'
#' @return The function does not return a specific value but outputs a formatted 
#'         string to the console showing the number of unique major versions.
#' @note Ensure that the dataset containing major and minor version data has been 
#'       loaded and that the variable `unique_major_versions` has been correctly 
#'       calculated before calling this function.
#' @examples
#' # Example usage:
#' get_unique_major_version()  # Displays the number of unique major versions in the console.
#'
#' # Ensure that the dataset is loaded, and the `unique_major_versions` variable 
#' # is defined based on the dataset.
#' 
#' @export
get_unique_major_version <- function() {
  
  return(cat(paste("Unique Major Versions: ", unique_major_versions, "\n")))
}

#' Retrieve and Display the Count of Unique Minor Versions
#'
#' This function prints the number of unique minor versions in the dataset. 
#' It uses the variable `unique_minor_versions`, which stores the count of distinct 
#' minor version numbers from a data frame of version information. The result is 
#' displayed as a formatted message to the console.
#'
#' @return The function does not return a specific value but outputs a formatted 
#'         string to the console showing the number of unique minor versions.
#' @note Ensure that the dataset containing major and minor version data has been 
#'       loaded and that the variable `unique_minor_versions` has been correctly 
#'       calculated before calling this function.
#' @examples
#' # Example usage:
#' get_unique_minor_version()  # Displays the number of unique minor versions in the console.
#'
#' # Ensure that the dataset is loaded, and the `unique_minor_versions` variable 
#' # is defined based on the dataset.
#' 
#' @export
get_unique_minor_version <- function() {
  
  return(cat(paste("Unique Minor Versions: ", unique_minor_versions, "\n")))
}

#' Plot the Distribution of Major Versions in the Dataset
#'
#' This function calculates and visualizes the distribution of major version numbers 
#' in a given dataset. It first checks if the 'version.major' column exists in the 
#' data frame, then groups the data by major versions and counts their occurrences.
#' Finally, it creates a bar plot of the distribution using `ggplot2`.
#'
#' @return A `ggplot` object that visualizes the distribution of major versions 
#'         as a bar plot, where the x-axis represents the major version numbers 
#'         and the y-axis represents the count of occurrences.
#' @note This function expects the input data frame (`df`) to have a column named 
#'       `version.major`. If the column does not exist, the function will stop 
#'       with an error message. The function will also adjust the text of x-axis 
#'       labels to ensure readability.
#' @examples
#' # Example usage:
#' # Assuming `df` is a data frame with a `version.major` column:
#' plot <- distrib_major_version()
#' print(plot)  # To display the plot
#'
#' # Make sure that `df` contains the correct structure with major version data.
#' 
#' @export
distrib_major_version <- function() {
  # Ensure the major column exists
  if (!"version.major" %in% colnames(df)) {
    stop("The data frame does not contain a 'major' column.")
  }
  
  # Calculate total versions and unique major versions
  total_versions <- nrow(df)
  unique_major_versions <- length(unique(df$major))
  
  # Group by major version and summarize counts
  major_distribution <- df %>%
    group_by(version.major) %>%
    summarise(count = n(), .groups = 'drop')  # Use .groups = 'drop' to avoid warnings
  
  # Create a bar plot for major version distribution
  plot <- ggplot(major_distribution, aes(x = factor(version.major), y = count)) +
    geom_bar(stat = "identity", fill = "steelblue") +
    theme_minimal() +
    labs(title = "Major Version", x = "Major Version", y = "Count") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

  return(plot)
}

#' Plot the Distribution of Minor Versions in the Dataset
#'
#' This function calculates and visualizes the distribution of minor version numbers 
#' in a given dataset. It checks whether the 'version.minor' column exists in the 
#' data frame, groups the data by minor versions, and counts their occurrences.
#' Finally, it creates a bar plot of the distribution using `ggplot2`.
#'
#' @return A `ggplot` object visualizing the distribution of minor versions as a 
#'         bar plot, where the x-axis represents the minor version numbers and the 
#'         y-axis represents the count of occurrences.
#' @note The function will stop execution and return an error message if the input 
#'       data frame (`df`) does not contain a 'version.minor' column. It also rotates 
#'       the x-axis labels to ensure they are easy to read.
#' @examples
#' # Example usage:
#' # Assuming `df` is a data frame with a `version.minor` column:
#' plot <- distrib_minor_version()
#' print(plot)  # To display the plot
#'
#' # Ensure that `df` contains the correct structure with minor version data.
#' 
#' @export
distrib_minor_version <- function() {
  # Ensure the minor column exists
  if (!"version.minor" %in% colnames(df)) {
    stop("The data frame does not contain a 'minor' column.")
  }
  
  # Calculate total versions and unique minor versions
  total_versions <- nrow(df)
  unique_minor_versions <- length(unique(df$minor))
  
  # Group by minor version and summarize counts
  minor_distribution <- df %>%
    group_by(version.minor) %>%
    summarise(count = n(), .groups = 'drop')  # Use .groups = 'drop' to avoid warnings
  
  # Create a bar plot for minor version distribution
  plot <- ggplot(minor_distribution, aes(x = factor(version.minor), y = count)) +
    geom_bar(stat = "identity", fill = "lightgreen") +
    theme_minimal() +
    labs(title = "Minor Version", x = "Minor Version", y = "Count") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

  return(plot)
}

#' Plot the Version Progression Trend Over Time
#'
#' This function visualizes the progression of software version numbers over time (or index).
#' It creates a trend line plot where each version number is represented as a combination of 
#' the major and minor version components. The x-axis represents the index (sequential order 
#' of entries), and the y-axis represents the combined version value (major version + minor version / 10).
#' 
#' The trend line provides a visual representation of how the version numbers progress, 
#' making it easier to observe patterns or releases over time.
#'
#' @return A `ggplot` object that represents a line plot showing the progression of 
#'         software versions over time. The x-axis represents the index of the 
#'         dataset rows, and the y-axis represents the calculated version values.
#' @note The function assumes the input data frame `df` contains `version.major` and 
#'       `version.minor` columns. It adds an index column to represent the sequential 
#'       order of rows for plotting.
#' @examples
#' # Example usage:
#' # Assuming `df` contains columns `version.major` and `version.minor`:
#' trend_plot <- version_progression_trend()
#' print(trend_plot)  # To display the trend plot
#'
#' # Ensure that `df` has the necessary version columns before running this function.
#' 
#' @export
version_progression_trend <- function() {
    df$index <- 1:nrow(df)
    
    plot <- ggplot(df, aes(x = index, y = version.major + version.minor / 10)) +
      geom_line(color = "blue") +
      theme_minimal() +
      labs(title = "", x = "Index", y = "Version")
    
    return(plot)
}

