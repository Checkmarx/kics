package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_IAM_Role_Allows_Public_Assume(t *testing.T) {
	const query = "aws/IAM_Role_Allows_Public_Assume.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
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
	const query = "aws/IAM_Role_Allows_Public_Assume.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
