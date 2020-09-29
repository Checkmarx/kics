package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_Insufficient_Password_Length(t *testing.T) {
	const query = "aws/Insufficient_Password_Length.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      13,
				Severity:  model.SeverityHigh,
				QueryName: "Insufficient password length",
			},
			{
				Line:      9,
				Severity:  model.SeverityHigh,
				QueryName: "Insufficient password length",
			},
		},
	)
}

func Test_Insufficient_Password_Length_Success(t *testing.T) {
	const query = "aws/Insufficient_Password_Length.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
