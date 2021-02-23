FROM fedora:27
RUN set -uex && \
    dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo && \
    sed -i 's/\$releasever/26/g' /etc/yum.repos.d/docker-ce.repo && \
    dnf install -vy docker-ce && \
    dnf clean all
HEALTHCHECK CMD curl --fail http://localhost:3000 || exit 1
