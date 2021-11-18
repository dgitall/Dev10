--1
SELECT SupplierName, SupplierCategoryName
FROM Purchasing.Suppliers
JOIN Purchasing.SupplierCategories ON
    Purchasing.SupplierCategories.SupplierCategoryID = Purchasing.Suppliers.SupplierCategoryID
WHERE PATINDEX('%Service%', SupplierCategoryName) != 0
--2
SELECT SupplierName, SupplierCategoryName
FROM Purchasing.Suppliers AS PS
JOIN Purchasing.SupplierCategories AS PSC ON
    PSC.SupplierCategoryID = PS.SupplierCategoryID
WHERE PATINDEX('%Service%', SupplierCategoryName) != 0
-- 3
SELECT SupplierName, SupplierCategoryName
FROM Purchasing.Suppliers AS PS
INNER JOIN Purchasing.SupplierCategories AS PSC ON
    PSC.SupplierCategoryID = PS.SupplierCategoryID
WHERE PATINDEX('%Service%', SupplierCategoryName) != 0
--4
SELECT StockItemName, SupplierName, SupplierCategoryName
FROM Warehouse.StockItems AS WS
JOIN Purchasing.Suppliers AS PS ON
    PS.SupplierID = WS.SupplierID
JOIN Purchasing.SupplierCategories AS PSC ON
    PSC.SupplierCategoryID = PS.SupplierCategoryID
WHERE SupplierCategoryName = 'Toy Supplier'