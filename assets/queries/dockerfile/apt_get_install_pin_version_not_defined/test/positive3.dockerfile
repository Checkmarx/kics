from busybox
run apt-get install python
run ["apt-get", "install", "python"]

from busybox2
run apt-get install -y -t python

from busybox3
run apt-get update && apt-get install -y \
    python-qt4 \
    python-pyside \
    python-pip \
    python3-pip \
    python3-pyqt5
