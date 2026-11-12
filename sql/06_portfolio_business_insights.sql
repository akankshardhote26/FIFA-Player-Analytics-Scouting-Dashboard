-- FIFA 21 Portfolio: Final Business Insights

WITH insights AS (

    -- Top 5 clubs by estimated squad value
    SELECT
        'Top Club by Squad Value' AS analysis,
        club_name AS category,
        ROUND(SUM(market_value_eur) / 1000000, 2)
            AS metric_value,
        'EUR millions' AS unit
    FROM public.fifa_players_clean
    WHERE NULLIF(TRIM(club_name), '') IS NOT NULL
    GROUP BY club_name
    ORDER BY metric_value DESC
    LIMIT 5
)
SELECT *
FROM insights

UNION ALL

SELECT *
FROM (
    -- Top 5 leagues by average rating
    SELECT
        'Top League by Avg Rating' AS analysis,
        league_name AS category,
        ROUND(AVG(overall), 2) AS metric_value,
        'rating points' AS unit
    FROM public.fifa_players_clean
    WHERE NULLIF(TRIM(league_name), '') IS NOT NULL
    GROUP BY league_name
    HAVING COUNT(*) >= 100
    ORDER BY metric_value DESC
    LIMIT 5
) leagues

UNION ALL

SELECT *
FROM (
    -- Market value by player rating segment
    SELECT
        'Market Value by Rating' AS analysis,
        CASE
            WHEN overall >= 85 THEN 'Elite (85+)'
            WHEN overall >= 75 THEN 'High (75-84)'
            WHEN overall >= 65 THEN 'Mid (65-74)'
            ELSE 'Developing (<65)'
        END AS category,
        ROUND(AVG(market_value_eur) / 1000000, 2)
            AS metric_value,
        'EUR millions' AS unit
    FROM public.fifa_players_clean
    GROUP BY category
    ORDER BY metric_value DESC
) segments

UNION ALL

SELECT *
FROM (
    -- Top 5 young recruitment candidates
    SELECT
        'Young Talent Candidate' AS analysis,
        short_name AS category,
        potential::NUMERIC AS metric_value,
        'potential rating' AS unit
    FROM public.fifa_players_clean
    WHERE age <= 23
      AND potential >= 80
      AND overall >= 65
      AND market_value_eur BETWEEN 1 AND 15000000
    ORDER BY potential DESC,
             growth_potential DESC,
             market_value_eur ASC,
             player_id
    LIMIT 5
) candidates;
