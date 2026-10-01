# "Generic Password" - 487f4be7-3fd9-4506-a07a-eae252180c08  positive-test
FROM baseImage

ENV ARTEMIS_USER=artemis
# positive1:
ENV ARTEMIS_PASSWORD=artemis

RUN apk add --no-cache git \
    && git config \
    --global \
    url."https://${GIT_USER}:${GIT_TOKEN}@github.com".insteadOf \
    "https://github.com"
