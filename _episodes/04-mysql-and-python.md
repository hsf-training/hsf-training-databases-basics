---
title: "MySQL and Python"
teaching: x
exercises: x
questions:
- ""
- ""
objectives:
- ""
- ""
keypoints:
- ""
- ""
---

## Why python with SQL?

## Install mysql connector
To install the MySQL Python library, you can use mysql-connector-python, which is a popular MySQL driver for Python. You can install it using pip, the Python package manager. Open a terminal or command prompt
```bash
pip install mysql-connector-python
```
If you are using Python 3, you might need to use pip3 instead of pip:
```bash
pip3 install mysql-connector-python
```

## Connecting to mysql server

```python
import mysql.connector

# Establish a connection to the MySQL server
connection = mysql.connector.connect(
    host="localhost", user="root", password="mypassword"
)

# Create a cursor to execute SQL commands
cursor = conn.cursor()
```
## Creating a Database

We will first create a database named "metadata" in our MySQL server.



```python
cursor.execute("CREATE DATABASE metadata")
```

To work with a specific database, you can use the USE command. For instance, to select the "metadata" database:
```python
cursor.execute("USE metadata")
```



## Create a table

Tables are used to structure and store data. Here's how you can create a table named "dataset" within the "metadata" database:

```python
# Define the CREATE TABLE SQL command

create_table_query = """

CREATE TABLE dataset (

    id INT AUTO_INCREMENT PRIMARY KEY,

    filename VARCHAR(255) NOT NULL UNIQUE,

    run_number INT NOT NULL,

    total_event INT NOT NULL,

    collision_type TEXT,

    data_type TEXT,

    collision_energy INT NOT NULL

)

"""
# Execute the CREATE TABLE command
cursor.execute(create_table_query)
```



## Insert into table
