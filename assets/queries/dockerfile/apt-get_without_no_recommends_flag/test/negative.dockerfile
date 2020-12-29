FROM node:12
RUN apt-get --no-install-recommends install apt-utils
RUN ["apt-get", "apt::install-recommends=false", "install", "apt-utils"]

