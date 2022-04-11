FROM busybox4
RUN apt-get install python
RUN ["apt-get", "install", "python"]

FROM busybox5
RUN apt-get install -y -t python

FROM busybox6
RUN apt-get update ; \
    apt-get install -y \
    python-qt4 \
    python-pyside \
    python-pip \
    python3-pip \
    python3-pyqt5
