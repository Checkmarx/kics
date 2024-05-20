FROM node:12
RUN sudo apt-get -y install apt-utils
RUN sudo apt-get -qy install git gcc
RUN ["sudo", "apt-get", "-y", "install", "apt-utils"]
