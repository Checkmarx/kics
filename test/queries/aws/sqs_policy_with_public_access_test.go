// nolint:dupl
package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_SQS_policy_with_Public_Access(t *testing.T) {
	const query = "aws/SQS_policy_with_Public_Access.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      47,
				Severity:  model.SeverityMedium,
				QueryName: "SQS policy with Public Access",
				Value:     ptrToString("examplequeue_aws"),
			},
			{
				Line:      72,
				Severity:  model.SeverityMedium,
				QueryName: "SQS policy with Public Access",
				Value:     ptrToString("examplequeue_aws_array"),
			},
			{
				Line:      15,
				Severity:  model.SeverityMedium,
				QueryName: "SQS policy with Public Access",
				Value:     ptrToString("examplequeue"),
			},
		},
	)
}

func Test_SQS_policy_with_Public_Access_Success(t *testing.T) {
	const query = "aws/SQS_policy_with_Public_Access.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
