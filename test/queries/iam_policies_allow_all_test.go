package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_IAM_Policies_Allow_All(t *testing.T) {
	const query = "IAM_Policies_Allow_All.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      32,
				Severity:  model.SeverityMedium,
				QueryName: "Allow all IAM policies",
			},
		},
	)
}

func Test_IAM_Policies_Allow_All_Success(t *testing.T) {
	const query = "IAM_Policies_Allow_All.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
