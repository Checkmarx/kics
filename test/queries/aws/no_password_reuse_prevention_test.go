package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_No_Password_Reuse_Prevention(t *testing.T) {
	const query = "aws/No_Password_Reuse_Prevention.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
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
	const query = "aws/No_Password_Reuse_Prevention.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
