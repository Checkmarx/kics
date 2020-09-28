package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_Not_Encrypted_Data_in_Launch_Configuration(t *testing.T) {
	const query = "Not_Encrypted_Data_in_Launch_Configuration.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
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
	const query = "Not_Encrypted_Data_in_Launch_Configuration.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
