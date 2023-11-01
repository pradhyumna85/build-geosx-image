# Description

GEOSX is a simulation framework for modeling coupled flow, transport, and geomechanics in the subsurface. The code provides advanced solvers for a number of target applications, including:

- carbon sequestration,
- geothermal energy,
- and similar systems.

A key focus of the project is achieving scalable performance on current and next-generation high performance computing systems. We do this through a portable programming model and research into scalable algorithms.

You may want to browse our publications page for more details on the HPC, numerics, and applied engineering components of this effort.

***Note - This is not an official repository of GEOSX**

Official links:

- [GEOSX documentation](https://geosx-geosx.readthedocs-hosted.com/en/latest/?).
- [GEOSX PDF documentation](https://geosx-geosx.readthedocs-hosted.com/_/downloads/en/latest/pdf/)
- [GEOSX Official website](https://www.geosx.org/)
- [GEOSX official Github repository](https://github.com/GEOSX/GEOSX)

# Resources

* Dockerfile to build GEOSX ([GEOSX Documentation — GEOSX documentation (readthedocs-hosted.com)](https://geosx-geosx.readthedocs-hosted.com/en/latest/index.html)) from source.
* The TPL base image ([Image Layer Details - geosx/ubuntu20.04-gcc9:245-83 | Docker Hub](https://hub.docker.com/layers/geosx/ubuntu20.04-gcc9/245-83/images/sha256-937d16a77b78ee612701a6732cd38ba619c4fa4bb4b4f1e00f1b8f8d773bf17a?context=explore)) used contains prebuit TPL binaries for GEOSX.
* Prebuilt GEOSX image (using **docker.cmake** in this repository) is hosted at Docker-hub: [Image Layer Details - pradhyumna85/geosx:1.0.1-cpu-x86-64 | Docker Hub](https://hub.docker.com/layers/pradhyumna85/geosx/1.0.1-cpu-x86-64/images/sha256-aa6d2c86174669acb419b46f95008d7480aa1303c38ebd3633fc6530e46b9956?context=repo)

***Note - for the build guide below, it is recommended to use the latest TPL base image tag with latest GEOSX git commit or source code.**

# Dockerfile build arguments

Refer how to pass arguments to docker build - [here](https://docs.docker.com/build/guide/build-args/)

Please refer the build **ARG**s in the Dockerfile and pass these to docker build according to your needs, like:

> `docker build --build-arg ORG=geosx --build-arg IMG=ubuntu20.04-gcc9 --build-arg VERSION=245-83 --build-arg CMAKE_BASE_VERSION=3.23 --build-arg CMAKE_SUB_VERSION=5 --build-arg N_CPUS=16 --build-arg TPL_DIREC=/opt/GEOS/GEOS_TPL-245-83-da2415a --build-arg COMMIT=v1.0.1 -t <your_docker_repository_url>:<tag> .`

However for builing with default **ARG**s:

> `docker build -t <your_docker_repository_url>:<tag> .`

Push the built image to your remote docker repo (make sure you are authenticated before running this):

> `docker push <your_docker_repository_url>:<tag>`

# Launching a container from the Base image

On windows cmd:

> `docker run -it -d --cap-add=SYS_PTRACE --name geosx -p 64000:22 -v "%cd%\home:/home/mpiuser" <your_docker_repository_url>:<tag>`

On powershell/bash:

> `docker run -it -d --cap-add=SYS_PTRACE --name geosx -p 64000:22 -v "${PWD}\home:/home/mpiuser" <your_docker_repository_url>:<tag>`

*Note: **-v** parameter is for bind mount and is optional in case you really require at this step.

# Post build

Basic usage guide: [pradhyumna85/geosx - Docker Image | Docker Hub](https://hub.docker.com/r/pradhyumna85/geosx).

# References

- [Build Guide — GEOSX documentation (readthedocs-hosted.com)](https://geosx-geosx.readthedocs-hosted.com/en/latest/docs/sphinx/buildGuide/Index.html)
