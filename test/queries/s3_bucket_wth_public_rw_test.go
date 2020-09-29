// nolint:dupl
package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_S3_Bucket_wth_Public_RW(t *testing.T) {
	const query = "S3_Bucket_wth_Public_RW.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
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
	const query = "S3_Bucket_wth_Public_RW.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
