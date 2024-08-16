FROM baseImage

RUN apk add --no-cache git \
    && git config \
    --global \
    url."https://${GIT_USER}:${GIT_TOKEN}@github.com".insteadOf \
    "https://github.com"

