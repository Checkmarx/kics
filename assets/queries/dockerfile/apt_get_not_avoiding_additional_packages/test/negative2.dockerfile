from node:12
run apt-get --no-install-recommends install apt-utils
run ["apt-get", "apt::install-recommends=false", "install", "apt-utils"]

