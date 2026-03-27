ARG PYTHON_VERSION="3.12"
FROM python:${PYTHON_VERSION}-slim

ARG MPICH_VERSION="3.4.3"
ARG HDF5_VERSION="1.14.6"

RUN apt-get update && apt-get -y install build-essential wget
COPY ./build_mpi.sh ./build_mpi.sh
RUN MPICH_VERSION=${MPICH_VERSION} sh build_mpi.sh

ARG HDF5_LIB="https://github.com/HDFGroup/hdf5/releases/download/hdf5_${HDF5_VERSION}/hdf5.tar.gz"


WORKDIR /install
RUN wget ${HDF5_LIB} && tar -xvzf hdf5.tar.gz && mv hdf5-${HDF5_VERSION} hdf5
WORKDIR /install/hdf5
RUN CC=/mpich/install/bin/mpicc ./configure --prefix /usr/local --enable-parallel && make -j4 && make install

WORKDIR /app
RUN rm -rf /install
RUN CC=/mpich/install/bin/mpicc HDF5_MPI="ON" HDF5_DIR="/usr/local" python -m pip install --no-binary=h5py h5py


