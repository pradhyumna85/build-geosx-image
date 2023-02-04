# Information

* Dockerfile to build GEOSX ([GEOSX Documentation — GEOSX documentation (readthedocs-hosted.com)](https://geosx-geosx.readthedocs-hosted.com/en/latest/index.html)) from source.
* The base image ([Image Layer Details - geosx/ubuntu20.04-gcc9:213-913 | Docker Hub](https://hub.docker.com/layers/geosx/ubuntu20.04-gcc9/213-913/images/sha256-4e20100e6a333a098a635dec3226380ca5f9131501723563090a4dc599582e63?context=explore)) used contains prebuit TPL binaries for GEOSX.
* Prebuilt GEOSX image (using **docker.cmake** in this repository) is hosted at Docker-hub: [pradhyumna85/geosx - Docker Image | Docker Hub](https://hub.docker.com/r/pradhyumna85/geosx), tag: [pradhyumna85/geosx:0.2.0-hp-zbook-17-G6-xeon-x86](https://hub.docker.com/layers/pradhyumna85/geosx/0.2.0-hp-zbook-17-G6-xeon-x86/images/sha256-e26145f6ac899b7223e0709b06de2515112cfc83b25b7b86b6beffdd1a097949?context=explore)

# Building Base image

Please refer the build **ARG**s in the Dockerfile and pass these to docker build according to your needs, like:

> `docker build --build-arg ORG=geosx --build-arg IMG=ubuntu20.04-gcc9 --build-arg CMAKE_BASE_VERSION=3.22 --build-arg CMAKE_SUB_VERSION=6 --build-arg VERSION=213-913 -t remote-dev-ubuntu20.04-gcc9:213-913 .`

However for builing with default **ARG**s:

> `docker build --build-arg -t remote-dev-ubuntu20.04-gcc9:213-913 .`

# Launching a container from the Base image

On windows cmd:

> `docker run -it -d --cap-add=SYS_PTRACE --name geosx-build-image -p 64000:22 -v "%cd%\home:/home/mpiuser" remote-dev-ubuntu20.04-gcc9:213-913`

On powershell/bash:

> `docker run -it -d --cap-add=SYS_PTRACE --name geosx-build-image -p 64000:22 -v "${PWD}\home:/home/mpiuser" remote-dev-ubuntu20.04-gcc9:213-913`

# Accessing container shell

> `docker exec -it geosx-build-image bash`

# Building GEOSX inside the container

Cloning and setting up GEOSX repository

> `cd /app`

> `git clone https://github.com/GEOSX/GEOSX.git`

> `cd GEOSX`

> `git lfs install`

> `git submodule init`

> `git submodule deinit integratedTests`

> `git submodule update`

Place your platform **cmake** file at **host-configs/your-platform.cmake**. Example **docker.cmake** is available this github the repository.

> `cd /app/GEOSX`

> `python scripts/config-build.py -hc host-configs/your-platform.cmake -bt Release`

> `cd build-your-platform-release`

In the above command  `build-your-platform-release` will be `build-docker-release` if using **docker.cmake**

> `make -j16`

In the above "16" is the number of cpu cores available, set it to maximum cores available to the container, eg "4"

> `make install`

Testing the build

> `cd /app/GEOSX/build-your-platform-release`

> `ctest -V`

Ideally it should show 100% coverage

Built GEOSX binary now should be available at `/app/GEOSX/install-you-platform-release/bin/geosx`, in the `install-you-platform-release` will be `install-docker-release` if used **docker.cmake** for building.

You can test the binary by the command:

> `/app/GEOSX/install-you-platform-release/bin/geosx --help`

Done!

# Post build

After successfully building GEOSX in the container you can commit that container as an image (and push to some container repository) for reusing later.

> `docker commit geosx-build-image <your_docker_repository_url>:<tag>`

> `docker push <your_docker_repository_url>:<tag>`

*Make sure you are authenticated before pushing. Build is already pushed and available at: [Image Layer Details - pradhyumna85/geosx:0.2.0-hp-zbook-17-G6-xeon-x86 | Docker Hub](https://hub.docker.com/layers/pradhyumna85/geosx/0.2.0-hp-zbook-17-G6-xeon-x86/images/sha256-e26145f6ac899b7223e0709b06de2515112cfc83b25b7b86b6beffdd1a097949?context=explore)

# References

- [Build Guide — GEOSX documentation (readthedocs-hosted.com)](https://geosx-geosx.readthedocs-hosted.com/en/latest/docs/sphinx/buildGuide/Index.html)
