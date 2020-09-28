package queries

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
)

func Test_RDS_without_Backup(t *testing.T) {
	const query = "RDS_without_Backup.rego"

	checkQuery(
		t,
		query,
		queryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      17,
				Severity:  model.SeverityMedium,
				QueryName: "RDS without Backup",
				Value:     ptrToString("mydb"),
			},
			{
				Line:      13,
				Severity:  model.SeverityMedium,
				QueryName: "RDS without Backup",
				Value:     ptrToString("mydb"),
			},
		},
	)
}

func Test_RDS_without_Backup_Success(t *testing.T) {
	const query = "RDS_without_Backup.rego"

	checkQuery(
		t,
		query,
		queryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
