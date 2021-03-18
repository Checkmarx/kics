FROM alpine:3.9
RUN apk add --update py-pip
RUN sudo pip install --upgrade pip
COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt
COPY app.py /usr/src/app/
COPY templates/index.html /usr/src/app/templates/
EXPOSE 5000
ENV TEST="test"
CMD ["python", "/usr/src/app/app.py"]

FROM alpine:3.7
RUN apk add py-pip && apk add tea
RUN apk add py-pip \
    && rm -rf /tmp/*
RUN apk add --dir /dir libimagequant \
    && minidlna
RUN ["apk", "add", "py-pip"]
RUN sudo pip install --upgrade pip
COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt
COPY app.py /usr/src/app/
COPY templates/index.html /usr/src/app/templates/
EXPOSE 5000
CMD ["python"]
