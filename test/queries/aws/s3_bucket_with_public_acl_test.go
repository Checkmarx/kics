package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_S3_Bucket_with_Public_ACL(t *testing.T) {
	const query = "aws/S3_Bucket_with_Public_ACL.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      18,
				Severity:  model.SeverityMedium,
				QueryName: "S3 bucket allows public ACL",
			},
			{
				Line:      8,
				Severity:  model.SeverityMedium,
				QueryName: "S3 bucket allows public ACL",
			},
		},
	)
}

func Test_S3_Bucket_with_Public_ACL_Success(t *testing.T) {
	const query = "aws/S3_Bucket_with_Public_ACL.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
