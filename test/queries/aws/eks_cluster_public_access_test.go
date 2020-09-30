package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_EKS_Cluster_Public_Access(t *testing.T) {
	const query = "aws/EKS_Cluster_Public_Access.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      7,
				Severity:  model.SeverityMedium,
				QueryName: "EKS cluster public access",
			},
		},
	)
}

func Test_EKS_Cluster_Public_Access_Success(t *testing.T) {
	const query = "aws/EKS_Cluster_Public_Access.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
