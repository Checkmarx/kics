package testcases

import (
	"encoding/json"
	"fmt"
	"reflect"
	"sort"
	"strings"

	"github.com/Checkmarx/kics/v2/pkg/model"
)

const helmOverrideFixture = "/path/e2e/fixtures/samples/helm_overrides"
const helmObservationQuery = "9f5128ee-5817-4e46-b7ac-38f06798578b"

type helmObservation struct {
	Chart   string
	Context string
	Values  map[string]string
}

func helmExpected(chart, context string, changes map[string]string) helmObservation {
	values := map[string]string{
		"replicaCount": "1", "tag": "default", "enabled": "true", "items": "default",
		"message": "default", "variant": "baseline", "requiredValue": "",
	}
	for key, value := range changes {
		values[key] = value
	}
	return helmObservation{Chart: chart, Context: context, Values: values}
}

func validateHelmObservations(want ...helmObservation) func([]byte) error {
	return func(data []byte) error {
		var summary model.Summary
		if err := json.Unmarshal(data, &summary); err != nil {
			return err
		}
		if summary.FailedToExecuteQueries != 0 || summary.FailedSimilarityID != 0 || summary.FailedToScanFiles != 0 {
			return fmt.Errorf("Helm fixture scan failed: %+v", summary.Counters)
		}
		if len(summary.Queries) != 1 || summary.Queries[0].QueryID != helmObservationQuery || summary.TotalCounter != len(want) {
			return fmt.Errorf("expected %d observations from %s, got %d results across %d queries",
				len(want), helmObservationQuery, summary.TotalCounter, len(summary.Queries))
		}
		var got []helmObservation
		for _, file := range summary.Queries[0].Files {
			suffix := "/charts/" + file.ResourceName + "/templates/configmap.yaml"
			if !strings.HasSuffix(strings.ReplaceAll(file.FileName, `\`, "/"), suffix) || file.Line < 1 {
				return fmt.Errorf("finding did not map to its Helm template: %+v", file)
			}
			var values map[string]string
			if err := json.Unmarshal([]byte(file.KeyActualValue), &values); err != nil {
				return fmt.Errorf("decode rendered values: %w", err)
			}
			got = append(got, helmObservation{Chart: file.ResourceName, Context: file.ContextSelector, Values: values})
		}
		less := func(observations []helmObservation) func(int, int) bool {
			return func(i, j int) bool {
				return observations[i].Chart+"/"+observations[i].Context < observations[j].Chart+"/"+observations[j].Context
			}
		}
		expected := append([]helmObservation(nil), want...)
		sort.Slice(expected, less(expected))
		sort.Slice(got, less(got))
		if !reflect.DeepEqual(expected, got) {
			return fmt.Errorf("rendered Helm values/contexts differ\nexpected: %+v\nactual: %+v", expected, got)
		}
		return nil
	}
}

func helmScanArgs(outputName string, extra ...string) cmdArgs {
	args := cmdArgs{
		"scan", "-p", helmOverrideFixture + "/charts", "--type", "Kubernetes",
		"-q", helmOverrideFixture + "/queries", "-b", "/path/assets/libraries",
		"--disable-secrets", "--no-progress", "--no-color", "--verbose",
		"-o", "/path/e2e/output", "--output-name", outputName, "--report-formats", "json",
	}
	return append(args, extra...)
}

func helmReport(name string, observations ...helmObservation) ResultsValidation {
	return ResultsValidation{
		ResultsFile: name, ResultsFormats: []string{"json"}, Validate: validateHelmObservations(observations...),
	}
}

// E2E-CLI-109 through 116 exercise the real CLI, renderer, query engine and JSON
// report. Both fixture charts deliberately have the same Chart.yaml name.
func init() { //nolint
	registerHelmConfigAndCLI()
	registerHelmPrecedence()
	registerHelmExperimental()
	registerHelmOverrideErrors()
}

func registerHelmConfigAndCLI() {
	api := helmExpected("api", "configured", map[string]string{
		"replicaCount": "14", "tag": "002", "enabled": "false", "items": "file-a,file-b", "message": "hello,world",
	})
	worker := helmExpected("worker", "configured", map[string]string{
		"replicaCount": "13", "tag": "001", "enabled": "false", "items": "file-a,file-b", "message": "hello,world",
	})
	Tests = append(Tests, TestCase{
		Name: "should apply Helm config overrides without experimental mode [E2E-CLI-109]",
		Args: args{
			Args: []cmdArgs{
				helmScanArgs("E2E_CLI_109_BASELINE"),
				helmScanArgs("E2E_CLI_109_YAML", "--config", helmOverrideFixture+"/config/settings.yaml"),
				helmScanArgs("E2E_CLI_109_JSON", "--config", helmOverrideFixture+"/config/settings.json"),
			},
			ExpectedResult: []ResultsValidation{
				helmReport("E2E_CLI_109_BASELINE", helmExpected("api", "", nil), helmExpected("worker", "", nil)),
				helmReport("E2E_CLI_109_YAML", api, worker),
				helmReport("E2E_CLI_109_JSON", api, worker),
			},
		},
		WantStatus: []int{30, 30, 30},
	})
	Tests = append(Tests, TestCase{
		Name: "should apply repeatable and chart-scoped Helm CLI flags [E2E-CLI-110]",
		Args: args{
			Args: []cmdArgs{helmScanArgs("E2E_CLI_110_RESULT",
				"--helm-values", helmOverrideFixture+"/values/common.yaml",
				"--helm-values", helmOverrideFixture+"/values/later.yaml",
				"--helm-set", "replicaCount=13", "--helm-set", "enabled=false",
				"--helm-set-string", "image.tag=001", "--helm-set-string", `message=hello\,world`,
				"--helm-chart-values", helmOverrideFixture+"/charts/api::"+helmOverrideFixture+"/values/api.yaml",
				"--helm-chart-set", helmOverrideFixture+"/charts/api::replicaCount=14",
				"--helm-chart-set-string", helmOverrideFixture+"/charts/api::image.tag=002",
			)},
			ExpectedResult: []ResultsValidation{helmReport("E2E_CLI_110_RESULT", api, worker)},
		},
		WantStatus: []int{30},
	})
}

func registerHelmPrecedence() {
	base := []string{
		"--config", helmOverrideFixture + "/config/settings.yaml",
		"--helm-set", "replicaCount=30", "--helm-set-string", "image.tag=cli-global",
		"--helm-chart-values", helmOverrideFixture + "/charts/api::" + helmOverrideFixture + "/values/api.yaml",
		"--helm-set", "items={cli-a,cli-b}",
	}
	worker := helmExpected("worker", "configured", map[string]string{
		"replicaCount": "30", "tag": "cli-global", "enabled": "false", "items": "cli-a,cli-b", "message": "hello,world",
	})
	Tests = append(Tests, TestCase{
		Name: "should enforce config CLI and chart-specific Helm precedence [E2E-CLI-111]",
		Args: args{
			Args: []cmdArgs{
				helmScanArgs("E2E_CLI_111_FILES", base...),
				helmScanArgs("E2E_CLI_111_SET", append(append([]string(nil), base...),
					"--helm-chart-set", helmOverrideFixture+"/charts/api::replicaCount=31",
					"--helm-chart-set-string", helmOverrideFixture+"/charts/api::image.tag=003")...),
			},
			ExpectedResult: []ResultsValidation{
				helmReport("E2E_CLI_111_FILES", helmExpected("api", "configured", map[string]string{
					"replicaCount": "12", "tag": "scoped-file", "enabled": "false", "items": "cli-a,cli-b", "message": "hello,world",
				}), worker),
				helmReport("E2E_CLI_111_SET", helmExpected("api", "configured", map[string]string{
					"replicaCount": "31", "tag": "003", "enabled": "false", "items": "cli-a,cli-b", "message": "hello,world",
				}), worker),
			},
		},
		WantStatus: []int{30, 30},
	})
}

func registerHelmExperimental() {
	base := []string{
		"--experimental-helm-scan", "--helm-values", helmOverrideFixture + "/charts/api/pinned.yaml",
		"--helm-set", "replicaCount=21", "--helm-set", "enabled=false", "--helm-set-string", "image.tag=001",
	}
	baseline := map[string]string{"replicaCount": "21", "tag": "001", "enabled": "false"}
	Tests = append(Tests, TestCase{
		Name: "should apply explicit overrides to every experimental combination [E2E-CLI-112]",
		Args: args{
			Args: []cmdArgs{helmScanArgs("E2E_CLI_112_RESULT", append(append([]string(nil), base...),
				"--helm-set", "needsRequired=false")...)},
			ExpectedResult: []ResultsValidation{helmReport("E2E_CLI_112_RESULT",
				helmExpected("api", "configured", baseline), helmExpected("worker", "configured", baseline),
				helmExpected("api", "configured+variant.yaml", map[string]string{
					"replicaCount": "21", "tag": "001", "enabled": "false", "variant": "auto",
				}))},
		},
		WantStatus: []int{30},
	})
	Tests = append(Tests, TestCase{
		Name: "should repair unspecified Helm values while preserving explicit overrides [E2E-CLI-113]",
		Args: args{
			Args: []cmdArgs{helmScanArgs("E2E_CLI_113_RESULT", base...)},
			ExpectedResult: []ResultsValidation{helmReport("E2E_CLI_113_RESULT",
				helmExpected("api", "configured", baseline), helmExpected("worker", "configured", baseline),
				helmExpected("api", "configured+variant.yaml", map[string]string{
					"replicaCount": "21", "tag": "001", "enabled": "false", "variant": "auto", "requiredValue": "kics-placeholder",
				}))},
		},
		WantStatus: []int{30},
	})
	Tests = append(Tests, TestCase{
		Name: "should reject fixer replacement of explicit empty values and retain successful renders [E2E-CLI-114]",
		Args: args{
			Args: []cmdArgs{helmScanArgs("E2E_CLI_114_RESULT", append(append([]string(nil), base...),
				"--helm-set", "requiredValue=")...)},
			ExpectedResult: []ResultsValidation{helmReport("E2E_CLI_114_RESULT",
				helmExpected("api", "configured", baseline), helmExpected("worker", "configured", baseline))},
		},
		WantStatus: []int{30},
		Validation: func(output string) bool { return strings.Contains(output, "without replacing an explicit override") },
	})
}

func registerHelmOverrideErrors() {
	for i, invalid := range []struct {
		name string
		args []string
		want string
	}{
		{"missing values file", []string{"--helm-values", helmOverrideFixture + "/missing.yaml"}, "must be a readable local file"},
		{"malformed expression", []string{"--helm-set", "missing-equals"}, "invalid Helm set expression"},
		{"invalid selector", []string{"--helm-chart-set", "::replicaCount=2"}, "must use chart-directory::value"},
		{"unknown config field", []string{"--config", helmOverrideFixture + "/config/invalid.yaml"}, "unknown field"},
	} {
		Tests = append(Tests, TestCase{
			Name:       "should reject Helm " + invalid.name + " before scanning [E2E-CLI-115]",
			Args:       args{Args: []cmdArgs{helmScanArgs(fmt.Sprintf("E2E_CLI_115_%d", i), invalid.args...)}},
			WantStatus: []int{126},
			Validation: func(output string) bool {
				return strings.Contains(output, invalid.want) && !strings.Contains(output, "Scanning with")
			},
		})
	}
	// A selector may be valid on disk but outside the selected scan paths.
	command := helmScanArgs("E2E_CLI_116_RESULT",
		"--helm-chart-set", helmOverrideFixture+"/charts/worker::replicaCount=10")
	command[2] = helmOverrideFixture + "/charts/api"
	Tests = append(Tests, TestCase{
		Name: "should warn about unmatched Helm selectors without affecting other charts [E2E-CLI-116]",
		Args: args{
			Args:           []cmdArgs{command},
			ExpectedResult: []ResultsValidation{helmReport("E2E_CLI_116_RESULT", helmExpected("api", "", nil))},
		},
		WantStatus: []int{30},
		Validation: func(output string) bool { return strings.Contains(output, "Helm override selector did not match") },
	})
}
