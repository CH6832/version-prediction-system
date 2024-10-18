# ----------------------------------------------------------------------------------------
# Title:        select_train_evaluate_model.R
# Author:       Christoph Hartleb
# Date:         2024-10-16
# Description:  Processing version data, splits it into training and testing sets,
#               evaluates different models, and selects the best model based on its
#               performance (specifically, Root Mean Squared Error or RMSE).
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

source("scripts/utils.R")

check_pkg_status(c("jsonlite","ggplot2","dplyr","tidyr","randomForest","caret","glmnet","lattice"))

library(jsonlite)
library(ggplot2)
library(dplyr)
library(lattice)
library(tidyr)
library(caret)
library(glmnet)
library(randomForest)

# Load the preprocessed dataset containing.
version_data <- read.csv("data/preprocessed/feature_engineered_versions.csv")

# Check if the 'cumulative_version' column exists in the dataset
# If not, create it by combining 'major' and 'minor' version numbers
# 'cumulative_version' is calculated as: major + (minor / 10), e.g., version 2.3 becomes 2.3.
if (!"cumulative_version" %in% colnames(version_data)) {
  version_data$cumulative_version <- version_data$major + version_data$minor / 10
}

# Set a seed for reproducibility, ensuring that the random sampling will produce the same result each time.
set.seed(123)

# Randomly select 80% of the data to be used for training the model.
sample_index <- sample(seq_len(nrow(version_data)), size = 0.8 * nrow(version_data))

# Create the training dataset using the randomly selected rows (80% of the original data).
train_data <- version_data[sample_index, ]

# The remaining 20% of the data is used as the test dataset to evaluate the model.
test_data <- version_data[-sample_index, ]

# Save the training and testing datasets as separate CSV files.
write.csv(train_data, "data/preprocessed/training_versions.csv", row.names = FALSE)
write.csv(test_data, "data/preprocessed/testing_versions.csv", row.names = FALSE)

#' Evaluate models using cross-validation
#'
#' This function evaluates machine learning models using 10-fold cross-validation on the training dataset.
#' It calculates the Root Mean Squared Error (RMSE) for each model and returns a summary of the results.
#'
#' The function currently supports two models:
#' \itemize{
#'   \item A linear regression model (`lm`) that predicts `cumulative_version` based on `major` and `minor` version numbers.
#'   \item A random forest model (`rf`) for the same task.
#' }
#'
#' The function performs cross-validation on the `train_data` and computes the average RMSE for each model, storing
#' the results in a data frame.
#'
#' @param train_data A data frame containing the training data. It should include the columns `cumulative_version`,
#'        `major`, and `minor`, which are used as the dependent and independent variables, respectively.
#'
#' @return A data frame with two columns:
#' \itemize{
#'   \item `Model`: The name of the model (`linear` for linear regression, `rf` for random forest).
#'   \item `RMSE`: The Root Mean Squared Error calculated from cross-validation.
#' }
#'
#' @note This function uses 10-fold cross-validation, which may take longer to execute for large datasets. 
#'       The RMSE values represent the predictive performance of the models on unseen data.
eval_models <- function(train_data) {
  
  # Define control for 10-fold cross-validation
  train_control <- trainControl(method = "cv", number = 10)
  
  # List of models to evaluate
  models <- list(
    linear = train(cumulative_version ~ major + minor, data = train_data, 
                   method = "lm", trControl = train_control),
    rf = train(cumulative_version ~ major + minor, data = train_data, 
               method = "rf", trControl = train_control)
  )
  
  # Initialize a data frame to store results
  results <- data.frame(Model = character(), RMSE = numeric(), stringsAsFactors = FALSE)
  
  # Evaluate each model
  for (model_name in names(models)) {
    model <- models[[model_name]]
    
    # Store RMSE from cross-validation results
    rmse <- model$results$RMSE[1]
    results <- rbind(results, data.frame(Model = model_name, RMSE = rmse))
  }
  
  return(results)
}

# Evaluate models.
model_results <- eval_models(train_data)

#' List of models for predicting cumulative version
#'
#' This object creates a list of machine learning models that predict the `cumulative_version` based on the 
#' `major` and `minor` version numbers in the `train_data` dataset. The models included in this list are:
#' 
#' \itemize{
#'   \item \code{linear}: A linear regression model (\code{lm}) that assumes a linear relationship between the 
#'   `cumulative_version` and the `major` and `minor` version numbers.
#'   \item \code{rf}: A random forest model (\code{randomForest}) that uses an ensemble of decision trees to model 
#'   the same relationship with more flexibility and non-linear interactions between features.
#' }
#'
#' Both models use `train_data` to fit the model, where `cumulative_version` is treated as the target variable, and 
#' `major` and `minor` are the predictors.
#'
#' @param train_data A data frame containing the training data. It must include the following columns:
#' \itemize{
#'   \item \code{cumulative_version}: The dependent variable representing the cumulative version.
#'   \item \code{major}: The major version number.
#'   \item \code{minor}: The minor version number.
#' }
#'
#' @return A list containing two models:
#' \itemize{
#'   \item \code{linear}: A linear regression model.
#'   \item \code{rf}: A random forest model.
#' }
#'
#' @note The linear model assumes that the relationship between the cumulative version and the predictors is linear. 
#' In contrast, the random forest model can capture more complex, non-linear relationships. 
#' 
#' The random forest model may take longer to train, especially with large datasets or many features.
models <- list(
  linear = lm(cumulative_version ~ major + minor, data = train_data),
  rf = randomForest(cumulative_version ~ major + minor, data = train_data)
)

#' Find the Best Model Based on RMSE
#'
#' This function identifies the best-performing model from a list of models evaluated on 
#' the training data. The selection is based on the Root Mean Squared Error (RMSE), which 
#' measures the average prediction error for each model. The model with the lowest RMSE 
#' is considered the best model.
#'
#' @details
#' The function assumes that the models have already been trained and cross-validated, 
#' and their performance metrics (RMSE) are stored in the global \code{model_results} 
#' object. This object should be a data frame with at least two columns:
#' \itemize{
#'   \item \code{Model}: The name of the model.
#'   \item \code{RMSE}: The corresponding RMSE value for each model.
#' }
#' 
#' The function extracts the name of the model with the lowest RMSE and returns it as the best model. 
#' Additionally, the function prints the name of the best model and its RMSE value for reference.
#'
#' @return 
#' A string containing the name of the best model (i.e., the model with the lowest RMSE).
#'
#' @note 
#' The function relies on \code{model_results}, which is expected to be a global data frame containing 
#' the RMSE values for each model. If this object is not available or does not contain the expected 
#' structure, the function will throw an error.
find_best_suited_model <- function() {
  # Find the name of the model with the lowest RMSE
  best_model_name <- model_results[which.min(model_results$RMSE), "Model"]
  cat("The best model is:", best_model_name, "with RMSE:", min(model_results$RMSE), "\n")
  
  return(best_model_name)
}

# Retrieve the name of the best model based on the lowest RMSE.
best_model_name <- find_best_suited_model()

# Extract the best model object from the pre-defined list of models.
best_model <- models[[best_model_name]]
