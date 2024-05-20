FROM node:12
RUN sudo apt-get -q install sl
RUN ["apt-get", "-q", "install", "apt-utils"] 