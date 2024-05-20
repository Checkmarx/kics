FROM node:12
RUN sudo apt-get -q -q install sl
RUN ["apt-get", "-q", "-q", "apt-utils"]
