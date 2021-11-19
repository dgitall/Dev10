-- Prior to this, the denormalized souvenirs data was loaded into a TempSouvenirs table
-- using the SQL Server Import extension

use Souvenirs
SELECT * FROM TempSouvenirs

-- Go through and fill in the basic data blocks

-- Owner Table
-- Test select to get the unique group names
SELECT distinct Owner
from TempSouvenirs
-- Do an insert using that selection to fill out the owner table
-- The select pulls out the names of different owner names. The insert puts that into the Name in Owner table
-- NOTE: The ID is an identity so it auto fills with incrementing values and we don't add it.
insert into Owner ([Name])    
    SELECT DISTINCT Owner
    FROM TempSouvenirs;
-- Confirm.
SELECT * FROM Owner;


-- Category Table
-- Test select to get the unique category names
SELECT distinct Category
from TempSouvenirs
-- Do an insert using that selection to fill out the owner table
-- The select pulls out the names of different owner names. The insert puts that into the Name in Owner table
-- NOTE: The ID is an identity so it auto fills with incrementing values and we don't add it.
-- NOTE: I added a description field because it may be useful later. However, there is no data in the file
--      so they are all NULL.
insert into Category ([Name])    
    SELECT distinct Category
    from TempSouvenirs
-- Confirm.
SELECT * FROM Category;


-- TravelLocation Table
-- Test select to get the unique travel locations. This looks for distinct combinations across all fields which
-- should work for cases like where you have multiple cities with the same name in a country but they are in different
-- regions. The city, region, and courty values that are empty are changed to [Unknown] since they probably exists
-- when the location is specified by the Long/Lat but it isn't known from this data set. Also, note that the cases 
-- where there is no location are returned with [Unknown]/NULL for all values. We add that as a separate location
-- in case that needs to be updated latest to specify online or Steam. If that's the case, it is easier to do that
-- here than to allow a nullable feature key in the Souvenir table and have to update every souvenir.
SELECT distinct isnull(City, '[Unknown]'), 
                isnull(Region, '[Unknown]'),
                isnull(Country, '[Unknown]'),Longitude,Latitude
from TempSouvenirs
-- Do an insert using that selection to fill out the TravelLocation table
insert into TravelLocation (City, Region, Country, Longitude, Latitude)    
    SELECT distinct isnull(City, '[Unknown]'), 
                    isnull(Region, '[Unknown]'),
                    isnull(Country, '[Unknown]'),Longitude,Latitude
    from TempSouvenirs
-- Confirm.
SELECT * FROM TravelLocation;


-- Fill in the Souvenir table
-- The complexity here is that there are three foreign keys that we need to match to. 
-- We will do a JOIN with the Owner table to get the OwnerID and a JOIN with the Category table
-- to get the CategoryID, and a JOIN with the TravelLocation table to get the TravelLocationID.
-- Note: JOINs do not handle NULL data in the comparisons well. In fact, it just doesn't work.
-- I got around that by converting the latitude and longitude to 9999 if any of the values are null.
-- This is outside of the possible values for lat/long so it allows a proper conparison and won't conflict
-- with any future realistic values. 
SELECT  O.OwnerID, TL.TravelLocationID, C.CategoryID, Souvenir_Name, Souvenir_Description, Weight, Price, convert(date, DateObtained, 21) AS DateObtained
FROM TempSouvenirs AS TS
JOIN Owner AS O ON O.Name = TS.Owner
JOIN TravelLocation AS TL ON
    TL.City = isnull(TS.City, '[Unknown]') AND TL.Region = isnull(TS.Region, '[Unknown]') AND
    TL.Country = isnull(TS.Country, '[Unknown]') AND
    isnull(TL.Latitude,9999) = isnull(TS.Latitude,9999)
   AND    isnull(TL.Longitude,9999) = isnull(TS.Longitude,9999)
JOIN Category AS C ON C.Name = TS.Category
-- Use this test query to now populate the Souvenir table
insert into Souvenir (OwnerID, TravelLocationID, CategoryID, [Name], Description, Weight, Price, DateObtained)    
    SELECT  OwnerID, TravelLocationID, CategoryID, Souvenir_Name, Souvenir_Description, Weight, Price, convert(date, DateObtained, 21) AS DateObtained
    FROM TempSouvenirs AS TS
    JOIN Owner AS O ON O.Name = TS.Owner
    JOIN TravelLocation AS TL ON
        TL.City = isnull(TS.City, '[Unknown]') AND TL.Region = isnull(TS.Region, '[Unknown]') AND
        TL.Country = isnull(TS.Country, '[Unknown]') AND
        isnull(TL.Latitude,9999) = isnull(TS.Latitude,9999)
    AND    isnull(TL.Longitude,9999) = isnull(TS.Longitude,9999)
    JOIN Category AS C ON C.Name = TS.Category

-- Confirm.
SELECT * FROM Souvenir;

select * FROM TempSouvenirs