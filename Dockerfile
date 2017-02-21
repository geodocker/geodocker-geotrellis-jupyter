FROM centos:7

ENV SPARK_HOME /usr/local/spark-2.1.0-bin-hadoop2.7

ADD spark-2.1.0-bin-hadoop2.7.tgz /usr/local
COPY scripts/requirements.txt /tmp
COPY toree-0.2.0.dev1.tar.gz /tmp

RUN yum -y install java-1.8.0-openjdk
COPY scripts/install-python.sh /scripts/
RUN /scripts/install-python.sh

COPY scripts/install-nodejs.sh /scripts/
RUN /scripts/install-nodejs.sh

COPY scripts/install-jupyter.sh /scripts/
RUN /scripts/install-jupyter.sh

COPY kernels/ /usr/local/share/jupyter/kernels/
RUN mkdir /opt/notebooks
RUN chown -R jack:jack /opt/notebooks
EXPOSE 8000
USER jack
WORKDIR /opt/notebooks

CMD ["jupyterhub", "--no-ssl", "--Spawner.notebook_dir=/opt/notebooks"]
