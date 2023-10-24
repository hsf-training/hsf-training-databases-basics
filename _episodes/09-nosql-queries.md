---
title: "NoSQL queries"
teaching: x
exercises: x
- ""
- ""
objectives:
- ""
- ""
keypoints:
- ""
- ""
---

# Elasticsearch Basics

In this section, we'll explore fundamental Elasticsearch queries and concepts.

## Elasticsearch Queries

Elasticsearch provides powerful search capabilities. Here are some core Elasticsearch queries that you'll use:

- **Create an Index**: Create a new index.
- **Create a Mapping**: Define the data structure for your documents.
- **Index Documents**: Insert new documents into an index.
- **Search Documents**: Retrieve data from an index.
- **Update Documents**: Modify existing data in documents.
- **Delete Documents**: Remove documents from an index.

## Setting up for Elasticsearch Queries

To interact with Elasticsearch, you'll typically use a client library or a tool like Kibana. Ensure you have Elasticsearch installed and configured.

## Creating an Index

First, let's create an Elasticsearch index named "metadata."

```json
PUT /metadata
{
  "settings": {
    "number_of_shards": 1,
    "number_of_replicas": 1
  }
}

POST /metadata/dataset/1
{
  "filename": "example_file1",
  "run_number": 12345,
  "total_event": 1000000,
  "collision_type": "PbPb",
  "data_type": "simulated",
  "collision_energy": 200
}

GET /metadata/dataset/_search
{
  "query": {
    "match_all": {}
  }
}

GET /metadata/dataset/_search
{
  "query": {
    "term": {
      "collision_type": "PbPb"
    }
  }
}


POST /metadata/dataset/1/_update
{
  "doc": {
    "data_type": "new_data_type"
  }
}

DELETE /metadata/dataset/1

```

```python
from elasticsearch import Elasticsearch
#from opensearchpy import OpenSearch

# Initialize an OpenSearch client
#es = OpenSearch(hosts=["http://localhost:9200"])

# Initialize an Elasticsearch client
es = Elasticsearch([{'host': 'localhost', 'port': 9200}])

# Create an Elasticsearch index
index_name = "metadata"
index_settings = {
    "settings": {
        "number_of_shards": 1,
        "number_of_replicas": 1
    }
}
es.indices.create(index=index_name, body=index_settings)

# Index a document
document = {
    "filename": "example_file1",
    "run_number": 12345,
    "total_event": 1000000,
    "collision_type": "PbPb",
    "data_type": "simulated",
    "collision_energy": 200
}
# We're not specifying document_id here

es.index(index=index_name, doc_type="dataset", body=document)

# Search for documents by filename
search_query = {
    "query": {
        "term": {
            "filename.keyword": "example_file1"  # Search by filename
        }
    }
}
search_results = es.search(index=index_name, doc_type="dataset", body=search_query)
for hit in search_results['hits']['hits']:
    print(hit['_source'])

# Update a document by filename
update_query = {
    "doc": {
        "data_type": "new_data_type"
    }
}
# Update based on the "filename" field
es.update_by_query(index=index_name, doc_type="dataset", body={"query": {"term": {"filename.keyword": "example_file1"}}}, body=update_query)

# Delete a document by filename
delete_query = {
    "query": {
        "term": {
            "filename.keyword": "example_file1"  # Delete by filename
        }
    }
}
# Delete based on the "filename" field
es.delete_by_query(index=index_name, doc_type="dataset", body=delete_query)

```