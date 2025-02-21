FROM node:12
RUN sudo apt-get --quiet install sl
RUN ["apt-get", "--quiet" ,"install", "apt-utils"] 