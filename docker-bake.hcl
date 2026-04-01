group "default" {
  targets = ["h5py"]
}

variable "HDF5_VERSION" {
  default = "1.14.6"
}

# ── Stage 1: MPICH ────────────────────────────────────────────────────────────

group "mpich" {
  targets = ["mpich-build"]
}

target "mpich-build" {
  name = "mpich-build-${item.mpich_major}"
  matrix = {
    item = [
      { mpich_major = 4, mpich_version = "4.1.2" },
      { mpich_major = 3, mpich_version = "3.4.3" },
    ]
  }

  dockerfile = "Dockerfile.mpich"
  platforms  = ["linux/amd64", "linux/arm64"]
  tags = [
    "docker.io/astropatty/mpich:mpich${item.mpich_version}",
    "docker.io/astropatty/mpich:mpich${item.mpich_major}",
  ]
  args = {
    MPICH_VERSION = item.mpich_version
  }
}

# ── Stage 2: Python + mpi4py ──────────────────────────────────────────────────

group "python" {
  targets = ["python-build"]
}

target "python-build" {
  name = "python-build-mpich${item.mpich_major}-py${replace(item.python_version, ".", "")}"
  matrix = {
    item = [
      { mpich_major = 4, mpich_version = "4.1.2", python_version = "3.12" },
      { mpich_major = 4, mpich_version = "4.1.2", python_version = "3.13" },
      { mpich_major = 4, mpich_version = "4.1.2", python_version = "3.14" },
      { mpich_major = 3, mpich_version = "3.4.3", python_version = "3.12" },
      { mpich_major = 3, mpich_version = "3.4.3", python_version = "3.13" },
      { mpich_major = 3, mpich_version = "3.4.3", python_version = "3.14" },
    ]
  }

  dockerfile = "Dockerfile.python"
  platforms  = ["linux/amd64", "linux/arm64"]
  tags = [
    "docker.io/astropatty/mpi4py:mpich${item.mpich_version}-py${item.python_version}",
    "docker.io/astropatty/mpi4py:mpich${item.mpich_major}-py${item.python_version}",
  ]
  args = {
    MPICH_VERSION  = item.mpich_version
    PYTHON_VERSION = item.python_version
    BASE_IMAGE     = "docker.io/astropatty/mpich:mpich${item.mpich_version}"
  }
}

# ── Stage 3: parallel-HDF5 + h5py ─────────────────────────────────────────────

group "h5py" {
  targets = ["h5py-build"]
}

target "h5py-build" {
  name = "h5py-build-mpich${item.mpich_major}-py${replace(item.python_version, ".", "")}"
  matrix = {
    item = [
      { mpich_major = 4, mpich_version = "4.1.2", python_version = "3.12" },
      { mpich_major = 4, mpich_version = "4.1.2", python_version = "3.13" },
      { mpich_major = 4, mpich_version = "4.1.2", python_version = "3.14" },
      { mpich_major = 3, mpich_version = "3.4.3", python_version = "3.12" },
      { mpich_major = 3, mpich_version = "3.4.3", python_version = "3.13" },
      { mpich_major = 3, mpich_version = "3.4.3", python_version = "3.14" },
    ]
  }

  dockerfile = "Dockerfile.h5py"
  platforms  = ["linux/amd64", "linux/arm64"]
  tags = [
    "docker.io/astropatty/parallel-h5py:mpich${item.mpich_version}-py${item.python_version}-hdf5-${HDF5_VERSION}",
    "docker.io/astropatty/parallel-h5py:mpich${item.mpich_version}-py${item.python_version}",
    "docker.io/astropatty/parallel-h5py:mpich${item.mpich_major}-py${item.python_version}",
  ]
  args = {
    MPICH_VERSION  = item.mpich_version
    PYTHON_VERSION = item.python_version
    HDF5_VERSION   = HDF5_VERSION
    BASE_IMAGE     = "docker.io/astropatty/mpi4py:mpich${item.mpich_version}-py${item.python_version}"
  }
}
