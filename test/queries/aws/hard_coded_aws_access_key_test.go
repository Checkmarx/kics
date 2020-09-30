package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_Hard_Coded_AWS_Access_Key(t *testing.T) {
	const query = "aws/Hard_Coded_AWS_Access_Key.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      14,
				Severity:  model.SeverityLow,
				QueryName: "Hardcoded AWS access key",
			},
			{
				Line:      41,
				Severity:  model.SeverityLow,
				QueryName: "Hardcoded AWS access key",
			},
		},
	)
}

func Test_Hard_Coded_AWS_Access_Key_Success(t *testing.T) {
	const query = "aws/Hard_Coded_AWS_Access_Key.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
