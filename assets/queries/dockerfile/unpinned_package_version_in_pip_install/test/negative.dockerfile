FROM alpine:3.4
RUN apk add --update py-pip=7.1.2-r0
RUN sudo pip install --upgrade pip=20.3 connexion=2.7.0
COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt
COPY app.py /usr/src/app/
COPY templates/index.html /usr/src/app/templates/
EXPOSE 5000
CMD ["python", "/usr/src/app/app.py"]

FROM alpine:3.1
RUN apk add py-pip=7.1.2-r0
RUN sudo pip install --upgrade pip=20.3 connexion=2.7.0
COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt
RUN pip3 install requests=2.7.0
COPY app.py /usr/src/app/
COPY templates/index.html /usr/src/app/templates/
EXPOSE 5000
CMD ["python", "/usr/src/app/app.py"]
