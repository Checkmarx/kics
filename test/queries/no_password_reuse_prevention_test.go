package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_No_Password_Reuse_Prevention(t *testing.T) {
	const query = "No_Password_Reuse_Prevention.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      13,
				Severity:  model.SeverityMedium,
				QueryName: "No password reuse prevention",
			},
			{
				Line:      10,
				Severity:  model.SeverityMedium,
				QueryName: "No password reuse prevention",
			},
		},
	)
}

func Test_No_Password_Reuse_Prevention_Success(t *testing.T) {
	const query = "No_Password_Reuse_Prevention.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
