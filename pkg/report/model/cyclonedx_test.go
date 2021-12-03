package model

import (
	"path/filepath"
	"reflect"
	"testing"
	"time"

	"github.com/Checkmarx/kics/internal/constants"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/test"
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
	XMLNS:        "http://cyclonedx.org/schema/bom/1.3",
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
	var vulnsC1, vulnsC2 []Vulnerability

	v1 := Vulnerability{
		Ref: "pkg:generic/../../../assets/queries/terraform/aws/guardduty_detector_disabled/test/positive.tf@0.0.0-bd4ac2f61e7ce38a8e0a-b88b-4902-b3fe-b0fcb17d5c10",
		ID:  "e38a8e0a-b88b-4902-b3fe-b0fcb17d5c10",
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
				Recommendation: "In line 1, a result was found. 'aws_guardduty_detector[{{positive1}}].tags is undefined or null', but 'aws_guardduty_detector[{{positive1}}].tags is defined and not null'",
			},
		},
	}

	v2 := Vulnerability{
		Ref: "pkg:generic/../../../assets/queries/terraform/aws/guardduty_detector_disabled/test/positive.tf@0.0.0-bd4ac2f61e7c704dadd3-54fc-48ac-b6a0-02f170011473",
		ID:  "704dadd3-54fc-48ac-b6a0-02f170011473",
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
				Recommendation: "In line 2, a result was found. 'GuardDuty Detector is not Enabled', but 'GuardDuty Detector should be Enabled'",
			},
		},
	}

	v3 := Vulnerability{
		Ref: "pkg:generic/../../../assets/queries/terraform/aws/guardduty_detector_disabled/test/negative.tf@0.0.0-68b4caecf5d5e38a8e0a-b88b-4902-b3fe-b0fcb17d5c10",
		ID:  "e38a8e0a-b88b-4902-b3fe-b0fcb17d5c10",
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
				Recommendation: "In line 1, a result was found. 'aws_guardduty_detector[{{negative1}}].tags is undefined or null', but 'aws_guardduty_detector[{{negative1}}].tags is defined and not null'",
			},
		},
	}

	vulnsC1 = append(vulnsC1, v1)
	vulnsC1 = append(vulnsC1, v2)

	c1 := Component{
		Type:    "file",
		BomRef:  "pkg:generic/../../../assets/queries/terraform/aws/guardduty_detector_disabled/test/positive.tf@0.0.0-bd4ac2f61e7c",
		Name:    "../../../assets/queries/terraform/aws/guardduty_detector_disabled/test/positive.tf",
		Version: "0.0.0-bd4ac2f61e7c",
		Purl:    "pkg:generic/../../../assets/queries/terraform/aws/guardduty_detector_disabled/test/positive.tf@0.0.0-bd4ac2f61e7c",
		Hashes: []Hash{
			{
				Alg:     "SHA-256",
				Content: "bd4ac2f61e7c623477b5d200b3662fd7caac5e89e042960fd1adb008e0962635",
			},
		},
		Vulnerabilities: vulnsC1,
	}

	vulnsC2 = append(vulnsC2, v3)

	c2 := Component{
		Type:    "file",
		BomRef:  "pkg:generic/../../../assets/queries/terraform/aws/guardduty_detector_disabled/test/negative.tf@0.0.0-68b4caecf5d5",
		Name:    "../../../assets/queries/terraform/aws/guardduty_detector_disabled/test/negative.tf",
		Version: "0.0.0-68b4caecf5d5",
		Purl:    "pkg:generic/../../../assets/queries/terraform/aws/guardduty_detector_disabled/test/negative.tf@0.0.0-68b4caecf5d5",
		Hashes: []Hash{
			{
				Alg:     "SHA-256",
				Content: "68b4caecf5d5130426a8b8f0222cdd7f31232b5c99a5bf0daf19099e26e2ec29",
			},
		},
		Vulnerabilities: vulnsC2,
	}

	cycloneDx.Components.Components = append(cycloneDx.Components.Components, c2)
	cycloneDx.Components.Components = append(cycloneDx.Components.Components, c1)

	type args struct {
		summary *model.Summary
	}
	tests := []struct {
		name string
		args args
		want *CycloneDxReport
	}{
		{
			name: "Build CycloneDX report",
			args: args{
				summary: &test.ExampleSummaryMock,
			},
			want: &cycloneDx,
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
			got := BuildCycloneDxReport(tt.args.summary)
			got.SerialNumber = "urn:uuid:" // set to "urn:uuid:" because it will be different for every report
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("BuildCycloneDxReport() = %v, want %v", got, tt.want)
			}
		})
	}
}
