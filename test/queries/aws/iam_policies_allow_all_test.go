package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_IAM_Policies_Allow_All(t *testing.T) {
	const query = "aws/IAM_Policies_Allow_All.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
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
	const query = "aws/IAM_Policies_Allow_All.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
