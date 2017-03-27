#!/bin/sh

set -x

npm install -g configurable-http-proxy
# install jupyter and jupyterhub python modules
pip3 install -r /tmp/requirements.txt

ln -s $SPARK_HOME /usr/local/spark

# Add User
useradd hadoop -m
usermod -a -G root hadoop
echo 'hadoop:hadoop' | chpasswd
