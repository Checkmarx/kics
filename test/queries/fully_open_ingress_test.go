package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_Fully_Open_Ingress(t *testing.T) {
	const query = "Fully_Open_Ingress.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
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
	const query = "Fully_Open_Ingress.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
