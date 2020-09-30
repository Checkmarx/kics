package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_RDS_without_Backup(t *testing.T) {
	const query = "aws/RDS_without_Backup.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
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
	const query = "aws/RDS_without_Backup.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
