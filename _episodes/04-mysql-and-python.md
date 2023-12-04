---
title: "SQLAlchemy and MySQL: Exercises"
teaching: 5
exercises: 6
questions:
- "How to perform CRUD operations using SQLAlchemy?"
- "How to query and filter records in SQLAlchemy?"
objectives:
- "Practice inserting records into a MySQL database using SQLAlchemy."
- "Perform queries and filtering on the dataset table."
- "Update and delete records in the dataset table."
keypoints:
- "CRUD operations in SQLAlchemy: Create, Read, Update, Delete."
- "Querying and filtering records based on specific conditions."
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
pip install cryptography
pip install pymysql
```

## Setting Up the Database Connection:

SQLAlchemy facilitates database connections in Python by using an Engine, which acts as the interface between the application and the database. The Engine manages database communication, executing SQL commands, and transaction handling. It requires a connection URL specifying the database type, credentials, and other connection details, allowing SQLAlchemy to interact seamlessly with various database systems through the specified dialects. Sessions, managed by sessionmaker, handle interactions between the application and the database, allowing for transactions, queries, and data manipulation in a structured manner.

Lets import necessary things.
```python
from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base, sessionmaker
from sqlalchemy import Column, Integer, String, Text
```

Now lets create a URL for our database connection.
URL componets.
* Dialect: Specifies the type of database being used (e.g., MySQL, PostgreSQL, SQLite). We use mysql.
* Driver: Identifies the library or driver used to interact with the database (e.g., PyMySQL for MySQL). We will use pymysql
* Username and Password: Credentials for accessing the database.
* Hostname and Port: Address and port number where the database server is located.
* Database Name: Name of the specific database to connect to.

So URl structure is : `Dialect+driver://username:password@hostname:port/databaseName`

And we create a engine using this db_url.
```python
# Define the MySQL database connection URL
db_url = "mysql+pymysql://root:mypassword@localhost:3306/metadata"

# Create an SQLAlchemy engine
engine = create_engine(db_url)
```


## Session for each connection
sessionmaker is a factory function that creates a session factory in SQLAlchemy. Sessions are used to interact with a database in SQLAlchemy, providing a way to persist, retrieve, and manipulate data. sessionmaker generates a configurable factory for creating sessions, allowing you to customize settings such as autocommit behavior, autoflush, and more. Sessions obtained from the session factory represent a single "unit of work" with the database, encapsulating a series of operations that should be treated atomically.
Lets open a session that will be used to do DB operation from python to sql using engine that we created.

```python
Session = sessionmaker(bind=engine)
session = Session()
```

## Define a base for declarative class
Declarative Base is a factory function from SQLAlchemy that generates a base class for declarative data models. This base class allows you to define database tables as Python classes, making it easier to define models by mapping Python classes to database tables. The classes created with declarative_base() typically inherit from this base class, and they include table schema definitions as class attributes.

```python
Base = declarative_base()
```

## Define and Create a Table
Now we will define the table named `dataset`.
# Define the dataset table
Here we have a column named `id` defined as an Integer type and serves as the primary key for the table. It auto-increments, meaning its value automatically increases for each new row added to the table.
We set `filename` column as unique so that there is no duplication of filename in the table.
The option `nullable` , if set to false then it must have a value.

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
The following code `Base.metadata.create_all(engine)` is an SQLAlchemy command that instructs the engine to create database tables based on the defined models (such as Dataset) mapped to SQLAlchemy classes (derived from Base) within the application. This command generates the corresponding SQL statements to create tables in the specified database (referenced by engine) based on the model definitions provided in the code.

```python
Base.metadata.create_all(engine)
```

## Insert record
Lets insert two records in to the Table.

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
session.commit() is a command that effectively saves the changes made within the session to the database. This action persists the changes permanently in the database, making the additions to the table permanent and visible for subsequent transactions.

## Search the databse.
`session.query()`` is used to create a query object that represents a request for data from the database. In this case, session.query(Dataset.filename) selects the filename column from the Dataset table. The .all() method executes the query and retrieves all the values from the filename column, returning a list of results containing these values from the database.

```python
# Query the filename column from the dataset table
results = session.query(Dataset.filename).all()

# Print the results
for result in results:
    print(result.filename)
```

{: .source}

> ## Search on different column
>
> Retrieve and display all collision_tpe 
>
> > ## Solution
> >
> > ```python
> >results = session.query(Dataset.collison_type).all()
> >for result in results:
        print(result.collison_type)
> > ```
> > {: .source}
> >
> > ~~~
> > pp
> > pPb
> > ~~~
> > {: .output}
> {: .solution}
{: .challenge}

# Search the database with condition.
In SQLAlchemy, the filter() method is used within a query() to add conditions or criteria to the query. It narrows down the selection by applying specific constraints based on the given criteria.

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

{: .source}

> ## Search using OR statement
>
> Retrieve and display filenames with "mc" data_type and collision_energy>1000
>
> > ## Solution
> >
> > ```python
> >results = session.query(Dataset.filename).filter((Dataset.data_type =="mc") | (Dataset.collision_energy>1000 )).all()
> >for result in results:
> >       print(result.collison_type)
> > ```
> > {: .source}
> >
> > ~~~
> > expx.myfile1.root
> > expx.myfile2.root
> > ~~~
> > {: .output}
> {: .solution}
{: .challenge}

## Update the database
To update a record in a table, you begin by querying for the specific record or records you want to update using query(). The filter() method is used to specify the conditions for the selection. Once you have the record(s) to update, modify the attributes as needed. Finally, calling session.commit() saves the changes made to the database. This ensures that the modifications are persisted permanently.

```python
# Update a record in the table
record_to_update = (
    session.query(Dataset).filter(Dataset.filename == "expx.myfile1.root").first()
)
if record_to_update:
    record_to_update.collision_type = "PbPb"
    record_to_update.collision_energy = 300
    session.commit()
```
{: .source}

> ## Update
>
> Update `run_number` to 1000 for record with data_type `mc`. 
>
> > ## Solution
> >
> > ```python
> >record_to_update = (session.query(Dataset).filter(Dataset.data_type == "mc").first())
> > if record_to_update:
> >       record_to_update.run_number = 1000
> >     session.commit()
> > ```
> > {: .source}
> >
> > ~~~
> > 
> > 
> > ~~~
> > {: .output}
> {: .solution}
{: .challenge}

## Delete the database
Basically the same, we need to first get the record to update using query and filter. Then delete the record and commit to see the changes.
```python
# Delete a record from the table
record_to_delete = (
    session.query(Dataset).filter(Dataset.filename == "expx.myfile2.root").first()
)
if record_to_delete:
    session.delete(record_to_delete)
    session.commit()
```
## Close the session
It's essential to close the session after you've finished working with it to release the resources associated with it, such as database connections and transactional resources. By closing the session, you ensure that these resources are properly released, preventing potential issues like resource leakage and maintaining good database connection management practices.

```python
session.close()
```
