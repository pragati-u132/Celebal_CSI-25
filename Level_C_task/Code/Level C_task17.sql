CREATE LOGIN TestLogin 
WITH PASSWORD = 'Test@1234';


CREATE USER TestUser 
FOR LOGIN TestLogin;

EXEC sp_addrolemember 
    @rolename = 'db_owner', 
    @membername = 'TestUser';

    -- List all members of db_owner role
SELECT dp1.name AS DatabaseRoleName, dp2.name AS MemberName
FROM sys.database_role_members AS drm
JOIN sys.database_principals AS dp1 ON drm.role_principal_id = dp1.principal_id
JOIN sys.database_principals AS dp2 ON drm.member_principal_id = dp2.principal_id
WHERE dp1.name = 'db_owner';
