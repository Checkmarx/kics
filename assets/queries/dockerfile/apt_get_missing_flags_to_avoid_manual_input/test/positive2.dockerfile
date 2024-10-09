FROM node:12
RUN sudo apt-get install python=2.7
RUN sudo apt-get install apt-utils
RUN ["sudo", "apt-get", "install", "apt-utils"]
