package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_IAM_Role_Assumed_by_All(t *testing.T) {
	const query = "IAM_Role_Assumed_by_All.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      37,
				Severity:  model.SeverityLow,
				QueryName: "IAM role allows all principals to assume",
			},
		},
	)
}

func Test_IAM_Role_Assumed_by_All_Success(t *testing.T) {
	const query = "IAM_Role_Assumed_by_All.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
