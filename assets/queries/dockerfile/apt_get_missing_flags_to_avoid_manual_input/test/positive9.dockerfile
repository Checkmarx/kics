FROM node:12
RUN apt-get install python3-numpy
RUN apt-get install --no-install-recommends python3-yaml
RUN apt-get install python3-pyqt5
RUN apt-get install python3-qt5 -q
RUN apt-get install -q python3-qt5
