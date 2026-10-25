FROM golang:1.22 AS build
WORKDIR /src
RUN go build -o /app

FROM build
RUN echo "intermediate stage referencing an alias"

FROM gcr.io/distroless/base:latest
COPY --from=build /app /app
