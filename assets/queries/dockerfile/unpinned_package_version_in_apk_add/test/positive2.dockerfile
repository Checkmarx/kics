from alpine:3.9
run apk add --update py-pip
run sudo pip install --upgrade pip
copy requirements.txt /usr/src/app/
run pip install --no-cache-dir -r /usr/src/app/requirements.txt
copy app.py /usr/src/app/
copy templates/index.html /usr/src/app/templates/
expose 5000
env TEST="test"
cmd ["python", "/usr/src/app/app.py"]

from alpine:3.7
run apk add py-pip && apk add tea
run apk add py-pip \
    && rm -rf /tmp/*
run apk add --dir /dir libimagequant \
    && minidlna
run ["apk", "add", "py-pip"]
run sudo pip install --upgrade pip
copy requirements.txt /usr/src/app/
run pip install --no-cache-dir -r /usr/src/app/requirements.txt
copy app.py /usr/src/app/
copy templates/index.html /usr/src/app/templates/
expose 5000
cmd ["python"]
