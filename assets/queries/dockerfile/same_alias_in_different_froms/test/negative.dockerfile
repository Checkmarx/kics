FROM debian:jesse1 AS build
RUN stuff

FROM debian:jesse1 AS another-alias
RUN more_stuff
