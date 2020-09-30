package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_SQS_Policy_with_ALL_Actions(t *testing.T) {
	const query = "aws/SQS_Policy_with_ALL_Actions.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      17,
				Severity:  model.SeverityMedium,
				QueryName: "SQS policy allows ALL (*) actions",
			},
		},
	)
}

func Test_SQS_Policy_with_ALL_Actions_Success(t *testing.T) {
	const query = "aws/SQS_Policy_with_ALL_Actions.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
