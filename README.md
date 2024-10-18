# Version Prediction System

## Table of Contents

- [Version Prediction System](#version-prediction-system)
  - [Table of Contents](#table-of-contents)
  - [Why such a project](#why-such-a-project)
  - [How it works](#how-it-works)
    - [Understanding the business problem](#understanding-the-business-problem)
    - [Collecting data](#collecting-data)
    - [Exploring the dataset](#exploring-the-dataset)
    - [Preprocessing and cleaning](#preprocessing-and-cleaning)
    - [EDA (Exploratory Data Analysis)](#eda-exploratory-data-analysis)
    - [Feature Selection/Engineering](#feature-selectionengineering)
    - [Model Evaluation](#model-evaluation)
    - [Model Interpretation](#model-interpretation)
    - [Predicting](#predicting)
    - [Reporting](#reporting)
  - [Content overview](#content-overview)
  - [How to open the project](#how-to-open-the-project)
  - [How to run the project](#how-to-run-the-project)
  - [What Resources are used to create the project?](#what-resources-are-used-to-create-the-project)
  - [License](#license)
  - [Copyright](#copyright)

## Why such a project

This project is designed to predict software version progression, which is critical for effective project management and release planning in software development. By accurately forecasting version numbers based on historical data, teams can better manage their development timelines, allocate resources efficiently, and minimize disruptions. The insights derived from this project can assist product managers, developers, and stakeholders in making informed decisions that enhance operational efficiency and product delivery.

## How it works

### Understanding the business problem

The primary goal of this project is to develop a model that predicts cumulative software version numbers based on major and minor version indicators. Accurate predictions can help teams plan updates, manage releases, and maintain consistency in versioning practices, ultimately enhancing user experience.

### Collecting data

The dataset utilized for this project is sourced from a collection of software versioning records. This includes details on major and minor versions, allowing for the analysis of historical version progression and trends. The dataset is structured to facilitate easy access and analysis.

### Exploring the dataset

During the exploration phase, initial insights into the dataset were obtained, including the distribution of major and minor versions, the total number of versions, and unique version identifiers. This step helped in understanding the data's structure and identifying any anomalies that required cleaning.

### Preprocessing and cleaning

Data preprocessing involved the following steps:
- **Handling Missing Values**: Addressing any gaps in the dataset.
- **Type Conversion**: Ensuring that version numbers are treated as numerical values for accurate calculations.
- **Feature Creation**: Generating additional features, such as cumulative version numbers, to aid in model training.

### EDA (Exploratory Data Analysis)

Exploratory Data Analysis revealed important patterns in version progression. Key insights included:
- Trends in the release frequency of major vs. minor versions.
- Observations on how versions correlate with significant updates in the software.

### Feature Selection/Engineering

Feature engineering focused on creating relevant predictors, including:
- **Cumulative Version Calculations**: Aggregating major and minor versions into a single cumulative version feature.
- **Version Progression Index**: A sequential index that helps in understanding versioning trends over time.

### Model Evaluation

Multiple models were evaluated to identify the best predictor of version numbers, including:
- **Linear Regression**: To analyze linear relationships between features and version numbers.
- **Random Forest**: To capture complex interactions and improve prediction accuracy.
- **Cross-validation**: Employed to ensure the robustness and reliability of model predictions.

### Model Interpretation

The best-performing model was analyzed to understand the key features driving predictions. Metrics such as RMSE were used to quantify model performance, and the results were visualized for better comprehension of how different features influence the predicted version numbers.

### Predicting

Once the model was trained, it was used to forecast future version numbers based on input data. The model generates predictions that help in planning future releases and versioning strategies.

### Reporting

Comprehensive reporting summarizes the model's performance, key insights from the data, and recommendations for future improvements. This section provides stakeholders with actionable information to enhance decision-making processes regarding version management.

## Content overview

    .
    ├── data/
    │   ├── preprocessed/ - Contains processed/cleaned data
    │   ├── raw/ - Original raw dataset
    │   └── test/ - Test data used for model evaluation
    ├── models/ - Model for Predictions
    ├── scripts/ - R scripts relevant for the project
    ├── COPYRIGHT - Project copyright
    ├── LICENSE - Project License
    ├── version-prediction-system.Rproj - RStudio project file
    ├── README.Rmd - Project information in RMarkdown format
    └── renv.lock - Lock file to ensure package consistency

## How to open the project

1. **Clone the repository**:
   Download the repository to your local machine:
   ```bash
   git clone https://github.com/YourUsername/version-prediction-system.git
   cd version-prediction-system
   ```

2. **Open with RStudio**:
   - Install [RStudio](https://posit.co/download/rstudio-desktop/).
   - Open **RStudio**, then go to `File -> Open Project` and select the `version-prediction-system.Rproj` file from the cloned folder.

## How to run the project

0. Run the following command to restore the environment:
   ```r
   renv::restore()
   ```

1. Load the raw data and explore/analyze:
   ```r
   source("scripts/explore_and_analyze.R")
   ```

2. Preprocess the raw data and do the feature engineering:
   ```r
   source("scripts/preprocessing_and_feature_engineering.R")
   ```

3. Execute the model training and evaluation pipeline:
   ```r
   source("scripts/select_train_evaluate_model.R")
   ```

4. Predict the next version:
   ```r
   source("scripts/predicting_version.R")
   ```

## What Resources are used to create the project?

* **R Language** - [R Documentation](https://www.r-project.org/other-docs.html)
* **RStudio IDE** - [RStudio IDE User Guide](https://docs.posit.co/ide/user/)
* **Markdown** - [Markdown Syntax](https://www.markdownguide.org/basic-syntax/)

## AI Assistance

The ChatGPT-4 model was utilized throughout the project to assist with fixing bugs, refining code logic, and enhancing the overall readability of documentation. It also played a key role in correcting grammar, spelling, and improving the clarity of all textual components, ensuring the documentation is polished and professional.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

## Copyright

See the [COPYRIGHT](COPYRIGHT) file for detailed copyright information.
