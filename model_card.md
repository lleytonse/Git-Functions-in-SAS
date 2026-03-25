# Model Card — Predictive Maintenance RUL Model (Gradient Boosting)

## Overview
This model predicts **Remaining Useful Life (RUL)** for a filter in a preventive-to-predictive maintenance transition.  
Data originates from run-to-failure trajectories of industrial filters exposed to controlled flow rate, dust feed, and dust types.

The model is trained on complete trajectories (test set) using a Gradient Boosting machine implemented via SAS `PROC GRADBOOST`.  
It generates an ASTORE for production scoring.

---

## Intended Use
- Predict how many time units remain before a filter reaches the failure threshold (differential pressure > 600 Pa)
- Enable predictive maintenance scheduling
- Support operational dashboards, alerts, and cost-saving maintenance programs

---

## Model Architecture
- Algorithm: Gradient Boosting (GRADBOOST)
- Trees: 266 out of 500 requested (early stopping)
- Max depth: 8
- Learning rate: 0.0417
- Subsampling rate: 0.5855
- Regularization: L1 = 0.66, L2 = 2.63

---

## Data Schema
- Target: RUL (interval)
- Predictors: Dust_feed, Differential_pressure, Time, Dust, Flow_rate
- Group: Data_No (trajectory ID)

---

## Key Insights From Training
- Dust_feed is the strongest predictor (importance = 1.0)
- Differential_pressure is nearly as critical (0.74)
- Time, Dust type, and Flow_rate have small but nonzero effects

---

## Evaluation
The Gradient Boosting model was evaluated using standard regression metrics across the training, validation, and test partitions. Performance was strong and consistent across all splits, with R-Square values above 0.99, indicating excellent fit and low prediction error.

- Training Performance
    - Average Error: 35.0765
    - Root Average Squared Error: 5.9225
    - Mean Absolute Error (MAE): 3.3180
    - Root Mean Square Error (RMSE): 1.8215
    - Mean Squared Error (MSE): 0.0034
    - Root Mean Squared Error: 0.0580
    - R-Square: 0.9937
    - Observations: 23,649

- Validation Performance
    - Average Error: 47.3139
    - Root Average Squared Error: 6.8785
    - Mean Absolute Error (MAE): 3.7968
    - Root Mean Square Error (RMSE): 1.9485
    - Mean Squared Error (MSE): 0.0042
    - Root Mean Squared Error: 0.0648
    - R-Square: 0.9912
    - Observations: 11,824

- Test Performance
    - Average Error: 52.0618
    - Root Average Squared Error: 7.2154
    - Mean Absolute Error (MAE): 4.0238
    - Root Mean Square Error (RMSE): 2.0059
    - Mean Squared Error (MSE): 0.0049
    - Root Mean Squared Error: 0.0700
    - R-Square: 0.9907
    - Observations: 3,941

### Summary
The model generalizes well, with only slight increases in RMSE and MAE from training → validation → testing.
RUL predictions are highly accurate across all partitions.

---

## Limitations
- Uses only complete trajectories due to censored training data
- Does not integrate physical models or survival modeling
- Assumes stable dust feed rate within each run

---

## Artifacts Included
- `model.ast` (ASTORE)
- `hyperparameters.json`
- `metrics.json`
- `feature_importance.json`
- `schema.json`
- SAS scoring code
- Training script (PROC GRADBOOST)
