package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_Lamda_Hardcoded_AWS_Access_Key(t *testing.T) {
	const query = "aws/Lamda_Hardcoded_AWS_Access_Key.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      35,
				Severity:  model.SeverityLow,
				QueryName: "Lambda hardcoded AWS access key",
			},
			{
				Line:      56,
				Severity:  model.SeverityLow,
				QueryName: "Lambda hardcoded AWS access key",
			},
		},
	)
}

func Test_Lamda_Hardcoded_AWS_Access_Key_Success(t *testing.T) {
	const query = "aws/Lamda_Hardcoded_AWS_Access_Key.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
