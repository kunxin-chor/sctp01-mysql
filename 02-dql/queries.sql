# Works for the `classicmodels` database

# Show all employees
# The `*` means all the columns
SELECT * from employees;

# Select just the firstName, lastName and email FROM
# all employees?
SELECT firstName, lastName, email FROM employees;

# Select an rename the columns
SELECT firstName AS "First Name", lastName AS "Last Name", email AS "Email" FROM employees;

# Get all employees from office code 1
SELECT * FROM employees WHERE officeCode=1;

# Just show the first name, last name and email of employees
# from office code 1
SELECT firstName, lastName, email FROM employees
WHERE officeCode=1;

# Get all customers from USA and show their contact first name, contact last name and name
SELECT contactFirstName, contactLastName, customerName FROM customers WHERE country = "USA";

# Select all employees where jobTitle is "<anything>sales"
SELECT * FROM employees WHERE jobTitle LIKE "%sales";

# Select all employees where jobTitle is "sales<anything>"
SELECT * FROM employees WHERE jobTitle LIKE "sales%"

# Select all employees where jobTitle is "<anything>sales<anything>"
SELECT * FROM employees WHERE jobTitle LIKE "%sales%"

# Find all orders which mentions the word "shipping" in the comments
# and display their orderNumber, status and comments
SELECT orderNumber, status, comments FROM orders WHERE comments LIKE "%shipping%"

# Get employees from office code 1 or from office code 2
SELECT firstName, lastName FROM employees WHERE officeCode = 1 OR officeCode = 2;

# Get ONLY sales rep from office code 1 or from office code 2
SELECT firstName, lastName, jobTitle, officeCode FROM employees WHERE jobTitle LIKE "Sales Rep" AND (officeCode = 2 OR officeCode =1);

# Get customers from NV in USA who have more than 5000 credit limit
SELECT * FROM customers WHERE state="NV" AND country="USA" and creditLimit > 5000

# Get all custoemrs from either Singapore or USA, and at the same time have less than 10K credit
SELECT * FROM customers WHERE (country="USA" OR country="Singapore") AND creditLimit < 10000;

# Show the first name and last name of each employee, and their office address
SELECT firstName, lastName, addressLine1, addressLine2
 FROM employees JOIN offices
 ON employees.officeCode = offices.officeCode

 # There are cases when two tables will have the same name for columns
 # use <table name>.<col name> to be more specific as which column to show
 SELECT firstName, lastName, addressLine1, addressLine2, employees.officeCode
 FROM employees JOIN offices
 ON employees.officeCode = offices.officeCode


# Three kinds of JOIN
# INNER JOIN - standard: only included in the result if there is a matching row on the other TABLE
# Find customers and the first name, last name and email of their sales REPLACESELECT customerName, firstName, lastName, email FROM customers
SELECT customerName, firstName AS "Sales Rep First Name", lastName as "Sales Rep Last Name"
FROM customers
JOIN employees
ON customers.salesRepEmployeeNumber = employees.employeeNumber;

# See the above but only for customers from USA
SELECT customerName, firstName AS "Sales Rep First Name", lastName as "Sales Rep Last Name"
FROM customers
JOIN employees
ON customers.salesRepEmployeeNumber = employees.employeeNumber
WHERE country="USA";

# LEFT OUTER JOIN - ALL ROWS ON THE LEFTHAND SIDE WILL BE INCLUDED
# All customers will be included regardless of whether they have a sales rep or not
SELECT customerName, firstName AS "Sales Rep First Name", lastName as "Sales Rep Last Name"
FROM customers
LEFT JOIN employees
ON customers.salesRepEmployeeNumber = employees.employeeNumber;

# get the current date
SELECT CURDATE();

# provide dates in the ISO date: YYYY-MM-DD
# get all payments after 30th June 2003
SELECT * FROM payments WHERE paymentDate > "2003-06-30";

# get all the payments in the year of 2003
SELECT * FROM payments WHERE paymentDate >= "2003-01-01" AND paymentDate <="2003-06-30"

# Get all payments  made in the June of 2003
SELECT * from payments WHERE YEAR(paymentDate) = "2003" AND MONTH(paymentDate) = "6"

# Aggregration functions allow us to summarize the entire table
SELECT COUNT(*) FROM employees;
SELECT AVG(amount) FROM payments;

# show only unique values with DISTINCT
SELECT DISTINCT(officeCode) from employees;

# sorting
SELECT * FROM customers ORDER BY  creditLimit;

# change the direction of the sort (from highest to lowest)

SELECT * FROM customers ORDER BY  creditLimit DESC;

# for each office, show their state and country, and how many employees there are
SELECT COUNT(*), employees.officeCode, country, state FROM employees
JOIN offices
ON employees.officeCode = offices.officeCode
GROUP BY officeCode, country, state

# show the average credit limit of each country
# 1. which table(s) will give us the info we want (if > 1 table, need to JOIN)
# 2  what do we want to group by?
# 3. SELECT ???? FROM <table name> GROUP BY <criteria to group by>
# 4. What do I want from each group: MIN, MAX, AVG, SUM, COUNT
# 5. Whatever you group by, you also must select (vice visera) excpet the aggregation
SELECT AVG(creditLimit), country FROM customers
GROUP BY country

# We are only interested in countries where the credit limit is more than 10000
SELECT AVG(creditLimit), country FROM customers
GROUP BY country
HAVING AVG(creditLimit) > 10000;

# WHERE will happen before the group by (the following will exclude countries with credit limit 0
# before the groupings)
SELECT AVG(creditLimit), country FROM customers
WHERE creditLimit != 0
GROUP BY country
HAVING AVG(creditLimit) > 10000;

# Find the total sales made by each salesperson in the year 2003
-- Show the total revenue made by each salesperson
select SUM(amount), employeeNumber, firstName, lastName  FROM payments JOIN customers
 ON payments.customerNumber = customers.customerNumber
JOIN employees
 ON customers.salesRepEmployeeNumber = employees.employeeNumber
GROUP BY employeeNumber;

# We find the sort so that the highest grossing salesperson is at the TEMPORARY-- Show the total revenue made by each salesperson
select SUM(amount), employeeNumber, firstName, lastName  FROM payments JOIN customers
 ON payments.customerNumber = customers.customerNumber
JOIN employees
 ON customers.salesRepEmployeeNumber = employees.employeeNumber
GROUP BY employeeNumber;

# what if only top 3?
# What if not in the USA?
select SUM(amount), employeeNumber, firstName, lastName  FROM payments JOIN customers
 ON payments.customerNumber = customers.customerNumber
JOIN employees
 ON customers.salesRepEmployeeNumber = employees.employeeNumber
GROUP BY employeeNumber
ORDER BY SUM(amount) DESC
LIMIT 3;


# What if only employees who earned more than 600K and are not from USA are conisdered?
select SUM(amount), country, employeeNumber, firstName, lastName  FROM payments JOIN customers
 ON payments.customerNumber = customers.customerNumber
JOIN employees
 ON customers.salesRepEmployeeNumber = employees.employeeNumber
 WHERE customers.country != "USA"
GROUP BY employeeNumber, country, firstName, lastName
HAVING sum(amount) > 600000
ORDER BY SUM(amount) DESC
LIMIT 3;

# Show all customers which credit limit is above the average credit limit
SELECT * from customers where creditLimit > AVG(creditLimit);