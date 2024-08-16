---
title: "Opensearch Text Based Queries"
teaching: x
exercises: 2
questions:
- "How to perform text based search in opensearch?"
- "What are the ways to do text based search in opensearch?"

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
## Match Phrase Query
Search for documents containing an exact phrase in the description field.
Structure of query is:
```JSON
{
    "query": {
        "match_phrase": {
            "<field>": "<phrase>"
        }
    }
}
```
Lets search for document(s) with exact phrase "without beam background" in description field.
```python
search_query = {"query": {"match_phrase": {"description": "without beam background"}}}

search_results = es.search(index=index_name, body=search_query)

for hit in search_results["hits"]["hits"]:
    print(hit["_source"])
```

{: .source}

> ## Search for documents with exact phrase "without chrenkov detector" .
>
> Retrieve documents with match phrase query.
>
> > ## Solution
> >
> > ```python
> > search_query = {
> >     "query": {
> >        "match_phrase": {
> >             "description": "without chrenkov detector"
> >         }
> >     }
> >}
> > search_results = es.search(index=index_name, body=search_query)
> > for hit in search_results["hits"]["hits"]:
        print(hit["_source"]["filename"])
> > ```
> > {: .source}
> >
> > ~~~
> > {'filename': 'expx.myfile3.root', 'run_number': 120, 'total_event': 200, 'collision_type': 'PbPb', 'data_type': 'data', 'collision_energy': 150, 'description': 'This file is produced without chrenkov detector'}
> > ~~~
> > {: .output}
> {: .solution}
{: .challenge}

## Match query
The match query is a basic query type in opensearch used to search for documents containing specific words or phrases in a specified field, such as the description field.
Structure of query is:
```JSON
{
    "query": {
        "match": {
            "query": "<text>"
        }
    }
}
```
Lets search for documents containing words "without" or "beam" in description field. Here it looks for document containing either of the words.
```python
search_query = {"query": {"match": {"description": "without beam"}}}

search_results = es.search(index=index_name, body=search_query)

for hit in search_results["hits"]["hits"]:
    print(hit["_source"])
```
You should see three documents with filename expx.myfile2.root , expx.myfile3.root and expx.myfile4.root, as these document contain either of word without or beam.
You can also add operator `and` for the query so that all the words are present in the field.
```JSON
{
    "query": {
        "match": {
            "query": "<text>",
            "operator": "and"
        }
    }
}

```
Example , to get the documents with word "beam" and "chrenkov" you will do.

```python
search_query = {
    "query": {"match": {"description": {"query": "beam chrenkov", "operator": "and"}}}
}

search_results = es.search(index=index_name, body=search_query)

for hit in search_results["hits"]["hits"]:
    print(hit["_source"])
```
{: .source}

> ## Search for documents with words "chrenkov" or  "trigger" .
>
> Retrieve documents with match phrase query.
>
> > ## Solution
> >
> > ```python
> > search_query = {
> >     "query": {
> >        "match": {
> >             "description": "chrenkov trigger"
> >         }
> >     }
> >}
> > search_results = es.search(index=index_name, body=search_query)
> > for hit in search_results["hits"]["hits"]:
        print(hit["_source"]["filename"])
> > ```
> > {: .source}
> >
> > ~~~
> > {'filename': 'expx.myfile3.root', 'run_number': 120, 'total_event': 200, 'collision_type': 'PbPb', 'data_type': 'data', 'collision_energy': 150, 'description': 'This file is produced without chrenkov detector'}
> > {'filename': 'expx.myfile1.root', 'run_number': 100, 'total_event': 1112, 'collision_type': 'pp', 'data_type': 'data', 'collision_energy': 250, 'description': 'This file is produced with L1 and L2 trigger.'}
> > ~~~
> > {: .output}
> {: .solution}
{: .challenge}

# query_string

# Wild card
Wildcard queries are used to search for documents based on patterns or partial matches within a field. In the example below, a wildcard query is used to search for documents where the description field contains any L trigger ie. L1/L2.
```python
search_query = {
    "query": {"query_string": {"default_field": "description", "query": "L*"}}
}

search_results = es.search(index=index_name, body=search_query)

for hit in search_results["hits"]["hits"]:
    print(hit["_source"]["description"])
```
You should see single document with filename expx.myfile1.root.

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
