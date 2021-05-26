FROM node:12
RUN apt-get -y install apt-utils
RUN apt-get -qy install git gcc
RUN ["apt-get", "-y", "install", "apt-utils"]
