SELECT BusinessEntityID, LastName, FirstName
FROM Person.Person

SELECT PersonID FROM Sales.Customer

-- Filtering people who are customers
-- Use Aliases in the SELECT for clarity of which schema the value comes from
-- It isn't necessary
SELECT SC.CustomerID, PP.LastName, PP.FirstName
FROM Sales.Customer AS SC
-- This JOIN returns all of SC that also has a person ID listed in PP schema
JOIN Person.Person AS PP ON
    PP.BusinessEntityID = SC.PersonID

    -- LEFT JOIN customer first; RIGHT JOIN, Person first:
    -- Filtering customers who are NOT people
    -- It isn't necessary to use a RIGHT JOIN here to get the same result since all of the
    -- PP data will be NULL. Instead, you can just do a WHERE PersonID IS NULL on the SC
    -- table. However, what is different is that all of the Columns from PP are pulled in.
    -- This may be important for applications where you need some info about things that are 
    -- not in another table. e.g. Info about classes that are not found in the enrollment table
    -- In other words, what classes have no students enrolled.
SELECT *
FROM Person.Person AS PP
-- This JOIN returns all of SC and joins to PP
RIGHT JOIN Sales.Customer AS SC ON
    PP.BusinessEntityID = SC.PersonID
-- It returns all of the SC with the PP columns
WHERE SC.PersonID IS NULL

-- How many customers in each territory
SELECT SC.TerritoryID, SST.Name, COUNT(SC.CustomerID) AS CountCustomers
FROM Sales.customer AS SC
JOIN Sales.SalesTerritory AS SST
    ON SC.TerritoryID = SST.TerritoryID
GROUP BY SC.TerritoryID, SST.Name

-- How many customers in each territory versus how many customers overall and a percentage
DECLARE @TotalCustomers float

SELECT @TotalCustomers = COUNT(CustomerID) FROM Sales.Customer

SELECT SC.TerritoryID, SST.Name, 
    COUNT(SC.CustomerID) AS CountCustomers, 
    @TotalCustomers AS TotalCustomers,
    COUNT(SC.CustomerID)/@TotalCustomers*100 AS PercentageOfTotal
FROM Sales.customer AS SC
JOIN Sales.SalesTerritory AS SST
    ON SC.TerritoryID = SST.TerritoryID
GROUP BY SC.TerritoryID, SST.Name

-- Subquery
-- How many records does each customer have
SELECT TOP 10 pp.BusinessEntityID, FirstName, LastName, SStore.Name AS StoreName,
    (SELECT COUNT(*) FROM Sales.Customer where Sales.Customer.PersonID = pp.BusinessEntityID) AS CustomerRecordCount
FROM Person.Person pp
JOIN Sales.Customer SC
    ON SC.CustomerID = pp.BusinessEntityID
JOIN Sales.Store SStore
    ON SStore.BusinessEntityID = SC.StoreID
WHERE (SELECT COUNT(*) FROM Sales.Customer where Sales.Customer.PersonID = pp.BusinessEntityID) > 0

-- FIlter all artists featured on a single album using JOINS
SELECT Artist.Name
FROM Album
JOIN Tracks ON
    Album.AlbumID = Tracks.AlbumID
JOIN ArtistTrack AS AT ON
    AT.TrackID = Tracks.TrackID
JOIN Artist ON
    AT.ArtistID = Artist.ArtistID

-- Filter all songes features on a single album using JOINs
SELECT Tracks.TrackName
FROM Album
JOIN Tracks ON
    Album.AlbumID = Tracks.AlbumID

-- Filter all Genres on an album
DECLARE @GenreList varchar(200)
SELECT @GenreList=COALESCE(@GenreList+', ','') + Genre.GenreName
FROM Album
JOIN Tracks ON
    Album.AlbumID = Tracks.AlbumID
JOIN TracksGenre AS TG ON
    TG.TrackID = Tracks.TrackID
JOIN Genre ON
    Genre.GenreID = Tracks.GenreID

SELECT Album.AlbumName, (SELECT @GenreList ) AS AlbumGenres
FROM Album

