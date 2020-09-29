package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_Missing_Cluster_Log_Types(t *testing.T) {
	const query = "aws/Missing_Cluster_Log_Types.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
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
	const query = "aws/Missing_Cluster_Log_Types.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
