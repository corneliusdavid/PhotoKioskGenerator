--
-- File generated with SQLiteStudio v3.0.6 on Sun Nov 1 08:49:53 2015
--
-- Text encoding used: windows-1252
--
PRAGMA foreign_keys = off;
BEGIN TRANSACTION;

-- Table: Names
CREATE TABLE Names (ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE, Surname STRING (50), PrimaryNames STRING (100), SecondaryNames STRING (100), PictureName STRING (100), LastUpdated DATETIME);

-- Index: PrimaryNames
CREATE INDEX PrimaryNames ON Names (PrimaryNames COLLATE NOCASE ASC);

-- Index: SecondaryNames
CREATE INDEX SecondaryNames ON Names (SecondaryNames COLLATE NOCASE ASC);

-- Index: Surname
CREATE INDEX Surname ON Names (Surname COLLATE NOCASE ASC);

COMMIT TRANSACTION;
PRAGMA foreign_keys = on;
