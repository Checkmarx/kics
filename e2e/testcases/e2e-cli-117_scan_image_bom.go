package testcases

import (
	"encoding/json"
	"fmt"
	"reflect"
	"strconv"
	"strings"

	"github.com/Checkmarx/kics/v2/pkg/imagebom"
)

// E2E-CLI-117 - KICS scan command with --image-bom
// should export a CycloneDX bill of materials of the Docker images found in the scan
func init() { //nolint
	testSample := TestCase{
		Name: "should export a bill of materials of the docker images found in the scan [E2E-CLI-117]",
		Args: args{
			Args: []cmdArgs{
				[]string{"scan",
					"-p", "/path/e2e/fixtures/samples/image_bom",
					"--image-bom",
					"-q", "/path/assets/queries/dockerfile/image_version_using_latest",
					"-b", "/path/assets/libraries", "--disable-secrets", "--no-progress",
					"-o", "/path/e2e/output",
					"--output-name", "E2E_CLI_117_RESULT",
					"--ignore-on-exit", "results",
				},
			},
			ExpectedResult: []ResultsValidation{
				{
					ResultsFile:    "kics-image-bom",
					ResultsFormats: []string{"image-bom"},
					Validate: validateImageBOM(map[string]map[string]int{
						"docker.io/library/golang@1.22":  {"/Dockerfile": 1},
						"gcr.io/distroless/base@latest":  {"/Dockerfile": 1},
						"docker.io/library/busybox@1.36": {"/deployment.yaml": 1},
						"docker.io/library/nginx@1.21":   {"/deployment.yaml": 1, "/docker-compose.yml": 1},
						"docker.io/library/redis@7":      {"/docker-compose.yml": 1},
					}),
				},
			},
		},
		WantStatus: []int{0},
	}

	Tests = append(Tests, testSample)
	registerHelmImageBOM()
}

func registerHelmImageBOM() {
	const chart = "/path/e2e/fixtures/samples/image_bom_helm"
	for _, experimental := range []bool{false, true} {
		name := "E2E_CLI_118_NORMAL"
		sources := 1
		if experimental {
			name = "E2E_CLI_118_EXPERIMENTAL"
			sources = 2
		}
		command := cmdArgs{"scan", "-p", chart, "--image-bom",
			"-q", "/path/assets/queries/k8s/image_without_digest", "-b", "/path/assets/libraries",
			"--disable-secrets", "--no-progress", "--ignore-on-exit", "results",
			"--helm-set", "image.repository=nginx", "--helm-set-string", "image.tag=global",
			"--helm-chart-set-string", chart + "::image.tag=1.27.0",
			"-o", "/path/e2e/output/" + name,
		}
		if experimental {
			command = append(command, "--experimental-helm-scan")
		}
		Tests = append(Tests, TestCase{
			Name: fmt.Sprintf("should export overridden Helm images with experimental mode %t [E2E-CLI-118]", experimental),
			Args: args{
				Args: []cmdArgs{command},
				ExpectedResult: []ResultsValidation{{
					ResultsFile: name + "/kics-image-bom", ResultsFormats: []string{"image-bom"},
					Validate: validateImageBOM(map[string]map[string]int{
						"docker.io/library/nginx@1.27.0": {"/templates/deployment.yaml": sources},
					}),
				}},
			},
			WantStatus: []int{0},
		})
	}
}

func validateImageBOM(want map[string]map[string]int) func([]byte) error {
	return func(data []byte) error {
		var bom imagebom.CycloneDxBOM
		if err := json.Unmarshal(data, &bom); err != nil {
			return err
		}
		if len(bom.Components) != len(want) {
			return fmt.Errorf("expected %d unique images, got %d: %+v", len(want), len(bom.Components), bom.Components)
		}
		seen := make(map[string]bool)
		for _, component := range bom.Components {
			expected, ok := want[component.BOMRef]
			if !ok || seen[component.BOMRef] || component.Type != "container" || component.PURL == "" {
				return fmt.Errorf("unexpected or duplicate image: %+v", component)
			}
			seen[component.BOMRef] = true
			got := make(map[string]int)
			lines := 0
			for _, property := range component.Properties {
				switch property.Name {
				case "kics:source:file":
					matched := false
					for suffix := range expected {
						if strings.HasSuffix(strings.ReplaceAll(property.Value, `\`, "/"), suffix) {
							got[suffix]++
							matched = true
						}
					}
					if !matched {
						return fmt.Errorf("unexpected image source: %s", property.Value)
					}
				case "kics:source:line":
					line, err := strconv.Atoi(property.Value)
					if err != nil || line < 1 {
						return fmt.Errorf("invalid source line: %q", property.Value)
					}
					lines++
				}
			}
			if !reflect.DeepEqual(got, expected) {
				return fmt.Errorf("image %s provenance: got %v, want %v", component.BOMRef, got, expected)
			}
			for _, count := range expected {
				lines -= count
			}
			if lines != 0 {
				return fmt.Errorf("image %s has mismatched source files and lines", component.BOMRef)
			}
		}
		return nil
	}
}
