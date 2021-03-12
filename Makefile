GOLINT := golangci-lint
IMAGE_TAG := $(shell git rev-parse HEAD)

.PHONY: dep
dep: # Download required dependencies
	go mod tidy
	go mod download

.PHONY: lint
lint: dep # Lint the files
	$(GOLINT) run -c .golangci.yml

.PHONY: gen
gen:
	go get -u github.com/mailru/easyjson/...
	easyjson pkg/model/model.go

.PHONY: test
test: dep # Run unit tests
	go test -short ./...

.PHONY: dockerise
dockerise:
	docker build -t "kics:${IMAGE_TAG}" .

.PHONY: mock
mock:
	mockgen -package mock -source pkg/engine/inspector.go > pkg/engine/mock/inspector.go
