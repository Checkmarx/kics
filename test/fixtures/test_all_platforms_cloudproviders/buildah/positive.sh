c=$(buildah from fedora)

buildah run ${c} apt install python3-setuptools -y
