package secrets

import (
	"context"
	"path/filepath"
	"sync"
	"testing"

	"github.com/Checkmarx/kics/v2/assets"
	"github.com/Checkmarx/kics/v2/internal/tracker"
	"github.com/Checkmarx/kics/v2/pkg/engine/source"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/progress"
	"github.com/Checkmarx/kics/v2/pkg/utils"
	"github.com/stretchr/testify/require"
)

var testCompileRegexesInput = []struct {
	name                   string
	inspectorParams        *source.QueryInspectorParameters
	allRegexQueries        []RegexQuery
	wantIDs                []string
	isCustomSecretsRegexes bool
}{
	{
		name: "empty_query",
		inspectorParams: &source.QueryInspectorParameters{
			IncludeQueries: source.IncludeQueries{ByIDs: []string{}},
			ExcludeQueries: source.ExcludeQueries{ByIDs: []string{}, ByCategories: []string{}},
			InputDataPath:  "",
		},
		allRegexQueries:        []RegexQuery{},
		wantIDs:                []string{},
		isCustomSecretsRegexes: false,
	},
	{
		name: "one_query",
		inspectorParams: &source.QueryInspectorParameters{
			IncludeQueries: source.IncludeQueries{ByIDs: []string{}},
			ExcludeQueries: source.ExcludeQueries{ByIDs: []string{}, ByCategories: []string{}},
			InputDataPath:  "",
		},
		allRegexQueries: []RegexQuery{
			{
				ID:       "487f4be7-3fd9-4506-a07a-eae252180c08",
				Name:     "Generic Password",
				RegexStr: `['|"]?[p|P][a|A][s|S][s|S][w|W][o|O][r|R][d|D]['|\"]?\s*[:|=]\s*['|"]?([A-Za-z0-9/~^_!@&%()=?*+-]{4,})['|"]?`,
			},
		},
		wantIDs:                []string{"487f4be7-3fd9-4506-a07a-eae252180c08"},
		isCustomSecretsRegexes: false,
	},
	{
		name: "three_queries",
		inspectorParams: &source.QueryInspectorParameters{
			IncludeQueries: source.IncludeQueries{ByIDs: []string{}},
			ExcludeQueries: source.ExcludeQueries{ByIDs: []string{}, ByCategories: []string{}},
			InputDataPath:  "",
		},
		allRegexQueries: []RegexQuery{
			{
				ID:       "487f4be7-3fd9-4506-a07a-eae252180c08",
				Name:     "Generic Password",
				RegexStr: `['|"]?[p|P][a|A][s|S][s|S][w|W][o|O][r|R][d|D]['|\"]?\s*[:|=]\s*['|"]?([A-Za-z0-9/~^_!@&%()=?*+-]{4,})['|"]?`,
			},
			{
				ID:       "4b2b5fd3-364d-4093-bac2-17391b2a5297",
				Name:     "K8s Environment Variable Password",
				RegexStr: `apiVersion((.*)\s*)*env:((.*)\s*)*name:\s*\w+[P|p][A|a][S|s][S|s]([W|w][O|o][R|r][D|d])?\w*\s*(value):\s*(["|'].*["|'])`,
				Multiline: MultilineResult{
					DetectLineGroup: 7,
				},
			},
			{
				ID:       "c4d3b58a-e6d4-450f-9340-04f1e702eaae",
				Name:     "Password in URL",
				RegexStr: `[a-zA-Z]{3,10}://[^/\s:@]*?:[^/\s:@]*?@[^/\s:@]*`,
			},
		},
		wantIDs:                []string{"487f4be7-3fd9-4506-a07a-eae252180c08", "4b2b5fd3-364d-4093-bac2-17391b2a5297", "c4d3b58a-e6d4-450f-9340-04f1e702eaae"},
		isCustomSecretsRegexes: false,
	},
	{
		name: "include_one",
		inspectorParams: &source.QueryInspectorParameters{
			IncludeQueries: source.IncludeQueries{ByIDs: []string{"487f4be7-3fd9-4506-a07a-eae252180c08"}},
			ExcludeQueries: source.ExcludeQueries{ByIDs: []string{}, ByCategories: []string{}},
			InputDataPath:  "",
		},
		allRegexQueries: []RegexQuery{
			{
				ID:       "487f4be7-3fd9-4506-a07a-eae252180c08",
				Name:     "Generic Password",
				RegexStr: `['|"]?[p|P][a|A][s|S][s|S][w|W][o|O][r|R][d|D]['|\"]?\s*[:|=]\s*['|"]?([A-Za-z0-9/~^_!@&%()=?*+-]{4,})['|"]?`,
			},
			{
				ID:       "4b2b5fd3-364d-4093-bac2-17391b2a5297",
				Name:     "K8s Environment Variable Password",
				RegexStr: `apiVersion((.*)\s*)*env:((.*)\s*)*name:\s*\w+[P|p][A|a][S|s][S|s]([W|w][O|o][R|r][D|d])?\w*\s*(value):\s*(["|'].*["|'])`,
				Multiline: MultilineResult{
					DetectLineGroup: 7,
				},
			},
			{
				ID:       "c4d3b58a-e6d4-450f-9340-04f1e702eaae",
				Name:     "Password in URL",
				RegexStr: `[a-zA-Z]{3,10}://[^/\s:@]*?:[^/\s:@]*?@[^/\s:@]*`,
			},
		},
		wantIDs:                []string{"487f4be7-3fd9-4506-a07a-eae252180c08"},
		isCustomSecretsRegexes: false,
	},
	{
		name: "exclude_one",
		inspectorParams: &source.QueryInspectorParameters{
			IncludeQueries: source.IncludeQueries{ByIDs: []string{}},
			ExcludeQueries: source.ExcludeQueries{ByIDs: []string{"c4d3b58a-e6d4-450f-9340-04f1e702eaae"}, ByCategories: []string{}},
			InputDataPath:  "",
		},
		allRegexQueries: []RegexQuery{
			{
				ID:       "487f4be7-3fd9-4506-a07a-eae252180c08",
				Name:     "Generic Password",
				RegexStr: `['|"]?[p|P][a|A][s|S][s|S][w|W][o|O][r|R][d|D]['|\"]?\s*[:|=]\s*['|"]?([A-Za-z0-9/~^_!@&%()=?*+-]{4,})['|"]?`,
			},
			{
				ID:       "4b2b5fd3-364d-4093-bac2-17391b2a5297",
				Name:     "K8s Environment Variable Password",
				RegexStr: `apiVersion((.*)\s*)*env:((.*)\s*)*name:\s*\w+[P|p][A|a][S|s][S|s]([W|w][O|o][R|r][D|d])?\w*\s*(value):\s*(["|'].*["|'])`,
				Multiline: MultilineResult{
					DetectLineGroup: 7,
				},
			},
			{
				ID:       "c4d3b58a-e6d4-450f-9340-04f1e702eaae",
				Name:     "Password in URL",
				RegexStr: `[a-zA-Z]{3,10}://[^/\s:@]*?:[^/\s:@]*?@[^/\s:@]*`,
			},
		},
		wantIDs:                []string{"487f4be7-3fd9-4506-a07a-eae252180c08", "4b2b5fd3-364d-4093-bac2-17391b2a5297"},
		isCustomSecretsRegexes: false,
	},
}

