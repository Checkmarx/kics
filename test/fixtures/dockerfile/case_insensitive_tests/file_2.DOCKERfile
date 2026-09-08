arg BASE_IMAGE=ubuntu:22.04
# Comments before from

from alpine:3.19 AS builder

copy .. .

healthcheck --interval=30s --timeout=30s --start-period=5s --retries=3 cmd [ "executable" ]
