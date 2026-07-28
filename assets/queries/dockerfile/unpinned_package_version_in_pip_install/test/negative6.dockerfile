FROM python:3.12-slim

RUN ["pip", "install", "--no-cache-dir", "requests==2.28.0"]

RUN ["pip", "install", "--trusted-host", "example.com", "requests==2.28.0"]