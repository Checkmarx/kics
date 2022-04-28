FROM busyboxneg2
RUN apt-get install python=2.7

FROM busyboxneg3
RUN apt-get install -y -t python=2.7

FROM busyboxneg4
RUN apt-get update; \
    apt-get install -y \
    python-qt4=4.11 \
    python-pyside=6.0.1 \
    python-pip=1.0.2 \
    python3-pip=1.0 \
    python3-pyqt5=5
