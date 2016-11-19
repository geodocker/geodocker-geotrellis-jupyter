#!/bin/sh

scl enable python33 'jupyter toree install --spark_opts="--master spark://spark-master:7077 --jars file:///tmp/geotrellis-uberjar-assembly-1.0.0-RC1.jar"'
scl enable python33 'jupyterhub --no-ssl'
