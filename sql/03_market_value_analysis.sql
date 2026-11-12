
-- =====================================================
-- FIFA 21 Player Analytics & Scouting Dashboard
-- File: 03_market_value_analysis.sql
-- Purpose: Market value, wage and recruitment analysis
-- Database: PostgreSQL
-- =====================================================

-- 1. Top 10 most valuable players
-- Business Question:
-- Which players have the highest market values?

SELECT
    short_name,
    age,
    club_name,
    primary_position,
    overall,
    potential,
    market_value_eur,
    wage_eur
FROM public.fifa_players_clean
WHERE market_value_eur IS NOT NULL
ORDER BY market_value_eur DESC, player_id
LIMIT 10;


-- 2. Market value and wages by player rating
-- Business Question:
-- How do player valuations and wages differ
-- across performance categories?

SELECT
    CASE
        WHEN overall >= 85 THEN 'Elite (85+)'
        WHEN overall >= 75 THEN 'High (75-84)'
        WHEN overall >= 65 THEN 'Mid (65-74)'
        ELSE 'Developing (<65)'
    END AS rating_category,

    COUNT(*) AS total_players,

    ROUND(AVG(market_value_eur) / 1000000, 2)
        AS avg_market_value_million,

    ROUND(AVG(wage_eur) / 1000, 2)
        AS avg_wage_thousand

FROM public.fifa_players_clean
GROUP BY rating_category
ORDER BY avg_market_value_million DESC;


-- 3. Affordable high-performing players
-- Business Question:
-- Which players have an overall rating of 75+
-- and market value of EUR 15 million or less?

SELECT
    short_name,
    age,
    club_name,
    primary_position,
    overall,
    potential,
    market_value_eur,
    wage_eur
FROM public.fifa_players_clean
WHERE overall >= 75
  AND market_value_eur BETWEEN 1 AND 15000000
ORDER BY overall DESC,
         market_value_eur ASC,
         player_id
LIMIT 20;


-- 4. Top 5 affordable players by position
-- Business Question:
-- Who are the strongest players in each position
-- with a market value of EUR 10 million or less?

WITH affordable_players AS (
    SELECT
        short_name,
        age,
        primary_position,
        overall,
        potential,
        market_value_eur,

        ROW_NUMBER() OVER (
            PARTITION BY primary_position
            ORDER BY overall DESC,
                     market_value_eur ASC,
                     player_id
        ) AS position_rank

    FROM public.fifa_players_clean
    WHERE market_value_eur BETWEEN 1 AND 10000000
      AND overall >= 70
      AND NULLIF(TRIM(primary_position), '') IS NOT NULL
)

SELECT *
FROM affordable_players
WHERE position_rank <= 5
ORDER BY primary_position, position_rank;
