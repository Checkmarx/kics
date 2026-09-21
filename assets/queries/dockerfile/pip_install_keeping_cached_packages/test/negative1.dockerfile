FROM python:3
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir nibabel pydicom matplotlib pillow && \
    pip install --no-cache-dir med2image
RUN pip3 install --no-cache-dir requests=2.7.0
RUN ["pip3", "install", "requests=2.7.0", "--no-cache-dir"]
CMD ["cat", "/etc/os-release"]
