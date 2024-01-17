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
    phone varchar(20)
) engine = innodb;

# show all the tables in a database
show tables;

# to examine the columns in a table, use `describe`
describe parents;