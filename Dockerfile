FROM centos:7

MAINTAINER Justin Polchlopek <jpolchlopek@azavea.com>

ENV SPARK_HOME /usr/local/spark-2.0.0-bin-hadoop2.7

ADD spark-2.0.0-bin-hadoop2.7.tgz /usr/local
ADD scripts/*.sh /scripts/
COPY scripts/requirements.txt /tmp
COPY toree-0.2.0.dev1.tar.gz /tmp
COPY geotrellis-uberjar-assembly-1.0.0-RC1.jar /tmp

RUN /scripts/build.sh
RUN ln -s $SPARK_HOME /opt/spark
ENV PYTHONPATH $SPARK_HOME/python

RUN yum -y install git make which
RUN mkdir /work
RUN git clone https://github.com/locationtech-labs/geopyspark.git /work/geopyspark
WORKDIR /work/geopyspark
RUN make backend-assembly
RUN git clone -b 2.1 https://github.com/OSGeo/gdal.git /work/gdal
WORKDIR /work/gdal/gdal
RUN ./configure && make && make install
WORKDIR /work/geopyspark
RUN scl enable rh-python35 'python3 /work/geopyspark/setup.py install'

RUN mkdir /opt/notebooks
RUN chown -R jack:jack /opt/notebooks

RUN mkdir /etc/jupyterhub
COPY python/jupyterhub_config.py /etc/jupyterhub/

USER jack
RUN mkdir /home/jack/.ipython
COPY python/load_spark_environment_variables.py /home/jack/.ipython/profile_default_startup
RUN scl enable rh-python35 'ipython kernel install --user --name pyspark'
COPY python/pyspark_kernel.json /home/jack/.local/share/jupyter/kernels/pyspark/kernel.json
ENV LD_LIBRARY_PATH $LD_LIBRARY_PATH:/usr/local/lib

EXPOSE 8000

WORKDIR /opt/notebooks

CMD scl enable rh-python35 'LD_LIBRARY_PATH=$LD_LIBRARY_PATH jupyterhub --no-ssl -f /etc/jupyterhub/jupyterhub_config.py --Spawner.notebook_dir=/opt/notebooks'
