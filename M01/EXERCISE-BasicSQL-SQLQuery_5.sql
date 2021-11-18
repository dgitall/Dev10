SELECT 'All for one, and one for all.'
SELECT 'All for one,' + 'and one for all'
SELECT 'All ' + 'for one' + ', and ' + 'one for ' + 'all'
SELECT LEN('All for one, and one for all')
SELECT CONCAT('All for one, ', 'and one for all')
SELECT * FROM string_split('All for one, and one for all.', ' ')
SELECT * FROM string_split('All for one, and one for all.', ',')
SELECT TOP 5 FullName FROM Application.People
SELECT TOP 5 FullName AS Fullname,
SUBSTRING(Fullname, 0, CHARINDEX(' ', Fullname) - 1) AS FirstName,
LEFT(SUBSTRING(Fullname, CHARINDEX(' ', Fullname)+1, LEN(Fullname)),1) AS LastInitial
FROM Application.People
SELECT TOP 8 CustomerCategoryName, PATINDEX('G%', CustomerCategoryName) FROM Sales.CustomerCategories
SELECT TOP 8 CustomerCategoryName, PATINDEX('G%R', CustomerCategoryName) FROM Sales.CustomerCategories
SELECT 6+6
SELECT 5/2
SELECT 5.0/2.0
SELECT 5/2.0
SELECT 5.0/2
SELECT SQL_VARIANT_PROPERTY( 5/2.0 , 'BaseType')
SELECT SQL_VARIANT_PROPERTY( 5.0/2 , 'BaseType')
SELECT ABS(-5)
SELECT 6*2
SELECT 6*2.0
SELECT 6/2
SELECT 6/4, 6%4
SELECT SQUARE(6)
SELECT * FROM sales.CustomerCategories
SELECT CustomerCategoryName FROM sales.CustomerCategories
SELECT TOP 8 CustomerCategoryName FROM sales.CustomerCategories