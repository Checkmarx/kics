FROM baseImage
RUN Test

FROM debian:jesse2 AS build
RUN stuff

FROM debian:jesse1 AS build
RUN more_stuff
