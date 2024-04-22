SELECT
    u.name AS user_name,
    COUNT(p.id) AS policy_count
FROM
    public.users u
LEFT JOIN
    public.policies p ON u.id = p.user_id
GROUP BY
    u.id, u.name
ORDER BY
    policy_count DESC
LIMIT
    10;
