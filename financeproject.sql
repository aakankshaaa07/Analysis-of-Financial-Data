-- Using Inner joins to find the manufacturing cost and discount% and then performing necessary operations to find other required prices
SELECT financedatatset.*, manufacturingcost.ManufacturingCost, discountband.Discount,
ManufacturingCost*UnitsSold AS TotalCostPrice,
SalePrice*UnitsSold AS TotalSellingPrice,
Discount*SalePrice*UnitsSold/100 AS DiscountPrice,
(SalePrice*UnitsSold) - (Discount*SalePrice*UnitsSold/100) AS NetSellingPrice,
(SalePrice*UnitsSold) - (Discount*SalePrice*UnitsSold/100) - (ManufacturingCost*UnitsSold) AS NetProfit
FROM financedatatset
JOIN manufacturingcost
ON financedatatset.Product = manufacturingcost.ProductName
JOIN discountband
ON financedatatset.DiscountBand = discountband.DiscountBand;

-- Which segment had the most profit from a single deal?
SELECT financedatatset.*, manufacturingcost.ManufacturingCost, discountband.Discount,
ManufacturingCost*UnitsSold AS TotalCostPrice,
SalePrice*UnitsSold AS TotalSellingPrice,
Discount*SalePrice*UnitsSold/100 AS DiscountPrice,
(SalePrice*UnitsSold) - (Discount*SalePrice*UnitsSold/100) AS NetSellingPrice,
MAX((SalePrice*UnitsSold) - (Discount*SalePrice*UnitsSold/100) - (ManufacturingCost*UnitsSold)) AS NetProfit
FROM financedatatset
JOIN manufacturingcost
ON financedatatset.Product = manufacturingcost.ProductName
JOIN discountband
ON financedatatset.DiscountBand = discountband.DiscountBand
GROUP BY Segment, Country
ORDER BY NetProfit DESC;
-- Government segment generated the most profit from one deal

-- Find the total profits by each country
SELECT financedatatset.*, manufacturingcost.ManufacturingCost, discountband.Discount,
ManufacturingCost*UnitsSold AS TotalCostPrice,
SalePrice*UnitsSold AS TotalSellingPrice,
Discount*SalePrice*UnitsSold/100 AS DiscountPrice,
(SalePrice*UnitsSold) - (Discount*SalePrice*UnitsSold/100) AS NetSellingPrice,
SUM((SalePrice*UnitsSold) - (Discount*SalePrice*UnitsSold/100) - (ManufacturingCost*UnitsSold)) AS NetProfit
FROM financedatatset
JOIN manufacturingcost
ON financedatatset.Product = manufacturingcost.ProductName
JOIN discountband
ON financedatatset.DiscountBand = discountband.DiscountBand
GROUP BY Country
ORDER BY NetProfit DESC;
-- Germany conceded the most profit

-- Find how many products were sold
SELECT Product, SUM(UnitsSold)
FROM financedatatset
GROUP BY Product;
-- Carretera = 146846; Montana = 154198; Paseo = 338239.5; Velo = 162424.5; VTT = 168783; Amarilla = 155315

-- View only deals with the Canadian government
SELECT financedatatset.*, manufacturingcost.ManufacturingCost, discountband.Discount,
ManufacturingCost*UnitsSold AS TotalCostPrice,
SalePrice*UnitsSold AS TotalSellingPrice,
Discount*SalePrice*UnitsSold/100 AS DiscountPrice,
(SalePrice*UnitsSold) - (Discount*SalePrice*UnitsSold/100) AS NetSellingPrice,
(SalePrice*UnitsSold) - (Discount*SalePrice*UnitsSold/100) - (ManufacturingCost*UnitsSold) AS NetProfit
FROM financedatatset
JOIN manufacturingcost
ON financedatatset.Product = manufacturingcost.ProductName
JOIN discountband
ON financedatatset.DiscountBand = discountband.DiscountBand
WHERE Country='Canada' AND Segment='Government';

-- The discounted price for all German customers is 500 if they pay more than 10000, how much does this affect the profit
SELECT *, manufacturingcost.ManufacturingCost, discountband.Discount,
ManufacturingCost*UnitsSold AS TotalCostPrice,
SalePrice*UnitsSold AS TotalSellingPrice,
Discount*SalePrice*UnitsSold/100 AS DiscountPrice,
(SalePrice*UnitsSold) - (Discount*SalePrice*UnitsSold/100) AS NetSellingPrice,
SUM((SalePrice*UnitsSold) - (Discount*SalePrice*UnitsSold/100) - (ManufacturingCost*UnitsSold)) AS NetProfit
FROM financedatatset
JOIN manufacturingcost
ON financedatatset.Product = manufacturingcost.ProductName
JOIN discountband
ON financedatatset.DiscountBand = discountband.DiscountBand
GROUP BY Country;
-- Germany's net profit with normal discount scheme is 2411122.7500000005
SELECT Country, UnitsSold, SalePrice, manufacturingcost.ManufacturingCost,
ManufacturingCost*UnitsSold AS TotalCostPrice,
SalePrice*UnitsSold AS TotalSellingPrice,
SUM(SalePrice*UnitsSold - IF (Country="Germany" AND SalePrice*UnitsSold > 10000, 500, 0) - (ManufacturingCost*UnitsSold)) AS NetProfit
FROM financedatatset
JOIN manufacturingcost
ON financedatatset.Product = manufacturingcost.ProductName
GROUP BY Country;
-- Gemrany's net profit with the new discount scheme is 4622375.5.
-- The difference in the net profit is 2211252.75, new discount scheme is more profitable.

-- How many products did small businesses in Mexico buy
SELECT Country, SUM(UnitsSold), Segment
FROM financedatatset
WHERE Country='Mexico' AND Segment='Small Business';
-- 25715 products were sold to small businesses in Mexico.