package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_S3_Bucket_without_Enabled_MFA_Delete(t *testing.T) {
	const query = "aws/S3_Bucket_without_Enabled_MFA_Delete.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
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
	const query = "aws/S3_Bucket_without_Enabled_MFA_Delete.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
