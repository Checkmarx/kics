FROM alpine:3.5
RUN apk add --update py2-pip
RUN gem install bundler:2.0.2
RUN bundle install
COPY requirements.txt /usr/src/app/
RUN pip install --no-cache-dir -r /usr/src/app/requirements.txt
COPY app.py /usr/src/app/
COPY templates/index.html /usr/src/app/templates/
EXPOSE 5000
CMD ["python", "/usr/src/app/app.py"]
ENV GRPC_VERSION 1.0.0
RUN gem install grpc -v ${GRPC_RUBY_VERSION}
RUN gem install grpc:${GRPC_VERSION} grpc-tools:${GRPC_VERSION}
