
---
title: "A bit more on queries"
teaching: 60
exercises: 30
questions:
- "How to perform SQL Join?"
- "How to make use of different SQL joins?"
objectives:
- "To retrieve data from multiple tables Simultaneously when data is related."
keypoints:
- "Performing different joins depending on the related column."
---

## SQL JOIN

In SQL, JOIN operations are used to combine rows from two or more tables based on a common column. Different types of JOINs can be used depending on your needs.

In this tutorial, we'll explore various JOIN types using the *dataset* and *experiments* tables.

Note: If you haven't created these tables in your database yet, please refer to the basic MySQL queries in the introduction tutorial to set them up.

Consider the following two tables (*dataset* and *experiments*) for our tutorial:

Example:
~~~
mysql> SELECT * FROM dataset;
+----+--------------------+------------+-------------+----------------+-----------+------------------+
| id | filename           | run_number | total_event | collision_type | data_type | collision_energy |
+----+--------------------+------------+-------------+----------------+-----------+------------------+
|  1 | lhcb.myfile.root   |        101 |        1234 | pp             | data      |            13400 |
|  2 | atlas.myfile.root  |        202 |        5678 | pp             | mc        |            13000 |
|  3 | cms.myfile.root    |        303 |        9101 | pp             | data      |            13600 |
|  4 | alice.myfile.root  |        404 |        1123 | Pb-Pb          | mc        |            55000 |
|  5 | belle2.myfile.root |        505 |        3141 | e⁺e⁻           | data      |            10500 |
|  6 | babar.myfile.root  |        606 |        7890 | e⁺e⁻           | data      |            10000 |
+----+--------------------+------------+-------------+----------------+-----------+------------------+
~~~
~~~
mysql> SELECT * FROM experiments;
+----+-----------------+------+
| id | experiment_name | year |
+----+-----------------+------+
|  1 | LHCb            | 2009 |
|  2 | ATLAS           | 2008 |
|  3 | CMS             | 2008 |
|  4 | ALICE           | 2010 |
|  5 | BELLE2          | 2018 |
+----+-----------------+------+
~~~

### INNER JOIN
An *INNER JOIN* returns records that have matching values in both tables.

Example: We want to get the *filename* and *experiment_name* for each dataset if there's a corresponding experiment.

We'll join on the *id* column to find the matching records.
```sql
SELECT d.filename, e.experiment_name
FROM dataset d
INNER JOIN experiments e
ON d.id = e.id;
```
~~~
+--------------------+-----------------+
| filename           | experiment_name |
+--------------------+-----------------+
| lhcb.myfile.root   | LHCb            |
| atlas.myfile.root  | ATLAS           |
| cms.myfile.root    | CMS             |
| alice.myfile.root  | ALICE           |
| belle2.myfile.root | BELLE2          |
+--------------------+-----------------+
~~~
One more example:
```sql
SELECT d.filename, e.experiment_name, d.total_event, d.collision_type, d.data_type, d.collision_energy
FROM dataset d
INNER JOIN experiments e
ON d.id = e.id;
```
~~~
+--------------------+-----------------+-------------+----------------+-----------+------------------+
| filename           | experiment_name | total_event | collision_type | data_type | collision_energy |
+--------------------+-----------------+-------------+----------------+-----------+------------------+
| lhcb.myfile.root   | LHCb            |        1234 | pp             | data      |            13400 |
| atlas.myfile.root  | ATLAS           |        5678 | pp             | mc        |            13000 |
| cms.myfile.root    | CMS             |        9101 | pp             | data      |            13600 |
| alice.myfile.root  | ALICE           |        1123 | Pb-Pb          | mc        |            55000 |
| belle2.myfile.root | BELLE2          |        3141 | e⁺e⁻           | data      |            10500 |
+--------------------+-----------------+-------------+----------------+-----------+------------------+
~~~
Note: *INNER JOIN* returns only the rows that have matching values in both tables.
- Features:
  - Returns rows where there is a match in both tables.
  - Only includes rows that have corresponding matches in the joined table.
### LEFT JOIN
A *LEFT JOIN* returns all records from the left table, and the matched records from the right table. The result is *NULL* from the right side if there is no match.

Example:
```sql
SELECT d.filename, e.experiment_name
FROM dataset d
LEFT JOIN experiments e
ON d.id = e.id;
```
~~~
+--------------------+-----------------+
| filename           | experiment_name |
+--------------------+-----------------+
| alice.myfile.root  | ALICE           |
| atlas.myfile.root  | ATLAS           |
| babar.myfile.root  | NULL            |
| belle2.myfile.root | BELLE2          |
| cms.myfile.root    | CMS             |
| lhcb.myfile.root   | LHCb            |
+--------------------+-----------------+
~~~
- Features:
  - Returns all rows from the left table (*dataset*), including unmatched rows.
  - Shows *NULL* for columns from the right table (*experiments*) if there is no match.

