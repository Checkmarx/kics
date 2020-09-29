// nolint:dupl
package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_S3_Bucket_wth_Public_RW(t *testing.T) {
	const query = "aws/S3_Bucket_wth_Public_RW.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      19,
				Severity:  model.SeverityInfo,
				QueryName: "S3 bucket with public RW access",
				Value:     ptrToString("my-tf-test-bucket"),
			},
			{
				Line:      34,
				Severity:  model.SeverityInfo,
				QueryName: "S3 bucket with public RW access",
				Value:     ptrToString("my-tf-test-bucket"),
			},
			{
				Line:      4,
				Severity:  model.SeverityInfo,
				QueryName: "S3 bucket with public RW access",
				Value:     ptrToString("my-tf-test-bucket"),
			},
		},
	)
}

func Test_S3_Bucket_wth_Public_RW_Success(t *testing.T) {
	const query = "aws/S3_Bucket_wth_Public_RW.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
