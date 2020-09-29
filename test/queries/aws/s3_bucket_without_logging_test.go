package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_S3_Bucket_without_Logging(t *testing.T) {
	const query = "aws/S3_Bucket_without_Logging.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      2,
				Severity:  model.SeverityLow,
				QueryName: "S3 no logging",
			},
		},
	)
}

func Test_S3_Bucket_without_Logging_Success(t *testing.T) {
	const query = "aws/S3_Bucket_without_Logging.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
