FROM fedora:27
RUN microdnf install -y \
    openssl-libs-1:1.1.1k-6.el8_5.x86_64 \
    zlib-1.2.11-18.el8_5.x86_64 \
 && microdnf clean all
