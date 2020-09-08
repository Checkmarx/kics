GOLINT := golangci-lint
IMAGE_TAG := $(shell git rev-parse HEAD)

.PHONY: dep
dep: # Download required dependencies
	go mod tidy
	go mod download

.PHONY: lint
lint: dep # Lint the files
	$(GOLINT) run -c .golangci.yml

.PHONY: test
test: dep # Run unit tests
	go test -short ./...

.PHONY: dockerise
dockerise:
	docker build --build-arg GIT_USER=$(user) --build-arg GIT_TOKEN=$(token) -t "ice:${IMAGE_TAG}" .

.PHONY: mock
mock:
	mockgen -package mock -source pkg/engine/inspector.go > pkg/engine/mock/inspector.go