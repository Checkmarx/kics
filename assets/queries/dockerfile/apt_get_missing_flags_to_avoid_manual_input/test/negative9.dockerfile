from node:12
run apt-get -y install apt-utils
run apt-get -qy install git gcc
run ["apt-get", "-y", "install", "apt-utils"]
