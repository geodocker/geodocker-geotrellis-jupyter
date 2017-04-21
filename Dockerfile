FROM centos:7

ARG SPARK_VERSION
ENV SPARK_HOME /usr/local/spark-${SPARK_VERSION}

ADD archives/spark-${SPARK_VERSION}.tgz /usr/local
ADD archives/ipykernel.tar /tmp
COPY config/requirements-1.txt /tmp
COPY config/requirements-2.txt /tmp
COPY config/patch.diff /tmp
COPY kernels/ /usr/local/share/jupyter/kernels/

RUN ln -s ${SPARK_HOME} /usr/local/spark && \
    yum install -y deltarpm epel-release && \
    yum install -y unzip patch java-1.8.0-openjdk python34 && \
    (curl https://bootstrap.pypa.io/get-pip.py | python3.4) && \
    (curl --silent --location https://rpm.nodesource.com/setup_7.x | bash -) && \
    yum install -y nodejs && \
    npm install -g configurable-http-proxy && \
    useradd hadoop -m && \
    usermod -a -G root hadoop && \
    (echo 'hadoop:hadoop' | chpasswd) && \
    yum clean all
RUN pip3 install -r /tmp/requirements-1.txt && \
    (pushd /tmp/ipykernel ; patch -p1 < /tmp/patch.diff ; pip3 install . ; popd) && \
    pip3 install -r /tmp/requirements-2.txt && \
    rm -rf /root/cache /tmp/*

EXPOSE 8000

USER hadoop

WORKDIR /tmp

CMD ["jupyterhub", "--no-ssl", "--Spawner.notebook_dir=/home/hadoop"]
