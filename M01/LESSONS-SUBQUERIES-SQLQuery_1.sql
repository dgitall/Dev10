-- Count of countries that don't have states/provinces
SELECT COUNT(DISTINCT CountryName) AS CountriesNoStatesProvinces
FROM Application.Countries AS C
WHERE NOT EXISTS
    (SELECT CountryID
    FROM Application.StateProvinces SP 
    WHERE SP.CountryID = C.CountryID)
-- City name with the largest population
SELECT CityName
FROM Application.Cities 
WHERE LatestRecordedPopulation IN 
    (SELECT MAX(LatestRecordedPopulation)
    FROM Application.Cities)
-- Cities with population greater than the average pop
SELECT CityName
FROM Application.Cities 
WHERE LatestRecordedPopulation >
    (SELECT AVG(LatestRecordedPopulation)
    FROM Application.Cities)
-- List of StateProvID, and count of Cities in each and Count of states/provinces
SELECT StateProvinceID,
    COUNT(DISTINCT CityID) AS CityCount,
    (SELECT COUNT(DISTINCT StateProvinceID)
    FROM Application.Cities) AS StateCount 
FROM Application.Cities
GROUP BY StateProvinceID 
-- All invoices that have an invoice total less than the average extended price
SELECT InvoiceID, SUM(ExtendedPrice) AS InvoiceTotal
FROM Sales.InvoiceLines 
GROUP BY InvoiceID
HAVING SUM(ExtendedPrice) < 
    (SELECT AVG(ExtendedPrice) FROM Sales.InvoiceLines)
-- All invoices that have an invoice total less than the average extended price and the average extended price
SELECT InvoiceID, SUM(ExtendedPrice) AS InvoiceTotal,
    (SELECT AVG(ExtendedPrice) FROM Sales.InvoiceLines) AS AverageExtendedPrice
FROM Sales.InvoiceLines 
GROUP BY InvoiceID
HAVING SUM(ExtendedPrice) < 
    (SELECT AVG(ExtendedPrice) FROM Sales.InvoiceLines)
