package model

import (
	"fmt"
	"path/filepath"
	"reflect"
	"runtime"
	"testing"
	"time"

	"github.com/Checkmarx/kics/v2/internal/constants"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/test"
	"github.com/stretchr/testify/assert"
)

var metadata Metadata = Metadata{
	Timestamp: time.Now().Format(time.RFC3339),
	Tools: &[]Tool{
		{
			Vendor:  "Checkmarx",
			Name:    "KICS",
			Version: constants.Version,
		},
	},
}

var initCycloneDxReport CycloneDxReport = CycloneDxReport{
	XMLNS:        "http://cyclonedx.org/schema/bom/1.5",
	XMLNSV:       "http://cyclonedx.org/schema/ext/vulnerability/1.0",
	SerialNumber: "urn:uuid:", // set to "urn:uuid:" because it will be different for every report
	Version:      1,
	Metadata:     &metadata,
}

// TestInitCycloneDxReport tests the InitCycloneDxReport function
func TestInitCycloneDxReport(t *testing.T) {
	tests := []struct {
		name string
		want *CycloneDxReport
	}{
		{
			name: "Init CycloneDX report",
			want: &initCycloneDxReport,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := InitCycloneDxReport()
			got.SerialNumber = "urn:uuid:" // set to "urn:uuid:" because it will be different for every report
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("InitCycloneDxReport() = %v, want %v", got, tt.want)
			}
		})
	}
}

