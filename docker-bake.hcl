group "default" {
  targets = ["mpich"]
}

variable "HDF5_VERSION" {
  default = "1.14.6"
}

target "mpich" {
  name = "mpich-${item.major}"
  matrix = {
    item = [
      {
        major = 4
        version = "4.1.2"

      },
      {
        major = 3
        version = "3.4.3"
      }
    ]
  }

  dockerfile = "Dockerfile"
  platforms = ["linux/amd64", "linux/arm64"]
  tags = ["docker.io/astropatty/parallel-h5py:mpich-${item.major}"]
  args = {
    MPICH_VERSION = item.version
  }
}

