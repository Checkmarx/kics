package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_S3_Bucket_without_Restriction_of_Public_Bucket(t *testing.T) {
	const query = "aws/S3_Bucket_without_Restriction_of_Public_Bucket.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      14,
				Severity:  model.SeverityHigh,
				QueryName: "S3 bucket without restriction of public bucket",
			},
			{
				Line:      11,
				Severity:  model.SeverityHigh,
				QueryName: "S3 bucket without restriction of public bucket",
			},
		},
	)
}

func Test_S3_Bucket_without_Restriction_of_Public_Bucket_Success(t *testing.T) {
	const query = "aws/S3_Bucket_without_Restriction_of_Public_Bucket.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
