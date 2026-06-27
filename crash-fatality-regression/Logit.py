import pandas as pd
import statsmodels.api as sm
import statsmodels.stats.api as sms
from statsmodels.compat import lzip
import matplotlib.pyplot as plt
import seaborn as sns
from scipy.stats import shapiro
import scipy.stats as scipy
import numpy as np
import sys
import os

# === 2. Set Working Directory ===
os.chdir(r"/Users/kevinmarcelin/Documents/Data 9660/Regression")

# === 3. Load the Dataset ===
pd.set_option('display.max_columns', 500)
mydata = pd.read_csv("Motor_Vehicle_Collisions_-_Crashes_new1.csv", low_memory=False)

# === 4. Redirect Output to a Text File ===
file = open('motor.txt', 'wt')
sys.stdout = file

print("=========== BASIC SUMMARY STATISTICS ===========")
print(mydata.describe(include='all'))
print("\n\n")

# === 5. Create a DataFrame Copy for Analysis ===
df = pd.DataFrame(mydata)

# === 6. Create Key Variables for Logistic Regression ===
# Dependent variable: keep the name 'Fatality' in the code,
# but it is just a numeric copy of WHETHER_PEOPLE_DIED.
df["Fatality"] = pd.to_numeric(df["WHETHER_PEOPLE_DIED"], errors="coerce")

# Main independent variable: Ford vs non-Ford (copy of IS_FORD)
df["Ford"] = pd.to_numeric(df["IS_FORD"], errors="coerce")

# Keep rows where the core variables are defined
core_cols = ["Fatality", "Ford"]
df = df.dropna(subset=core_cols)

print("=========== VARIABLE CHECK (core dtypes) ===========")
print(df[["Ford", "Fatality"]].dtypes)
print("\n\n")

# === 7. Count Categories in Categorical Columns (just for info) ===
print("=========== NUMBER OF CATEGORIES IN EACH CATEGORICAL COLUMN ===========")
categorical_cols = df.select_dtypes(include="object").columns
for col in categorical_cols:
    print(f"{col}: {df[col].nunique()} unique categories")
print("\n\n")

# === 8. Simple Logistic Regression: Ford vs WHETHER_PEOPLE_DIED ===
print("=========== SIMPLE LOGISTIC REGRESSION (Ford -> WHETHER PEOPLE DIED) ===========")

df_simple = df[["WHETHER_PEOPLE_DIED", "Ford"]].dropna()

X_simple = sm.add_constant(df_simple["Ford"])
y_simple = pd.to_numeric(df_simple["WHETHER_PEOPLE_DIED"], errors="coerce")

# Drop any rows where coercion produced NaN
valid_idx = ~y_simple.isna()
X_simple = X_simple.loc[valid_idx]
y_simple = y_simple.loc[valid_idx]

model_simple = sm.Logit(y_simple, X_simple).fit()
print(model_simple.summary())
print("\n\n")

# === 9. MULTIPLE LOGISTIC REGRESSION (MATCHING outputPROJECT47 X-VARIABLES) ===
print("=========== MULTIPLE LOGISTIC REGRESSION (MATCHING outputPROJECT47) ===========")

# X-variables chosen to match outputPROJECT47:
x_cols = [
    'IS_FORD',
    'IS_WEEKDAY',
    'DRIVER_SEX_MALE',
    'DRIVER_WITH_LICENSE',
    'IS_WINTER',
    'IS_SPRING',
    'IS_FALL',
    'IS_SUMMER',
    'IS_RUSH_HOUR',
    'VEHICLE_OCCUPANTS',
    'IS_MORE_THAN_10_YEARS_OLD',
    'IS_MORE_THAN_20_YEARS_OLD',
    'IS_TRUCK'
]

# Build regression DataFrame for multiple model
subset_cols = ["Fatality"] + x_cols
df_reg = df[subset_cols].dropna()

print("Rows in df_reg after dropna on all model variables:", df_reg.shape[0])

y = df_reg["Fatality"]
X = df_reg[x_cols]

# Add constant
X = sm.add_constant(X)

print("Final X shape:", X.shape)
print("\nColumns in X and their data types:\n", X.dtypes)
print("\nAny non-numeric columns left:", X.select_dtypes(exclude=["number"]).columns.tolist())

# Ensure numeric
X = X.astype(float)
y = y.astype(float)

# Fit the multiple logistic regression model
model_multi = sm.Logit(y, X).fit()
print(model_multi.summary())
print("\n\n")

# === 10. Interpret Key Findings ===
print("=========== INTERPRETATION ===========")
print("Simple model:")
print("  Dependent variable: WHETHER_PEOPLE_DIED")
print("  Predictor: Ford (copy of IS_FORD)")
print("  This matches the simple logistic regression in outputPROJECT47.\n")

print("Multiple model:")
print("  Dependent variable: Fatality (numeric copy of WHETHER_PEOPLE_DIED;")
print("  name kept as 'Fatality' in your code and output).")
print("  Predictors (matching outputPROJECT47):")
print("    IS_FORD, IS_WEEKDAY, DRIVER_SEX_MALE, DRIVER_WITH_LICENSE,")
print("    IS_WINTER, IS_SPRING, IS_FALL, IS_SUMMER, IS_RUSH_HOUR,")
print("    VEHICLE_OCCUPANTS, IS_MORE_THAN_10_YEARS_OLD,")
print("    IS_MORE_THAN_20_YEARS_OLD, IS_TRUCK.\n")

print("\n=========== END OF REPORT ===========")