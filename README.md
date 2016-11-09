GeoDocker GeoTrellis Jupyter Notebook
=====================================

A Docker container to provide a Jupyter notebook instance with GeoTrellis functionality to [GeoDocker](https://github.com/geodocker/geodocker).

Configuration and Usage
-----------------------

Start this container using the `--net=host` option and point a browser on the host machine to http://localhost:7777 to enter the interface.  Select `Apache Toree - Scala` from the New dropdown menu and start typing Scala commands.  Note that `sc` is pre-initialized to a live `SparkContext` instance.
