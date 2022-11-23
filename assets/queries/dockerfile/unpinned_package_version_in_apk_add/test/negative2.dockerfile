FROM alpine:3.4
RUN apk add --update py-pip=7.1.2-r0
RUN sudo pip install --upgrade pip
COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt
COPY app.py /usr/src/app/
COPY templates/index.html /usr/src/app/templates/
EXPOSE 5000
CMD ["python", "/usr/src/app/app.py"]

FROM alpine:3.1
RUN apk add --virtual .test py-pip=7.1.2-r0
RUN apk --quiet --update --no-cache add libstdc++==11.2.1_git20220219-r2
RUN ["apk", "add", "--virtual .test", "py-pip=7.1.2-r0"]
RUN sudo pip install --upgrade pip
COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt
COPY app.py /usr/src/app/
COPY templates/index.html /usr/src/app/templates/
EXPOSE 5000
CMD ["python", "/usr/src/app/app.py"]
