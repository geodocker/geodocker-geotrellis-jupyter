FROM centos:7

MAINTAINER Justin Polchlopek <jpolchlopek@azavea.com>

ENV SPARK_HOME /usr/local/spark-2.0.0-bin-hadoop2.7

ADD spark-2.0.0-bin-hadoop2.7.tgz /usr/local
ADD scripts/*.sh /scripts/
COPY scripts/requirements.txt /tmp
COPY toree-0.2.0.dev1.tar.gz /tmp
COPY geotrellis-uberjar-assembly-1.0.0-RC1.jar /tmp

RUN /scripts/build.sh

EXPOSE 8000

CMD scl enable python33 'jupyterhub --no-ssl'
