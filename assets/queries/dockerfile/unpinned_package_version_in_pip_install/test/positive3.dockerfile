FROM python:3.12-slim

RUN pip install --no-cache-dir --index-url https://example.com/simple --trusted-host example.com flask
