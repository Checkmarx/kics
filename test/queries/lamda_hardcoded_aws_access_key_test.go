package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_Lamda_Hardcoded_AWS_Access_Key(t *testing.T) {
	const query = "Lamda_Hardcoded_AWS_Access_Key.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
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
	const query = "Lamda_Hardcoded_AWS_Access_Key.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
