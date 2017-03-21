FROM centos:7

ENV SPARK_HOME /usr/local/spark-2.1.0-bin-hadoop2.7

ADD spark-2.1.0-bin-hadoop2.7.tgz /usr/local
COPY scripts/requirements.txt /tmp
COPY scripts/install-python.sh /scripts/
COPY scripts/install-nodejs.sh /scripts/
COPY scripts/install-jupyter.sh /scripts/
COPY scripts/install-all.sh /scripts/
COPY kernels/ /usr/local/share/jupyter/kernels/

RUN /scripts/install-all.sh && mkdir /opt/notebooks && chown -R hadoop:hadoop /opt/notebooks

EXPOSE 8000

USER hadoop

WORKDIR /opt/notebooks

CMD ["jupyterhub", "--no-ssl", "--Spawner.notebook_dir=/opt/notebooks"]
