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
We will use pythonic client called `opensearch-py` to query Opensearch.

Install the OpenSearch Python client:
```bash
pip install opensearch-py
```

TODO: Say a few words about python environments


## Creating an Index
Index is a logical namespace that holds a collection of documents. It defines the schema or structure of the documents it contains, including the fields and their data types.
Mapping refers to the definition of how fields and data types are structured within documents stored in an index. It defines the schema or blueprint for documents, specifying the characteristics of each field such as data type, indexing options, analysis settings, and more.
If no mapping is provided opensearch index it by itself.
We will define mapping for the metadata attributes. For string we have two data type option. keyword type is used for exact matching and filtering and test type is used for full-text search and analysis.

```python
from opensearchpy import OpenSearch

OPENSEARCH_HOST = "localhost"
OPENSEARCH_PORT = 9200
OPENSEARCH_USERNAME="admin"
OPENSEARCH_PASSWORD="<custom-admin-password>"
# Initialize an Opensearcg client
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
            "collision_energy": {"type": "integer"},
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
we will index two documents into the "metadata" index. Each document represents a dataset with various fields like filename, run number, total events, collision type, data type, collision energy, and description.

The `_op_type` parameter in the bulk indexing operation specifies the operation type for each document. In this case, we're using  "create", which creates a new document only if it doesn't already exist. If a document with the same ID already exists, the "create" operation will fail. The other common operation type is "index", which overwrites document if it already exists.


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
documents = [document1, document2]
print("number of doduments to be indexed indexed:  %s"  str(len(documents)))
```
### Synchronous indexing

```python
for document in documents:
    _id =  document["filename"]
    res = es.index(index=index_name, id= _id,  body=document, op_type='create')
    print(res)
```

### Bulk Indexing
The bulk function from the OpenSearch Python client is used to perform bulk indexing operations, which is more efficient than indexing documents one by one.

```python
actions = []
duplicates = []
for document in documents:
    _id =  document["filename"]

    # Check if document exists already
    if es.exists(index=index_name, id=_id):
        duplicates.append(document)

    else:
        actions.append({
                "_index": index_name,
                "_id": _id,
                "_source": document,
                "_op_type": "create"
            })
from opensearchpy import OpenSearch, helpers

res = helpers.bulk(es, actions)
print("number of successfully indexed documents: %s"  str(res[0]))
```


## Search for documents

### Term Query
A term query is a type of query used to search for documents that contain an exact term or value in a specific field. It can be applied to keyword and integer data types.

```python
search_query = {
    "query": {"term": {"collision_type": "pp"}}  # Search by filename
}
search_results = es.search(index=index_name, body=search_query)
for hit in search_results["hits"]["hits"]:
    print(hit["_source"])
```

### Must Query
The must query combines multiple conditions and finds documents that match all specified criteria. This is equivalent to AND operator.

```python
search_query = {
    "query": {
        "bool": {
            "must": [
                { "term": {"collision_type": "pp"} },
                { "term": { "data_type": "mc" } }
            ]
        }
    }
}
search_results = es.search(index=index_name, body=search_query)
for hit in search_results["hits"]["hits"]:
    print(hit["_source"])
```

### Should Query
The should query searches for documents that match any of the specified conditions. This is equivalent to OR operator.

```python
search_query = {
    "query": {
        "bool": {
            "should": [
                { "term": {"collision_type": "pp"} },
                { "term": { "collision_energy": 1127 } }
            ]
        }
    }
}
search_results = es.search(index=index_name, body=search_query)
for hit in search_results["hits"]["hits"]:
    print(hit["_source"])
```

### Must Not Query
The must_not query excludes documents that match the specified condition. This is equivalent to NOT operator.


```python
search_query = {
    "query": {
        "bool": {
            "must_not": [
                { "term": {"collision_type": "pp"} }
            ]
        }
    }
}
search_results = es.search(index=index_name, body=search_query)
for hit in search_results["hits"]["hits"]:
    print(hit["_source"])
```


### Range Query
A range query is used to search for documents within a specified range of values for numeric or date fields.
```python
search_query = {
    "query": {
        "bool": {
            "filter": [
                { "range": { "run_number": { "gte": 60, "lte": 101 } } }
            ]
        }
    }
}
search_results = es.search(index=index_name, body=search_query)
for hit in search_results["hits"]["hits"]:
    print(hit["_source"])
```


# Update a document by filename
Lets update a field of a docuement, There are two ways you can do this.  The first approach uses the update_by_query method, which updates documents that match a specific query. In this case, it updates the "data_type" field of the document with the filename "expx.myfile1.root" to "new_data_type".
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

The second approach uses the update method, which updates a specific document by its ID (_id). It updates the "data_type" field of the document with the ID "expx.myfile1.root" to "new_data_type".

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
