SELECT
    type_id,
    COUNT(*) AS total_policies
FROM
    public.policies
GROUP BY
    type_id
ORDER BY
    type_id ASC;
