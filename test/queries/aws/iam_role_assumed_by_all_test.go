package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_IAM_Role_Assumed_by_All(t *testing.T) {
	const query = "aws/IAM_Role_Assumed_by_All.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
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
	const query = "aws/IAM_Role_Assumed_by_All.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
