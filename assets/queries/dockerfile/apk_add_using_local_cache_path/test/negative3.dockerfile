from gliderlabs/alpine:3.3
run apk add --no-cache python
workdir /app
onbuild COPY . /app
onbuild RUN virtualenv /env && /env/bin/pip install -r /app/requirements.txt
expose 8080
cmd ["/env/bin/python", "main.py"]