FROM node:12
RUN ["sudo", "apt-get", "-q" ,"install", "apt-utils"]
RUN sudo apt-get -q install apt-utils
