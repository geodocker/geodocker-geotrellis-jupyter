#!/bin/sh

set -x

yum -y install java-1.8.0-openjdk
/scripts/install-python.sh
/scripts/install-nodejs.sh
/scripts/install-jupyter.sh
yum clean all
