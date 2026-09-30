from alpine:3.5
run apk add --update py2-pip
run pip install --upgrade pip
label maintainer="SvenDowideit@home.org.au"
copy requirements.txt /usr/src/app/
from --platform=arm64 baseimage as baseimage-build
