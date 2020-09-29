package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_S3_Bucket_without_Logging(t *testing.T) {
	const query = "S3_Bucket_without_Logging.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
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
	const query = "S3_Bucket_without_Logging.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
