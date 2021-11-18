SELECT ColorID, ColorName
FROM Warehouse.Colors
WHERE ColorName LIKE 'Dark%'
-- 2
SELECT ColorName
FROM Warehouse.Colors
WHERE LEN(ColorName)=5
-- 3
SELECT ColorID, ColorName
FROM Warehouse.Colors
WHERE ColorID=1 OR ColorID=11 OR ColorID=15 OR ColorID=36
-- 4
SELECT ColorID, ColorName
FROM Warehouse.Colors
WHERE ColorID IN (1, 11, 15, 36)
-- 5
SELECT CustomerName, PostalCityID
FROM Sales.Customers
WHERE PostalCityID = 242
-- 6
SELECT CustomerName, DeliveryPostalCode
FROM Sales.Customers
WHERE DeliveryPostalCode = 90210
-- 7
SELECT CustomerName
FROM Sales.Customers
WHERE CustomerName LIKE 'An%'
-- 8
SELECT CustomerName
FROM Sales.Customers
WHERE CustomerName BETWEEN 'An'AND 'Ao'
-- 9
SELECT CustomerName, PhoneNumber
FROM Sales.Customers
WHERE PhoneNumber LIKE '%555-%'
-- 10
SELECT CustomerName, DeliveryAddressLine1, PostalAddressLine2
FROM Sales.Customers
WHERE DeliveryAddressLine1 = 'Shop 2' AND PostalAddressLine2='Emilyville'
-- 11
SELECT DISTINCT DeliveryMethodID
FROM Sales.Customers
-- 12
SELECT TOP 5 CustomerName
FROM Sales.Customers
ORDER BY CustomerName DESC
-- 13
SELECT CustomerName, AccountOpenedDate
FROM Sales.Customers
WHERE AccountOpenedDate>='2015-07-01' AND AccountOpenedDate<='2015-12-31'
ORDER BY AccountOpenedDate, CustomerName 
-- 14
SELECT CustomerName, AccountOpenedDate
FROM Sales.Customers
WHERE AccountOpenedDate BETWEEN '2015-07-01' AND '2015-12-31'
ORDER BY AccountOpenedDate, CustomerName 
-- 15 
SELECT CustomerName, CreditLimit
FROM Sales.Customers
WHERE CustomerName IN ('DIpti Shah', 'Ivana Hadrabova', 'Emma Salpa', 'Ian Olofsson')
ORDER BY CreditLimit
-- 16
SELECT TOP 5 CustomerName, BuyingGroupID
FROM Sales.Customers
WHERE BuyingGroupID IS NULL
-- 17
SELECT TOP 5 CustomerName, BuyingGroupID
FROM Sales.Customers
WHERE BuyingGroupID IS NOT NULL
-- 18
SELECT CustomerName, BuyingGroupID,
CASE 
    WHEN BuyingGroupID IS NULL THEN 'No Buyer'
    ELSE CAST(BuyingGroupID as char(1))
END AS BuyerGroup
FROM Sales.Customers
WHERE CustomerID IN (SELECT TOP 3 CustomerID FROM Sales.Customers WHERE BuyingGroupID IS NULL) 
    OR CustomerID IN (SELECT TOP 3 CustomerID FROM Sales.Customers WHERE BuyingGroupID LIKE '[1-9]')
ORDER BY BuyerGroup
-- 12 again
SELECT CustomerName
FROM Sales.Customers
WHERE CustomerName IN (SELECT TOP 5 CustomerName
FROM Sales.Customers
ORDER BY CustomerName DESC)
ORDER BY CustomerName ASC
-- 18 from the instructor solution. What wasn't obvious is that you can hardcode in some specific selections
SELECT TOP 5 CustomerName,
    CASE  
        WHEN BuyingGroupID IS NULL THEN 'No Buyer'
        ELSE CAST(BuyingGroupID as char(1))
    END AS BuyerGroup
FROM Sales.Customers
WHERE CustomerName IN ('Eric Torres', 'Cosmina Vlad', 'Bala Dixit') 
    OR CustomerName LIKE 'Tailspin%(%MT%)'
ORDER BY BuyerGroup;