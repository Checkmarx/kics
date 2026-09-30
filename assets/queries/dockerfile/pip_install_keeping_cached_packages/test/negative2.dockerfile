from python:3
run pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir nibabel pydicom matplotlib pillow && \
    pip install --no-cache-dir med2image
run pip3 install --no-cache-dir requests=2.7.0
run ["pip3", "install", "requests=2.7.0", "--no-cache-dir"]
cmd ["cat", "/etc/os-release"]
