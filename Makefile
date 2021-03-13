########################
# GNU Makefile         #
# Golang SDK required  #
########################
.DEFAULT_GOAL := help
GOLINT := golangci-lint
IMAGE_TAG := $(shell git rev-parse HEAD)

.PHONY: clean
clean: ## remove files created during build
	$(call print-target)
	rm -rf dist
	rm -rf bin
	rm -f coverage.*

.PHONY: mod-tidy
mod-tidy: ## go mod tidy
	$(call print-target)
	go mod tidy
	cd tools && go mod tidy

.PHONY: install
install: ## go install tools
	$(call print-target)
	cd tools && go install $(shell cd tools && go list -f '{{ join .Imports " " }}' -tags=tools)

.PHONY: lint
lint: ## Lint the files
lint: mod-tidy
	$(call print-target)
	$(GOLINT) run -c .golangci.yml

.PHONY: build
build: ## go build
build: lint generate
	$(call print-target)
	go build -o bin/ -ldflags "-X github.com/Checkmarx/kics/internal/constants.Version=${IMAGE_TAG}" ./...
	@mv bin/console bin/kics

.PHONY: go-clean
go-clean: ## Go clean build, test and modules caches
	$(call print-target)
	go clean -r -i -cache -testcache -modcache

.PHONY: generate
generate: ## go generate
	$(call print-target)
	go generate ./...

.PHONY: test
test-short: # Run sanity unit tests
test-short: generate
	$(call print-target)
	go test -short ./...

.PHONY: test
test: ## Run tests with race detector and code covarage
test: generate
	$(call print-target)
	go test -race -covermode=atomic -coverprofile=coverage.out ./...
	go tool cover -html=coverage.out -o coverage.html

.PHONY: cover
cover: ## generate coverage report
cover: test
	$(call print-target)
	go tool cover -html=coverage.out -o coverage.html

.PHONY: docker
docker: ## build docker image
	$(call print-target)
	docker build -t "kics:${IMAGE_TAG}" .

.PHONY: release
release: ## goreleaser --rm-dist
release: install
	$(call print-target)
	goreleaser --rm-dist

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

define print-target
	@printf "Executing target: \033[36m$@\033[0m\n"
endef
