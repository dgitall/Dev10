SELECT r.date_format
FROM master.sys.dm_exec_requests r
WHERE r.session_id = @@SPID;

SELECT FORMAT(SYSDATETIME(), 'hh:mm:ss')
SELECT FORMAT(SYSUTCDATETIME(), 'MMMM-dd-yyy hh:mm:ss')

SELECT DAY(InvoiceDate) AS DayOfMonth,
    COUNT(InvoiceID) AS NumberOfInvoices,
    SUM(TotalChillerItems) AS ChillerItems,
    SUM(TotalDryItems) AS DryItems
FROM Sales.Invoices
WHERE YEAR(InvoiceDate) = 2016
    AND MONTH(InvoiceDate) = 4
GROUP BY DAY(InvoiceDate)
ORDER BY DAY(InvoiceDate)

SELECT DATENAME(q, GETDATE())
SELECT DATEPART(q, GETDATE())
