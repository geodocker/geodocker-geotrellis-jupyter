#!/bin/sh

yum -y update

# Install Python
yum -y install centos-release-scl
yum -y install python33
scl enable python33 'easy_install pip'
echo '/opt/rh/python33/root/usr/lib64' >> /etc/ld.so.conf
ldconfig

# Install Java
yum -y install java-1.8.0-openjdk-devel

# Install NodeJS
curl --silent --location https://rpm.nodesource.com/setup_7.x | bash -
yum -y install nodejs

# Install JupyterHub and Jupyter
yum -y install gcc gcc-c++
npm install -g configurable-http-proxy
scl enable python33 'pip install -r /tmp/requirements.txt'

# Install Toree
scl enable python33 'pip install --pre /tmp/toree-0.2.0.dev1.tar.gz'
scl enable python33 'jupyter toree install --spark_opts="--master local --jars /tmp/geotrellis-uberjar-assembly-1.0.0-RC1.jar"'
rm /tmp/toree-0.2.0.dev1.tar.gz

# Add User
useradd jack -m 
echo 'jack:jack' | chpasswd
