# GeoDocker GeoTrellis Jupyter Notebook #

A Docker container to provide a Jupyter notebook instance with GeoTrellis functionality to [GeoDocker](https://github.com/geodocker/geodocker).

## Configuring and Starting ##

To use the image with a self-contained local master, type

```bash
docker run -it --rm -p 8000:8000 quay.io/geodocker/jupyter:4
```

After a few moments, the server should be available at [`localhost:8000`](http://localhost:8000).

## Usage ##

The default username and password are both `hadoop`.
