---
title: "NOSQL Queries"
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

## Setting up for Elasticsearch/Opensearch Queries

Install the elasticsearch Python Cleint:
```bash
pip install elasticsearch
```

Install the OpenSearch Python client:
```bash
pip install opensearch-py
```


## Creating an Index
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
```

## Index into a document

```python
# Index a document
document1 = {
    "filename": "expx.myfile1.root",
    "run_number": 100,
    "total_event": 1112,
    "collision_type": "pp",
    "data_type": "data",
    "collision_energy": 11275
}
document2 = {
    "filename": "expx.myfile2.root",
    "run_number": 55,
    "total_event": 999,
    "collision_type": "pPb",
    "data_type": "mc",
    "collision_energy": 1127
}

es.index(index=index_name, doc_type="dataset", body=document)
#es.index(index=index_name, doc_type="dataset", body=document2)

```

# Search for documents by filename
```python
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
```

# Update a document by filename
```python
update_query = {
    "doc": {
        "data_type": "new_data_type"
    }
}
# Update based on the "filename" field
es.update_by_query(index=index_name, doc_type="dataset", body={"query": {"term": {"filename.keyword": "expx.myfile1.root"}}}, body=update_query)
```


# Delete a document by filename
```python
delete_query = {
    "query": {
        "term": {
            "filename.keyword": "expx.myfile1.root"  # Delete by filename
        }
    }
}
# Delete based on the "filename" field
es.delete_by_query(index=index_name, doc_type="dataset", body=delete_query)
```