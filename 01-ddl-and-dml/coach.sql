# Show all databases in your SQL server
show databases;

# create a new database
create database swimming_coach;

# switch database with `use1
use swimming_coach;

# create table
# order of the creating the columns
# <name of column> <data type> <options> <null or not null>
create table parents (
    id int unsigned auto_increment primary key,
    name varchar(100) not null,
    email varchar(320) not null,
    phone varchar(20),
    UNIQUE(email)
) engine = innodb;

# show all the tables in a database
show tables;

# to examine the columns in a table, use `describe`
describe parents;

# Creating foreign keys
# 1. Create the table first, then add the foreign KEY
# 2. Create the table and the foreign key in one DDL statement (but it's still considered as 2 process)
# (engine must be inndob)
CREATE TABLE students (
    id MEDIUMINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(300) NOT NULL,
    swimming_grade VARCHAR(20) NOT NULL DEFAULT "N/A",
    dob DATETIME NOT NULL,
    # MAKE SURE THE DATA TYPE OF THE FK MATCHES THE CORRESPONDING COLUMN IN THE OTHER TABLE. Note: the FK has been linked yet
    parent_id INT UNSIGNED NOT NULL
) engine = innodb;

-- Create the foreign key between two tables
-- ADD CONSTRAINT: Name a FK
ALTER TABLE students ADD CONSTRAINT fk_students_parents
    FOREIGN KEY (parent_id) REFERENCES parents(id);

-- Inserting data (DML)
INSERT INTO parents (name, email, phone) VALUES ("Tan Ah Kow", "tanahkow@gemail.com", "12312345");

-- Get all rows from table (DQL)
SELECT * FROM parents;

-- Insert multiple rows
INSERT INTO parents (name, email, phone) VALUES ("Jon Snow", "jonsnow@winterfell.com", "456456"),("Charlie Brown", "charlie@peanuts.com", "7717771");

-- insert a valid student
INSERT INTO students (name, swimming_grade, dob, parent_id ) VALUES ("Tan Ah Mew", "Bronze", "2020-05-10", 1);

-- invalid insert: don't try
INSERT INTO students (name, swimming_grade, dob, parent_id) VALUES ("John Cena", "Gold Star", "1968-05-05", 999);

-- Invalid delete, don't try. We can't delete Tan Ah Kow because Tan Ah Mew depends on Tan Ah Kow
DELETE FROM parents WHERE id = 1;

-- NOT SAFE, DON'T TRY AT HOME OR WORK
CREATE TABLE sessions (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    amount INT UNSIGNED NOT NULL,
    type VARCHAR(20) DEFAULT "CASH"
) engine = innodb;

-- INSERT A DUMMY SESSION
INSERT INTO sessions (amount, type) VALUES (900, "VISA");

ALTER TABLE sessions ADD COLUMN student_id MEDIUMINT UNSIGNED NOT NULL;

ALTER TABLE sessions ADD CONSTRAINT fk_sessions_students 
 FOREIGN KEY (student_id) REFERENCES students(id);

 -- DROP A COLUMN
 ALTER TABLE sessions DROP COLUMN student_id;

 -- Delete a table
 DROP TABLE sessions;  -- remove the table named `sessions`

 -- UPDATE AN EXISTING ROW
 UPDATE parents SET name="John Wick" WHERE id = 2;

 UPDATE parents SET name="Char Brown", email="char@gemail.com" WHERE id=3;

 DELETE FROM parents WHERE id=2;
 ------ SESSION TABLE IS NOT CREATED PROPERLY -------------------

 CREATE TABLE locations (
    id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    address VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL
 ) engine = innodb;

 CREATE TABLE sessions (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(255) NOT NULL,
    student_id MEDIUMINT UNSIGNED NOT NULL,
    location_id TINYINT UNSIGNED NOT NULL,
    FOREIGN KEY(student_id) REFERENCES students(id),
    FOREIGN KEY(location_id) REFERENCES locations(id)

 ) engine = innodb;