var OriginalData1 = `
resource "google_container_cluster" "primary3" {
name               = "marcellus-wallace"
location           = "us-central1-a"
initial_node_count = 3

master_auth {
	username = "1234567890qwertyuiopasdfghjklçzxcvbnm"
	password = ""

	client_certificate_config {
		issue_client_certificate = true
	}
}
}`

var OriginalData2 = `
apiVersion: v1
kind: Secret
metadata:
name: secret-basic-auth
type: kubernetes.io/basic-auth
stringData:
password: "root"`

var OriginalData3 = `
resource "aws_transfer_ssh_key" "example" {
server_id = aws_transfer_server.example.id
user_name = aws_transfer_user.example.user_name
body      = <<EOT
-----BEGIN OPENSSH PRIVATE KEY-----
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAaAAAABNlY2RzYS
1zaGEyLW5pc3RwMjU2AAAACG5pc3RwMjU2AAAAQQTTD+Q+10oNWDzXxx9x2bOobcXAA4rd
jGaQoqJjcXRWR2TS1ioKvML1fI5KLP4kuF3TlyPTLgJxlfrJtYYEfGHwAAAA0FjbkWRY25
FkAAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBNMP5D7XSg1YPNfH
H3HZs6htxcADit2MZpCiomNxdFZHZNLWKgq8wvV8jkos/iS4XdOXI9MuAnGV+sm1hgR8Yf
AAAAAgHI23o+KRbewZJJxFExEGwiOPwM7gonjATdzLP+YT/6sAAAA0cm9nZXJpb3AtbWFj
Ym9va0BSb2dlcmlvUC1NYWNCb29rcy1NYWNCb29rLVByby5sb2NhbAECAwQ=
-----END OPENSSH PRIVATE KEY-----
EOT
}`

