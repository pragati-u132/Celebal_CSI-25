CREATE TABLE BST (
    N INT,
    P INT
);

INSERT INTO BST (N, P) VALUES
(7, 2),
(3, 2),
(6, 8),
(9, 8),
(2, 3),
(8, 5),
(5, NULL);
select *from BST;

SELECT 
    N,
    CASE
        WHEN P IS NULL THEN 'Root'
        WHEN N NOT IN (SELECT DISTINCT P FROM BST WHERE P IS NOT NULL) THEN 'Leaf'
        ELSE 'Inner'
    END AS Node_Type
FROM BST
ORDER BY N;
