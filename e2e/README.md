# E2E tests

The purpose of this docs is to describe KICS' E2E test suite

## Getting Started

There are several ways to execute the E2E tests.

### TLDR;

This steps will build the kics and then run the E2E using the built binary (placed by default under `${PWD}/bin/kics`)

```bash
make test-e2e
```

### Step by Step

These steps will build the kics and then run the E2E using the built binary.

```bash
go build -o ./bin/kics cmd/console/main.go
```

If you want to provide a version:
```bash
go build -o ./bin/kics -ldflags "-X github.com/Checkmarx/kics/internal/constants.Version=$(git rev-parse --short HEAD) cmd/console/main.go
```

and then:

```bash
E2E_KICS_BINARY=./bin/kics go test "github.com/Checkmarx/kics/e2e" -v
```

## Test Scenarios

Test scenarios are defined as follows:

```go
var tests = []struct {
	name          string
	args          args
	wantStatus    int
	removePayload []string
}{
	// E2E-CLI-005 - KICS scan with -- payload-path flag should create a file with the
	// passed name containing the payload of the files scanned
	{
		name: "E2E-CLI-005",
		args: args{
            // These are CLI arguments passed down to the KICS binary
			args: []cmdArgs{
				[]string{"scan", "--silent", "-q", "../assets/queries", "-p", "fixtures/samples/terraform.tf",
					"--payload-path", "fixtures/payload.json", "-q", "../assets/queries"},
			},
             // this is a reference to a fixture placed under e2e/fixtures that contains the expected stdout output
			expectedOut: []string{
				"E2E_CLI_005",
			},
            // this is a reference to a fixture placed under e2e/fixtures that contains the expected KICS' payload
			expectedPayload: []string{
				"E2E_CLI_005_PAYLOAD",
			},
		},
		wantStatus:    0,
        // we should cleanup the payload after running this scenario
		removePayload: []string{"payload.json"},
	},
}
```

E2E tests are skiped in short mode:

```go
func Test_E2E_CLI(t *testing.T) {
	kicsPath := getKICSBinaryPath("")

	if testing.Short() {
		t.Skip("skipping E2E tests in short mode.")
	}
//...
}
```
