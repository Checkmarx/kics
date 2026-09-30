FROM fedora:27
RUN set -uex && \
    dnf config-manager --set-enabled docker-ce-test && \
    dnf install docker-ce && \
    dnf clean all

FROM fedora:28
RUN set -uex
RUN dnf config-manager --set-enabled docker-ce-test
RUN dnf in docker-ce
RUN dnf clean all