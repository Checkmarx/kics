FROM alpine:3.5
RUN apk add --update py2-pip
RUN pip install --upgrade pip
COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt
COPY app.py /usr/src/app/
COPY templates/index.html /usr/src/app/templates/
EXPOSE 5000
CMD ["python", "/usr/src/app/app.py"]

FROM 923847651029.dkr.ecr.eu-west-1.amazonaws.com/echo/echo-fips:latest@sha256:a1f3c2e9b0d74682f5a3c1e8b2d09f47c6e1a3b8d2f04c7e9a1b3d5f7c2e4a6b8
RUN apk add --update py2-pip
RUN pip install --upgrade pip
COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt
COPY app.py /usr/src/app/
COPY templates/index.html /usr/src/app/templates/
EXPOSE 5001
CMD ["python", "/usr/src/app/app.py"]