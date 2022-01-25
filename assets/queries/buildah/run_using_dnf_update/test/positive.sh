c=$(buildah from fedora)

buildah run ${c} -- dnf update -y
