FROM node:12
RUN sudo apt-get -q=2 install apt-utils
RUN ["apt-get", "-q=2", "install", "apt-utils"]