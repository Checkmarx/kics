package azure

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_Vault_disabled_Audit(t *testing.T) {
	const queryPath = "azure/Vault_disabled_Audit.rego"

	utils.CheckQuery(
		t,
		queryPath,
		utils.QueryTerraformFile(queryPath),
		[]model.Vulnerability{
			{
				Line:      16,
				Severity:  model.SeverityHigh,
				QueryName: "Vault with disabled Audit",
			},
		},
	)
}

func Test_Vault_disabled_Audit_Success(t *testing.T) {
	const queryPath = "azure/Vault_disabled_Audit.rego"

	utils.CheckQuery(
		t,
		queryPath,
		utils.QueryTerraformSuccessFile(queryPath),
		[]model.Vulnerability{},
	)
}
