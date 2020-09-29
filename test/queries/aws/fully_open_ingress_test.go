package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_Fully_Open_Ingress(t *testing.T) {
	const query = "aws/Fully_Open_Ingress.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      95,
				Severity:  model.SeverityHigh,
				QueryName: "Fully open Ingress",
			},
			{
				Line:      105,
				Severity:  model.SeverityHigh,
				QueryName: "Fully open Ingress",
			},
		},
	)
}

func Test_Fully_Open_Ingress_Success(t *testing.T) {
	const query = "aws/Fully_Open_Ingress.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
