package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_SQS_Policy_with_ALL_Actions(t *testing.T) {
	const query = "SQS_Policy_with_ALL_Actions.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
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
	const query = "SQS_Policy_with_ALL_Actions.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
