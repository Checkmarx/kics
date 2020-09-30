package azure

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_SQL_Database_disabled_Audit(t *testing.T) {
	const queryPath = "azure/SQL_Database_disabled_Audit.rego"

	utils.CheckQuery(
		t,
		queryPath,
		utils.QueryTerraformFile(queryPath),
		[]model.Vulnerability{
			{
				Line:      50,
				Severity:  model.SeverityHigh,
				QueryName: "SQL Database disabled Audit",
			},
			{
				Line:      34,
				Severity:  model.SeverityHigh,
				QueryName: "SQL Database disabled Audit",
			},
		},
	)
}

func Test_SQL_Database_disabled_Audit_Success(t *testing.T) {
	const queryPath = "azure/SQL_Database_disabled_Audit.rego"

	utils.CheckQuery(
		t,
		queryPath,
		utils.QueryTerraformSuccessFile(queryPath),
		[]model.Vulnerability{},
	)
}
