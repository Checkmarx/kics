package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_Cloudfront_without_WAF(t *testing.T) {
	const query = "aws/Cloudfront_without_WAF.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
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
	const query = "aws/Cloudfront_without_WAF.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
