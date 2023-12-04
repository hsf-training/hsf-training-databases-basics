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

## sqlAlchemy
SQLAlchemy is a powerful library that provides a high-level interface for interacting with databases, making database operations more Pythonic and abstracting SQL commands.


## Installation
Make sure you have python in your system. Lets create a virtual environment and install sqlAlchemy .
Lets create a directory to work
```bash
mkdir myhsfwork && cd myhsfwork
```

Creating a vittual environment.

```bash
python -m venv venv
```

Activate the venv
```bash
source venv/bin/activate
```

now install sqlAlchemy
```bash
pip install sqlalchemy
```

## Setting Up the Database Connection:
In this section, we'll explore how to set up the SQLAlchemy engine, which serves as the connection to the database. The engine takes care of connecting to the database server, executing SQL commands, and managing transactions.

1.1. Creating an SQLAlchemy Engine:
The create_engine function from SQLAlchemy is used to create an engine. This function takes a database URL as an argument, which specifies the type of database and connection details. The term "dialect" is an important component of the URL.

Explanation of Dialect:

In SQLAlchemy, a dialect is a database-specific set of functions and SQL constructs. It provides the necessary translation between the SQL language and the specific database system you're using.
Dialects enable SQLAlchemy to communicate with various database backends, such as MySQL, PostgreSQL, SQLite, and many others, by generating the appropriate SQL statements and managing database-specific features.
When creating an engine, you specify the dialect in the URL. SQLAlchemy recognizes the dialect from the URL and configures the engine to work with the chosen database system.

lets create a engine for our mysql connection.
```python
from sqlalchemy import create_engine

# Define the MySQL database connection URL
db_url = "mysql://root:mypassword@localhost:3306/metadata"

# Create an SQLAlchemy engine
engine = create_engine(db_url, echo=True)
```

## Session for each connection
```python
Session = sessionmaker(bind=engine)
session = Session()
```
# Define a base for declarative class
```python
Base = declarative_base()
```
## Define and Create a Table
# Define the dataset table

```python
class Dataset(Base):
    __tablename__ = "dataset"

    id = Column(Integer, primary_key=True, autoincrement=True)
    filename = Column(String(255), unique=True, nullable=False)
    run_number = Column(Integer, nullable=False)
    total_event = Column(Integer, nullable=False)
    collision_type = Column(Text)
    data_type = Column(Text)
    collision_energy = Column(Integer, nullable=False)
```
# create the table
```python
Base.metadata.create_all(engine)
```

## Insert record
```python
dataset1 = Dataset(
    filename="expx.myfile1.root",
    run_number=100,
    total_event=1112,
    collision_type="pp",
    data_type="data",
    collision_energy=11275,
)
dataset2 = Dataset(
    filename="expx.myfile2.root",
    run_number=55,
    total_event=999,
    collision_type="pPb",
    data_type="mc",
    collision_energy=1127,
)

session.add(dataset1)
session.add(dataset2)
session.commit()
```

```python
# Query the filename column from the dataset table
results = session.query(Dataset.filename).all()

# Print the results
for result in results:
    print(result.filename)
```
```python
results1 = session.query(Dataset.filename).filter(Dataset.collision_type == "pp").all()
# Print the results for the first query
print("Filenames where collision_type is 'pp':")
for result in results1:
    print(result.filename)

results2 = (
    session.query(Dataset.filename)
    .filter(Dataset.run_number > 50, Dataset.collision_type == "pp")
    .all()
)
# Print the results for the second query
print("\nFilenames where run_number > 50 and collision_type is 'pp':")
for result in results2:
    print(result.filename)
```

```python
# Update a record in the table
record_to_update = (
    session.query(Dataset).filter(Dataset.filename == "expx.myfile1.root").first()
)
if record_to_update:
    record_to_update.collision_type = "PbPb"
    record_to_update.collision_energy = 300
    session.commit()

# Delete a record from the table
record_to_delete = (
    session.query(Dataset).filter(Dataset.filename == "expx.myfile2.root").first()
)
if record_to_delete:
    session.delete(record_to_delete)
    session.commit()

# Close the session
session.close()
```







## All susequent chapter to be discussed.
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