var OriginalData0 = `
resource "aws_lambda_function" "analysis_lambda2" {
  # lambda have plain text secrets in environment variables
  filename      = "resources/lambda_function_payload.zip"
  function_name = "${local.resource_prefix.value}-analysis"
  role          = "${aws_iam_role.iam_for_lambda.arn}"
  handler       = "exports.test"

  source_code_hash = "${filebase64sha256("resources/lambda_function_payload.zip")}"

  runtime = "nodejs12.x"

  environment {
	variables = {
	  secret_key = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
	}
  }
}
`

var OriginalData4 = `# kics-scan ignore
resource "google_container_cluster" "primary3" {
name               = "marcellus-wallace"
location           = "us-central1-a"
initial_node_count = 3

master_auth {
	username = "1234567890qwertyuiopasdfghjklçzxcvbnm"
	password = "password123456"

	client_certificate_config {
		issue_client_certificate = true
	}
}
}`

var OriginalData5 = `
resource "google_container_cluster" "primary3" {
name               = "marcellus-wallace"
location           = "us-central1-a"
initial_node_count = 3

master_auth {
	username = "1234567890qwertyuiopasdfghjklçzxcvbnm"
  # password = "password123456"

	client_certificate_config {
		issue_client_certificate = true
	}
}
}`

var OriginalData6 = `
- name: Start a workflow in the Itential Automation Platform
	community.network.iap_start_workflow:
		iap_port: 3000
	    iap_fqdn: localhost
#       kics-scan ignore-line
#       token_key: "DFSFSFHFGFGF[DSFSFAADAFASD%3D"
		workflow_name: "RouterUpgradeWorkflow"
		description: "OS-Router-Upgrade"
		variables: {"deviceName":"ASR9K"}
`

var OriginalData7 = `# kics-scan disable=baee238e-1921-4801-9c3f-79ae1d7b2cbc
- name: Start a workflow in the Itential Automation Platform
	community.network.iap_start_workflow:
		iap_port: 3000
		iap_fqdn: localhost
		token_key: "DFSFSFHFGFGF[DSFSFAADAFASD%3D"
		workflow_name: "RouterUpgradeWorkflow"
		description: "OS-Router-Upgrade"
		variables: {"deviceName":"ASR9K"}
	register: result
`

