########################
# GNU Makefile         #
# Golang SDK required  #
########################
.DEFAULT_GOAL := help
GOLINT := golangci-lint
COMMIT := $(shell git rev-parse HEAD)
VERSION := snapshot-$(shell echo ${COMMIT} | cut -c1-8)
LIB = $(shell pwd)/lib
IMAGE_TAG := dev
TARGET_BIN ?= bin/kics
CONSTANTS_PATH = github.com/Checkmarx/kics/internal/constants

.PHONY: clean
clean: ## remove files created during build
	$(call print-target)
	rm -rf dist
	rm -rf bin
	rm -rf vendor
	rm -f coverage.*
	rm -f cover.out
	rm -rf *.log
	rm -rf **/*.log
	rm -f results.*
	rm -rf e2e/output

.PHONY: mod-tidy
mod-tidy: ## go mod tidy - download and cleanup modules
	$(call print-target)
	@go mod tidy

.PHONY: vendor
vendor: ## go mod vendor - download vendor modules
	$(call print-target)
	@go mod vendor

.PHONY: lint
lint: ## Lint the files
lint: mod-tidy
	$(call print-target)
	$(GOLINT) run -c .golangci.yml

.PHONY: build-all
build-all: ## go build for both kics and query builder
build-all: lint generate
	$(call print-target)
	@go build -o bin/ \
		-ldflags "-X ${CONSTANTS_PATH}.Version=${VERSION} -X ${CONSTANTS_PATH}.SCMCommit=${COMMIT}" ./...
	@mv bin/console bin/kics

.PHONY: build
build: ## go build
build: generate
	$(call print-target)
	@go build -o ${TARGET_BIN} -ldflags "-X ${CONSTANTS_PATH}.SCMCommit=${COMMIT} -X ${CONSTANTS_PATH}.Version=${VERSION} -X ${CONSTANTS_PATH}.BaseURL=${DESCRIPTIONS_URL}" \
		cmd/console/main.go


.PHONY: go-clean
go-clean: ## Go clean build, test and modules caches
	$(call print-target)
	@go clean -r -i -cache -testcache -modcache

.PHONY: generate
generate: mod-tidy ## go generate
	$(call print-target)
	@go generate ./...

.PHONY: generate-antlr
generate-antlr: ## generate parser with ANTLRv4, needs JRE (Java Runtime Environment) on the system
	@cd pkg/parser/jsonfilter/ && java -jar $(LIB)/antlr-4.13.1-complete.jar -Dlanguage=Go -visitor -no-listener -o parser JSONFilter.g4

.PHONY: test
test-short: # Run sanity unit tests
test-short: generate
	$(call print-target)
	@go test -short ./...

.PHONY: test
test: ## Run all tests
test: test-cover test-e2e
	$(call print-target)

.PHONY: test-race
test-race: ## Run tests with race detector
test-race: generate
	$(call print-target)
	@go test -race $(shell go list ./... | grep -v e2e)

.PHONY: test-unit
test-unit: ## Run unit tests
test-unit: generate
	$(call print-target)
	@go test $(shell go list ./... | grep -v e2e)

.PHONY: test-cover
test-cover: ## Run tests with code coverage
test-cover: generate
	$(call print-target)
	@go test -covermode=atomic -v -coverprofile=coverage.out $(shell go list ./... | grep -v e2e)

.PHONY: test-coverage-report
test-coverage-report: ## Run unit tests and generate test coverage report
test-coverage-report: test-cover
	@python3 .github/scripts/coverage/get-coverage.py coverage.out
	@echo "Generating coverage.html"
	@go tool cover -html=coverage.out -o coverage.html

.PHONY: test-e2e
test-e2e: ## Run E2E tests
test-e2e: build
	$(call print-target)
	E2E_KICS_BINARY=$(PWD)/bin/kics go test "github.com/Checkmarx/kics/v2/e2e" -v -timeout 1500s

.PHONY: cover
cover: ## generate coverage report
cover: test
	$(call print-target)
	@go tool cover -html=coverage.out -o coverage.html

.PHONY: docker
docker: ## build docker image
	$(call print-target)
	@docker build --build-arg VERSION=${VERSION} --build-arg COMMIT=${COMMIT} -t "kics:${IMAGE_TAG}" .

.PHONY: podman
podman: ## build podman image
	$(call print-target)
	@podman build --build-arg VERSION=${VERSION} --build-arg COMMIT=${COMMIT} -t "kics:${IMAGE_TAG}" .

.PHONY: docker-compose
dkr-compose: ## build docker image and runs docker-compose up
	$(call print-target)
	VERSION=${VERSION} COMMIT=${COMMIT} IMAGE_TAG=${IMAGE_TAG} docker-compose up --build

.PHONY: podman-compose
podman-compose: ## build podman image and runs podman-compose up
	$(call print-target)
	VERSION=${VERSION} COMMIT=${COMMIT} IMAGE_TAG=${IMAGE_TAG} podman-compose up --build

.PHONY: dkr-build-antlr
dkr-build-antlr: ## build ANTLRv4 docker image and generate parser based on given grammar
	@docker build -t antlr4-generator:dev -f ./docker/Dockerfile.antlr .
	@docker run --rm -u $(id -u ${USER}):$(id -g ${USER}) -v $(pwd)/pkg/parser:/work -it antlr4-generator:dev

.PHONY: podman-build-antlr
podman-build-antlr: ## build ANTLRv4 podman image and generate parser based on given grammar
	@podman build -t antlr4-generator:dev -f ./docker/Dockerfile.antlr .
	@podman run --rm -u $(id -u ${USER}):$(id -g ${USER}) -v $(pwd)/pkg/parser:/work -it antlr4-generator:dev

.PHONY: release
release: ## goreleaser --rm-dist
release: install
	$(call print-target)
	@goreleaser --rm-dist

.PHONY: run-local
run-local: ## run agains local kics.config
run-local: build
	$(call print-target)
	@./bin/kics scan --config kics.config

.PHONY: generate-queries-docs
generate-queries-docs: ## generate queries catalog md files
	$(call print-target)
	@pip3 install -r .github/scripts/docs-generator/requirements.txt
	@python3 -u .github/scripts/docs-generator/docs-generator.py \
		-p ./assets/queries/ \
		-o ./docs/queries/ \
		-f md \
		-t .github/scripts/docs-generator/templates
	@python3 -u -B .github/scripts/docs-generator/query-page-generator/query-page-generator.py \
    	-p ./assets/queries/ \
        -o ./docs/queries/ \
        -f md \
        --t .github/scripts/docs-generator/query-page-generator/templates/query-page-template.md \
		--df
	@echo "\033[36mQueries catalog updated\033[0m"

.PHONY: integration
integration: ## run kics against all its samples
	$(call print-target)
	@go run cmd/console/main.go scan -p assets/queries --log-level DEBUG --log-file

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

define print-target
	@printf "Executing target: \033[36m$@\033[0m\n"
endef

.PHONY: lint-docker-image
lint-docker-image:
	docker run -t --rm -v ./:/app -w /app golangci/golangci-lint:v1.57.2 golangci-lint run -v -c /app/.golangci.yml --timeout 20m

.PHONY: lint-podman-image
lint-podman-image:
	podman run -t --rm -v ./:/app -w /app golangci/golangci-lint:v1.57.2 golangci-lint run -v -c /app/.golangci.yml --timeout 20m