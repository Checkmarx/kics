FROM alpine:3.4
RUN apk add --update py-pip=7.1.2-r0
RUN pip3 install -r pip_requirements.txt
COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt
COPY app.py /usr/src/app/
COPY templates/index.html /usr/src/app/templates/
EXPOSE 5000
CMD ["python", "/usr/src/app/app.py"]
