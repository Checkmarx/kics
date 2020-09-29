package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_IAM_Policies_Attached_to_User(t *testing.T) {
	const query = "aws/IAM_Policies_Attached_to_User.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
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
	const query = "aws/IAM_Policies_Attached_to_User.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
