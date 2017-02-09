#!/bin/sh

yum -y update

# Install Python
yum -y install centos-release-scl
yum-config-manager --enable rhel-server-rhscl-7-rpms
yum -y install rh-python35
scl enable rh-python35 'easy_install pip'
scl enable rh-python35 'pip install --upgrade pip'
echo '/opt/rh/rh-python35/root/usr/lib64' >> /etc/ld.so.conf
ldconfig

# Install Java
yum -y install java-1.8.0-openjdk-devel

# Install NodeJS
curl --silent --location https://rpm.nodesource.com/setup_7.x | bash -
yum -y install nodejs

# Install JupyterHub and Jupyter
yum -y install gcc gcc-c++
npm install -g configurable-http-proxy
scl enable rh-python35 'pip install -r /tmp/requirements.txt'

# Install Toree
scl enable rh-python35 'pip install --pre /tmp/toree-0.2.0.dev1.tar.gz'
scl enable rh-python35 'jupyter toree install --spark_opts="--master local --jars /tmp/geotrellis-uberjar-assembly-1.0.0-RC1.jar"'
rm /tmp/toree-0.2.0.dev1.tar.gz

# Install GeoPySpark's dependencies
yum -y install epel-release
yum -y repolist
yum -y install geos-devel lapack-devel atlas-devel blas-devel
scl enable rh-python35 'pip install numpy'
scl enable rh-python35 'pip3 install "shapely>=1.6b3"'
scl enable rh-python35 'pip3 install "avro-python3>=1.8"'

# Add User
useradd jack -m 
echo 'jack:jack' | chpasswd
