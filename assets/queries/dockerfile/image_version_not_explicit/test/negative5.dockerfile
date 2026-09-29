from alpine:3.5
run apk add --update py2-pip
run pip install --upgrade pip
copy requirements.txt /usr/src/app/
run pip install --no-cache-dir -r /usr/src/app/requirements.txt
copy app.py /usr/src/app/
copy templates/index.html /usr/src/app/templates/
expose 5000
arg IMAGE=alpine:3.12
from $IMAGE
cmd ["python", "/usr/src/app/app.py"]
