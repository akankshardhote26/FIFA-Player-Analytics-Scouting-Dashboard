
-- =====================================================
-- FIFA 21 Player Analytics & Scouting Dashboard
-- File: 05_advanced_scouting.sql
-- Purpose: Advanced recruitment and scouting analysis
-- Database: PostgreSQL
-- =====================================================

-- 1. Players performing above their positional average
-- Business Question:
-- Which players have ratings above their
-- position's average overall rating?

WITH position_averages AS (
    SELECT
        primary_position,
        ROUND(AVG(overall), 2) AS avg_position_rating
    FROM public.fifa_players_clean
    WHERE NULLIF(TRIM(primary_position), '') IS NOT NULL
    GROUP BY primary_position
)
SELECT
    p.short_name,
    p.age,
    p.primary_position,
    p.overall,
    a.avg_position_rating,
    ROUND(
        p.overall - a.avg_position_rating, 2
    ) AS rating_above_average,
    p.market_value_eur
FROM public.fifa_players_clean p
JOIN position_averages a
    ON p.primary_position = a.primary_position
WHERE p.overall > a.avg_position_rating
ORDER BY rating_above_average DESC, p.player_id
LIMIT 20;


-- 2. Value-for-money player analysis
-- Business Question:
-- Which players offer the highest overall
-- rating per EUR 1 million of market value?

WITH player_value AS (
    SELECT
        player_id,
        short_name,
        age,
        primary_position,
        overall,
        potential,
        market_value_eur,

        ROUND(
            overall::NUMERIC /
            NULLIF(market_value_eur / 1000000, 0),
            2
        ) AS value_score

    FROM public.fifa_players_clean
    WHERE market_value_eur > 0
      AND overall >= 70
      AND age <= 28
)
SELECT
    short_name,
    age,
    primary_position,
    overall,
    potential,
    market_value_eur,
    value_score
FROM player_value
ORDER BY value_score DESC,
         overall DESC,
         player_id
LIMIT 20;


-- 3. Young player growth rankings by position
-- Business Question:
-- Which young players have the highest
-- development potential within their position?

WITH talent_ranking AS (
    SELECT
        player_id,
        short_name,
        age,
        primary_position,
        overall,
        potential,
        growth_potential,
        market_value_eur,

        DENSE_RANK() OVER (
            PARTITION BY primary_position
            ORDER BY growth_potential DESC
        ) AS growth_rank

    FROM public.fifa_players_clean
    WHERE age <= 23
      AND potential >= 80
      AND NULLIF(TRIM(primary_position), '') IS NOT NULL
)
SELECT
    short_name,
    age,
    primary_position,
    overall,
    potential,
    growth_potential,
    market_value_eur,
    growth_rank
FROM talent_ranking
WHERE growth_rank <= 5
ORDER BY primary_position,
         growth_rank,
         potential DESC,
         player_id;


-- 4. Final position-based recruitment shortlist
-- Business Question:
-- Which young players offer strong potential
-- within a EUR 15 million valuation threshold?

WITH recruitment_candidates AS (
    SELECT
        player_id,
        short_name,
        age,
        club_name,
        primary_position,
        overall,
        potential,
        growth_potential,
        market_value_eur,

        ROW_NUMBER() OVER (
            PARTITION BY primary_position
            ORDER BY potential DESC,
                     growth_potential DESC,
                     market_value_eur ASC,
                     player_id
        ) AS recruitment_rank

    FROM public.fifa_players_clean
    WHERE age <= 23
      AND potential >= 80
      AND overall >= 65
      AND market_value_eur BETWEEN 1 AND 15000000
      AND NULLIF(TRIM(primary_position), '') IS NOT NULL
)
SELECT
    short_name,
    age,
    club_name,
    primary_position,
    overall,
    potential,
    growth_potential,
    market_value_eur,
    recruitment_rank
FROM recruitment_candidates
WHERE recruitment_rank <= 5
ORDER BY primary_position, recruitment_rank;
