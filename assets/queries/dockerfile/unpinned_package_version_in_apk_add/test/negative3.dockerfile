from alpine:3.4
run apk add --update py-pip=7.1.2-r0
run sudo pip install --upgrade pip
copy requirements.txt /usr/src/app/
run pip install --no-cache-dir -r /usr/src/app/requirements.txt
copy app.py /usr/src/app/
copy templates/index.html /usr/src/app/templates/
expose 5000
cmd ["python", "/usr/src/app/app.py"]

from alpine:3.1
run apk add py-pip=7.1.2-r0
run ["apk", "add", "py-pip=7.1.2-r0"]
run sudo pip install --upgrade pip
copy requirements.txt /usr/src/app/
run pip install --no-cache-dir -r /usr/src/app/requirements.txt
copy app.py /usr/src/app/
copy templates/index.html /usr/src/app/templates/
expose 5000
cmd ["python", "/usr/src/app/app.py"]
