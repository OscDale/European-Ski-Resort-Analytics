USE ski_analytics;

DROP TABLE IF EXISTS average_weekly_weather;

CREATE TABLE average_weekly_weather (
    id INT AUTO_INCREMENT PRIMARY KEY,
    resort_name VARCHAR(100) NOT NULL,
    country VARCHAR(50) NOT NULL,
    season_week_num INT NOT NULL,
    week_timeframe VARCHAR(30) NOT NULL,
    avg_sqi DECIMAL(5,2),
    avg_snowfall_cm FLOAT,
    avg_snow_depth_m FLOAT,
    avg_sunshine_hours FLOAT,
    avg_temp_max_c FLOAT,
    avg_temp_min_c FLOAT,
    avg_powder_days FLOAT,
    INDEX idx_resort_week (resort_name, season_week_num)
);

INSERT INTO average_weekly_weather (
    resort_name,
    country,
    season_week_num,
    week_timeframe,
    avg_sqi,
    avg_snowfall_cm,
    avg_snow_depth_m,
    avg_sunshine_hours,
    avg_temp_max_c,
    avg_temp_min_c,
    avg_powder_days
)
WITH base_aggregates AS (
    SELECT 
        resort_name,
        country,
        season_week_num,
        CONCAT(
            'Wk ', season_week_num, ' (',
            DATE_FORMAT(MIN(week_start_date), '%b %d'), ' - ',
            DATE_FORMAT(MIN(week_end_date), '%b %d'), ')'
        ) AS week_timeframe,
        AVG(avg_sqi) AS raw_avg_sqi,
        AVG(total_snowfall_cm) AS avg_snowfall_cm,
        AVG(avg_snow_depth_m) AS avg_snow_depth_m,
        AVG(total_sunshine_hours) AS avg_sunshine_hours,
        AVG(avg_temp_max_c) AS avg_temp_max_c,
        AVG(avg_temp_min_c) AS avg_temp_min_c,
        AVG(powder_days_count) AS avg_powder_days
    FROM weekly_resort_weather
    GROUP BY 
        resort_name,
        country,
        season_week_num
),
rescaled AS (
    SELECT 
        *,
        -- Rescaling Component weights to hit peak historical potential:
        -- 1. Snow Depth Component (Max 40 pts: 1.2m average depth = full points)
        LEAST(40, (avg_snow_depth_m / 1.2) * 40) +
        
        -- 2. Fresh Snowfall Component (Max 35 pts: 25cm weekly average = full points)
        LEAST(35, (avg_snowfall_cm / 25.0) * 35) +
        
        -- 3. Powder Frequency Component (Max 15 pts: 1.5 powder days/wk = full points)
        LEAST(15, (avg_powder_days / 1.5) * 15) +
        
        -- 4. Climate Comfort Component (Max 10 pts)
        (CASE 
            WHEN avg_temp_max_c BETWEEN -6 AND 1 THEN 10
            WHEN avg_temp_max_c BETWEEN -10 AND 4 THEN 6
            ELSE 2 
         END) AS scaled_sqi
    FROM base_aggregates
)
SELECT 
    resort_name,
    country,
    season_week_num,
    week_timeframe,
    ROUND(LEAST(100, GREATEST(20, scaled_sqi)), 2) AS avg_sqi,
    ROUND(avg_snowfall_cm, 1) AS avg_snowfall_cm,
    ROUND(avg_snow_depth_m, 2) AS avg_snow_depth_m,
    ROUND(avg_sunshine_hours, 1) AS avg_sunshine_hours,
    ROUND(avg_temp_max_c, 1) AS avg_temp_max_c,
    ROUND(avg_temp_min_c, 1) AS avg_temp_min_c,
    ROUND(avg_powder_days, 1) AS avg_powder_days
FROM rescaled
ORDER BY 
    country, 
    resort_name, 
    season_week_num;