package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_Unchangeable_Password(t *testing.T) {
	const query = "aws/Unchangeable_Password.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      12,
				Severity:  model.SeverityMedium,
				QueryName: "Unchangeable password",
			},
		},
	)
}

func Test_Unchangeable_Password_Success(t *testing.T) {
	const query = "aws/Unchangeable_Password.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
