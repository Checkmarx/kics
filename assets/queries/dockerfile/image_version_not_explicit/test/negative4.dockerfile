FROM ubuntu:22.04 AS test1
RUN echo "depth1"

FROM test1 AS test2
RUN echo "depth2"

FROM test2 AS test3
RUN echo "depth3"

FROM test3 AS test4
RUN echo "depth4"

FROM test4 
RUN echo "depth5"