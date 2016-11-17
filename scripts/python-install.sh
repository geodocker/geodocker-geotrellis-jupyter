#!/bin/bash

python -V
easy_install pip
yum -y install gcc gcc-fortran gcc-c++
yum -y install blas-devel lapack-devel
pip install numpy
pip install scipy
pip install pandas
# pip install nose "ipython[notebook]"
pip install jupyter
