FROM python:3.12-slim

RUN pip install \
    --no-cache-dir \
    --index-url https://example.com/simple \
    --trusted-host example.com \
    requests==2.28.0 \
    flask==2.3.0

FROM python:3.11-slim

RUN pip3 install --no-cache-dir --index-url https://example.com/simple --trusted-host example.com numpy==1.24.0
