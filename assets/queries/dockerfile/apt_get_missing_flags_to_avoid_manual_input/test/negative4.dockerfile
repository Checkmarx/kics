FROM node:12
RUN sudo apt-get -qq install apt-utils
RUN ["apt-get", "-qq", "install", "apt-utils"] 
