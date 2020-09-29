package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_Cloudfront_without_WAF(t *testing.T) {
	const query = "Cloudfront_without_WAF.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      15,
				Severity:  model.SeverityLow,
				QueryName: "Cloudfront without WAF",
			},
		},
	)
}

func Test_Cloudfront_without_WAF_Success(t *testing.T) {
	const query = "Cloudfront_without_WAF.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
