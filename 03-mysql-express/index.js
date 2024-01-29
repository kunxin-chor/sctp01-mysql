const express = require('express');
const mysql2 = require('mysql2/promise');
const dotenv = require('dotenv');
const hbs = require('hbs');
const wax = require('wax-on');
const handlebarHelpers = require('handlebars-helpers')({
    'handlebars': hbs.handlebars
});


dotenv.config();

let app = express();
app.use(express.urlencoded({ extended: false }));

// Set up Handlebars
app.set('view engine', 'hbs');

// Use Wax-On for additional Handlebars helpers
wax.on(hbs.handlebars);
wax.setLayoutPath('./views/layouts');

async function main() {
    // create a MySQL connection
    const connection = await mysql2.createConnection({
        host: process.env.DB_HOST, // server: URL or IP address
        user: process.env.DB_USER,
        database: process.env.DB_DATABASE,
        password: process.env.DB_PASSWORD
    });

    app.get('/customers', async function (req, res) {
        // we want the first element from the array returned from connection.execute
        const [customers] = await connection.execute(`
            SELECT * from Customers
                JOIN Companies ON Customers.company_id = Companies.company_id;
        `);
        // same as: const customers = await connection.execute("SELECT * from Customers")[0];
        res.render('customers/index', {
            customers
        })
    });

    // display the form to create a new customer
    app.get('/customers/create', async function (req, res) {
        const [companies] = await connection.execute(`SELECT * from Companies`);
        res.render("customers/create", {
            companies
        });
    });

    // process the form to create a new customer
    app.post('/customers/create', async function (req, res) {
        // Using RAW QUERIES -- DANGEROUS! Vulnerable to SQL injections
        // const { first_name, last_name, rating, company_id} = req.body;
        // const query = `
        //      INSERT INTO Customers (first_name, last_name, rating, company_id) 
        //      VALUES ('${first_name}', '${last_name}', ${rating}, ${company_id})
        // `;
        // await connection.execute(query);
        // res.redirect('/customers');

        // USING PRPEARED SQL STATEMENTS
        const { first_name, last_name, rating, company_id } = req.body;
        const query = `
             INSERT INTO Customers (first_name, last_name, rating, company_id) 
             VALUES (?, ?, ?, ?)
        `;
        // prepare the values in order of the question marks in the query
        const bindings = [first_name, last_name, parseInt(rating), parseInt(company_id)];
        await connection.execute(query, bindings);
        res.redirect('/customers');
    });

    app.get('/customers/search', async function (req, res) {

        let sql = "SELECT * from Customers WHERE 1";
        const bindings = [];
        if (req.query.searchTerms) {
            sql += ` AND (first_name LIKE ? OR last_name LIKE ?)`;
            bindings.push(`%${req.query.searchTerms}%`);
            bindings.push(`%${req.query.searchTerms}%`);
        }

        const [customers] = await connection.execute(sql, bindings);

        res.render('customers/search-form', {
            customers
        });
    });

    // Delete
    app.get('/customers/:customer_id/delete', async function (req, res) {
        const sql = "select * from Customers where customer_id = ?";
        // connection.execute will ALWAYS return an array even if it is just one result
        // that one result will be the only element in the array
        const [customers] = await connection.execute(sql, [req.params.customer_id]);
        const customer = customers[0];
        res.render('customers/delete', {
            customer,
        })
    });

    // for this to be secure, there must be JWT authentication
    // and there must be differnation between access rights
    // Can consider not use auto_increment for primary key but use UUID instead
    app.post('/customers/:customer_id/delete', async function (req, res) {
        const query = "DELETE FROM Customers WHERE customer_id = ?";
        await connection.execute(query, [req.params.customer_id]);
        res.redirect('/customers');
    });

    app.get('/customers/:customer_id/update', async function (req, res) {
        const query = "SELECT * FROM Customers WHERE customer_id = ?";
        const [customers] = await connection.execute(query, [req.params.customer_id]);
        const customer = customers[0];

        const [companies] = await connection.execute(`SELECT * from Companies`);

        res.render('customers/update', {
            customer, companies
        })
    });

    app.post('/customers/:customer_id/update', async function (req, res) {
        const { first_name, last_name, rating, company_id } = req.body;
        const query = `UPDATE Customers SET first_name=?,
                                            last_name =?,
                                            rating=?,
                                            company_id=?
                                        WHERE customer_id = ?
        `;
        const bindings = [first_name, last_name, rating, company_id, req.params.customer_id];
        await connection.execute(query, bindings);
        res.redirect('/customers');
    })

    // Display the form to create a new employee
    app.get('/employees/create', async function (req, res) {
        const [departments] = await connection.execute(`SELECT * from Departments`);
        const [customers] = await connection.execute(`SELECT * FROM Customers`);
      
        res.render("employees/create", {
            departments, customers
        });
    });

    // Process the form to create a new employee
    app.post('/employees/create', async function (req, res) {
        const { first_name, last_name, department_id, customers  } = req.body;
        const query = `
        INSERT INTO Employees (first_name, last_name, department_id) 
        VALUES (?, ?, ?)
    `;
        const bindings = [first_name, last_name, parseInt(department_id)];
        const [results] = await connection.execute(query, bindings);
        
        // The employee has been created, get the ID of the new employee
        const newEmployeeId = results.insertId; 

        for (let c of customers) {
            const query = `INSERT INTO EmployeeCustomer (employee_id, customer_id)
                VALUES (?, ?)
            `;
            await connection.execute(query, [newEmployeeId, c])
        }

        res.redirect('/employees');
    });

    // Route to display a table of employees
    app.get('/employees', async function (req, res) {
        const [employees] = await connection.execute(`
        SELECT Employees.employee_id, Employees.first_name, Employees.last_name, Departments.name AS department_name
        FROM Employees
        JOIN Departments ON Employees.department_id = Departments.department_id;
    `);
        res.render('employees/index', {
            employees
        });
    });




}
main();

app.listen(3000, () => {
    console.log("server has started");
});
