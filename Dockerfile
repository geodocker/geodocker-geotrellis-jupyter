FROM centos:7

ARG SPARK_VERSION
ENV SPARK_HOME /usr/local/spark-${SPARK_VERSION}

ADD spark-${SPARK_VERSION}.tgz /usr/local
COPY scripts/requirements.txt /tmp
COPY scripts/install-python.sh /scripts/
COPY scripts/install-nodejs.sh /scripts/
COPY scripts/install-jupyter.sh /scripts/
COPY scripts/install-all.sh /scripts/
COPY kernels/ /usr/local/share/jupyter/kernels/

RUN /scripts/install-all.sh && \
    mkdir /opt/notebooks && \
    chown -R hadoop:hadoop /opt/notebooks && \
    mkdir -p /usr/etc/jupyter /usr/share/jupyter && \
    chown -R hadoop:hadoop /usr/etc/jupyter /usr/share/jupyter

EXPOSE 8000

USER hadoop

WORKDIR /opt/notebooks

CMD ["jupyterhub", "--no-ssl", "--Spawner.notebook_dir=/opt/notebooks"]
