FROM ubuntu:18.04
RUN apt-get update && apt-get install -y netcat \
    apt-get update && apt-get install -y supervisor
ENTRYPOINT ["mysql"]
