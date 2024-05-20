FROM node:12
RUN apt-get --assume-yes install apt-utils
RUN ["sudo", "apt-get", "--assume-yes", "install", "apt-utils"] 
