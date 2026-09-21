from alpine:3.5
run apk add --update py2-pip
run gem install bundler:2.0.2
run bundle install
copy requirements.txt /usr/src/app/
run pip install --no-cache-dir -r /usr/src/app/requirements.txt
copy app.py /usr/src/app/
copy templates/index.html /usr/src/app/templates/
expose 5000
cmd ["python", "/usr/src/app/app.py"]
env GRPC_VERSION 1.0.0
run gem install grpc -v ${GRPC_RUBY_VERSION}
run gem install grpc:${GRPC_VERSION} grpc-tools:${GRPC_VERSION}
