-- Source table (new + existing data)
CREATE TABLE SourceTable (
    EmpID INT,
    EmpName VARCHAR(50)
);

-- Target table (only existing data)
CREATE TABLE TargetTable (
    EmpID INT,
    EmpName VARCHAR(50)
);

-- SourceTable has all data
INSERT INTO SourceTable VALUES
(1, 'A'),
(2, 'B'),
(3, 'C'),
(4, 'D');
select *from SourceTable;

-- TargetTable has only some of the data
INSERT INTO TargetTable VALUES
(1, 'A'),
(2, 'B');
select *from TargetTable;

INSERT INTO TargetTable (EmpID, EmpName)
SELECT EmpID, EmpName
FROM SourceTable
WHERE NOT EXISTS (
    SELECT 1
    FROM TargetTable
    WHERE TargetTable.EmpID = SourceTable.EmpID
);
