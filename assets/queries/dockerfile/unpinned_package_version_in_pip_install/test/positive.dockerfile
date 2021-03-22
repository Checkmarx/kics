FROM alpine:3.9
RUN apk add --update py-pip=7.1.2-r0
RUN pip install --user pip
RUN ["pip", "install", "connexion"]
COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt
COPY app.py /usr/src/app/
COPY templates/index.html /usr/src/app/templates/
EXPOSE 5000
ENV TEST="test"
CMD ["python", "/usr/src/app/app.py"]

FROM alpine:3.7
RUN apk add --update py-pip=7.1.2-r0
RUN pip install connexion
COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt
RUN pip3 install requests
COPY app.py /usr/src/app/
COPY templates/index.html /usr/src/app/templates/
EXPOSE 5000
CMD ["python"]
