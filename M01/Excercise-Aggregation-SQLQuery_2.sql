-- 1
SELECT AVG(TypicalWeightPerUnit)
FROM Warehouse.StockItems
-- 2
DECLARE @HeaviestTypical bigint
DECLARE @LightestTypical float

SELECT @HeaviestTypical = MAX(TypicalWeightPerUnit),
    @LightestTypical = MIN(TypicalWeightPerUnit)
FROM Warehouse.StockItems

SELECT StockItemName, TypicalWeightPerUnit
FROM Warehouse.StockItems
WHERE TypicalWeightPerUnit = @HeaviestTypical OR    
    TypicalWeightPerUnit = @LightestTypical
-- 3
SELECT Brand, COUNT(StockItemID) AS StockedCount
FROM  Warehouse.StockItems
GROUP BY Brand
ORDER BY Brand
--4
SELECT COUNT(VehicleTemperatureID) AS TempCount,
    MIN(RecordedWhen) AS EarliestDate,
    MAX(RecordedWhen) AS LatestDate
FROM Warehouse.VehicleTemperatures
--5 
SELECT VehicleRegistration,
 ChillerSensorNumber,
  MIN(Temperature) AS MinTemp,
    MAX(Temperature) AS MaxTtemp,
    AVG(Temperature) AS AvgTemp,
    COUNT(VehicleTemperatureID) AS CountTemp,
    COUNT(DISTINCT VehicleRegistration) AS UniqueRegistrations
FROM Warehouse.VehicleTemperatures
WHERE MONTH(RecordedWhen) = '03' AND YEAR(RecordedWhen) = '2016'
GROUP BY VehicleRegistration, ChillerSensorNumber
ORDER BY VehicleRegistration, ChillerSensorNumber
--6
SELECT *
FROM Sales.OrderLines
WHERE OrderID = 1163
--7
SELECT OrderID, SUM((Quantity*UnitPrice)*(TaxRate/100+1))
FROM Sales.OrderLines
WHERE OrderID = 1163
GROUP BY OrderID
-- 8
SELECT COUNT(OrderLineID)
FROM Sales.OrderLines
WHERE Quantity != PickedQuantity
-- 9
SELECT OrderID, SUM(Quantity - PickedQuantity) AS OutstandingQuantity
FROM Sales.OrderLines
WHERE Quantity != PickedQuantity
GROUP BY OrderID
--10
SELECT OrderID, SUM((Quantity*UnitPrice)*(TaxRate/100+1)) AS OrderTotal
FROM Sales.OrderLines
GROUP BY OrderID
ORDER BY OrderTotal
-- 11
SELECT OrderID, SUM((Quantity*UnitPrice)*(TaxRate/100+1)) AS OrderTotal
FROM Sales.OrderLines
GROUP BY OrderID
HAVING SUM((Quantity*UnitPrice)*(TaxRate/100+1)) < 1000
--ORDER BY OrderTotal