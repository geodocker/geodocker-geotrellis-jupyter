FROM quay.io/geodocker/spark:latest

MAINTAINER Justin Polchlopek, jpolchlopek@azavea.com

RUN yum -y update && \
    yum -y install scl-utils && \
    rpm -Uvh https://www.softwarecollections.org/en/scls/rhscl/python33/epel-7-x86_64/download/rhscl-python33-epel-7-x86_64.noarch.rpm && \
    yum -y install python33 && \
    yum -y install gcc gcc-fortran gcc-c++ && \
    yum -y install blas-devel lapack-devel

RUN scl enable python33 'easy_install pip'
RUN scl enable python33 'pip install numpy'
RUN scl enable python33 'pip install scipy'
RUN scl enable python33 'pip install pandas'
RUN scl enable python33 'pip install jupyter'
RUN scl enable python33 'pip install --upgrade ipython[all]'

RUN alternatives --set java /usr/java/jdk1.8.0_45/jre/bin/java
RUN yum -y install git
RUN curl https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo 
RUN yum -y install sbt
RUN git clone https://github.com/apache/incubator-toree.git
RUN pushd incubator-toree && \
    APACHE_SPARK_VERSION=2.0.0 make build && \
    APACHE_SPARK_VERSION=2.0.0 make dist && \
    mkdir -p dist/toree-pip && \
    cp -r dist/toree dist/toree-pip && \
    cp dist/toree/LICENSE dist/toree-pip/LICENSE && \
    cp dist/toree/NOTICE dist/toree-pip/NOTICE && \
    cp dist/toree/DISCLAIMER dist/toree-pip/DISCLAIMER && \
    cp dist/toree/VERSION dist/toree-pip/VERSION && \
    cp dist/toree/RELEASE_NOTES.md dist/toree-pip/RELEASE_NOTES.md && \
    cp -R dist/toree/licenses dist/toree-pip/licenses && \
    cp -rf etc/pip_install/* dist/toree-pip/. && \
    printf "__version__ = '$(grep BASE_VERSION= Makefile | sed -e 's/BASE_VERSION=\(.*\)/\1/')'\n" >> dist/toree-pip/toree/_version.py && \
    printf "__commit__ = '$(git rev-parse --short=12 --verify HEAD)'\n" >> dist/toree-pip/toree/_version.py && \
    pushd dist/toree-pip/ && \
    scl enable python33 'python setup.py sdist --dist-dir=.' && \
    scl enable python33 'pip install $(ls toree-*.tar.gz) && jupyter toree install' && \
    popd && \
    rm -rf dist/toree-pip/ && \
    popd

EXPOSE 7001
EXPOSE 7002
EXPOSE 7003
EXPOSE 7004
EXPOSE 7005
EXPOSE 7006
EXPOSE 7077
EXPOSE 7777
EXPOSE 6066

CMD scl enable python33 'PYSPARK_PYTHON=python3 PYSPARK_DRIVER_PYTHON=jupyter PYSPARK_DRIVER_PYTHON_OPTS="notebook --no-browser --port=7777" pyspark --packages com.databricks:spark-csv_2.10:1.1.0 --executor-memory 6400M --driver-memory 6400M'
