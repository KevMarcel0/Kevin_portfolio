# Crash Fatality Risk: Logistic Regression

**Question:** Are Ford vehicles more likely to be in fatal crashes once driver, vehicle, and timing factors are controlled for?

Team project for CIS 9660 at Baruch, built with two classmates. A report using national crash data found Ford had the highest share of fatal crashes from 2017 to 2019, so we tested whether that holds up in NYC crash records once other factors are accounted for.

**My role:** ran the Python analysis, both logistic regression models in statsmodels and the output report (`Logit.py`).

**Tools:** Python (pandas, statsmodels, numpy, scipy), Excel for data prep

## The Data

- NYC motor vehicle collision records (NYC Open Data), 2016-2024
- 89,102 records and 27 columns before cleaning, with 449,158 missing values across the table
- 64,791 records after cleaning, which is what the model ran on
- Fatal crashes are rare: 38 of the 64,791 records involved a death (0.06%)

## How It Was Cleaned

- Built dummy variables in Excel from the raw columns: Ford vs. other makes, weekday vs. weekend, driver sex, license status, season, rush hour (5-9 AM and 5-8 PM), vehicle age over 10 and over 20 years, and truck vs. other vehicles.
- Removed rows with blank or unknown driver sex, blank license status, blank vehicle type, and more than 7 occupants.
- In Python, converted every model column to numeric and dropped rows still missing a value before fitting.

## The Model

1. **Simple:** fatal crash (yes/no) predicted by Ford alone.
2. **Multiple:** Ford plus 12 controls (weekday, driver sex, license status, the four seasons, rush hour, number of occupants, vehicle age, and truck).

Significance was judged at p < 0.05.

## What We Found

1. **On its own, Ford looked riskier.** In the simple model, Fords had about 2.3 times the odds of a fatal crash (p = 0.035).
2. **That effect went away with controls.** In the full model, Ford was no longer significant (p = 0.063), so we couldn't say driving a Ford raises the chance of dying in a crash.
3. **License status mattered most.** Crashes with a licensed driver had much lower odds of a death (p = 0.001). Put the other way, unlicensed drivers had about 6 times the odds.
4. Driver sex, weekday, rush hour, number of occupants, vehicle age, and trucks were not significant.

## Recommendation

Put safety efforts toward unlicensed drivers, not vehicle make. The Ford headline from the national report didn't hold up once license status and the other factors were in the model.

## What It Doesn't Answer

- Speed, weather, road type, and driver age weren't in the data, and they matter a lot.
- With only 38 fatal crashes, the estimates are noisy.
- The full model didn't fully converge (statsmodels gave an iteration warning), and all four season variables were included alongside the constant, so they overlap. The season results, including a significant spring coefficient, shouldn't be trusted.
- This shows associations, not causes.

## Files

| File | What it is |
|---|---|
| `Logit.py` | Loads the cleaned CSV, runs both models, and writes the output to `motor.txt` |

The crash CSV isn't included because of its size. Update the file path at the top of `Logit.py` to run it.
