---
title: "Introduction to NoSQL"
teaching: 60
exercises: 30
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

# NOSQL Databases
NSQL databases diverge from the traditional table-based structure of RDMS and are designed to handle unstructured or
semi-structured data. They offer flexibility in data modeling and storage, supporting various data formats. Types of NoSQL database are :

| NoSQL Database Type       | Description                                                  | Examples                                     |
| ------------------------- | ------------------------------------------------------------ | -------------------------------------------- |
| Key-Value Store           | Stores data as key-value pairs. Simple and efficient for basic storage and retrieval operations. | Redis, DynamoDB, Riak                        |
| Document-Oriented         | Stores data in flexible JSON-like documents, allowing nested structures and complex data modeling. | MongoDB, Couchbase, CouchDB, OpenSearch, Elasticsearch                  |
| Column-Family Store       | Organizes data into columns rather than rows, suitable for analytical queries and data warehousing. | Apache Cassandra, HBase, ScyllaDB             |
| Graph Database            | Models data as nodes and edges, ideal for complex relationships and network analysis. | Neo4j, ArangoDB, OrientDB                      |
| Wide-Column Store         | Similar to column-family stores but optimized for wide rows and scalable columnar data storage. | Apache HBase, Apache Kudu, Google Bigtable     |

# Opensearch Databases
Opensearch is kind of NoSQL database which is document oriented. It stores data as JSON documents.
It is also a distributed search and analytics engine designed for scalability, real-time data processing, and full-text search capabilities.
It is often used for log analytics, monitoring, and exploring large volumes of structured and unstructured data.

In the following chapters, we will build a metadata search engine/database. We will exploit the functionality of OpenSearch to create a database where we can store files with their corresponding metadata, and look for the files that match metadata queries.
