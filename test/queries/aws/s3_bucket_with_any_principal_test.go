package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_S3_Bucket_with_any_Principal(t *testing.T) {
	const query = "aws/S3_Bucket_with_any_Principal.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
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
	const query = "aws/S3_Bucket_with_any_Principal.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
