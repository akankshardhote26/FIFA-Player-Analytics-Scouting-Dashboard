
-- =====================================================
-- FIFA 21 Player Analytics & Scouting Dashboard
-- File: 04_club_league_analysis.sql
-- Purpose: Club and league performance analysis
-- Database: PostgreSQL
-- =====================================================

-- 1. Top 10 clubs by total squad market value
-- Business Question:
-- Which clubs have the highest estimated squad values?

SELECT
    club_name,
    COUNT(*) AS total_players,
    ROUND(AVG(overall), 2) AS avg_overall,
    ROUND(SUM(market_value_eur) / 1000000, 2)
        AS squad_value_million_eur
FROM public.fifa_players_clean
WHERE NULLIF(TRIM(club_name), '') IS NOT NULL
GROUP BY club_name
ORDER BY squad_value_million_eur DESC
LIMIT 10;


-- 2. Top 10 leagues by average player rating
-- Business Question:
-- Which leagues have the highest average ratings
-- among leagues with at least 100 players?

SELECT
    league_name,
    COUNT(*) AS total_players,
    ROUND(AVG(overall), 2) AS avg_overall_rating,
    ROUND(AVG(potential), 2) AS avg_potential_rating,
    ROUND(SUM(market_value_eur) / 1000000000, 2)
        AS total_market_value_billion_eur
FROM public.fifa_players_clean
WHERE NULLIF(TRIM(league_name), '') IS NOT NULL
GROUP BY league_name
HAVING COUNT(*) >= 100
ORDER BY avg_overall_rating DESC
LIMIT 10;


-- 3. Clubs with the most high-potential young players
-- Business Question:
-- Which clubs have the largest number of players
-- aged 23 or younger with potential >= 85?

SELECT
    club_name,
    COUNT(*) AS high_potential_young_players,
    ROUND(AVG(potential), 2) AS avg_potential,
    ROUND(AVG(growth_potential), 2)
        AS avg_growth_potential
FROM public.fifa_players_clean
WHERE age <= 23
  AND potential >= 85
  AND NULLIF(TRIM(club_name), '') IS NOT NULL
GROUP BY club_name
ORDER BY high_potential_young_players DESC,
         avg_potential DESC
LIMIT 15;


-- 4. Compare average wages across leagues
-- Business Question:
-- Which leagues have the highest average player wages?

SELECT
    league_name,
    COUNT(*) AS total_players,
    ROUND(AVG(wage_eur), 2) AS avg_wage_eur,
    ROUND(MAX(wage_eur), 2) AS highest_wage_eur,
    ROUND(AVG(market_value_eur) / 1000000, 2)
        AS avg_market_value_million_eur
FROM public.fifa_players_clean
WHERE NULLIF(TRIM(league_name), '') IS NOT NULL
  AND wage_eur IS NOT NULL
GROUP BY league_name
HAVING COUNT(*) >= 100
ORDER BY avg_wage_eur DESC
LIMIT 10;
