FROM ubuntu:22.04 AS test1
RUN echo "depth"

FROM test1 AS test2
RUN echo "depth"

FROM test_fail_1
RUN echo "depth"

FROM test3 AS test_fail_2
RUN echo "depth"

FROM test2 AS test3
RUN echo "depth"

FROM test3 AS test_fail_1
RUN echo "depth"