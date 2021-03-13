--1. What is the undiscounted subtotal for each Order (identified by OrderID).
select o.OrderID, sum(od.UnitPrice * od.Quantity) SalesTotal
from Orders o
	join [Order Details] od
	on o.OrderID = od.OrderID
group by o.OrderID
order by SalesTotal desc
--2. What products are currently for sale (not discontinued)?
select *
from Products
where Discontinued = 0

--3. What is the cost after discount for each order?  Discounts should be applied as a percentage off.
select o.OrderID, sum(od.UnitPrice * od.Quantity * (1-od.Discount)) SalesTotal
from Orders o
	join [Order Details] od
	on o.OrderID = od.OrderID
group by o.OrderID
order by SalesTotal desc

--4. I need a list of sales figures broken down by category name.  Include the total $ amount sold over all time and the total number of items sold.
select c.CategoryName, sum(od.UnitPrice * od.Quantity * (1-od.Discount)) SalesTotal, sum(od.Quantity)Quantity
from [Order Details] od
	join Products p
	on od.ProductID = p.ProductID
	join Categories c
	on p.CategoryID = c.CategoryID
group by c.CategoryName
order by Quantity desc

--5. What are our 10 most expensive products?
select Top 10 ProductName, UnitPrice
from Products
group by ProductName, UnitPrice
order by UnitPrice Desc

--6. In which quarter in 1997 did we have the most revenue?
select top 1 datepart(qq, o.OrderDate) theQuarter, sum(od.UnitPrice * od.Quantity * (1-od.Discount)) SalesTotal
from orders o
	join [Order Details] od
	on o.OrderID = od.OrderID
where o.OrderDate between '1997-01-01' and '1997-12-31'
group by datepart(qq, o.OrderDate)
order by SalesTotal desc

--7. Which products have a price that is higher than average?
select avg(p.UnitPrice)
from Products p

select p.ProductName, p.UnitPrice
from Products p
where p.UnitPrice > (select avg(p.UnitPrice)
					 from Products p)
group by p.ProductName, p.UnitPrice
order by p.UnitPrice desc