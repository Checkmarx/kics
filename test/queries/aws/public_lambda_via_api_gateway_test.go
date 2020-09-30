package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_Public_Lambda_via_API_Gateway(t *testing.T) {
	const query = "aws/Public_Lambda_via_API_Gateway.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      9,
				Severity:  model.SeverityMedium,
				QueryName: "Public Lambda via API Gateway",
				Value:     ptrToString("MyHandler::handleRequest"),
			},
		},
	)
}

func Test_Public_Lambda_via_API_Gateway_Success(t *testing.T) {
	const query = "aws/Public_Lambda_via_API_Gateway.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
