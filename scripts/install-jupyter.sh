#!/bin/sh

set -x

npm install -g configurable-http-proxy
# install jupyter and jupyterhub python modules
pip3 install -r /tmp/requirements.txt

ln -s $SPARK_HOME /usr/local/spark

# Add User
useradd jack -m
echo 'jack:jack' | chpasswd