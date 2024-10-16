# ----------------------------------------------------------------------------------------
# Title:        utils.R
# Author:       Christoph Hartleb
# Date:         2024-10-16
# Description:  Provides utility functions designed to support various data processing and
#               environment setup tasks for other scripts in the project.
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

# Import necessary libraries.
library(parallel)
library(dplyr)
library(jsonlite)
library(ggplot2)

#' Check and install missing packages
#'
#' This function checks if the required packages are installed. 
#' If a package is not installed, it automatically installs it. 
#' Otherwise, it confirms that the package is already installed.
#'
#' @param pkgs A character vector of package names to check.
#' @return None. The function returns `NULL` invisibly.
#'         It prints messages indicating the status of each package.
check_pkg_status <- function(pkgs) {
    for (pkg in pkgs) {
        if (!requireNamespace(pkg, quietly = TRUE, echo = FALSE)) {
            install.packages(pkg)
            message(paste("INFO: '", pkg, "' has been installed."))
        } else {
            message(paste("INFO: '", pkg, "' is already installed."))
        }
    }
    return(invisible(NULL))
}

#' Load dataset from a CSV file
#'
#' This function loads a dataset from a specified CSV file. 
#' It first normalizes the file path, checks if the file exists, 
#' and reads the file into a data frame.
#'
#' @param data_filepath A string representing the file path to the CSV file.
#' @return A data frame containing the data from the CSV file.
#'         If the file does not exist, the function throws an error.
load_dataset <- function(data_filepath) {
    norm_path = normalizePath(data_filepath)
    max_threads <- detectCores()
    if (!file.exists(norm_path)) {
        # stop executing
        stop(message(paste("ERROR: '", norm_path, "' does not exist.")))
    }
    data <- read.csv(norm_path)

    return(data)
}
