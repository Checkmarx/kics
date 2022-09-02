.PHONY: all githooks clean deps test lint out_dir

OUT_DIR ?= build
GOARCH  ?= amd64
GOOS    ?= linux
ifeq ($(GOOS),windows)
    BIN_EXTENSION=.exe
endif
SEMVER  ?= 0.0.0-$(shell whoami)

all: deps test lint build

init: githooks
	curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s -- -b $(shell go env GOPATH)/bin

githooks:
	git config core.hooksPath .githooks

out_dir:
	mkdir -p $(OUT_DIR)

test: out_dir
	go test -count=1 -race ./... -tags 'release netgo osusergo' -v -coverprofile=$(OUT_DIR)/coverage.out
	go tool cover -func=$(OUT_DIR)/coverage.out

#
# lint go code critical checks
#
# Shortcut for lint for developer
lint: out_dir
	$(if $(CI), make ci_lint, make lint_local)

lint_local:
	golangci-lint run --fix -v

# Running lint with additional checks for sonarscanner
# Used by CI
ci_lint:
	golangci-lint run --out-format checkstyle > $(OUT_DIR)/lint-report.xml

format:
	go fmt ./...

deps:
	go get -u ./...
	go mod tidy
	go mod verify

