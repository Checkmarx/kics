from fedora:27
run set -uex && \
    dnf config-manager --set-enabled docker-ce-test && \
    dnf install docker-ce && \
    dnf clean all

from fedora:28
run set -uex
run dnf config-manager --set-enabled docker-ce-test
run dnf in docker-ce
run dnf clean all