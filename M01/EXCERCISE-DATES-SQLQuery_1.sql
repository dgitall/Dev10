--1
SELECT YEAR(HireDate) AS HireYear, COUNT(HireDate) AS EmployeeCount
FROM HumanResources.Employee
GROUP BY YEAR(HireDate)
ORDER BY YEAR(HireDate) DESC
--2
SELECT MIN(DATEDIFF(d, OrderDate, ShipDate)) AS MinDiff, MAX( DATEDIFF(d, OrderDate, ShipDate)) AS MaxDiff
FROM Sales.SalesOrderHeader
--3
SELECT YEAR(OrderDate) AS OrderYear, COUNT(DISTINCT MONTH(OrderDate)) AS NumberOfMonths
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
ORDER BY Year(OrderDate)
--4
SELECT MIN(OrderDate) AS FirstOrder, MAX(OrderDate) AS LastOrder
FROM Sales.SalesOrderHeader
--5
SELECT DATENAME(WEEKDAY, OrderDate) AS OrderDayOfWeek,
    COUNT(DISTINCT SalesOrderID) AS NumberOfSales,
    AVG(TotalDue) AS AvgSales
FROM Sales.SalesOrderHeader
GROUP BY DATENAME(WEEKDAY, OrderDate)
--6 Not working
SELECT WorkOrderID
  --  DATEDIFF(d, ScheduledStartDate, ScheduledEndDate) AS ScheduledTime
  --  DATEDIFF(d, ActualStartDate, ActualEndDate) AS ActualTime
FROM Production.WorkOrderRouting
WHERE DATEDIFF(d, ActualStartDate, ActualEndDate) - DATEDIFF(d, ScheduledStartDate, ScheduledEndDate)  > 0
GROUP BY WorkOrderID
ORDER BY WorkOrderID
-- 7 Not working
SELECT COUNT(ProductID)
 --   DATEDIFF(d, ScheduledStartDate, ScheduledEndDate) AS ScheduledTime,
  --  DATEDIFF(d, ActualStartDate, ActualEndDate) AS ActualTime
FROM Production.WorkOrderRouting
WHERE DATEDIFF(d, ActualStartDate, ActualEndDate) - DATEDIFF(d, ScheduledStartDate, ScheduledEndDate)  > 14
GROUP BY WorkOrderID
ORDER BY WorkOrderID
--8
SELECT SUM(ActualCost - PlannedCost) AS CostOverrun
FROM Production.WorkOrderRouting
--9 Not working
SELECT DATENAME(WEEKDAY, ModifiedDate) AS POWeekDay,
    COUNT(DISTINCT WorkOrderID) AS POCount
FROM Production.WorkOrderRouting
Group BY  DATENAME(WEEKDAY, ModifiedDate)
ORDER BY POWeekDay


