FROM node:12
RUN ["sudo", "apt-get", "--quiet", "install", "apt-utils"] 
RUN sudo apt-get --quiet install apt-utils