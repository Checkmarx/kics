package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_Unchangeable_Password(t *testing.T) {
	const query = "Unchangeable_Password.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      12,
				Severity:  model.SeverityMedium,
				QueryName: "Unchangeable password",
			},
		},
	)
}

func Test_Unchangeable_Password_Success(t *testing.T) {
	const query = "Unchangeable_Password.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
