CREATE TABLE STATION (
    ID INT,
    CITY VARCHAR(21),
    STATE VARCHAR(2),
    LAT_N FLOAT,
    LONG_W FLOAT
);

INSERT INTO STATION (ID, CITY, STATE, LAT_N, LONG_W) VALUES
(1, 'Alpha', 'AA', 37.77, 122.42),
(2, 'Beta',  'BB', 41.88, 87.62),
(3, 'Gamma', 'CC', 25.76, 80.19),
(4, 'Delta', 'DD', 47.60, 122.33),
(5, 'Epsilon', 'EE', 30.26, 97.74);
select *from STATION;

SELECT 
    ROUND(
        ABS(MAX(LAT_N) - MIN(LAT_N)) + ABS(MAX(LONG_W) - MIN(LONG_W)), 
        4
    ) AS Manhattan_Distance
FROM STATION;

