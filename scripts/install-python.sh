#!/bin/sh

set -x

# Install Python
yum -y install deltarpm epel-release
yum -y install python34
curl https://bootstrap.pypa.io/get-pip.py | python3.4
