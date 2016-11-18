FROM centos:7

MAINTAINER Justin Polchlopek <jpolchlopek@azavea.com>

ADD spark-2.0.2-bin-hadoop2.7.tgz /usr/local
COPY scripts/build.sh /scripts/
COPY toree-0.2.0.dev1.tar.gz /tmp/toree-0.2.0.dev1.tar.gz

ENV SPARK_HOME /usr/local/spark-2.0.2-bin-hadoop2.7
RUN /scripts/build.sh

EXPOSE 8000

CMD scl enable python33 'jupyterhub --no-ssl'
