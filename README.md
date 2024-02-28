# Data Engineer Challenge SQL

This repository contains the solution for the Data Engineer Challenge, including SQL scripts and Docker setup for an e-commerce database.

## Overview

The challenge involves creating SQL scripts to set up an e-commerce database and address specific business queries. Additionally, a Docker image is provided for easy deployment and testing.

## Instructions

### Build Docker Image

To build the Docker image, run the following commands:

```bash
docker build -t challenge-sql .
```

### Run Docker Container
After building the image, start a Docker container with the following command:

```bash
docker run -it challenge-sql
```

Finally, quit the console with the command `.exit`

## Diagram
The challenge contains a proposal for data modeling according to the suggested needs and requirements.
`diagram/der.png`: Image of the diagram suggested for solving the challenge.
`diagram/diagram.txt`: Content generated through `create_tables.sql` at https://dbdiagram.io/

## SQL Scripts
`sql/create_table.sql`: Contains SQL statements to create tables for the e-commerce database.
`sql/business_response.sql`: SQL queries providing solutions to business questions related to the e-commerce data.
`sql/create_triggers`: This script contains the triggers needed to store the events in the `Item` table, for a `HistoryUpdateItems` table
`sql/create_trigger_events.sql`: This is a script to test whether events are happening as expected.

## Contributing
Feel free to contribute by opening issues or submitting pull requests.
