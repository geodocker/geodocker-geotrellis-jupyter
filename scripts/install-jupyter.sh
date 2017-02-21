#!/bin/sh

set -x

# install jupyterhub and jupyter
# yum -y install gcc gcc-c++
npm install -g configurable-http-proxy
# install jupyter and jupyterhub python modules
pip3 install -r /tmp/requirements.txt

# Install Toree
# scl enable rh-python35 'pip install --pre /tmp/toree-0.2.0.dev1.tar.gz'
# scl enable rh-python35 'jupyter toree install --spark_opts="--master local --jars /tmp/geotrellis-uberjar-assembly-1.0.0-RC1.jar"'
# rm /tmp/toree-0.2.0.dev1.tar.gz

ln -s $SPARK_HOME /usr/local/spark

# Add User
useradd jack -m
echo 'jack:jack' | chpasswd
