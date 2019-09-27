# Sakila

# Description
The Sakila sample database ships with MySQL.  We show three ways to query the database:
1.  With MySQL.  Several queries in MySQL are given in `sakila-sample-queries.sql`.
2.  With Pandas.  While one could always pass the SQL statements in 1 with, `pandas.read_sql`, we choose to 
use the functionality of the Pandas DataFrame to perform the same queries and joins as in 1.  The 
requests and results are given in the notebook `python-sakila.ipynb`.
3.  With SQLAlchemy in Python.  The queries in 1 are performed using SQLAlchemy's Object Relational Mapper and CORE language.  Again, these queries could have been performed using the 'pass-through' option of directly passing 
SQL statements; however, we choose to demonstrate the use of SQLAlchemy for these tasks.
These queries are given in `sqlalchemy-sakila.ipynb`.