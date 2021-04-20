# Tests

The purpose of this docs is to describe KICS' tests

## Getting Started

There are several ways to execute the E2E tests.

### TLDR

This command will execute all go tests:

```bash
make test-race-cover
```

This will run a shorter test suite without the queries tests.
```bash
make test-short
```

If you want to generate a HTML coverage report:

```bash
make test-coverage-report
```