var testInspectInput = []struct {
	name     string
	files    model.FileMetadatas
	wantVuln []model.Vulnerability
	wantErr  bool
}{
	{
		name: "valid_no_results",
		files: model.FileMetadatas{
			{
				ID:                "853012ab-cc05-4c1c-b517-9c3552085ee8",
				Document:          model.Document{},
				OriginalData:      OriginalData1,
				LinesOriginalData: utils.SplitLines(OriginalData1),
				Kind:              "TF",
				FilePath:          "assets/queries/common/passwords_and_secrets/test/negative7.tf",
			},
		},
		wantVuln: []model.Vulnerability{},
		wantErr:  false,
	},
	{
		name: "valid_one_result",
		files: model.FileMetadatas{
			{
				ID:                "b032c51d-2e7c-4ffc-8a81-41405c166bc8",
				Document:          model.Document{},
				OriginalData:      OriginalData2,
				LinesOriginalData: utils.SplitLines(OriginalData2),
				Kind:              "K8S",
				FilePath:          "assets/queries/common/passwords_and_secrets/test/positive1.yaml",
			},
		},
		wantVuln: []model.Vulnerability{
			{
				QueryID:     "487f4be7-3fd9-4506-a07a-eae252180c08",
				QueryName:   "Passwords And Secrets - Generic Password",
				Severity:    model.SeverityHigh,
				Category:    "Secret Management",
				Description: "Query to find passwords and secrets in infrastructure code.",
			},
		},
		wantErr: false,
	},
	{
		name: "valid_one_multiline_result",
		files: model.FileMetadatas{
			{
				ID:                "d274e272-a4af-497e-a900-a277500e4182",
				Document:          model.Document{},
				OriginalData:      OriginalData3,
				LinesOriginalData: utils.SplitLines(OriginalData3),
				Kind:              "TF",
				FilePath:          "assets/queries/common/passwords_and_secrets/test/positive13.tf",
			},
		},
		wantVuln: []model.Vulnerability{
			{
				QueryID:     "51b5b840-cd0c-4556-98a7-fe5f4def80cf",
				QueryName:   "Passwords And Secrets - Asymmetric private key",
				Severity:    model.SeverityHigh,
				Category:    "Secret Management",
				Description: "Query to find passwords and secrets in infrastructure code.",
			},
		},
		wantErr: false,
	},
	{
		name: "valid_generic_secret",
		files: model.FileMetadatas{
			{
				ID:                "",
				Document:          model.Document{},
				OriginalData:      OriginalData0,
				LinesOriginalData: utils.SplitLines(OriginalData0),
				Kind:              "TF",
				FilePath:          "assets/queries/common/passwords_and_secrets/test/positive37.tf",
			},
		},
		wantVuln: []model.Vulnerability{
			{
				QueryID:     "3e2d3b2f-c22a-4df1-9cc6-a7a0aebb0c99",
				QueryName:   "Passwords And Secrets - Generic Secret",
				Severity:    model.SeverityHigh,
				Category:    "Secret Management",
				Description: "Query to find passwords and secrets in infrastructure code.",
			},
		},
		wantErr: false,
	},
	{
		name: "valid_no_results",
		files: model.FileMetadatas{
			{
				ID: "853012ab-cc05-4c1c-b517-9c3552085ee8",
				Commands: model.CommentsCommands{
					"ignore": "",
				},
				Document:          model.Document{},
				OriginalData:      OriginalData4,
				LinesOriginalData: utils.SplitLines(OriginalData4),
				Kind:              "TF",
				FilePath:          "assets/queries/common/passwords_and_secrets/test/negative7.tf",
			},
		},
		wantVuln: []model.Vulnerability{},
		wantErr:  false,
	},
	{
		name: "valid_no_results",
		files: model.FileMetadatas{
			{
				ID:                "853012ab-cc05-4c1c-b517-9c3552085ee8",
				LinesIgnore:       []int{9},
				Document:          model.Document{},
				OriginalData:      OriginalData5,
				LinesOriginalData: utils.SplitLines(OriginalData5),
				Kind:              "TF",
				FilePath:          "assets/queries/common/passwords_and_secrets/test/negative7.tf",
			},
		},
		wantVuln: []model.Vulnerability{},
		wantErr:  false,
	},
	{
		name: "valid_no_results",
		files: model.FileMetadatas{
			{
				ID:                "853012ab-cc05-4c1c-b517-9c3552085ee8",
				LinesIgnore:       []int{6, 7},
				Document:          model.Document{},
				OriginalData:      OriginalData6,
				LinesOriginalData: utils.SplitLines(OriginalData6),
				Kind:              "ANS",
				FilePath:          "assets/queries/common/passwords_and_secrets/test/positive28.yaml",
			},
		},
		wantVuln: []model.Vulnerability{},
		wantErr:  false,
	},
	{
		name: "valid_no_results",
		files: model.FileMetadatas{
			{
				ID: "853012ab-cc05-4c1c-b517-9c3552085ee8",
				Commands: model.CommentsCommands{
					"disable": "baee238e-1921-4801-9c3f-79ae1d7b2cbc",
				},
				Document:          model.Document{},
				OriginalData:      OriginalData7,
				LinesOriginalData: utils.SplitLines(OriginalData7),
				Kind:              "ANS",
				FilePath:          "assets/queries/common/passwords_and_secrets/test/positive28.yaml",
			},
		},
		wantVuln: []model.Vulnerability{},
		wantErr:  false,
	},
}

