#!/bin/sh

set -x

curl --silent --location https://rpm.nodesource.com/setup_7.x | bash -
yum -y install nodejs

# install jupyterhub and jupyter
# yum -y install gcc gcc-c++
# npm install -g configurable-http-proxy
# scl enable rh-python35 'pip install -r /tmp/requirements.txt'
