from alpine:3.9
run apk add --update py-pip=7.1.2-r0
run pip install --user pip
run ["pip", "install", "connexion"]
copy requirements.txt /usr/src/app/
run pip install --no-cache-dir -r /usr/src/app/requirements.txt
copy app.py /usr/src/app/
copy templates/index.html /usr/src/app/templates/
expose 5000
env TEST="test"
cmd ["python", "/usr/src/app/app.py"]

from alpine:3.7
run apk add --update py-pip=7.1.2-r0
run pip install connexion
copy requirements.txt /usr/src/app/
run pip install --no-cache-dir -r /usr/src/app/requirements.txt
run pip3 install requests
copy app.py /usr/src/app/
copy templates/index.html /usr/src/app/templates/
expose 5000
cmd ["python"]
