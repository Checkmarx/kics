c=$(buildah from fedora)

buildah run ${c} -- dnf install -y nginx
