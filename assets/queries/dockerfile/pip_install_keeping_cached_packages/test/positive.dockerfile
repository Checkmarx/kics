FROM python:3
RUN pip install --upgrade pip && \
    pip install nibabel pydicom matplotlib pillow && \
    pip install med2image
CMD ["cat", "/etc/os-release"]

FROM python:3.1
RUN pip install --upgrade pip
RUN python -m pip install nibabel pydicom matplotlib pillow
CMD ["cat", "/etc/os-release"]
