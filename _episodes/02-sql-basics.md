---
title: "MySQL Basics"
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

# SQL Basics

In this section, we'll cover fundamental SQL commands that are essential for working with MySQL.

## SQL Commands

Here are some of the core SQL commands that you'll use in MySQL:

- `CREATE DATABASE`: Create a new database.
- `CREATE TABLE`: Create a new table.
- `INSERT INTO`: Insert new records into a table.
- `SELECT`: Retrieve data from a database.
- `UPDATE`: Modify existing data in a table.
- `DELETE`: Remove data from a table.

## setting up for sql commands 
In the terminal , run the follwoing command
~~~bash
docker exec -it metadata bash -c "mysql -uroot -pmypassword"
~~~
Then you will see mysql command prompt as ``mysql>`` . All the sql command has to be typed in this command prompt.

## Creating a Database

We will first create a database named ``metadata`` in our mysql server.
```sql
CREATE DATABASE metadata;
```

To work with a specific database, you can use the USE command. For instance, to select the "metadata" database:
```sql
USE metadata;
```

Tables are used to structure and store data. Here's how you can create a table named "dataset" within the "metadata" database:
```sql
CREATE TABLE dataset (
    id INT AUTO_INCREMENT PRIMARY KEY,
    filename VARCHAR(255) NOT NULL UNIQUE,
    run_number INT NOT NULL,
    total_event INT NOT NULL,
    collision_type TEXT,
    data_type TEXT,
    collision_energy INT NOT NULL
);
```

collision_type = "PbPb, pp, pPb, Interfill"

You can use the INSERT INTO command to add records to a table. Here's an example of inserting data into the "dataset" table:
```sql
INSERT INTO dataset (filename, run_number, total_event, collision_type, data_type collision_energy)
VALUES (expx.myfile1.root, 100, 1112, "pp", "data", 11275)
```

```sql
INSERT INTO dataset (filename, run_number, total_event, collision_type, data_type collision_energy)
VALUES (expx.myfile2.root, 55, 999, "pPb", "mc", 1127)
```

The SELECT command allows you to retrieve data from a table. To retrieve all records from the "dataset" table, you can use:
```sql
SELECT * FROM dataset;
```
You can select specific columns by listing them after the SELECT statement:
```sql
SELECT filename FROM dataset;
```

To filter data based on certain conditions, you can use the WHERE clause. For example, to select filenames where the "collision_type" is 'pp':
```sql
SELECT filename FROM dataset WHERE collision_type='pp';
SELECT filename FROM dataset WHERE run_number > 50;
SELECT filename FROM dataset WHERE run_number > 50 AND collision_type='pp';
```

{: .source}

> ## SELECT on different condition
>
> Get the filename of condition event_number > 1000 and data_type is ``mc``
>
> > ## Solution
> >
> > ```sql
> >SELECT filename FROM dataset WHERE event_number > 1000 AND data_type='mc';
> > ```
> > {: .source}
> >
> > ~~~
> > xxxx
> > ~~~
> > {: .output}
> {: .solution}
{: .challenge}

The UPDATE command is used to make changes to existing data. For example, if you want to update the "data_type" for a specific record, you can use:

```sql
UPDATE dataset 
SET collision_type = 'new_type', collision_energy = 300
WHERE filename = 'expx.myfile1.root';
```

The DELETE command is used to remove data from a table. To delete a record with a specific filename, you can use:
```sql
DELETE FROM dataset
WHERE filename = 'expx.myfile2.root';
```
