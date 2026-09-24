USE ski_analytics;

DROP TABLE IF EXISTS weekly_resort_weather;

CREATE TABLE weekly_resort_weather (
    id INT AUTO_INCREMENT PRIMARY KEY,
    resort_name VARCHAR(100) NOT NULL,
    country VARCHAR(50) NOT NULL,
    season VARCHAR(10) NOT NULL,
    season_week_num INT NOT NULL,
    week_label VARCHAR(50) NOT NULL,
    week_start_date DATE NOT NULL,
    week_end_date DATE NOT NULL,
    avg_temp_max_c FLOAT,
    avg_temp_min_c FLOAT,
    total_snowfall_cm FLOAT,
    avg_snow_depth_m FLOAT,
    total_sunshine_hours FLOAT,
    avg_sqi DECIMAL(5,2),
    peak_sqi DECIMAL(5,2),
    powder_days_count INT,
    INDEX idx_resort_season (resort_name, season),
    INDEX idx_season_week (season, season_week_num)
);

INSERT INTO weekly_resort_weather (
    resort_name,
    country,
    season,
    season_week_num,
    week_label,
    week_start_date,
    week_end_date,
    avg_temp_max_c,
    avg_temp_min_c,
    total_snowfall_cm,
    avg_snow_depth_m,
    total_sunshine_hours,
    avg_sqi,
    peak_sqi,
    powder_days_count
)
WITH daily_scored AS (
    SELECT 
        resort_name,
        country,
        date,
        temperature_2m_max,
        temperature_2m_min,
        snowfall_sum_cm,
        snow_depth_avg_m,
        sunshine_hours,
        -- Rescaled Daily SQI Formula (0 to 100 Scale)
        LEAST(100, GREATEST(0,
            -- 1. Fresh Snowfall Component (Max 40 pts)
            LEAST(40, snowfall_sum_cm * 4.0) +
            
            -- 2. Snow Depth Base Component (Max 30 pts)
            LEAST(30, snow_depth_avg_m * 20.0) +
            
            -- 3. Powder Day Bonus Component (15 pts if >= 10cm fresh snow)
            (CASE WHEN snowfall_sum_cm >= 10 THEN 15 ELSE 0 END) +
            
            -- 4. Temperature / Sunshine Comfort Component (Max 15 pts)
            (CASE 
                WHEN temperature_2m_max BETWEEN -8 AND 1 THEN 10
                WHEN temperature_2m_max BETWEEN -12 AND 4 THEN 5
                ELSE 0 
             END) +
            LEAST(5, sunshine_hours * 0.8)
        )) AS daily_sqi,
        CASE 
            WHEN MONTH(date) >= 12 THEN YEAR(date)
            WHEN MONTH(date) <= 4 THEN YEAR(date) - 1
            ELSE NULL 
        END AS season_start_year,
        CASE 
            WHEN MONTH(date) >= 12 THEN STR_TO_DATE(CONCAT(YEAR(date), '-12-01'), '%Y-%m-%d')
            WHEN MONTH(date) <= 4 THEN STR_TO_DATE(CONCAT(YEAR(date) - 1, '-12-01'), '%Y-%m-%d')
            ELSE NULL 
        END AS season_anchor
    FROM daily_resort_weather
    WHERE MONTH(date) IN (12, 1, 2, 3, 4)
),
week_calculated AS (
    SELECT 
        *,
        FLOOR(DATEDIFF(date, season_anchor) / 7) + 1 AS season_week_num,
        CONCAT(RIGHT(season_start_year, 2), '/', RIGHT(season_start_year + 1, 2)) AS season,
        DATE_ADD(season_anchor, INTERVAL (FLOOR(DATEDIFF(date, season_anchor) / 7) * 7) DAY) AS week_start_date
    FROM daily_scored
    WHERE season_anchor IS NOT NULL
)
SELECT 
    resort_name,
    country,
    season,
    season_week_num,
    CONCAT(
        'Wk ', season_week_num, ' ', season, ' (',
        DATE_FORMAT(week_start_date, '%b %d'), ' - ',
        DATE_FORMAT(DATE_ADD(week_start_date, INTERVAL 6 DAY), '%b %d'), ')'
    ) AS week_label,
    week_start_date,
    DATE_ADD(week_start_date, INTERVAL 6 DAY) AS week_end_date,
    ROUND(AVG(temperature_2m_max), 1) AS avg_temp_max_c,
    ROUND(AVG(temperature_2m_min), 1) AS avg_temp_min_c,
    ROUND(SUM(snowfall_sum_cm), 1) AS total_snowfall_cm,
    ROUND(AVG(snow_depth_avg_m), 2) AS avg_snow_depth_m,
    ROUND(SUM(sunshine_hours), 1) AS total_sunshine_hours,
    ROUND(AVG(daily_sqi), 2) AS avg_sqi,
    ROUND(MAX(daily_sqi), 2) AS peak_sqi,
    SUM(CASE WHEN snowfall_sum_cm >= 10 THEN 1 ELSE 0 END) AS powder_days_count
FROM week_calculated
WHERE season_week_num BETWEEN 1 AND 22
GROUP BY 
    resort_name,
    country,
    season,
    season_start_year,
    season_week_num,
    week_start_date;