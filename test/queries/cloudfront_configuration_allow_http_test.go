package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_Cloudfront_Configuration_Allow_HTTP(t *testing.T) {
	const query = "Cloudfront_Configuration_Allow_HTTP.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      49,
				Severity:  model.SeverityHigh,
				QueryName: "Cloudfront configuration allow HTTP",
			},
			{
				Line:      76,
				Severity:  model.SeverityHigh,
				QueryName: "Cloudfront configuration allow HTTP",
			},
		},
	)
}

func Test_Cloudfront_Configuration_Allow_HTTP_Success(t *testing.T) {
	const query = "Cloudfront_Configuration_Allow_HTTP.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
