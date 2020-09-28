package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_S3_Bucket_with_Public_ACL(t *testing.T) {
	const query = "S3_Bucket_with_Public_ACL.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
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
	const query = "S3_Bucket_with_Public_ACL.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
