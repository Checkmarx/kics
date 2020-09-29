package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_S3_Bucket_with_Public_Policy(t *testing.T) {
	const query = "S3_Bucket_with_Public_Policy.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      18,
				Severity:  model.SeverityHigh,
				QueryName: "S3 bucket allows public policy",
			},
			{
				Line:      9,
				Severity:  model.SeverityHigh,
				QueryName: "S3 bucket allows public policy",
			},
		},
	)
}

func Test_S3_Bucket_with_Public_Policy_Success(t *testing.T) {
	const query = "S3_Bucket_with_Public_Policy.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
