-- DQL Assessment
-- Step 3

-- 1
-- Get the 3 most inexpensive souvenirs. Then get the 7 most expensive souvenirs.
SELECT TOP 3 *
FROM Souvenir
ORDER BY Price
SELECT TOP 7 *
FROM Souvenir
ORDER BY Price DESC

-- 2
-- List all mugs, ordered from heaviest to lightest.
SELECT SouvenirID, [Name], Weight
FROM Souvenir
WHERE [Name] LIKE '%Mug%'
ORDER BY Weight DESC

-- 3
-- Count the number of spoons in the collection.
SELECT COUNT(SouvenirID)
FROM Souvenir
WHERE [Name] LIKE '%spoon%'

-- 4
-- Find the average weight, minimum weight, and maximum weight for each category by
-- name. Use meaningful alias names for the aggregates.
SELECT C.CategoryID, C.[Name], AVG(Weight) AS AvgWeight, MIN(Weight) AS MinWeight, MAX(Weight) AS MaxWeight
FROM Souvenir AS S
JOIN Category AS C ON S.CategoryID = C.CategoryID
GROUP BY C.CategoryID, C.[Name]

-- 5
-- List all kitchenware souvenirs and their general location fields - including city name,
-- region name, country name, longitude, and latitude - without duplication.
-- Note: It is unclear in the question what exactly shouldn't be duplicated. The assumption here
-- is that we will not return the same souvenir more than once in the query. This seems trivial with the 
-- current database configuration, but it was tricky to load the data to not duplicate the locations. 
SELECT DISTINCT SouvenirID, S.[Name], C.Name, TL.City, TL.Region, TL.Country, TL.Longitude, TL.Latitude
FROM Souvenir AS S
JOIN TravelLocation AS TL ON S.TravelLocationID = TL.TravelLocationID
JOIN Category AS C ON S.CategoryID = C.CategoryID
WHERE C.Name = 'Kitchenware'
-- NOTE: Here's another interpretation. If we want no repitition in the location it is more complicated since we want to, but can't,
-- do a DISTINCT selection off of just one value (TravelLocationID) yet still return all of the other values. I
-- used an approach outlined at https://stackoverflow.com/questions/11937206/sql-query-multiple-columns-using-distinct-on-one-column-only
-- which uses a subquery to create an intermediate table with the SourvenirIDs of the distinct TravelLocationIDs. 
SELECT b.SouvenirID, b.[Name], C.Name, TL.City, TL.Region, TL.Country, TL.Longitude, TL.Latitude
FROM   (
        SELECT DISTINCT MAX(SouvenirID) AS SouvenirID,
        TravelLocationID
        FROM   Souvenir
        GROUP BY
              TravelLocationID
   ) AS a
INNER JOIN Souvenir b
    ON  a.SouvenirID = b.SouvenirID
JOIN TravelLocation AS TL ON a.TravelLocationID = TL.TravelLocationID
JOIN Category AS C ON b.CategoryID = C.CategoryID
ORDER BY a.TravelLocationID

-- 6
-- Find the earliest and latest obtained date for each owner, ordered by the earliest of the
-- earliest dates to the latest of the earliest dates.
SELECT O.Name, MIN(S.DateObtained) AS EarliestObtainedDate, MAX(S.DateObtained) AS LatestObtainedDate
FROM Souvenir AS S 
JOIN Owner AS O ON S.OwnerID = O.OwnerID
GROUP BY O.Name
ORDER BY MIN(S.DateObtained)

-- 7
-- What is the most popular date for the souvenirs? Store this date in a variable. Find all
-- souvenirs obtained on that date.
DECLARE @MostCommonDate DATETIME2

SELECT @MostCommonDate = (SELECT TOP 1 DateObtained
FROM Souvenir
GROUP BY DateObtained
ORDER BY COUNT(SouvenirID) DESC)

SELECT SouvenirID, [Name], DateObtained
FROM Souvenir
WHERE DateObtained = @MostCommonDate

-- 8 
-- Find all souvenirs that do not have a latitude and longitude.
SELECT S.[Name], TL.City, TL.Region, TL.Country, TL.Longitude, TL.Latitude
FROM Souvenir AS S
JOIN TravelLocation AS TL ON S.TravelLocationID = TL.TravelLocationID
WHERE S.TravelLocationID IN (
    SELECT TravelLocationID
    FROM TravelLocation
    WHERE Longitude IS NULL
)

-- 9
-- Find all souvenirs that do not have a city, region, and country.
SELECT S.[Name], TL.City, TL.Region, TL.Country, TL.Longitude, TL.Latitude
FROM Souvenir AS S
JOIN TravelLocation AS TL ON S.TravelLocationID = TL.TravelLocationID
WHERE S.TravelLocationID IN (
    SELECT TravelLocationID
    FROM TravelLocation
    WHERE (City = '[Unknown]') AND (Region  = '[Unknown]') AND (Country  = '[Unknown]')
)

-- 10
-- Find all souvenirs - name, city name, region name, country name, latitude,longitude,
-- and weight - heavier than the average weight for all souvenirs. Use a subquery in a
-- WHERE clause to achieve this.
SELECT S.[Name], TL.City, TL.Region, TL.Country, TL.Longitude, TL.Latitude, Weight
FROM Souvenir AS S
JOIN TravelLocation AS TL ON S.TravelLocationID = TL.TravelLocationID
WHERE Weight > (
    SELECT AVG(Weight)
    FROM Souvenir)

-- 11
-- Find the most expensive and least expensive souvenir in each category
SELECT C.[Name] AS CategoryName, MAX(Price) AS MostExpensive, MIN(Price) AS LeastExpensive
FROM Souvenir AS S
JOIN Category AS C ON S.CategoryID = C.CategoryID
GROUP BY C.Name
ORDER BY C.Name