var testNewInspectorInputs = []struct {
	name                             string
	inspectorParams                  *source.QueryInspectorParameters
	assetsSecretsQueryMetadataJSON   string
	assetsSecretsQueryRegexRulesJSON string
	queriesPath                      string
	disableSecrets                   bool
	wantRegLen                       int
	wantErr                          bool
}{
	{
		name: "invalid_regex_rules",
		inspectorParams: &source.QueryInspectorParameters{
			IncludeQueries: source.IncludeQueries{ByIDs: []string{}},
			ExcludeQueries: source.ExcludeQueries{ByIDs: []string{}},
			InputDataPath:  "",
		},
		assetsSecretsQueryMetadataJSON:   `{}`,
		assetsSecretsQueryRegexRulesJSON: `[]`,
		disableSecrets:                   false,
		wantRegLen:                       0,
		wantErr:                          true,
	},
	{
		name: "invalid_metadata",
		inspectorParams: &source.QueryInspectorParameters{
			IncludeQueries: source.IncludeQueries{ByIDs: []string{}},
			ExcludeQueries: source.ExcludeQueries{ByIDs: []string{}},
			InputDataPath:  "",
		},
		assetsSecretsQueryMetadataJSON:   `{`,
		assetsSecretsQueryRegexRulesJSON: `{}`,
		disableSecrets:                   false,
		wantRegLen:                       0,
		wantErr:                          true,
	},
	{
		name: "valid_one_regex_rule_full_path",
		inspectorParams: &source.QueryInspectorParameters{
			IncludeQueries: source.IncludeQueries{ByIDs: []string{}},
			ExcludeQueries: source.ExcludeQueries{ByIDs: []string{}},
			InputDataPath:  "",
		},
		assetsSecretsQueryRegexRulesJSON: `
		{
			"rules":[
				{
					"id": "487f4be7-3fd9-4506-a07a-eae252180c08",
					"name": "Generic Password",
					"regex": "['|\"]?[p|P][a|A][s|S][s|S][w|W][o|O][r|R][d|D]['|\"]?\\s*[:|=]\\s*['|\"]?([A-Za-z0-9/~^_!@&%()=?*+-]{4,})['|\"]?"
				}
			]
		}`,
		assetsSecretsQueryMetadataJSON: `{
			"queryName": "Passwords And Secrets",
			"severity": "HIGH",
			"category": "Secret Management",
			"descriptionText": "Query to find passwords and secrets in infrastructure code.",
			"descriptionUrl": "https://docs.kics.io/latest/secrets/",
			"platform": "Common",
			"descriptionID": "d69d8a89",
			"cloudProvider": "common",
			"cwe": "798"
		  }`,
		disableSecrets: false,
		wantRegLen:     1,
		wantErr:        false,
	},
	{
		name: "valid_one_regex_rule",
		inspectorParams: &source.QueryInspectorParameters{
			IncludeQueries: source.IncludeQueries{ByIDs: []string{}},
			ExcludeQueries: source.ExcludeQueries{ByIDs: []string{}},
			InputDataPath:  "",
		},
		assetsSecretsQueryRegexRulesJSON: `{
			"rules":[
				{
					"id": "487f4be7-3fd9-4506-a07a-eae252180c08",
					"name": "Generic Password",
					"regex": "['|\"]?[p|P][a|A][s|S][s|S][w|W][o|O][r|R][d|D]['|\"]?\\s*[:|=]\\s*['|\"]?([A-Za-z0-9/~^_!@&%()=?*+-]{4,})['|\"]?"
				}
			]
		}`,
		assetsSecretsQueryMetadataJSON: `{
			"queryName": "Passwords And Secrets",
			"severity": "HIGH",
			"category": "Secret Management",
			"descriptionText": "Query to find passwords and secrets in infrastructure code.",
			"descriptionUrl": "https://docs.kics.io/latest/secrets/",
			"platform": "Common",
			"descriptionID": "d69d8a89",
			"cloudProvider": "common",
			"cwe": "798"
		  }`,
		disableSecrets: true,
		wantRegLen:     0,
		wantErr:        false,
	},
	{
		name: "valid_one_regex_rules_test_glob",
		inspectorParams: &source.QueryInspectorParameters{
			IncludeQueries: source.IncludeQueries{ByIDs: []string{}},
			ExcludeQueries: source.ExcludeQueries{ByIDs: []string{}},
			InputDataPath:  "",
		},
		assetsSecretsQueryRegexRulesJSON: `{
			"rules":[
				{
					"id": "487f4be7-3fd9-4506-a07a-eae252180c08",
					"name": "Generic Password",
					"regex": "['|\"]?[p|P][a|A][s|S][s|S][w|W][o|O][r|R][d|D]['|\"]?\\s*[:|=]\\s*['|\"]?([A-Za-z0-9/~^_!@&%()=?*+-]{4,})['|\"]?"
				}
			]
		}`,
		assetsSecretsQueryMetadataJSON: `{
			"queryName": "Passwords And Secrets",
			"severity": "HIGH",
			"category": "Secret Management",
			"descriptionText": "Query to find passwords and secrets in infrastructure code.",
			"descriptionUrl": "https://docs.kics.io/latest/secrets/",
			"platform": "Common",
			"descriptionID": "d69d8a89",
			"cloudProvider": "common",
			"cwe": "798"
		  }`,
		disableSecrets: false,
		wantRegLen:     1,
		wantErr:        false,
	},
}

