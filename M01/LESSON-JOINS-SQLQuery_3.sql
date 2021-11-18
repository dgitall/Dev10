SELECT StockItemName
FROM Warehouse.StockItems
INNER JOIN Warehouse.Colors ON 
    Warehouse.StockItems.ColorID = Warehouse.Colors.ColorID
WHERE ColorName = 'Yellow'

SELECT WS.ColorID, StockItemName, ColorName
FROM Warehouse.StockItems AS WS
JOIN Warehouse.Colors AS C ON WS.ColorID = C.ColorID
WHERE ColorName = 'Yellow'

SELECT StockGroupName, StockItemName, ColorName
FROM Warehouse.StockItems AS WS
JOIN Warehouse.Colors AS C ON WS.ColorID = C.ColorID
JOIN Warehouse.StockItemStockGroups WSISG ON
    WSISG.StockItemID = WS.StockItemID
JOIN Warehouse.StockGroups WSG ON
    WSG.StockGroupID = WSISG.StockGroupID
WHERE ColorName = 'Yellow'

DECLARE @GroupList varchar(100)

SELECT @GroupList = COALESCE(@GroupList + ', ', '') + StockGroupName
FROM Warehouse.StockItems AS WS
JOIN Warehouse.Colors AS C ON WS.ColorID = C.ColorID
JOIN Warehouse.StockItemStockGroups WSISG ON
    WSISG.StockItemID = WS.StockItemID
JOIN Warehouse.StockGroups WSG ON
    WSG.StockGroupID = WSISG.StockGroupID
WHERE ColorName = 'Yellow' AND StockItemName = 'Ride on toy sedan car (Yellow) 1/12 scale'

SELECT @GroupList

SELECT StockItemName AS YellowStockItems, STRING_AGG(StockGroupName, ', ') AS StockGroups
FROM Warehouse.StockItems AS WS
JOIN Warehouse.Colors AS C ON WS.ColorID = C.ColorID
JOIN Warehouse.StockItemStockGroups WSISG ON
    WSISG.StockItemID = WS.StockItemID
JOIN Warehouse.StockGroups WSG ON
    WSG.StockGroupID = WSISG.StockGroupID
WHERE ColorName = 'Yellow'
GROUP BY StockItemName

SELECT StockItemName AS YellowStockItems,
    UnitPackageType.PackageTypeName AS UnitPackage,
    OuterPackageType.PackageTypeName AS OuterPackageType
FROM Warehouse.StockItems AS WS
JOIN Warehouse.Colors AS C ON WS.ColorID = C.ColorID
JOIN Warehouse.PackageTypes AS UnitPackageType ON
    UnitPackageType.PackageTypeID = WS.UnitPackageID
JOIN Warehouse.PackageTypes AS OuterPackageType ON
    OuterPackageType.PackageTypeID = WS.OuterPackageID
WHERE ColorName = 'Yellow'    

SELECT SO.OrderID,
    SUM((Quantity * UnitPrice)*(TaxRate/100 + 1)) AS OrderTotal
FROM Sales.OrderLines AS SOL
JOIN Sales.Orders AS SO ON SO.OrderID = SOL.OrderID
WHERE YEAR(OrderDate) = 2016
GROUP BY SO.OrderID
HAVING SUM((Quantity * UnitPrice)*(TaxRate/100 + 1)) < 1000.00
ORDER BY OrderTotal, SO.OrderID