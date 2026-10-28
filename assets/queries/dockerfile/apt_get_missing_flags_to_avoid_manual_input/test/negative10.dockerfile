FROM node:12
RUN apt-get install python3-numpy -y
RUN apt-get install python3-yaml curl -yq
RUN apt-get install python3-numpy --assume-yes
RUN apt-get install python3-qt5 -q -q
RUN apt-get update; apt-get install curl -y; rm -rf /var/lib/apt/lists/*
RUN apt-get install curl \
	-y
