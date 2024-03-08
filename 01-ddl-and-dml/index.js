const mysql = require('mysql2/promise');

async function main() {
    try {
        // Create a connection to the database
        const connection = await mysql.createConnection({
            host: 'localhost',   // replace with your database host, e.g., 'localhost'
            user: 'root',        // replace with your database username
            password: '', // replace with your database password
            database: 'swimming_coach'   // replace with your database name
        });

        console.log('Successfully connected to the database.');

        // Perform any database operations here
        // Example: Query the database
        const [rows] = await connection.execute("SELECT * FROM sessions");
        console.log(rows[0].when.constructor.name);
        console.log(rows[0].when.toISOString())
        await connection.end();
    } catch (error) {
        console.error('Error connecting to the database:', error);
    }
}

main();
