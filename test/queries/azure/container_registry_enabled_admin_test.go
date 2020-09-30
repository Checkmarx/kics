package azure

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_Container_Registry_enabled_Admin(t *testing.T) {
	const queryPath = "azure/Container_Registry_enabled_Admin.rego"

	utils.CheckQuery(
		t,
		queryPath,
		utils.QueryTerraformFile(queryPath),
		[]model.Vulnerability{
			{
				Line:      11,
				Severity:  model.SeverityHigh,
				QueryName: "Admin user is enabled for Container Registry",
			},
		},
	)
}

func Test_Container_Registry_enabled_Admin_Success(t *testing.T) {
	const queryPath = "azure/Container_Registry_enabled_Admin.rego"

	utils.CheckQuery(
		t,
		queryPath,
		utils.QueryTerraformSuccessFile(queryPath),
		[]model.Vulnerability{},
	)
}
