package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_S3_Bucket_without_Enabled_MFA_Delete(t *testing.T) {
	const query = "S3_Bucket_without_Enabled_MFA_Delete.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      25,
				Severity:  model.SeverityHigh,
				QueryName: "S3 bucket without enabled MFA Delete",
			},
			{
				Line:      12,
				Severity:  model.SeverityHigh,
				QueryName: "S3 bucket without enabled MFA Delete",
			},
		},
	)
}

func Test_S3_Bucket_without_Enabled_MFA_Delete_Success(t *testing.T) {
	const query = "S3_Bucket_without_Enabled_MFA_Delete.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
