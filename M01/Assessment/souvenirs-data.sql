-- Prior to this, the denormalized souvenirs data was loaded into a TempSouvenirs table
-- using the SQL Server Import extension using all of the suggested data type settings

use Souvenirs
SELECT * FROM TempSouvenirs

-- Go through and fill in the basic data blocks

-- Owner Table
-- Test select to get the unique group names
SELECT DISTINCT Owner
FROM TempSouvenirs
-- Do an INSERT using that selection to fill out the owner table
-- The select pulls out the names of different owner names. The INSERT puts that into the Name in Owner table
-- NOTE: The ID is an identity so it auto fills with incrementing values and we don't add it.
INSERT INTO Owner ([Name])    
    SELECT DISTINCT Owner
    FROM TempSouvenirs;
-- Confirm.
SELECT * FROM Owner;


-- Category Table
-- Test select to get the unique category names
SELECT DISTINCT Category
FROM TempSouvenirs
-- Do an INSERT using that selection to fill out the owner table
-- The select pulls out the names of different owner names. The INSERT puts that into the Name in Owner table
-- NOTE: The ID is an identity so it auto fills with incrementing values and we don't add it.
-- NOTE: I added a description field because it may be useful later. However, there is no data in the file
--      so they are all NULL.
INSERT INTO Category ([Name])    
    SELECT DISTINCT Category
    FROM TempSouvenirs
-- Confirm.
SELECT * FROM Category;


-- TravelLocation Table
-- Test select to get the unique travel locations. This looks for DISTINCT combinations across all fields which
-- should work for cases like where you have multiple cities with the same name in a country but they are in different
-- regions. The city, region, and courty values that are empty are changed to [Unknown] since they probably exists
-- when the location is specified by the Long/Lat but it isn't known FROM this data set. Also, note that the cases 
-- where there is no location are returned with [Unknown]/NULL for all values. We add that as a separate location
-- in case that needs to be updated latest to specify online or Steam. If that's the case, it is easier to do that
-- here than to allow a nullable feature key in the Souvenir table and have to update every souvenir.
SELECT DISTINCT isnull(City, '[Unknown]'), 
                isnull(Region, '[Unknown]'),
                isnull(Country, '[Unknown]'),Longitude,Latitude
FROM TempSouvenirs
-- Do an INSERT using that selection to fill out the TravelLocation table
INSERT INTO TravelLocation (City, Region, Country, Longitude, Latitude)    
    SELECT DISTINCT isnull(City, '[Unknown]'), 
                    isnull(Region, '[Unknown]'),
                    isnull(Country, '[Unknown]'),Longitude,Latitude
    FROM TempSouvenirs
-- Confirm.
SELECT * FROM TravelLocation;


-- Fill in the Souvenir table
-- The complexity here is that there are three foreign keys that we need to match to. 
-- We will do a JOIN with the Owner table to get the OwnerID, a JOIN with the Category table
-- to get the CategoryID, and a JOIN with the TravelLocation table to get the TravelLocationID.
-- Note: JOINs do not handle NULL data in the comparisons well. In fact, it just doesn't work.
-- I got around that by converting the latitude and longitude to 9999 if any of the values are null.
-- This is outside of the possible values for lat/long so it allows a proper conparison and won't conflict
-- with any future realistic values. 
SELECT  O.OwnerID, 
    TL.TravelLocationID, 
    C.CategoryID, 
    TS.Souvenir_Name, 
    TS.Souvenir_Description, 
    TS.Weight, 
    TS.Price AS Price, 
    CAST(TS.DateObtained AS datetime2) AS DateObtained
FROM TempSouvenirs AS TS
JOIN Owner AS O ON O.Name = TS.Owner
JOIN TravelLocation AS TL ON
    TL.City = isnull(TS.City, '[Unknown]') AND TL.Region = isnull(TS.Region, '[Unknown]') AND
    TL.Country = isnull(TS.Country, '[Unknown]') AND
    isnull(TL.Latitude,9999) = isnull(TS.Latitude,9999)
AND    isnull(TL.Longitude,9999) = isnull(TS.Longitude,9999)
JOIN Category AS C ON C.Name = TS.Category
-- Use this test query to now populate the Souvenir table
INSERT INTO Souvenir (OwnerID, TravelLocationID, CategoryID, [Name], Description, Weight, Price, DateObtained)    
    SELECT  O.OwnerID, 
        TL.TravelLocationID, 
        C.CategoryID, 
        TS.Souvenir_Name, 
        TS.Souvenir_Description, 
        TS.Weight, 
        TS.Price AS Price, 
        CAST(TS.DateObtained AS datetime2) AS DateObtained
    FROM TempSouvenirs AS TS
    JOIN Owner AS O ON O.Name = TS.Owner
    JOIN TravelLocation AS TL ON
        TL.City = isnull(TS.City, '[Unknown]') AND TL.Region = isnull(TS.Region, '[Unknown]') AND
        TL.Country = isnull(TS.Country, '[Unknown]') AND
        isnull(TL.Latitude,9999) = isnull(TS.Latitude,9999) AND
        isnull(TL.Longitude,9999) = isnull(TS.Longitude,9999)
    JOIN Category AS C ON C.Name = TS.Category
-- Confirm.
SELECT * FROM Souvenir;



