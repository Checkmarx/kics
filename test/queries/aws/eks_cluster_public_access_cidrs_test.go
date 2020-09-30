package aws

import (
	"testing"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/test/utils"
)

func Test_EKS_Cluster_Public_Access_cidrs(t *testing.T) {
	const query = "aws/EKS_Cluster_Public_Access_cidrs.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformFile(query),
		[]model.Vulnerability{
			{
				Line:      8,
				Severity:  model.SeverityHigh,
				QueryName: "EKS cluster public access cidrs",
			},
			{
				Line:      30,
				Severity:  model.SeverityHigh,
				QueryName: "EKS cluster public access cidrs",
			},
		},
	)
}

func Test_EKS_Cluster_Public_Access_cidrs_Success(t *testing.T) {
	const query = "aws/EKS_Cluster_Public_Access_cidrs.rego"

	utils.CheckQuery(
		t,
		query,
		utils.QueryTerraformSuccessFile(query),
		[]model.Vulnerability{},
	)
}
