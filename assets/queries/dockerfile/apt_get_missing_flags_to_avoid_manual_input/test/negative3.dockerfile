FROM node:12
RUN apt-get --yes install apt-utils
RUN ["sudo", "apt-get", "--yes" ,"install", "apt-utils"]
