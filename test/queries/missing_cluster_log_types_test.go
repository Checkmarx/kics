package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_Missing_Cluster_Log_Types(t *testing.T) {
	const query = "Missing_Cluster_Log_Types.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      9,
				Severity:  model.SeverityLow,
				QueryName: "Missing cluster log types",
			},
		},
	)
}

func Test_Missing_Cluster_Log_Types_Success(t *testing.T) {
	const query = "Missing_Cluster_Log_Types.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
