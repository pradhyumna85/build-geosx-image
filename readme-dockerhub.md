# Description

GEOSX is a simulation framework for modeling coupled flow, transport, and geomechanics in the subsurface. The code provides advanced solvers for a number of target applications, including:

- carbon sequestration,
- geothermal energy,
- and similar systems.

A key focus of the project is achieving scalable performance on current and next-generation high performance computing systems. We do this through a portable programming model and research into scalable algorithms.

You may want to browse our publications page for more details on the HPC, numerics, and applied engineering components of this effort.

### *Note - This is not an official repository of GEOSX

# Documentation and resources

- [GEOSX documentation](https://geosx-geosx.readthedocs-hosted.com/en/latest/?).
- [GEOSX PDF documentation](https://geosx-geosx.readthedocs-hosted.com/_/downloads/en/latest/pdf/)
- [GEOSX Official website](https://www.geosx.org/)
- [GEOSX official Github repository](https://github.com/GEOSX/GEOSX)

# Image Build guide
[**https://github.com/pradhyumna85/build-geosx-image**](https://github.com/pradhyumna85/build-geosx-image/tree/Geosx1.0.1)

*Note - This is optional as the prebuilt image already exists in this docker hub repository, unless you want to build with some other configurations.

---

# Pulling the image (*This might take some time as image size is ~1.5GB)

> `docker pull pradhyumna85/geosx:1.0.1-cpu-x86-64`

---

# Launching container

## without bind mount:

> `docker run -it -d --cap-add=SYS_PTRACE --name geosx -p 64000:22 pradhyumna85/geosx:1.0.1-cpu-x86-64`

## with bind mount:

> `docker run -it -d --cap-add=SYS_PTRACE --name geosx -p 64000:22 -v "%cd%\home:/home/mpiuser" pradhyumna85/geosx:1.0.1-cpu-x86-64`

*Note - For bash/powershell replace **%cd%** with **${PWD}**

# Accessing container

Using docker CLI:

> `docker exec -it geosx bash`

Using SSH (host port 64000 forwarded to container SSH port):

> Use respective user credentials to connect via SSH CLI or SSH clients like Putty

> `SSH host: localhost`

> `SSH port: 64000`

*Note- VSCode remote SSH can also be used. (*Note- connect using **root** user)

Using VSCode Docker extension (Attach to VSCode feature):

> [refer this](https://code.visualstudio.com/docs/devcontainers/attach-container#:~:text=To%20attach%20to%20a%20Docker,you%20want%20to%20connect%20to.)

## From shell, change user to "mpiuser" (*important if using "mpirun")

> `su mpiuser`

## Run GEOSX on an xml file input

> `/app/GEOSX/install-docker-release/bin/geosx -i some_dir/test.xml`

with **mpirun:**

> `mpirun -np 8 /app/GEOSX/install-docker-release/bin/geosx -i some_dir/test.xml -x 2 -y 2 -z 2`

*Note- **8** in the above command is the CPU count on the machine/container. x, y and z are arguments for dividing blocks in x, y and z axis for parallel processing.

# C-tests to check compilation stability

> `cd /app/GEOSX/build-docker-release`

> `ctest -V`

# Machine details

- HP ZBook 17 G6
- Windows 10
- Intel Xeon E-2286M CPU @ 2.40GHz (16 CPUs)
- Docker version 20.10.22, build 3a2c30b

# GEOSX build details

GEOSX version: 0.2.0 (HEAD, sha1: 2bf2c4a06)

  - c++ compiler: gcc 9.4.0
  - MPI version: Open MPI v4.0.3, package: Debian OpenMPI, ident: 4.0.3, repo rev: v4.0.3, Mar 03, 2020
  - HDF5 version: 1.12.1
  - Conduit version: 0.8.2
  - VTK version: 9.2.6
  - RAJA version: 2023.6.1
  - umpire version: 2023.6.0
  -  adiak version: ..
  - caliper version: 2.10.0
  - METIS version: 5.1.0
  - PARAMETIS version: 4.0.3
  - scotch version: 7.0.3
  - superlu_dist version: 6.3.0
  - suitesparse version: 5.7.9
  - Python3 version: 3.8.10
  - hypre release version: 2.29.0

# References

- [Developing inside docker container with precompiled TPL-binaries](https://geosx-geosx.readthedocs-hosted.com/en/latest/docs/sphinx/developerGuide/Contributing/UsingDocker.html?highlight=docker])
- [Installing GEOSX on windows using WSL](https://geosx-geosx.readthedocs-hosted.com/en/latest/docs/sphinx/developerGuide/Contributing/InstallWin.html)
- [GEOSX quick-start](https://geosx-geosx.readthedocs-hosted.com/en/latest/docs/sphinx/QuickStart.html)
- [GEOSX Github](https://github.com/GEOSX/GEOSX)
- Tutorials:

  - [Basic tutorials](https://geosx-geosx.readthedocs-hosted.com/en/latest/docs/sphinx/tutorials/Index.html)
  - [Basic examples](https://geosx-geosx.readthedocs-hosted.com/en/latest/docs/sphinx/basicExamples/Index.html)

# Credentials

> user: **mpiuser**

> password: **pass**

---

> user: **root**

> password: **Docker!**

# Solution to common problem (if occurs)

- If facing dns/url resolution errors with apt, apt-get and git the run the below command as **root user**:

> `echo "nameserver 8.8.8.8" | tee /etc/resolv.conf > /dev/null`
