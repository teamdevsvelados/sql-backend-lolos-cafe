# Lolo’s Café – Backend ☕

This repository contains the database design and implementation for Lolo’s Café, developed using MySQL Workbench and MySQL.
The project includes the entity-relationship model, database creation scripts, and sample data required for testing and validation.

## Project Objectives

The main goals of this project are:

Create the Entity-Relationship Diagram (ERD) of the database using MySQL Workbench.

Execute SQL scripts to create the project database and its tables.

Create SQL scripts to insert sample data (at least 5 records per main table).

## Repository Structure

The repository contains the following files:

├── model-db-lolos.png <br>
├── script-lolos.sql <br>
├── sample-data-lolos.sql <br>
└── README.md

### model-db-lolos.png

Shows the final Entity-Relationship Diagram (ERD) of the database.

Includes entities, attributes, primary keys, and foreign key relationships.

### script-lolos.sql

SQL script used to:

Create the database

Define all tables

Establish primary keys, foreign keys, constraints, and indexes

Must be executed before inserting sample data.

### sample-data-lolos.sql

SQL script that inserts sample (seed) data into the database.

Contains approximately 5 records per main table.

Designed to respect foreign key constraints and table relationships.

Used for testing and validating database functionality.

## How to Run the Project

1. Open MySQL Workbench.

2. Execute the database structure script:

**script-lolos.sql**

3. Once the database and tables are created, execute:

**sample-data-lolos.sql**


4. Verify the data using SELECT queries.

## 🛠 Technologies Used

MySQL

MySQL Workbench

SQL (DDL & DML)

## Notes

The database design follows relational best practices.

Foreign key constraints ensure data integrity.

Sample data is provided only for development and academic purposes.

## Author

Team Devsvelados 🤠 
Academic Project