-- Testing and Validation
-- Reconstruct the original dataset FROM the Souvenir Database. Export this and compare externally to make sure they match.
-- This confirms that we didn't lose or mangle any data in transferring it into the database. 
-- NOTE: I used this tutorial on how to programmatically compare two Excel files for differences. 
-- https://trumpexcel.com/compare-two-excel-sheets/. There are differences in the formatting of header titles and including
-- NULL for empty values. However, all other data matches exactly. 
SELECT
    S.Name As Souvenier_Name,
    S.[Description] AS Souvenier_Description,
    C.Name AS Category,
    nullif(TL.City, '[Unknown]') AS City,
    nullif(TL.Region, '[Unknown]') AS Region,
    nullif(TL.Country, '[Unknown]') AS Country,
    O.Name AS Owner,
    TL.Longitude AS Longitude,
    TL.Latitude AS Latitude,
    Price AS Price,
    Weight AS Weight,
    FORMAT(DateObtained,'yyyy-MM-ddTHH:mm:ss.fffffff')  AS DateObtained
    FROM Souvenir AS S
    JOIN Category AS C ON S.CategoryID = C.CategoryID
    JOIN Owner AS O ON S.OwnerID = O.OwnerID
    JOIN TravelLocation AS TL ON S.TravelLocationID = TL.TravelLocationID;


-- We are finished loading data so remove the tempory data table
drop table TempSouvenirs;

-- Update
-- 1
-- Video games need to be seperated FROM the Toy category
-- * Add a new Video Game category
-- * Update souvenirs that are video games with the new category
INSERT INTO Category ([Name])    
    SELECT 'Video Game'
-- Confirm.
SELECT * FROM Category;

UPDATE Souvenir 
    SET CategoryID = (SELECT CategoryID FROM Category WHERE [Name]='Video Game')
WHERE SouvenirID IN (
        SELECT SouvenirID
        FROM Souvenir AS S
        JOIN Category AS C ON C.CategoryID = S.CategoryID
        WHERE (C.Name = 'Toy') AND S.[Description] LIKE '%Video game%')
-- Confirm
SELECT SouvenirID, S.Name, S.[Description], C.Name
FROM Souvenir AS S
JOIN Category AS C ON C.CategoryID = S.CategoryID
WHERE S.[Description] LIKE '%Video game%'

-- 2
-- Jewelry boxes should be recategorized as Miscellaneous
UPDATE Souvenir
    SET CategoryID = (SELECT CategoryID FROM Category WHERE [Name]='Miscellaneous')
WHERE SouvenirID IN (
        SELECT SouvenirID
        FROM Souvenir AS S
        WHERE S.[Name] LIKE '%Jewelry Box%')
-- Confirm
SELECT SouvenirID, S.[Name], C.CategoryID, C.[Name]
 FROM Souvenir AS S
 JOIN Category AS C ON C.CategoryID = S.CategoryID
WHERE S.[Name] LIKE '%Jewelry Box%'  

-- 3
-- Shamisen, Egyptian Drum, and Zuffolo need to be broken out as Musical Instruments.
-- Find them first and notice they are set as Miscellaneous now
SELECT SouvenirID, S.[Name], C.CategoryID, C.[Name]
 FROM Souvenir AS S
 JOIN Category AS C ON C.CategoryID = S.CategoryID
WHERE S.[Name] IN ('Shamisen', 'Egyptian Drum', 'Zuffolo')
-- Check to see if there is already a category for Musical Instruments
  SELECT * FROM Category
-- There is no musical instrument category so add that to the list, first.
INSERT INTO Category ([Name])    
    SELECT 'Musical Instrument'
-- Confirm.
SELECT * FROM Category;
-- Update the category
UPDATE Souvenir
    SET CategoryID = (SELECT CategoryID FROM Category WHERE [Name]='Musical Instrument')
WHERE SouvenirID IN (
        SELECT SouvenirID
        FROM Souvenir AS S
        WHERE S.[Name] IN ('Shamisen', 'Egyptian Drum', 'Zuffolo'))
-- Confirm
SELECT SouvenirID, S.[Name], C.CategoryID, C.[Name]
 FROM Souvenir AS S
 JOIN Category AS C ON C.CategoryID = S.CategoryID
WHERE S.[Name] IN ('Shamisen', 'Egyptian Drum', 'Zuffolo')


-- Delete
-- 1
-- Delete the souvenir that is the heaviest. This is causing trouble in graphing data and is
-- an outlier we want to exclude.
-- See which one it is
SELECT SouvenirID, S.[Name], Weight
 FROM Souvenir AS S
 WHERE Weight =  (
     SELECT MAX(Weight) FROM Souvenir)
-- Delete the souvenir we just found
DELETE FROM Souvenir
where SouvenirID = (
    SELECT SouvenirID
    FROM Souvenir AS S
    WHERE Weight =  (
        SELECT MAX(Weight) FROM Souvenir))
-- Confirm that the max weight is no longer the same as before deleting
SELECT SouvenirID, S.[Name], Weight
 FROM Souvenir AS S
 WHERE Weight =  (
     SELECT MAX(Weight) FROM Souvenir)

-- 2
-- Delete all souvenirs that are dirt or sand
-- See what we have
SELECT SouvenirID, [Name], Description
 FROM Souvenir 
 WHERE ([Name] LIKE '%dirt%') OR ([Name] LIKE '%sand%')
 -- Delete the souvenirs we just found
DELETE FROM Souvenir
where SouvenirID IN (
    SELECT SouvenirID
    FROM Souvenir 
    WHERE ([Name] LIKE '%dirt%') OR ([Name] LIKE '%sand%'))
-- Confirm
SELECT SouvenirID, [Name], Description
 FROM Souvenir 
 WHERE ([Name] LIKE '%dirt%') OR ([Name] LIKE '%sand%')