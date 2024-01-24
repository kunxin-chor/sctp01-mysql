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