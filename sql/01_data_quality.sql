
-- =====================================================
-- FIFA 21 Player Analytics & Scouting Dashboard
-- File: 01_data_quality.sql
-- Purpose: Data validation, cleaning and transformation
-- Database: PostgreSQL
-- =====================================================

-- 1. Validate total records and unique player IDs
SELECT
    COUNT(*) AS total_players,
    COUNT(DISTINCT sofifa_id) AS unique_players,
    COUNT(*) - COUNT(DISTINCT sofifa_id) AS duplicate_ids
FROM public.players_21_raw;


-- 2. Check missing values in important columns
SELECT
    COUNT(*) FILTER (
        WHERE NULLIF(TRIM(short_name), '') IS NULL
    ) AS missing_names,

    COUNT(*) FILTER (
        WHERE NULLIF(TRIM(overall), '') IS NULL
    ) AS missing_overall,

    COUNT(*) FILTER (
        WHERE NULLIF(TRIM(potential), '') IS NULL
    ) AS missing_potential,

    COUNT(*) FILTER (
        WHERE NULLIF(TRIM(value_eur), '') IS NULL
    ) AS missing_market_value,

    COUNT(*) FILTER (
        WHERE NULLIF(TRIM(club_name), '') IS NULL
    ) AS missing_clubs,

    COUNT(*) FILTER (
        WHERE NULLIF(TRIM(league_name), '') IS NULL
    ) AS missing_leagues
FROM public.players_21_raw;


-- 3. Validate player rating ranges
SELECT
    MIN(overall::INTEGER) AS min_overall,
    MAX(overall::INTEGER) AS max_overall,
    ROUND(AVG(overall::NUMERIC), 2) AS avg_overall,
    MIN(potential::INTEGER) AS min_potential,
    MAX(potential::INTEGER) AS max_potential
FROM public.players_21_raw
WHERE NULLIF(TRIM(overall), '') IS NOT NULL
  AND NULLIF(TRIM(potential), '') IS NOT NULL;


-- 4. Create an analysis-ready player table
-- Recreates the cleaned table from the raw dataset.
-- Run after reviewing the validation results.

DROP TABLE IF EXISTS public.fifa_players_clean;

CREATE TABLE public.fifa_players_clean AS
SELECT
    sofifa_id::INTEGER AS player_id,
    short_name,
    long_name,
    age::INTEGER AS age,
    nationality,
    club_name,
    league_name,
    player_positions,
    TRIM(SPLIT_PART(player_positions, ',', 1))
        AS primary_position,

    overall::INTEGER AS overall,
    potential::INTEGER AS potential,

    potential::INTEGER - overall::INTEGER
        AS growth_potential,

    NULLIF(TRIM(value_eur), '')::NUMERIC
        AS market_value_eur,

    NULLIF(TRIM(wage_eur), '')::NUMERIC
        AS wage_eur,

    NULLIF(TRIM(release_clause_eur), '')::NUMERIC
        AS release_clause_eur,

    preferred_foot

FROM public.players_21_raw;


-- 5. Verify cleaned dataset
SELECT
    COUNT(*) AS total_players,
    COUNT(DISTINCT player_id) AS unique_players,
    ROUND(AVG(overall), 2) AS avg_rating,
    ROUND(AVG(age), 2) AS avg_age,
    ROUND(SUM(market_value_eur) / 1000000000, 2)
        AS total_market_value_billions
FROM public.fifa_players_clean;


-- 6. Preview cleaned player records
SELECT
    player_id,
    short_name,
    age,
    primary_position,
    overall,
    potential,
    growth_potential,
    market_value_eur
FROM public.fifa_players_clean
LIMIT 10;
