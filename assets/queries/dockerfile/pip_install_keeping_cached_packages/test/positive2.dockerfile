from python:3
run pip install --upgrade pip && \
    pip install nibabel pydicom matplotlib pillow && \
    pip install med2image
cmd ["cat", "/etc/os-release"]

from python:3.1
run pip install --upgrade pip
run python -m pip install nibabel pydicom matplotlib pillow
run pip3 install requests=2.7.0
run ["pip3", "install", "requests=2.7.0"]
cmd ["cat", "/etc/os-release"]
