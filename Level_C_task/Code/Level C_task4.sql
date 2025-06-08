CREATE TABLE Contests (
    contest_id INT,
    hacker_id INT,
    name VARCHAR(50)
);

CREATE TABLE Colleges (
    college_id INT,
    contest_id INT
);

CREATE TABLE Challenges (
    challenge_id INT,
    college_id INT
);

CREATE TABLE View_Stats (
    challenge_id INT,
    total_views INT,
    total_unique_views INT
);

CREATE TABLE Submission_Stats (
    challenge_id INT,
    total_submissions INT,
    total_accepted_submissions INT
);

-- Contests
INSERT INTO Contests VALUES
(66406, 17973, 'Rose'),
(66556, 79153, 'Angela'),
(94828, 80275, 'Frank');
select *from Contests;

-- Colleges
INSERT INTO Colleges VALUES
(11219, 66406),
(32473, 66556),
(56685, 94828);
select *from Colleges;

-- Challenges
INSERT INTO Challenges VALUES
(47127, 11219),
(18765, 11219),
(60292, 32473),
(72974, 56685);
select *from Challenges;

-- View_Stats
INSERT INTO View_Stats VALUES
(47127, 26, 19),
(47127, 15, 14),
(18765, 43, 10),
(18765, 72, 13),
(60292, 11, 10),
(72974, 41, 15);
select *from View_Stats;

-- Submission_Stats
INSERT INTO Submission_Stats VALUES
(47127, 27, 10),
(47127, 56, 18),
(18765, 43, 10),
(18765, 72, 13),
(60292, 11, 10),
(72974, 68, 24),
(72974, 82, 14);
select *from Submission_Stats;

SELECT 
    c.contest_id,
    c.hacker_id,
    c.name,
    ISNULL(SUM(ss.total_submissions), 0) AS total_submissions,
    ISNULL(SUM(ss.total_accepted_submissions), 0) AS total_accepted_submissions,
    ISNULL(SUM(vs.total_views), 0) AS total_views,
    ISNULL(SUM(vs.total_unique_views), 0) AS total_unique_views
FROM Contests c
JOIN Colleges col ON c.contest_id = col.contest_id
JOIN Challenges ch ON col.college_id = ch.college_id
LEFT JOIN Submission_Stats ss ON ch.challenge_id = ss.challenge_id
LEFT JOIN View_Stats vs ON ch.challenge_id = vs.challenge_id
GROUP BY c.contest_id, c.hacker_id, c.name
HAVING 
    SUM(ISNULL(ss.total_submissions, 0)) > 0 OR 
    SUM(ISNULL(ss.total_accepted_submissions, 0)) > 0 OR 
    SUM(ISNULL(vs.total_views, 0)) > 0 OR 
    SUM(ISNULL(vs.total_unique_views, 0)) > 0
ORDER BY c.contest_id;
