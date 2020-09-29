package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_Not_Encrypted_Data_in_Launch_Configuration(t *testing.T) {
	const query = "aws/Not_Encrypted_Data_in_Launch_Configuration.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      6,
				Severity:  model.SeverityMedium,
				QueryName: "Not encrypted data in launch configuration",
			},
		},
	)
}

func Test_Not_Encrypted_Data_in_Launch_Configuration_Success(t *testing.T) {
	const query = "aws/Not_Encrypted_Data_in_Launch_Configuration.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
