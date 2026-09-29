from fedora:27
run set -uex && \
    dnf config-manager --set-enabled docker-ce-test && \
    dnf install -y docker-ce && \
    dnf clean all