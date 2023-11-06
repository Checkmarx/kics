FROM ubuntu:22.04 AS test
RUN echo "hello"

FROM test AS build
RUN echo "build"

FROM construction AS final
RUN echo "final"