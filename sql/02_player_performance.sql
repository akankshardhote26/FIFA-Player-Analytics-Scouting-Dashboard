
-- =====================================================
-- FIFA 21 Player Analytics & Scouting Dashboard
-- File: 02_player_performance.sql
-- Purpose: Player performance and talent discovery
-- Database: PostgreSQL
-- =====================================================

-- 1. Top 10 highest-rated players
-- Business Question:
-- Who are the highest-rated players in FIFA 21?

SELECT
    short_name,
    age,
    club_name,
    primary_position,
    overall,
    potential,
    market_value_eur
FROM public.fifa_players_clean
ORDER BY overall DESC, potential DESC, player_id
LIMIT 10;


-- 2. Top 5 players in each position
-- Business Question:
-- Who are the best players within each position?

WITH ranked_players AS (
    SELECT
        short_name,
        club_name,
        primary_position,
        overall,
        potential,
        market_value_eur,

        ROW_NUMBER() OVER (
            PARTITION BY primary_position
            ORDER BY overall DESC,
                     potential DESC,
                     player_id
        ) AS position_rank

    FROM public.fifa_players_clean
    WHERE NULLIF(TRIM(primary_position), '') IS NOT NULL
)
SELECT *
FROM ranked_players
WHERE position_rank <= 5
ORDER BY primary_position, position_rank;


-- 3. High-potential young players
-- Business Question:
-- Which players aged 23 or younger have
-- a potential rating of at least 85?

SELECT
    short_name,
    age,
    club_name,
    primary_position,
    overall,
    potential,
    growth_potential,
    market_value_eur
FROM public.fifa_players_clean
WHERE age <= 23
  AND potential >= 85
ORDER BY potential DESC,
         growth_potential DESC,
         player_id;


-- 4. Affordable young talent
-- Business Question:
-- Which young players have strong potential
-- and a market value of EUR 10 million or less?

SELECT
    short_name,
    age,
    club_name,
    primary_position,
    overall,
    potential,
    growth_potential,
    market_value_eur
FROM public.fifa_players_clean
WHERE age <= 23
  AND potential >= 80
  AND market_value_eur BETWEEN 1 AND 10000000
ORDER BY growth_potential DESC,
         market_value_eur ASC,
         player_id;


-- 5. Young talent scouting KPIs
-- Business Question:
-- How large is the high-potential young
-- player pool, and what are its averages?

SELECT
    COUNT(*) AS high_potential_players,

    ROUND(AVG(overall), 2)
        AS avg_current_rating,

    ROUND(AVG(potential), 2)
        AS avg_potential_rating,

    ROUND(AVG(growth_potential), 2)
        AS avg_growth_potential,

    ROUND(AVG(market_value_eur) / 1000000, 2)
        AS avg_market_value_million

FROM public.fifa_players_clean
WHERE age <= 23
  AND potential >= 85;
