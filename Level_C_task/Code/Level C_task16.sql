-- 1. Create Table
CREATE TABLE SwapExample (
    ID INT,
    Col1 INT,
    Col2 INT
);

-- 2. Insert Dummy Data
INSERT INTO SwapExample VALUES
(1, 10, 20),
(2, 30, 40),
(3, 50, 60);

-- 3. View Before Swap
SELECT * FROM SwapExample;

-- swap
WITH SwapData AS (
    SELECT ID, Col1, Col2
    FROM SwapExample
)
UPDATE SwapExample
SET Col1 = SwapData.Col2,
    Col2 = SwapData.Col1
FROM SwapExample
JOIN SwapData ON SwapExample.ID = SwapData.ID;
select *from SwapExample;