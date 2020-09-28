package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_S3_Bucket_with_Ignore_Public_ACL(t *testing.T) {
	const query = "S3_Bucket_with_Ignore_Public_ACL.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
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
	const query = "S3_Bucket_with_Ignore_Public_ACL.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
