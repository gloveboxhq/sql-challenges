SELECT
    c.id AS carrier_id,
    c.full_name AS carrier_name,
    COUNT(p.id) AS total_policies
FROM
    public.carriers c
LEFT JOIN
    public.policies p ON c.id = p.carrier_id
GROUP BY
    c.id, c.full_name
ORDER BY
    c.id ASC;
