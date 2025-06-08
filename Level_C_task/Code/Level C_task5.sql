CREATE TABLE Hackers (
    hacker_id INT,
    name VARCHAR(50)
);

CREATE TABLE Submissions (
    submission_date DATE,
    submission_id INT,
    hacker_id INT,
    score INT
);
-- Hackers Table
INSERT INTO Hackers VALUES
(15758, 'Rose'),
(20703, 'Angela'),
(36396, 'Frank'),
(38289, 'Patrick'),
(44065, 'Lisa'),
(53473, 'Kimberly'),
(62529, 'Bonnie'),
(79722, 'Michael');
select *from Hackers;

-- Submissions Table (sample data from March 1 to 6)
INSERT INTO Submissions VALUES
('2016-03-01', 8494, 20703, 0),
('2016-03-01', 22403, 53473, 15),
('2016-03-01', 23965, 79722, 60),
('2016-03-01', 30173, 36396, 70),
('2016-03-02', 34928, 20703, 10),
('2016-03-02', 38740, 15758, 60),
('2016-03-02', 42769, 79722, 25),
('2016-03-02', 44364, 79722, 60),
('2016-03-03', 45440, 20703, 0),
('2016-03-03', 49050, 36396, 70),
('2016-03-03', 50273, 79722, 5),
('2016-03-04', 50344, 20703, 0),
('2016-03-04', 51360, 44065, 90),
('2016-03-04', 54404, 53473, 65),
('2016-03-04', 61533, 79722, 45),
('2016-03-05', 72852, 20703, 0),
('2016-03-05', 74546, 38289, 0),
('2016-03-05', 76487, 62529, 0),
('2016-03-05', 82439, 36396, 10),
('2016-03-05', 85006, 36396, 40),
('2016-03-06', 90404, 20703, 0);
select *from Submissions;

WITH daily_submission_counts AS (
    SELECT submission_date, hacker_id, COUNT(*) AS submission_count
    FROM Submissions
    GROUP BY submission_date, hacker_id
),
max_submissions AS (
    SELECT submission_date, MAX(submission_count) AS max_sub
    FROM daily_submission_counts
    GROUP BY submission_date
),
top_hackers AS (
    SELECT d.submission_date, d.hacker_id, d.submission_count
    FROM daily_submission_counts d
    JOIN max_submissions m 
        ON d.submission_date = m.submission_date AND d.submission_count = m.max_sub
),
min_hacker_each_day AS (
    SELECT submission_date, MIN(hacker_id) AS hacker_id
    FROM top_hackers
    GROUP BY submission_date
),
unique_hackers AS (
    SELECT submission_date, COUNT(DISTINCT hacker_id) AS total_unique_hackers
    FROM Submissions
    GROUP BY submission_date
)
SELECT 
    s.submission_date,
    u.total_unique_hackers,
    h.hacker_id,
    hk.name
FROM min_hacker_each_day h
JOIN unique_hackers u ON h.submission_date = u.submission_date
JOIN Hackers hk ON h.hacker_id = hk.hacker_id
JOIN Submissions s ON s.submission_date = h.submission_date
GROUP BY s.submission_date, u.total_unique_hackers, h.hacker_id, hk.name
ORDER BY s.submission_date;
