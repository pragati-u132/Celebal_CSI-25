CREATE TABLE Functions (
    x INT,
    y INT
);

INSERT INTO Functions (x, y) VALUES
(20, 20),
(20, 20),
(20, 21),
(23, 22),
(22, 23),
(21, 20);
select *from Functions;

SELECT DISTINCT f1.x, f1.y
FROM Functions f1
JOIN Functions f2 ON f1.x = f2.y AND f1.y = f2.x
WHERE f1.x <= f1.y
ORDER BY f1.x;
