

This repository builds container images which are designed to be serve as base images for building workloads that run on HPC systems. These three images include:

1. A ubuntu image with MPICH installed
2. Image 1 with a Python environment with mpi4py
3. Image 2 with parallel hdf5 and h5py installed

## Current version information

Multiple versions of mpich and python are available

mpich: 
- 3.4.3 (used in Cray PE 8.1)
- 4.1.2 (used in Cray PE 9.0)

python: 3.12 -> 3.14

hdf5: 1.14.6 (latest version as of 10/21/2025)

Version 2 of hdf5 will be supported in the future.

## Repos and tagging conventions

The dockerhub repos for these images are

[docker.io/astropatty/mpich](https://hub.docker.com/repository/docker/astropatty/mpich)
[docker.io/astropatty/mpi4py](https://hub.docker.com/repository/docker/astropatty)
[docker.io/astropatty/parallel-h5py](https://hub.docker.com/repository/docker/astropatty/parallel-h5py)

Images are tagged by their major versions. For example, to get an image that has MPICH 4 and and Python 3.13:

`docker.io/astropatty/mpi4py:mpich4-py3.13`

## Using these images

### Python installation

There is a default python installation in the container which is managed by uv. It should function just like any other Python environment, except that you must replace every call to `pip` `uv pip`.

e.g. instead of

`pip install numpy`

use 

`uv pip install numpy`

### Binding to Host MPI

These images are primarily designed to be used on HPC systems where MPI communication will be done via the host MPI interface. This requires binding the system MPI libraries into the container at runtime. These containers have been tested on Perlmutter at NERSC and on Polaris at the ALCF. The former uses `podman-hpc`, while the latter uses `apptainer`

#### podman-hpc (e.g. Perlmutter)

This one's easy. Simply call `podman-hpc` with the `--mpi` flag, e.g.

`srun -n 16 podman-hpc run --mpi astropatty/parallel-h5py:mpich-4.1.2-py3.14  python -c "from mpi4py import MPI; print(MPI.COMM_WORLD.Get_rank())"

You should get the numbers 0-15 printed out, but probably in a random order.


#### apptainer (e.g. polaris)

This one is a bit tricker, because you need to manually bind to the system MPICH. First load the appropriate modules:

```bash 
ml use /soft/modulefiles 
ml spack-pe-base
ml apptainer
ml cray-mpich-abi
```

Then set the following environment variable

```bash
export APPTAINERENV_LD_LIBRARY_PATH="$CRAY_LD_LIBRARY_PATH:$LD_LIBRARY_PATH:/opt/cray/pe/lib64:/opt/cray/pals/1.7/lib:/usr/hostlib64"
export ADDITIONAL_CONTAINER_FLAGS="-B /opt/cray -B /var/run/palsd/ -B /usr/lib64:/usr/hostlib64" 
```

Then download the image, convert it to the apptainer format, and run it

```bash
apptainer build mpi4py.sif docker://docker.io/astropatty/mpi4py:mpich-4-py3.13
mpiexec -n 32 apptainer exec $ADDITIONAL_CONTAINER_FLAGS mpich.sif python -c "from mpi4py import MPI; print(MPI.COMM_WORLD.Get_rank())"
```

Which should print out the numbers 0-31 in some random order.














