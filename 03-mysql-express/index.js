const express = require('express');
const mysql2 = require('mysql2/promise');
const dotenv = require('dotenv');
const hbs = require('hbs');
const wax = require('wax-on');

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

    app.get('/customers/create', async function(req,res){
        const [companies] = await connection.execute(`SELECT * from Companies`);
        res.render("customers/create",{
            companies
        });
    });

    app.post('/customers/create', async function(req,res){
        const { first_name, last_name, rating, company_id} = req.body;
        const query = `
             INSERT INTO Customers (first_name, last_name, rating, company_id) 
             VALUES ('${first_name}', '${last_name}', ${rating}, ${company_id})
        `;
        await connection.execute(query);
        res.redirect('/customers');
    })


}
main();

app.listen(3000, () => {
    console.log("server has started");
});
