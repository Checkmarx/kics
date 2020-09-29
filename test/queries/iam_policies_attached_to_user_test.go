package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_IAM_Policies_Attached_to_User(t *testing.T) {
	const query = "IAM_Policies_Attached_to_User.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      18,
				Severity:  model.SeverityLow,
				QueryName: "IAM policies attached to user",
			},
		},
	)
}

func Test_IAM_Policies_Attached_to_User_Success(t *testing.T) {
	const query = "IAM_Policies_Attached_to_User.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
