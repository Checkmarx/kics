package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_S3_Bucket_with_any_Principal(t *testing.T) {
	const query = "S3_Bucket_with_any_Principal.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      17,
				Severity:  model.SeverityHigh,
				QueryName: "S3 bucket with any principal",
			},
		},
	)
}

func Test_S3_Bucket_with_any_Principal_Success(t *testing.T) {
	const query = "S3_Bucket_with_any_Principal.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
