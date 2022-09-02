SOURCE_FILES?=./...
TEST_PATTERN?=.
TEST_OPTIONS?=
TEST_TIMEOUT?=5m
SEMVER?=0.0.0-$(shell whoami)
CI_COMMIT_SHORT_SHA?=$(shell git log --pretty=format:'%h' -n 1)

test:
	go test $(TEST_OPTIONS) -v -failfast -race -coverpkg=./... -covermode=atomic -coverprofile=coverage.out $(SOURCE_FILES) -run $(TEST_PATTERN) -timeout=$(TEST_TIMEOUT)
.PHONY: test

cover: test
	go tool cover -html=coverage.out
.PHONY: cover

fmt:
	go mod tidy
	gofumpt -w -l .
.PHONY: fmt

ci: build test
.PHONY: ci

build:
	go build -tags 'release netgo osusergo'  \
		-ldflags '$(linker_flags) -s -w -extldflags "-fno-PIC -static" -X main.pkgName=chglog -X main.version=$(SEMVER) -X main.commit=$(CI_COMMIT_SHORT_SHA)' \
		 -o chglog ./cmd/chglog/...
.PHONY: build

.DEFAULT_GOAL := build