### RIGHT JOIN
A *RIGHT JOIN* returns all records from the right table, and the matched records from the left table. The result is *NULL* from the left side when there is no match.

Example:
```sql
SELECT e.experiment_name, d.filename
FROM experiments e
RIGHT JOIN dataset d
ON d.id = e.id;
```
~~~
+-----------------+--------------------+
| experiment_name | filename           |
+-----------------+--------------------+
| ALICE           | alice.myfile.root  |
| ATLAS           | atlas.myfile.root  |
| NULL            | babar.myfile.root  |
| BELLE2          | belle2.myfile.root |
| CMS             | cms.myfile.root    |
| LHCb            | lhcb.myfile.root   |
+-----------------+--------------------+
~~~
- Features:
  - Returns all rows from the right table (*experiments*), including unmatched rows.
  - Shows *NULL* for columns from the left table (*dataset*) if there is no match.

### FULL OUTER JOIN
A *FULL OUTER JOIN* returns all records when there is a match in either left or right table. This type of join is not directly supported in MySQL, but you can achieve it using *UNION*.

Example:
```sql
SELECT d.filename, e.experiment_name
FROM dataset d
LEFT JOIN experiments e
ON d.id = e.id
UNION
SELECT d.filename, e.experiment_name
FROM experiments e
LEFT JOIN dataset d
ON d.id = e.id;
```
~~~
+--------------------+-----------------+
| filename           | experiment_name |
+--------------------+-----------------+
| alice.myfile.root  | ALICE           |
| atlas.myfile.root  | ATLAS           |
| babar.myfile.root  | NULL            |
| belle2.myfile.root | BELLE2          |
| cms.myfile.root    | CMS             |
| lhcb.myfile.root   | LHCb            |
+--------------------+-----------------+
~~~
- Features:
  - Combines results from both *LEFT JOIN* and *RIGHT JOIN*.
  - Includes all rows from both tables, showing *NULL* where there is no match.


## Task: Joining Tables with Updated Schema
**Scenario:** You have updated the experiments table by adding a new *run_number* column, which matches some of the the *run_number* in the dataset table. You need to use this new column to retrieve combined data from both tables and then Write an SQL query to retrieve a list of columns including the filename, total event count, and the experiment name for each dataset. Ensure that the query matches the datasets to the corresponding experiments using the *run_number* column.

*Hint:* Use an *INNER JOIN* to combine the dataset and experiments tables based on the run_number column

```sql
ALTER TABLE experiments;
ADD COLUMN run_number INT;
UPDATE experiments SET run_number = 101 WHERE experiment_name = 'LHCb';
```

## Cross Join
A *CROSS JOIN* generates the Cartesian product of two tables, means every row from the first table is paired with every row from the second table. This can be useful for creating all possible combinations of rows, especially when crafting complex queries.

In MySQL, *JOIN*, *CROSS JOIN*, and *INNER JOIN* can often be used interchangeably. However, in standard SQL, they serve different purposes: *INNER JOIN* requires an ON clause to specify how tables should be matched, whereas *CROSS JOIN* creates a Cartesian product without any matching conditions.

To see how a *CROSS JOIN* works, let’s create an additional table named *additional_info* in the same database.
```sql
mysql> SELECT * FROM additional_info;
+----+-----------+------------+
| id | info_name | run_number |
+----+-----------+------------+
|  1 | Info A    |        101 |
|  2 | Info B    |        202 |
|  3 | Info C    |        303 |
|  4 | Info D    |        404 |
|  5 | Info E    |        505 |
+----+-----------+------------+
```
```sql
mysql> SELECT e.experiment_name, i.run_number FROM experiments e CROSS JOIN additional_info i;
+-----------------+------------+
| experiment_name | run_number |
+-----------------+------------+
| BELLE2          |        101 |
| ALICE           |        101 |
| CMS             |        101 |
| ATLAS           |        101 |
| LHCb            |        101 |
| BELLE2          |        202 |
| ALICE           |        202 |
| CMS             |        202 |
| ATLAS           |        202 |
| LHCb            |        202 |
| BELLE2          |        303 |
| ALICE           |        303 |
| CMS             |        303 |
| ATLAS           |        303 |
| LHCb            |        303 |
| BELLE2          |        404 |
| ALICE           |        404 |
| CMS             |        404 |
| ATLAS           |        404 |
| LHCb            |        404 |
| BELLE2          |        505 |
| ALICE           |        505 |
| CMS             |        505 |
| ATLAS           |        505 |
| LHCb            |        505 |
+-----------------+------------+
```

### Try Youself!
The below two queries have same output. Can you explain?
```sql
SELECT *
FROM dataset d
LEFT JOIN (experiments e, additional_info a)
ON (e.run_number = d.run_number AND a.run_number = d.run_number);
```

```sql
SELECT *
FROM dataset d
LEFT JOIN (experiments e CROSS JOIN additional_info a)
ON (e.run_number = d.run_number AND a.run_number = d.run_number);
```




### Enjoy Your SQL Journey!
