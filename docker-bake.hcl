group "all" {
  targets = ["mpich", "openmpi"]
}

variable "H5PY_VERSION" {
  default = "3.13.0"
}

target "mpich" {
  dockerfile = "Dockerfile"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["docker.io/astropatty/parallel-h5py:${H5PY_VERSION}-mpich"]
}

target "openmpi" {
  dockerfile = "Dockerfile"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["docker.io/astropatty/parallel-h5py:${H5PY_VERSION}-openmpi"]
  args = {
    MPI_IMPL = "openmpi-bin libopenmpi-dev"
  }
}

