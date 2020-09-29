package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_IAM_Policies_with_Full_Pivileges(t *testing.T) {
	const query = "aws/IAM_Policies_with_Full_Pivileges.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      11,
				Severity:  model.SeverityMedium,
				QueryName: "IAM policies with full privileges",
			},
		},
	)
}

func Test_IAM_Policies_with_Full_Pivileges_Success(t *testing.T) {
	const query = "aws/IAM_Policies_with_Full_Pivileges.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
