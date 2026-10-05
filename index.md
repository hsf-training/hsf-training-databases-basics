---
title: "Introduction to Databases for HEP"
subtitle: "An HSF Training lesson on databases with applications in High Energy and Nuclear Physics"
---

Experiments in High Energy Physics (HEP) and Nuclear Physics produce far more than event data.
File catalogs, run bookkeeping, detector calibrations and alignments, and collaboration records all
need to be stored, searched, and kept consistent, often by many people and services at once.
Databases are the tool for this job.

This lesson introduces database fundamentals through hands-on examples from HEP. You will work with a
relational database (MySQL), a lightweight embedded database (SQLite), and a document-oriented
NoSQL search engine (OpenSearch). Along the way you will build a small metadata catalog for experiment files
and model a simplified conditions database.

:::{important} Prerequisites
* Comfort working in a Unix shell (navigating directories, running commands).
  If you need a refresher, see the [HSF Unix Shell lesson](https://hsf-training.github.io/hsf-training-unix-shell/00-setup.html).
* Basic knowledge of Python (variables, functions, lists and dictionaries, installing packages with `pip`).
  See the [HSF Python lesson](https://hsf-training.github.io/analysis-essentials/python/README.html) if needed.
* A GitHub account (to use GitHub Codespaces), or Docker/Apptainer available on your machine.
  Familiarity with containers is helpful but not required; see the
  [HSF Docker lesson](https://hsf-training.github.io/hsf-training-docker/).
:::

## What you will learn

By the end of this lesson you will be able to:

* Explain what a database management system is, and when to choose a relational or a non-relational database.
* Create databases and tables, and insert, query, update, and delete records with SQL.
* Combine data from related tables using SQL joins.
* Interact with a database from Python using SQLAlchemy, without writing raw SQL.
* Describe the key concepts of a conditions database (Global Tags, Payloads, PayloadTypes, and Intervals of Validity) and query one.
* Create and query a self-contained SQLite database built from the Particle Data Group particle table.
* Index and search JSON documents in OpenSearch, including term, range, compound, and full-text queries.


## Getting started

Follow the instructions on the [Setup](setup.md) page before starting with the chapters.

:::{note} About HSF Training
This lesson is part of the [HEP Software Foundation (HSF) Training](https://hepsoftwarefoundation.org/training/curriculum.html)
curriculum. Find more lessons and upcoming events in the
[HSF Training Center](https://hepsoftwarefoundation.org/training/center.html).

The lesson is developed by the community. Found a typo, or want to suggest an improvement? Please
[open an issue or a pull request](https://github.com/hsf-training/hsf-training-databases-basics) on GitHub.
:::
