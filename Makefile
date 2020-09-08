GOLINT := golangci-lint

.PHONY: dep
dep: # Download required dependencies
	go mod tidy
	go mod download

.PHONY: lint
lint: dep # Lint the files
	$(GOLINT) run -c .golangci.yml

.PHONY: test
test: dep # Run unit tests
	go test -race -count=1 -short ./...