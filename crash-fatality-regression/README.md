# Motor Vehicle Crash Fatality Risk Analysis
_Logistic Regression Using Real-World Crash Data_

## Overview
This project analyzes motor vehicle crash data to identify factors associated with **fatal crash outcomes**, with a specific focus on whether **Ford vehicles** are more likely to be involved in fatal crashes once key driver, vehicle, and situational variables are controlled for.

The analysis is implemented in **Python** using **statsmodels**, with both a **simple logistic regression** and a **multiple logistic regression model** that mirrors a formally specified regression design.

---

## Research Question
> Are Ford vehicles statistically associated with higher fatal crash risk compared to non-Ford vehicles, after accounting for driver characteristics, vehicle attributes, and environmental conditions?

---

## Data
- **Source:** Motor Vehicle Collisions crash dataset  
- **Format:** CSV  
- **Observations:** 89,000+ crash records (post-cleaning)
- **Target Variable:**
  - `Fatality` → numeric copy of `WHETHER_PEOPLE_DIED`  
    - 1 = fatal crash  
    - 0 = non-fatal crash  

Raw data is excluded from this repository due to size. The pipeline assumes the dataset is locally available.

---

## Tech Stack
- Python
- pandas
- statsmodels
- numpy
- scipy
- matplotlib / seaborn

---

## Data Preparation & Cleaning
The analysis performs the following preprocessing steps:

- Converts key variables to numeric using `pd.to_numeric()` with coercion
- Drops rows with missing values in core regression variables
- Separates **simple** and **multiple regression datasets**
- Ensures all regression inputs are strictly numeric before model fitting
- Outputs all regression summaries and diagnostics to a text report (`motor.txt`)

---

## Feature Engineering
### Core Variables
- `Fatality` – Dependent variable (binary)
- `Ford` – Binary indicator derived from `IS_FORD`

### Control Variables Used in Multiple Model
The multiple logistic regression includes the following predictors:

- `IS_FORD`
- `IS_WEEKDAY`
- `DRIVER_SEX_MALE`
- `DRIVER_WITH_LICENSE`
- `IS_WINTER`
- `IS_SPRING`
- `IS_FALL`
- `IS_SUMMER`
- `IS_RUSH_HOUR`
- `VEHICLE_OCCUPANTS`
- `IS_MORE_THAN_10_YEARS_OLD`
- `IS_MORE_THAN_20_YEARS_OLD`
- `IS_TRUCK`

These variables control for **temporal effects, driver behavior, vehicle characteristics, and crash context**.

---

## Modeling Approach
### 1. Simple Logistic Regression
A baseline logistic regression was estimated using:
- **Dependent variable:** `WHETHER_PEOPLE_DIED`
- **Predictor:** `Ford`

Purpose:
- Measure the raw relationship between Ford vehicles and fatal outcomes without controls.

---

### 2. Multiple Logistic Regression
A fully specified logistic regression model was estimated using:

- **Dependent variable:** `Fatality`
- **Predictors:** Ford indicator + 12 control variables
- **Estimation method:** Maximum Likelihood Estimation (`statsmodels.Logit`)

A constant term was added explicitly using `sm.add_constant()`.

---

## Model Output
- Regression summaries are printed using `model.summary()`
- All output is redirected to a text file:
