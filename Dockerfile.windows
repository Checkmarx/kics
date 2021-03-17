FROM golang:1.16.0-windowsservercore-1809 as build

WORKDIR /workspace

# cache dependencies as docker layers
COPY go.mod /workspace
COPY go.sum /workspace

# fix https://github.com/golang/lint/issues/288
RUN mkdir -p $GOPATH/src/golang.org/x/; \
  cd $GOPATH/src/golang.org/x/; \
  git clone https://github.com/golang/tools.git
RUN go mod download -x

COPY . /workspace

ARG VERSION=development
ENV GOOS=windows GOARCH=amd64 GCO_ENABLED=0

RUN go mod download
RUN $env:LDFLAGS = '-X github.com/Checkmarx/kics/internal/constants.Version=' + $env:VERSION; \
  go build -ldflags $env:LDFLAGS -a -installsuffix cgo -o "bin/kics.exe" cmd/console/main.go

FROM mcr.microsoft.com/windows/nanoserver:1809
WORKDIR /app
COPY --from=build ./workspace/bin/kics.exe /app/kics.exe
COPY --from=build ./workspace/assets/ /app/assets
ENTRYPOINT ["cmd", "/c", "kics.exe"]
