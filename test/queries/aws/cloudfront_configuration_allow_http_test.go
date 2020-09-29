package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_Cloudfront_Configuration_Allow_HTTP(t *testing.T) {
	const query = "aws/Cloudfront_Configuration_Allow_HTTP.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
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
	const query = "aws/Cloudfront_Configuration_Allow_HTTP.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
