FROM ubuntu:22.04 AS test
RUN echo "hello"

FROM positive4 
RUN echo "positive4"

FROM positive42
RUN echo "positive42"