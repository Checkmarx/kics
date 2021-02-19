FROM node:12
RUN apt-get install apt-utils
RUN ["apt-get", "install", "apt-utils"]