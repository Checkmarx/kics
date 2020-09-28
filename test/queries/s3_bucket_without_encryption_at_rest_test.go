package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_S3_Bucket_without_Encryption_at_REST(t *testing.T) {
	const query = "S3_Bucket_without_Encryption_at_REST.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      12,
				Severity:  model.SeverityHigh,
				QueryName: "S3 bucket without encryption at REST",
			},
		},
	)
}

func Test_S3_Bucket_without_Encryption_at_REST_Success(t *testing.T) {
	const query = "S3_Bucket_without_Encryption_at_REST.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