func TestEntropyInterval(t *testing.T) {
	inputs := []struct {
		name    string
		entropy Entropy
		token   string
		want    bool
	}{
		{
			name: "empty_within_bounds",
			entropy: Entropy{
				Group: 0, // not relevant for this test
				Min:   0,
				Max:   0,
			},
			token: "",
			want:  true,
		},
		{
			name: "empty_outside_bounds",
			entropy: Entropy{
				Group: 0, // not relevant for this test
				Min:   1,
				Max:   2,
			},
			token: "",
			want:  false,
		},
		{
			name: "token_larger_than_max_entropy",
			entropy: Entropy{
				Group: 0,
				Min:   1,
				Max:   2, // 3.655152
			},
			token: "d68d2897add9bc2203a5ed0632a5cdd8ff8cefb0",
			want:  false,
		},
		{
			name: "token_within_bounds",
			entropy: Entropy{
				Group: 0,
				Min:   1,
				Max:   3.7,
			},
			token: "d68d2897add9bc2203a5ed0632a5cdd8ff8cefb0",
			want:  true,
		},
		{
			name: "password_less_than_minimum",
			entropy: Entropy{
				Group: 0,
				Min:   3, // 2.321928
				Max:   4,
			},
			token: "passx",
			want:  false,
		},
		{
			name: "password_within_bound",
			entropy: Entropy{
				Group: 0,
				Min:   2, // 2.321928
				Max:   3,
			},
			token: "passx",
			want:  true,
		},
	}
	for _, in := range inputs {
		highEntropy, entropyValue := CheckEntropyInterval(in.entropy, in.token)
		require.Equal(t, in.want, highEntropy, "test[%s] CheckEntropyInterval(%+v, %s) = %v, want %v :: entropyValue %f",
			in.name,
			in.entropy,
			in.token,
			highEntropy,
			in.want,
			entropyValue,
		)
	}
}

func TestCompileRegexQueries(t *testing.T) {
	for _, in := range testCompileRegexesInput {
		got, err := compileRegexQueries(in.inspectorParams, in.allRegexQueries, in.isCustomSecretsRegexes, "")
		require.NoError(t, err, "test[%s] compileRegexQueries(%+v, %+v) error", in.name, in.inspectorParams, in.allRegexQueries)
		require.Len(t,
			got,
			len(in.wantIDs),
			"test[%s] compileRegexQueries(%+v, %+v) = %+v, want %+v",
			in.name,
			in.inspectorParams,
			in.allRegexQueries,
			got,
			in.wantIDs,
		)
		for _, regexQuery := range got {
			require.NotNil(t,
				regexQuery.Regex,
				"test[%s] compileRegexQueries(%+v, %+v) = %+v, want %+v",
				in.name,
				in.inspectorParams,
				in.allRegexQueries,
				got,
				in.wantIDs,
			)
			require.Contains(t,
				in.wantIDs,
				regexQuery.ID,
				"test[%s] compileRegexQueries() - %v not in %+v",
				in.name,
				regexQuery.ID,
				in.wantIDs,
			)
		}
	}
}

