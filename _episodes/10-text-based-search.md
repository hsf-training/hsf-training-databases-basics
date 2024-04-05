
---
title: "Opensearch Text Based Queries"
teaching: x
exercises: x
questions:
- ""
- ""

objectives:
- "Understand the fundamental query types in Opensearch for text-based searches."
- "Learn how to construct and execute various text-based queries using Opensearch."

keypoints:
- "Opensearch supports a range of text-based query types, including match, match_phrase, wildcard, prefix, and fuzzy queries."
- "Each query type has specific use cases and parameters that can be customized for tailored search results."
- "Efficient utilization of text-based queries in Opensearch can significantly enhance data retrieval and analysis capabilities"
---

# Text Based Queries
Opensearch is a powerful search and analytics engine that excels in handling text-based queries efficiently.
Understanding how to construct and utilize text-based queries in Opensearch is crucial for effective data retrieval and analysis.
This guide will delve into the concepts and techniques involved in Opensearch text-based queries.




# Match Query:
The match query is a basic query type in opensearch used to search for documents containing specific words or phrases in a specified field, such as the description field. Here's an example of a match query searching for the term "physics" in the description field:
{
    "query": {
        "match": {
            "description": "physics"
        }
    }
}

Match Phrase Query:
Search for documents containing an exact phrase in the description field.

{
    "query": {
        "match_phrase": {
            "description": "Dataset produced using my a config and z physics"
        }
    }
}


# Wild card
Wildcard queries are used to search for documents based on patterns or partial matches within a field. In the example below, a wildcard query is used to search for documents where the description field contains any text with the letter "p":
```python
search_query = {
    "query": {"query_string": {"default_field": "description", "query": "*p*"}}
}

search_results = es.search(index=index_name, body=search_query)

for hit in search_results["hits"]["hits"]:
    print(hit["_source"]["description"])
```


# Prefix Query:
Prefix queries are used to search for documents where a specified field starts with a specific prefix. For example, the prefix query below searches for documents where the filename field starts with "expx.":
```python
search_query = {"query": {"prefix": {"filename": "expx."}}}
```
search_results = es.search(index=index_name, body=search_query)

for hit in search_results["hits"]["hits"]:
    print(hit["_source"]["filename"])
This query will match documents with filenames like "expx.csv," "expx_data.txt," etc.


# Fuzzy Query:
Fuzzy queries are used to find documents with terms similar to a specified term, allowing for some degree of error or variation. In the example below, a fuzzy query is used to search for documents with terms similar to "produced" in the description field:
```python
search_query = {"query": {"fuzzy": {"description": "physic"}}}

search_results = es.search(index=index_name, body=search_query)

for hit in search_results["hits"]["hits"]:
    print(hit["_source"]["description"])
```

This query will match documents with terms like "production," "producer," "products," etc., based on the fuzziness parameter specified.