// TestBuildCycloneDxReport tests the BuildCycloneDxReport function
func TestBuildCycloneDxReport(t *testing.T) {
	var cycloneDx CycloneDxReport = initCycloneDxReport
	var cycloneDxCritical CycloneDxReport = initCycloneDxReport
	var cycloneDxCWE CycloneDxReport = initCycloneDxReport
	var vulnsC1, vulnsC2, vulnsC3, vulnsC4 []Vulnerability
	var positiveSha, negativeSha, criticalSha string

	var sha256TestMap = map[string]map[string]string{
		"positive": {
			"Unix":            "487d5879d7ec205b4dcd037d5ce0075ed4fedb9dd5b8e45390ffdfa3442f15f7",
			"Windows":         "bd4ac2f61e7c623477b5d200b3662fd7caac5e89e042960fd1adb008e0962635",
			"CriticalWindows": "1c624a2f982858ee0b747f26c0e0019bc7fbb130c7719e90a5d5c1f552608a4f",
			"CriticalUnix":    "04174a2b45ae406d5432590304b1773c9a46a95a2327b3cc164cb464dc57cef5",
		},
		"negative": {
			"Unix":    "cd10cef2b154363f32ca4018426982509efbc9e1a8ea6bca587e68ffaef09c37",
			"Windows": "68b4caecf5d5130426a8b8f0222cdd7f31232b5c99a5bf0daf19099e26e2ec29",
		},
	}

	if runtime.GOOS == "windows" {
		positiveSha = sha256TestMap["positive"]["Windows"]
		negativeSha = sha256TestMap["negative"]["Windows"]
		criticalSha = sha256TestMap["positive"]["CriticalWindows"]
	} else {
		positiveSha = sha256TestMap["positive"]["Unix"]
		negativeSha = sha256TestMap["negative"]["Unix"]
		criticalSha = sha256TestMap["positive"]["CriticalUnix"]
	}

	v1 := Vulnerability{
		Ref: fmt.Sprintf("pkg:generic/../../../assets/queries/terraform/aws/guardduty_detector_disabled/test/positive.tf@0.0.0-%se38a8e0a-b88b-4902-b3fe-b0fcb17d5c10", positiveSha[0:12]),
		ID:  "e38a8e0a-b88b-4902-b3fe-b0fcb17d5c10",
		CWE: "",
		Source: Source{
			Name: "KICS",
			URL:  "https://kics.io/",
		},
		Ratings: []Rating{
			{
				Severity: "None",
				Method:   "Other",
			},
		},
		Description: "[Terraform].[Resource Not Using Tags]: AWS services resource tags are an essential part of managing components",
		Recommendations: []Recommendation{
			{
				Recommendation: "Problem found in line 1. Expected value: aws_guardduty_detector[{{positive1}}].tags is defined and not null. Actual value: aws_guardduty_detector[{{positive1}}].tags is undefined or null.",
			},
		},
	}

	v2 := Vulnerability{
		Ref: fmt.Sprintf("pkg:generic/../../../assets/queries/terraform/aws/guardduty_detector_disabled/test/positive.tf@0.0.0-%s704dadd3-54fc-48ac-b6a0-02f170011473", positiveSha[0:12]),
		ID:  "704dadd3-54fc-48ac-b6a0-02f170011473",
		CWE: "",
		Source: Source{
			Name: "KICS",
			URL:  "https://kics.io/",
		},
		Ratings: []Rating{
			{
				Severity: "Medium",
				Method:   "Other",
			},
		},
		Description: "[Terraform].[GuardDuty Detector Disabled]: Make sure that Amazon GuardDuty is Enabled",
		Recommendations: []Recommendation{
			{
				Recommendation: "Problem found in line 2. Expected value: GuardDuty Detector should be Enabled. Actual value: GuardDuty Detector is not Enabled.",
			},
		},
	}

	v3 := Vulnerability{
		Ref: fmt.Sprintf("pkg:generic/../../../assets/queries/terraform/aws/guardduty_detector_disabled/test/negative.tf@0.0.0-%se38a8e0a-b88b-4902-b3fe-b0fcb17d5c10", negativeSha[0:12]),
		ID:  "e38a8e0a-b88b-4902-b3fe-b0fcb17d5c10",
		CWE: "",
		Source: Source{
			Name: "KICS",
			URL:  "https://kics.io/",
		},
		Ratings: []Rating{
			{
				Severity: "None",
				Method:   "Other",
			},
		},
		Description: "[Terraform].[Resource Not Using Tags]: AWS services resource tags are an essential part of managing components",
		Recommendations: []Recommendation{
			{
				Recommendation: "Problem found in line 1. Expected value: aws_guardduty_detector[{{negative1}}].tags is defined and not null. Actual value: aws_guardduty_detector[{{negative1}}].tags is undefined or null.",
			},
		},
	}

	v4 := Vulnerability{
		Ref: fmt.Sprintf("pkg:generic/../../../assets/queries/terraform/aws/guardduty_detector_disabled/test/negative.tf@0.0.0-%s704dadd3-54fc-48ac-b6a0-02f170011473", negativeSha[0:12]),
		ID:  "704dadd3-54fc-48ac-b6a0-02f170011473",
		CWE: "22",
		Source: Source{
			Name: "KICS",
			URL:  "https://kics.io/",
		},
		Ratings: []Rating{
			{
				Severity: "Medium",
				Method:   "Other",
			},
		},
		Description: "[Terraform].[GuardDuty Detector Disabled]: Make sure that Amazon GuardDuty is Enabled",
		Recommendations: []Recommendation{
			{
				Recommendation: "Problem found in line 2. Expected value: GuardDuty Detector should be Enabled. Actual value: GuardDuty Detector is not Enabled.",
			},
		},
	}

	vulnsC3 = append(vulnsC3, v4)

	v5 := Vulnerability{
		Ref: fmt.Sprintf("pkg:generic/../../../test/fixtures/test_critical_custom_queries/amazon_mq_broker_encryption_disabled/test/positive1.yaml@0.0.0-%v316278b3-87ac-444c-8f8f-a733a28da609", criticalSha[0:12]),
		ID:  "316278b3-87ac-444c-8f8f-a733a28da609",
		Source: Source{
			Name: "KICS",
			URL:  "https://kics.io/",
		},
		Ratings: []Rating{
			{
				Severity: "Critical",
				Method:   "Other",
			},
		},
		Description: "[].[AmazonMQ Broker Encryption Disabled]: testCISDescription",
		Recommendations: []Recommendation{
			{
				Recommendation: "Problem found in line 6. Expected value: 'default_action.redirect.protocol' is equal 'HTTPS'. Actual value: 'default_action.redirect.protocol' is missing.",
			},
		},
	}

	vulnsC1 = append(vulnsC1, v1)
	vulnsC1 = append(vulnsC1, v2)

	c1 := Component{
		Type:    "file",
		BomRef:  fmt.Sprintf("pkg:generic/../../../assets/queries/terraform/aws/guardduty_detector_disabled/test/positive.tf@0.0.0-%s", positiveSha[0:12]),
		Name:    "../../../assets/queries/terraform/aws/guardduty_detector_disabled/test/positive.tf",
		Version: fmt.Sprintf("0.0.0-%s", positiveSha[0:12]),
		Purl:    fmt.Sprintf("pkg:generic/../../../assets/queries/terraform/aws/guardduty_detector_disabled/test/positive.tf@0.0.0-%s", positiveSha[0:12]),
		Hashes: []Hash{
			{
				Alg:     "SHA-256",
				Content: positiveSha,
			},
		},
		Vulnerabilities: vulnsC1,
	}

	vulnsC2 = append(vulnsC2, v3)

	c2 := Component{
		Type:    "file",
		BomRef:  fmt.Sprintf("pkg:generic/../../../assets/queries/terraform/aws/guardduty_detector_disabled/test/negative.tf@0.0.0-%s", negativeSha[0:12]),
		Name:    "../../../assets/queries/terraform/aws/guardduty_detector_disabled/test/negative.tf",
		Version: fmt.Sprintf("0.0.0-%s", negativeSha[0:12]),
		Purl:    fmt.Sprintf("pkg:generic/../../../assets/queries/terraform/aws/guardduty_detector_disabled/test/negative.tf@0.0.0-%s", negativeSha[0:12]),
		Hashes: []Hash{
			{
				Alg:     "SHA-256",
				Content: negativeSha,
			},
		},
		Vulnerabilities: vulnsC2,
	}

	c3 := Component{
		Type:    "file",
		BomRef:  fmt.Sprintf("pkg:generic/../../../assets/queries/terraform/aws/guardduty_detector_disabled/test/negative.tf@0.0.0-%s", negativeSha[0:12]),
		Name:    "../../../assets/queries/terraform/aws/guardduty_detector_disabled/test/negative.tf",
		Version: fmt.Sprintf("0.0.0-%s", negativeSha[0:12]),
		Purl:    fmt.Sprintf("pkg:generic/../../../assets/queries/terraform/aws/guardduty_detector_disabled/test/negative.tf@0.0.0-%s", negativeSha[0:12]),
		Hashes: []Hash{
			{
				Alg:     "SHA-256",
				Content: negativeSha,
			},
		},
		Vulnerabilities: vulnsC3,
	}

	vulnsC4 = append(vulnsC4, v5)

	c4 := Component{
		Type:    "file",
		BomRef:  fmt.Sprintf("pkg:generic/../../../test/fixtures/test_critical_custom_queries/amazon_mq_broker_encryption_disabled/test/positive1.yaml@0.0.0-%v", criticalSha[0:12]),
		Name:    "../../../test/fixtures/test_critical_custom_queries/amazon_mq_broker_encryption_disabled/test/positive1.yaml",
		Version: fmt.Sprintf("0.0.0-%v", criticalSha[0:12]),
		Purl:    fmt.Sprintf("pkg:generic/../../../test/fixtures/test_critical_custom_queries/amazon_mq_broker_encryption_disabled/test/positive1.yaml@0.0.0-%v", criticalSha[0:12]),
		Hashes: []Hash{
			{
				Alg:     "SHA-256",
				Content: criticalSha,
			},
		},
		Vulnerabilities: vulnsC4,
	}

	cycloneDx.Components.Components = append(cycloneDx.Components.Components, c2)
	cycloneDx.Components.Components = append(cycloneDx.Components.Components, c1)
	cycloneDxCWE.Components.Components = append(cycloneDxCWE.Components.Components, c3)
	cycloneDxCritical.Components.Components = append(cycloneDxCritical.Components.Components, c4)

	filePaths := make(map[string]string)

	file1 := filepath.Join("..", "..", "..", "assets", "queries", "terraform", "aws", "guardduty_detector_disabled", "test", "positive.tf")
	file2 := filepath.Join("..", "..", "..", "assets", "queries", "terraform", "aws", "guardduty_detector_disabled", "test", "negative.tf")
	file3 := filepath.Join("..", "..", "..", "test", "fixtures", "test_critical_custom_queries", "amazon_mq_broker_encryption_disabled", "test", "positive1.yaml")
	filePaths[file1] = file1
	filePaths[file2] = file2
	filePaths[file3] = file3

	type args struct {
		summary   *model.Summary
		filePaths map[string]string
	}
	tests := []struct {
		name string
		args args
		want *CycloneDxReport
	}{
		{
			name: "Build CycloneDX report",
			args: args{
				summary:   &test.ExampleSummaryMock,
				filePaths: map[string]string{file1: file1, file2: file2},
			},
			want: &cycloneDx,
		},
		{
			name: "Build CycloneDX report with critical severity",
			args: args{
				summary:   &test.SummaryMockCritical,
				filePaths: map[string]string{file3: file3},
			},
			want: &cycloneDxCritical,
		},
		{
			name: "Build CycloneDX report with cwe field complete",
			args: args{
				summary:   &test.ExampleSummaryMockCWE,
				filePaths: map[string]string{file2: file2},
			},
			want: &cycloneDxCWE,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			queries := tt.args.summary.Queries
			for idx := range queries {
				for i := range queries[idx].Files {
					queries[idx].Files[i].FileName = filepath.Join("..", "..", "..", queries[idx].Files[i].FileName)
				}
			}
			got := BuildCycloneDxReport(tt.args.summary, tt.args.filePaths)
			got.SerialNumber = "urn:uuid:" // set to "urn:uuid:" because it will be different for every report
			assert.Equal(t, len(got.Components.Components), len(tt.want.Components.Components), "Comparing number of components")
			for idx := range got.Components.Components {
				assert.Equal(t, got.Components.Components[idx].BomRef, tt.want.Components.Components[idx].BomRef, "Comparing BomRef of components")
				assert.Equal(t, got.Components.Components[idx].Version, tt.want.Components.Components[idx].Version, "Comparing Version of components")
				assert.Equal(t, got.Components.Components[idx].Purl, tt.want.Components.Components[idx].Purl, "Comparing Purl of components")
				assert.Equal(t, got.Components.Components[idx].Hashes, tt.want.Components.Components[idx].Hashes, "Comparing Hashes of components")
				for idx2 := range got.Components.Components[idx].Vulnerabilities {
					assert.Equal(t, got.Components.Components[idx].Vulnerabilities[idx2].Ref, tt.want.Components.Components[idx].Vulnerabilities[idx2].Ref, "Comparing Vulnerabilities Ref of components")
					assert.Equal(t, got.Components.Components[idx].Vulnerabilities[idx2].Description, tt.want.Components.Components[idx].Vulnerabilities[idx2].Description, "Comparing Vulnerabilities Description of components")
					assert.Equal(t, got.Components.Components[idx].Vulnerabilities[idx2].Ratings, tt.want.Components.Components[idx].Vulnerabilities[idx2].Ratings, "Comparing Vulnerabilities Ratings of components")
					assert.Equal(t, got.Components.Components[idx].Vulnerabilities[idx2].Recommendations, tt.want.Components.Components[idx].Vulnerabilities[idx2].Recommendations, "Comparing Vulnerabilities Recommendations of components")
				}
			}
		})
	}
}
