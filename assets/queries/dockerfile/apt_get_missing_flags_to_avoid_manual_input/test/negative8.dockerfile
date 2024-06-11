FROM node:12
RUN apt-get -q -q install sl
RUN ["apt-get", "-q", "-q", "apt-utils"]
