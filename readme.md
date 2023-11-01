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

# Building Base image

***Note - At the time of writing this, the above prebuilt image was built using [GEOSX v1.0.1](https://github.com/GEOS-DEV/GEOS/releases/tag/v1.0.1), git commit id: [2bf2c4a](https://github.com/GEOS-DEV/GEOS/commit/2bf2c4a06a102fb53aa9c4b98c59bc765be79adb)). Browse files for th above commit version: [tree - 2bf2c4a](https://github.com/GEOS-DEV/GEOS/tree/2bf2c4a06a102fb53aa9c4b98c59bc765be79adb).**

---

Please refer the build **ARG**s in the Dockerfile and pass these to docker build according to your needs, like:

> `docker build --build-arg ORG=geosx --build-arg IMG=ubuntu20.04-gcc9 --build-arg CMAKE_BASE_VERSION=3.23 --build-arg CMAKE_SUB_VERSION=5 --build-arg VERSION=245-83 -t remote-dev-ubuntu20.04-gcc9:245-83 .`

However for builing with default **ARG**s:

> `docker build -t remote-dev-ubuntu20.04-gcc9:245-83 .`

The above base build image is available at: [Image Layer Details - pradhyumna85/geosx:base-build-image-geosx-1.0.1-TPL-245-83 | Docker Hub](https://hub.docker.com/layers/pradhyumna85/geosx/base-build-image-geosx-1.0.1-TPL-245-83/images/sha256-e64f78dd885e9cfbc7da96bc03d998c1d65a76ab09a7ee70fa85397333cec0c1?context=repo)

# Launching a container from the Base image

On windows cmd:

> `docker run -it -d --cap-add=SYS_PTRACE --name geosx-build-image-101 -p 64000:22 -v "%cd%\home:/home/mpiuser" remote-dev-ubuntu20.04-gcc9:245-83`

On powershell/bash:

> `docker run -it -d --cap-add=SYS_PTRACE --name geosx-build-image-101 -p 64000:22 -v "${PWD}\home:/home/mpiuser" remote-dev-ubuntu20.04-gcc9:245-83`

*Note: **-v** parameter is for bind mount and is optional in case you really require at this step.

# Accessing container shell

> `docker exec -it geosx-build-image-101 bash`

# Building GEOSX inside the container

Cloning and setting up GEOSX repository. Starting with switching user

> `su mpiuser`

> `pip install virtualenv`

> `cd /app`

> `git clone https://github.com/GEOSX/GEOSX.git`

> `cd GEOSX`

> `git checkout v1.0.1`

> `git lfs install`

> `git submodule init`

> `git submodule deinit integratedTests`

> `git submodule update`

Place/create your platform **cmake** file at **host-configs/your-platform.cmake**. Example **docker.cmake** is available in this github repository (shell file editor like vim, nano etc can be used to create cmake file by copying and pasting content of docker.cmake in this repository).

> `cd /app/GEOSX`

> `python scripts/config-build.py -hc host-configs/docker.cmake -bt Release`

> `cd build-docker-release`

> `make -j16`

In the above "16" is the number of cpu cores available, set it to maximum cores available to the container, eg "4"

The `make -j..` command, output shouldn't even contain warnings ideally to make sure everything works correctly post build.

> `make install`

Testing the build

> `cd /app/GEOSX/build-docker-release`

> `ctest -V`

Ideally it should show 100% coverage

Built GEOSX binary now should be available at `/app/GEOSX/install-docker-release/bin/geosx`

You can test the binary by the command:

> `/app/GEOSX/install-docker-release/bin/geosx --help`

**Note - The above command shows Geosx version as 0.2.0 instead of 1.0.1 which is incorrect and safe to ignore.*

Done!

# Post build

After successfully building GEOSX in the container you can commit that container as an image (and push to some container repository) for reusing later.

> `docker commit geosx-build-image-101 <your_docker_repository_url>:<tag>`

> `docker push <your_docker_repository_url>:<tag>`

*Make sure you are authenticated to the remote image repository before pushing. Build is already pushed and available at: [Image Layer Details - pradhyumna85/geosx:1.0.1-cpu-x86-64 | Docker Hub](https://hub.docker.com/layers/pradhyumna85/geosx/1.0.1-cpu-x86-64/images/sha256-aa6d2c86174669acb419b46f95008d7480aa1303c38ebd3633fc6530e46b9956?context=repo).

You can also find the basic guilde on using GEOSX inside a docker container using this prebuilt image at my docker hub repository's readme/description: [pradhyumna85/geosx - Docker Image | Docker Hub](https://hub.docker.com/r/pradhyumna85/geosx).

# References

- [Build Guide — GEOSX documentation (readthedocs-hosted.com)](https://geosx-geosx.readthedocs-hosted.com/en/latest/docs/sphinx/buildGuide/Index.html)
