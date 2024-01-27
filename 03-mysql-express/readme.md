# Dependencies
* express
* dotenv
* mysql2
* hbs
* wax-on

# Setup steps
1. Create a new database in MySQL (for our example, we use `crm`). First, enter MySQL with `mysql -u root` and enter the following command.
    ```
    create database crm; 
    ```

2. In the first line of the `schema.sql` and `data.sql`, type in
    ```
    USE crm;
    ```

3. Exit out from MySQL, and create the tables and setup initial data with:
```
    mysql -u root < schema.sql
    mysql -u root < data.sql
```