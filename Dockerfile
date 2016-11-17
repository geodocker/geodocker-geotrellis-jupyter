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

RUN git clone https://github.com/geotrellis/geotrellis.git
RUN pushd geotrellis && \
    ./sbt "project spark-etl" "set test in assembly := {}" assembly && \
    popd
# RUN cp geotrellis/spark-etl/target/scala-2.11/geotrellis*assembly*.jar jars/

RUN git clone https://github.com/jpolchlo/incubator-toree.git
ENV APACHE_SPARK_VERSION 2.0.1
RUN pushd incubator-toree && \
    make build && \
    make dist && \
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
    sbt "project toree-macros" publishLocal && \
    sbt "project toree-plugins" publishLocal && \
    sbt "project toree-kernel-api" publishLocal && \
    popd

COPY loader loader
RUN pushd loader && \
    mkdir /tmp/jars && \
    sbt "run /tmp/jars" && \
    find /tmp/jars -name \*.jar -exec cp {} /opt/spark/jars \; && \
    rm -r /tmp/jars && \
    popd

ENV SPARK_PKGS $(cat << END | xargs echo | sed 's/ /,/g' com.databricks:spark-avro_2.11:3.0.1 END)

EXPOSE 7777

COPY scripts/entrypoint.sh /usr/local/sbin/
ENTRYPOINT ["/usr/local/sbin/entrypoint.sh"]

