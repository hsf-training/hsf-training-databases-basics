---
title: "Opensearch Queries"
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

# Opensearch Basics

In this section, we'll explore fundamental Opensearch queries and concepts.

## Opensearch Queries

Opensearch provides powerful search capabilities. Here are some core Opensearch queries that you'll use:

- **Create an Index**: Create a new index.
- **Create a Mapping**: Define the data structure for your documents.
- **Index Documents**: Insert new documents into an index.
- **Search Documents**: Retrieve data from an index.
- **Update Documents**: Modify existing data in documents.
- **Delete Documents**: Remove documents from an index.

## Setting up for Opensearch Queries

Install the OpenSearch Python client:
```bash
pip install opensearch-py
```


## Creating an Index
```python
from opensearchpy import OpenSearch

OPENSEARCH_HOST = "localhost"
OPENSEARCH_PORT = 9200
OPENSEARCH_USERNAME="admin"
OPENSEARCH_PASSWORD="<custom-admin-password>"
# Initialize an Elasticsearch client
es = OpenSearch(
        hosts = [{'host': OPENSEARCH_HOST, 'port': OPENSEARCH_PORT}],
        http_auth = (OPENSEARCH_USERNAME, OPENSEARCH_PASSWORD),
        use_ssl = True,
        verify_certs = False
        )
```

## Create an Opensearch index
```python
index_name = "metadata"
# Define mappings for the index
mapping = {
       "properties": {
            "filename": {"type": "text"},
            "run_number": {"type": "integer"},
            "total_event": {"type": "integer"},
            "collision_type": {"type": "keyword"},
            "data_type": {"type": "keyword"},
            "collision_energy": {"type": "integer"}
            "description" : {"type": "text",  "analyzer": "standard"}
        }
    }
# define setting of index
index_body = {
        'settings': {
            'index': {
            'number_of_shards': 1
            }
        },
        'mappings': mapping
        }
# create the index
es.indices.create(index=index_name, body=index_body)
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
    "collision_energy": 11275,
    "description" : "Dataset produced uing my x config for y physics"
}
document2 = {
    "filename": "expx.myfile2.root",
    "run_number": 55,
    "total_event": 999,
    "collision_type": "pPb",
    "data_type": "mc",
    "collision_energy": 1127,
    "description" : "Dataset produced uing my a config and z physics"
}

# check is document already exists
for document in [document1, document2]:
    _id = document["filename"]
    is_exists = es.exists(index=INDEX_NAME, id=_id)
    if is_exists:
        continue
    else:
        es.index(index=index_name, body=document)

# bulk
actions = []
duplicates = []
for dataset in datasets:
    _id =  document["filename"]

    # Check if document exists already
    if es.exists(index=INDEX_NAME, id=_id):
        duplicates.append(dataset)

    else:
        actions.append({
                "_index": INDEX_NAME,
                "_id": _id,
                "_source": dataset,
                "_op_type": "index"
            })
bulk(es, actions)
```
describe _op_type (inmdex and create),


# Search for documents by filename
```python
search_query = {
    "query": {"term": {"filename.keyword": "example_file1"}}  # Search by filename
}
search_results = es.search(index=index_name, doc_type="dataset", body=search_query)
for hit in search_results["hits"]["hits"]:
    print(hit["_source"])
```

# Text Based Search
```python
search_query = {
    "query": {
        "query_string": {
            "default_field": "description",
            "query": "*p*"
        }
    }
}

search_results = es.search(index=index_name, doc_type="dataset", body=search_query)

for hit in search_results["hits"]["hits"]:
    print(hit["_source"]["filename"])
```


# Update a document by filename
```python
update_query = {"doc": {"data_type": "new_data_type"}}
# Update based on the "filename" field
es.update_by_query(
    index=index_name,
    doc_type="dataset",
    body={"query": {"term": {"filename.keyword": "expx.myfile1.root"}}},
    body=update_query,
)
```

```python
_id = "expx.myfile1.root"
data = {"data_type": "new_data_type"}
es.update(index=INDEX_NAME, id=_id, body= {"doc":data})
```


# Delete a document by filename (-> _id)
```python
delete_query = {
    "query": {"term": {"filename.keyword": "expx.myfile1.root"}}  # Delete by filename
}
# Delete based on the "filename" field
es.delete_by_query(index=index_name, doc_type="dataset", body=delete_query)
```

```python
_id = "expx.myfile1.root"
es.delete(index=index_name, id=_id)
```
