#!/bin/bash

export PYSPARK_PYTHON=python3
PYSPARK_DRIVER_PYTHON=jupyter PYSPARK_DRIVER_PYTHON_OPTS="notebook --no-browser --port=7777" pyspark --packages com.databricks:spark-csv_2.10:1.1.0 --executor-memory 6400M --driver-memory 6400M
