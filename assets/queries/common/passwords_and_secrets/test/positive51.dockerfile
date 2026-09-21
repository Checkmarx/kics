# "Dockerfile ENV hardcoded password with omitted equals" - f05f238a-2ef0-4c39-9a36-951de1ba6dc9  positive-test
FROM baseImage

ENV ARTEMIS_USER artemis
ENV ARTEMIS_PASSWORD artemis

RUN apk add --no-cache git \
    && git config \
    --global \
    url."https://${GIT_USER}:${GIT_TOKEN}@github.com".insteadOf \
    "https://github.com"
