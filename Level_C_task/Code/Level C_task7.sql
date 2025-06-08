WITH Numbers AS (
    SELECT 2 AS n
    UNION ALL
    SELECT n + 1 FROM Numbers WHERE n + 1 <= 1000
),
Divisors AS (
    SELECT a.n, b.n AS d
    FROM Numbers a
    JOIN Numbers b ON b.n < a.n
),
NonPrimes AS (
    SELECT DISTINCT n
    FROM Divisors
    WHERE n % d = 0
),
Primes AS (
    SELECT n FROM Numbers
    WHERE n NOT IN (SELECT n FROM NonPrimes)
)
SELECT STRING_AGG(CAST(n AS VARCHAR), '&') AS PrimeNumbers
FROM Primes
OPTION (MAXRECURSION 1000);
