FROM gliderlabs/alpine:3.3
RUN apk add --no-cache python
WORKDIR /app
ONBUILD COPY . /app
ONBUILD RUN virtualenv /env; \
    /env/bin/pip install -r /app/requirements.txt
EXPOSE 8080
CMD ["/env/bin/python", "main.py"]
