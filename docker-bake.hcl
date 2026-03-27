group "default" {
  targets = ["mpich"]
}

variable "HDF5_VERSION" {
  default = "1.14.6"
}

target "mpich" {
  name = "mpich-${item.mpich_major}-py${replace(item.python_version, ".", "")}"
  matrix = {
    item = [
      { mpich_major = 4, mpich_version = "4.1.2", python_version = "3.12" },
      { mpich_major = 4, mpich_version = "4.1.2", python_version = "3.13" },
      { mpich_major = 3, mpich_version = "3.4.3", python_version = "3.12" },
      { mpich_major = 3, mpich_version = "3.4.3", python_version = "3.13" },
    ]
  }

  dockerfile = "Dockerfile"
  platforms  = ["linux/amd64", "linux/arm64"]
  tags = [
    "docker.io/astropatty/parallel-h5py:mpich-${item.mpich_version}-py${item.python_version}-hdf5-${HDF5_VERSION}",
    "docker.io/astropatty/parallel-h5py:mpich-${item.mpich_version}-py${item.python_version}",
    "docker.io/astropatty/parallel-h5py:mpich-${item.mpich_major}-py${item.python_version}",
  ]
  args = {
    MPICH_VERSION  = item.mpich_version
    HDF5_VERSION   = HDF5_VERSION
    PYTHON_VERSION = item.python_version
  }
}

