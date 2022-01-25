c=$(buildah from fedora)

buildah run ${c} apt-get install python3-setuptools -y
