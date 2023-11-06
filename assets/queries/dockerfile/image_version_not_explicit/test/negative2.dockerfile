FROM ubuntu:22.04 AS test
RUN echo "hello"

FROM test AS build
RUN echo "build"

FROM build AS final
RUN echo "final"