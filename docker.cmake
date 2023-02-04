# file: docker.cmake

# detect host and name the configuration file
site_name(HOST_NAME)
set(CONFIG_NAME "hp-zbook-17-G6-hal-xeon-x86" CACHE PATH "")
message("CONFIG_NAME = ${CONFIG_NAME}")

# set paths to C, C++, and Fortran compilers. Note that while GEOSX does not contain any Fortran code,
# some of the third-party libraries do contain Fortran code. Thus a Fortran compiler must be specified.
set(CMAKE_C_COMPILER "/usr/bin/clang-8" CACHE PATH "")
set(CMAKE_CXX_COMPILER "/usr/bin/clang++-8" CACHE PATH "")
set(CMAKE_Fortran_COMPILER "/usr/bin/gfortran" CACHE PATH "")
set(ENABLE_FORTRAN OFF CACHE BOOL "" FORCE)

# enable MPI and set paths to compilers and executable.
# Note that the MPI compilers are wrappers around standard serial compilers.
# Therefore, the MPI compilers must wrap the appropriate serial compilers specified
# in CMAKE_C_COMPILER, CMAKE_CXX_COMPILER, and CMAKE_Fortran_COMPILER.
set(ENABLE_MPI ON CACHE BOOL "")
set(MPI_C_COMPILER "/usr/bin/mpicc" CACHE PATH "")
set(MPI_CXX_COMPILER "/usr/bin/mpicxx" CACHE PATH "")
set(MPI_Fortran_COMPILER "/usr/bin/mpifort" CACHE PATH "")
set(MPIEXEC "/usr/bin/mpirun" CACHE PATH "")

# disable CUDA and OpenMP
set(CUDA_ENABLED OFF CACHE BOOL "" FORCE)
set(ENABLE_OPENMP OFF CACHE BOOL "" FORCE)

# enable PVTPackage
set(ENABLE_PVTPackage ON CACHE BOOL "" FORCE)

# enable tests
set(ENABLE_GTEST_DEATH_TESTS ON CACHE BOOL "" FORCE )

# define the path to your compiled installation directory
set(GEOSX_TPL_DIR "/opt/GEOSX_TPL" CACHE PATH "")
# let GEOSX define some third party libraries information for you
include(${CMAKE_CURRENT_LIST_DIR}/tpls.cmake)