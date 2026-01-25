SET NOCOUNT ON;

IF DB_ID(N'$(DB_NAME)') IS NULL
BEGIN
    PRINT N'Creating database $(DB_NAME)...';
    CREATE DATABASE [$(DB_NAME)];
END
GO

IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name = N'$(DB_APP_USER)')
BEGIN
    PRINT N'Creating login $(DB_APP_USER)...';
    CREATE LOGIN [$(DB_APP_USER)] WITH PASSWORD = N'$(DB_APP_PASSWORD)', CHECK_POLICY = OFF;
END
GO

USE [$(DB_NAME)];
GO

IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name = N'$(DB_APP_USER)')
BEGIN
    PRINT N'Creating user $(DB_APP_USER)...';
    CREATE USER [$(DB_APP_USER)] FOR LOGIN [$(DB_APP_USER)];
END
GO

IF IS_ROLEMEMBER('db_datareader', '$(DB_APP_USER)') <> 1
BEGIN
    ALTER ROLE db_datareader ADD MEMBER [$(DB_APP_USER)];
END
GO

IF IS_ROLEMEMBER('db_datawriter', '$(DB_APP_USER)') <> 1
BEGIN
    ALTER ROLE db_datawriter ADD MEMBER [$(DB_APP_USER)];
END
GO

IF IS_ROLEMEMBER('db_ddladmin', '$(DB_APP_USER)') <> 1
BEGIN
    ALTER ROLE db_ddladmin ADD MEMBER [$(DB_APP_USER)];
END
GO
