FROM node:12
RUN apt-get --quiet --quiet install sl
RUN ["apt-get", "--quiet", "--quiet" ,"install", "apt-utils"] 