func TestNewInspector(t *testing.T) {
	tmpQueryMetadataJSON := assets.SecretsQueryMetadataJSON

	for _, in := range testNewInspectorInputs {
		ctx := context.Background()
		assets.SecretsQueryMetadataJSON = in.assetsSecretsQueryMetadataJSON
		secretsInspector, err := NewInspector(
			ctx,
			map[string]bool{},
			&tracker.CITracker{},
			in.inspectorParams,
			in.disableSecrets,
			60,
			in.assetsSecretsQueryRegexRulesJSON,
			false,
		)
		if in.wantErr {
			require.Error(t,
				err,
				"test[%s] NewInspector(%+v, %+v, %+v) = %+v, want %+v",
				in.name,
				in.inspectorParams,
				in.assetsSecretsQueryMetadataJSON,
				in.assetsSecretsQueryRegexRulesJSON,
				err,
				in.wantErr,
			)
			continue
		}

		require.NoError(t, err, "test[%s] NewInspector() should not return error", in.name)
		require.NotNil(t, secretsInspector, "test[%s] NewInspector() should not return nil", in.name)
		require.NotNil(t, secretsInspector.regexQueries, "test[%s] NewInspector() should not return nil", in.name)
		require.Len(t,
			secretsInspector.regexQueries,
			in.wantRegLen,
			"test[%s] NewInspector() should return %d regex queries",
			in.name,
			in.wantRegLen,
		)
	}
	t.Cleanup(func() {
		assets.SecretsQueryMetadataJSON = tmpQueryMetadataJSON
	})
}

func TestInspect(t *testing.T) {
	wg := &sync.WaitGroup{}
	for _, in := range testInspectInput {
		currentQuery := make(chan int64)
		wg.Add(1)

		ctx := context.Background()
		secretsInspector, err := NewInspector(
			ctx,
			map[string]bool{},
			&tracker.CITracker{},
			&source.QueryInspectorParameters{
				IncludeQueries: source.IncludeQueries{ByIDs: []string{}},
				ExcludeQueries: source.ExcludeQueries{ByIDs: []string{}},
				InputDataPath:  "",
			},
			false,
			60,
			assets.SecretsQueryRegexRulesJSON,
			false,
		)
		require.NoError(t, err, "NewInspector() should not return error")

		proBarBuilder := progress.InitializePbBuilder(true, true, true)
		progressBar := proBarBuilder.BuildCounter("Executing queries: ", secretsInspector.GetQueriesLength(), wg, currentQuery)

		go progressBar.Start()

		basePaths := []string{filepath.FromSlash("assets/queries/")}
		gotVulns, err := secretsInspector.Inspect(ctx, basePaths, in.files, currentQuery)
		if in.wantErr {
			require.Error(t, err, "test[%s] Inspect(%+v, %+v) = %+v, want %+v", in.name, basePaths, in.files, err, in.wantErr)
			continue
		}

		require.NoError(t, err, "test[%s] Inspect() should not return error", in.name)
		require.Len(t, gotVulns, len(in.wantVuln), "test[%s] Inspect() should return %d vulnerabilities", in.name, len(in.wantVuln))
		for i, gotVuln := range gotVulns {
			require.Equal(t,
				in.wantVuln[i].QueryID,
				gotVuln.QueryID,
				"test[%s] Inspect() should return vulnerabilities with QueryID %s", in.name, in.wantVuln[i].QueryID)
			require.Equal(t,
				in.wantVuln[i].QueryName,
				gotVuln.QueryName,
				"test[%s] Inspect() should return vulnerabilities with QueryName %s", in.name, in.wantVuln[i].QueryName)
		}

		go func() {
			defer func() {
				close(currentQuery)
			}()
		}()
	}
}
