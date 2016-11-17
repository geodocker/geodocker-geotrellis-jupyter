#!/bin/bash

echo "Running entrypoint.sh $*"

if [ -z "$1" ]; then
    echo "Starting Jupyter notebook in local mode"
    exec scl enable python33 "PYSPARK_PYTHON=python3 PYSPARK_DRIVER_PYTHON=jupyter PYSPARK_DRIVER_PYTHON_OPTS='notebook --no-browser --port=7777' pyspark --master 'local[*]' --executor-memory 6400M --driver-memory 6400M"
else
    echo "Starting Jupyter notebook with args: $*"
    exec scl enable python33 "PYSPARK_PYTHON=python3 PYSPARK_DRIVER_PYTHON=jupyter PYSPARK_DRIVER_PYTHON_OPTS='notebook --no-browser --port=7777' pyspark --executor-memory 6400M --driver-memory 6400M $*"
fi
