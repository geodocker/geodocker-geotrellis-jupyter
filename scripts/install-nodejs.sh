#!/bin/sh

set -x

curl --silent --location https://rpm.nodesource.com/setup_7.x | bash -
yum -y install nodejs
