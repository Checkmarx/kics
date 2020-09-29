package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_S3_Bucket_with_Ignore_Public_ACL(t *testing.T) {
	const query = "aws/S3_Bucket_with_Ignore_Public_ACL.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      10,
				Severity:  model.SeverityLow,
				QueryName: "S3 bucket with ignore public ACL",
			},
		},
	)
}

func Test_S3_Bucket_with_Ignore_Public_ACL_Success(t *testing.T) {
	const query = "aws/S3_Bucket_with_Ignore_Public_ACL.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
