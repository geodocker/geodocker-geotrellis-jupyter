# GeoDocker GeoTrellis Jupyter Notebook #

A Docker container to provide a Jupyter notebook instance with GeoTrellis functionality to [GeoDocker](https://github.com/geodocker/geodocker).

## Configuring and Starting ##

### Toy Settings ###

Starting this image in toy settings (e.g. with a "cluster" confined entirely to one physical computer) is very easy.

#### Self-Contained ####

To use the image with a self-contained local master, type

```bash
docker run -it --rm -p 8000:8000 quay.io/geodocker/geotrellis-jupyter:9b577f1
```

After a few moments, the server should be available at [`localhost:8000`](http://localhost:8000).

#### With GeoDocker ####

First ensure that the `docker-compose` command is installed and working.
With that command present, simply navigate into a directory containing the appropriate [`docker-compose.yml`](docker-compose.yml) file and bring the "cluster" up

```bash
cd ~/local/src/geodocker-geotrellis-jupyter
docker-compose up
```

As before, the server should be available at [`localhost:8000`](http://localhost:8000).

### Serious Settings ###

The two most immediate issues with using this image in a more serious setting (with a real cluster) are
   - properly configuring the Spark master, and
   - enabling SSL.

To use the image with a YARN master, the appropriate configuration files must be copied to the image
(the precise details of how to do that are left as an exercise to the reader).
Once everything is setup so that it is possible run jobs with a YARN master from within the container, Toree must be reinstalled with the appropriate settings.
The command to do that might look something like this

```bash
scl enable python33 'jupyter toree install --spark_opts="--master yarn --jars file:///tmp/geotrellis-uberjar-assembly-1.0.0-RC1.jar"'
```

To use the image with Spark in stand-alone mode, Toree must be reinstalled with the appropriate settings.
The command to do that might look something like this

```bash
scl enable python33 'jupyter toree install --spark_opts="--master spark://10.0.1.3:7077 --jars file:///tmp/geotrellis-uberjar-assembly-1.0.0-RC1.jar"'
```

In stand-alone mode, the version of Spark in the image (currently 2.0.0) must match the version installed on the cluster.
If that is not true, then it is be necessary to create a new image
(either derived from this one [in the docker-sense] or built from a fork of this source distribution)
with the appropriate version of Spark installed.

To run `jupyterhub` with SSL enabled, the [JupyterHub documentation](https://github.com/jupyterhub/jupyterhub) suggests something like this

```bash
jupyterhub --ip 10.0.1.2 --port 443 --ssl-key my_ssl.key --ssl-cert my_ssl.cert
```

Please see the JupyterHub documentation for more detailed discussion;
The steps/suggestions given here are probably necessary but almost certainly not sufficient to produce a working setup.

The [`geodocker.sh`](scripts/geodocker.sh) script is an example of a script which reinstalls Toree then launches JupyerHub.
For serious usage, it will probably be necessary to create another docker image derived form this one.
That image should contain site-specific configuration files and a script similar to `scripts/geodocker.sh` with the appropriate configuration and launch commands encapsulated within.

## Usage ##

The default username and password are both `jack`.
The default account is suitable for local use,
but if the image is going to be used in a more serious setting, be sure to disable that account and enable some other login mechanism.

To make use of GeoTrellis, create a new "Apache Toree - Scala" notebook (or use an existing one).

![screenshot from 2016-11-19 15 45 07](https://cloud.githubusercontent.com/assets/11281373/20458321/b14c04e8-ae6f-11e6-8edf-467121f72d91.png)
