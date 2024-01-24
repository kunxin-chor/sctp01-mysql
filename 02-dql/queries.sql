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

SELECT firstName, lastName, addressLine1, addressLine2 FROM employees JOIN offices
 ON employees.officeCode = offices.officeCode