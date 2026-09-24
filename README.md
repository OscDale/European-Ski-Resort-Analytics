# ski-resort-analytics-git

# European Ski Resort Historical Performance Analytics 🎿

## Overview
This project analyses 20 years of historical weather and snowfall data across major European ski destinations to improve seasonal trip planning. By evaluating long-term trends, this tool identifies which resorts and specific operating weeks historically deliver the best conditions.

**[View the Interactive Tableau Dashboard Here](https://public.tableau.com/app/profile/oscar.dale/viz/EuropeanSkiResortHistoricalPerformanceAnalytics/Dashboard)**

---

## The Ski Quality Index (SQI)
To benchmark resorts objectively, I developed a composite **Ski Quality Index (0–100)** formula implemented through SQL and Python. The SQI evaluates historical reliability using four weighted components:
1. **Snow Depth Base:** Measured in metres to verify adequate snow cover.
2. **Fresh Snowfall:** Weekly accumulation totals.
3. **Powder Frequency:** Count of days with significant fresh snowfall.
4. **Climate & Sunshine Comfort:** Accounting for optimal temperature bands and sunshine hours.

---

## Tech Stack & Architecture
* **Python (Jupyter Notebooks):** Used `pandas` for data ingestion, cleaning, exploratory analysis, and generating weekly data structures.
* **SQL:** Relational data modelling and pipeline processing, including dimensional schemas (`dim_resort`), daily-to-weekly aggregations via CTEs, and automated SQI scoring.
* **Tableau Public:** Visual dashboarding featuring interactive heatmaps, scatter plots, dynamic parameters, and custom filtering.

---

## Repository Structure
* `/notebooks`: Contains the Jupyter notebook detailing the data cleaning and processing logic.
* `/sql`: Houses the relational schema and aggregation queries:
  * `01_dim_resort.sql`: Defines resort metadata and generated elevation fields.
  * `02_weekly_resort_weather.sql`: Aggregates daily weather into standardised 7-day winter operating weeks.
  * `03_average_weekly_weather.sql`: Computes multi-season historical averages and the final SQI score.
* `/data`: Contains samples of the structured datasets.