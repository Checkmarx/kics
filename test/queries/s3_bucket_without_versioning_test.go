package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_S3_Bucket_without_Versioning(t *testing.T) {
	const query = "S3_Bucket_without_Versioning.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      17,
				Severity:  model.SeverityHigh,
				QueryName: "S3 bucket without versioning",
			},
			{
				Line:      38,
				Severity:  model.SeverityHigh,
				QueryName: "S3 bucket without versioning",
			},
			{
				Line:      12,
				Severity:  model.SeverityHigh,
				QueryName: "S3 bucket without versioning",
			},
		},
	)
}

func Test_S3_Bucket_without_Versioning_Success(t *testing.T) {
	const query = "S3_Bucket_without_Versioning.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
