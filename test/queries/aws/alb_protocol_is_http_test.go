package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_ALB_Protocol_is_HTTP(t *testing.T) {
	const query = "aws/ALB_Protocol_is_HTTP.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      25,
				Severity:  model.SeverityHigh,
				QueryName: "ALB protocol is HTTP",
			},
			{
				Line:      19,
				Severity:  model.SeverityHigh,
				QueryName: "ALB protocol is HTTP",
			},
		},
	)
}

func Test_ALB_Protocol_is_HTTP_Success(t *testing.T) {
	const query = "aws/ALB_Protocol_is_HTTP.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
