package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_IAM_Role_Allows_Public_Assume(t *testing.T) {
	const query = "IAM_Role_Allows_Public_Assume.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      78,
				Severity:  model.SeverityLow,
				QueryName: "IAM role allows public assume",
			},
			{
				Line:      15,
				Severity:  model.SeverityLow,
				QueryName: "IAM role allows public assume",
			},
		},
	)
}

func Test_IAM_Role_Allows_Public_Assume_Success(t *testing.T) {
	const query = "IAM_Role_Allows_Public_Assume.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
