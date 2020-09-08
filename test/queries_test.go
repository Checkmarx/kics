package test

import (
	"context"
	"fmt"
	"io/ioutil"
	"os"
	"path"
	"testing"

	"github.com/checkmarxDev/ice/pkg/engine"
	"github.com/checkmarxDev/ice/pkg/engine/mock"
	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/checkmarxDev/ice/pkg/parser"
	"github.com/golang/mock/gomock"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/stretchr/testify/assert"
)

type expectedResult struct {
	line     int
	severity string
	name     string
}

type testCase struct {
	query           string
	file            string
	expectedResults []expectedResult
}

var testCases = []testCase{
	{
		query: "ALB_protocol_is_HTTP.q",
		file:  "ALB_protocol_is_HTTP.tf",
		expectedResults: []expectedResult{
			{
				line:     25,
				severity: "High",
				name:     "ALB protocol is HTTP",
			},
			{
				line:     19,
				severity: "High",
				name:     "ALB protocol is HTTP",
			},
		},
	},
	{
		query: "ALB_protocol_is_HTTP.q",
		file:  "ALB_protocol_is_HTTP_success.tf",
	},
	{
		query: "Cloudfront_configuration_allow_HTTP.q",
		file:  "Cloudfront_configuration_allow_HTTP.tf",
		expectedResults: []expectedResult{
			{
				line:     49,
				severity: "High",
				name:     "Cloudfront configuration allow HTTP",
			},
			{
				line:     76,
				severity: "High",
				name:     "Cloudfront configuration allow HTTP",
			},
		},
	},
	{
		query: "Cloudfront_configuration_allow_HTTP.q",
		file:  "Cloudfront_configuration_allow_HTTP_success.tf",
	},
	{
		query: "Cloudwatch_without_retention_days.q",
		file:  "Cloudwatch_without_retention_days.tf",
		expectedResults: []expectedResult{
			{
				line:     15,
				severity: "Low",
				name:     "Cloudwatch without retention days",
			},
		},
	},
	{
		query: "Cloudwatch_without_retention_days.q",
		file:  "Cloudwatch_without_retention_days_success.tf",
	},
	{
		query: "Cloudfront_without_WAF.q",
		file:  "Cloudfront_without_WAF.tf",
		expectedResults: []expectedResult{
			{
				line:     15,
				severity: "Low",
				name:     "Cloudfront without WAF",
			},
		},
	},
	{
		query: "Cloudfront_without_WAF.q",
		file:  "Cloudfront_without_WAF_success.tf",
	},
	{
		query: "Eks_Cluster_Public_Access_cidrs.q",
		file:  "Eks_Cluster_Public_Access_cidrs.tf",
		expectedResults: []expectedResult{
			{
				line:     8,
				severity: "High",
				name:     "EKS cluster public access cidrs",
			},
		},
	},
	{
		query: "Eks_Cluster_Public_Access_cidrs.q",
		file:  "Eks_Cluster_Public_Access_cidrs_success.tf",
	},

	{
		query: "Eks_Cluster_Public_Access.q",
		file:  "Eks_Cluster_Public_Access.tf",
		expectedResults: []expectedResult{
			{
				line:     7,
				severity: "Medium",
				name:     "EKS cluster public access",
			},
		},
	},
	{
		query: "Eks_Cluster_Public_Access.q",
		file:  "Eks_Cluster_Public_Access_success.tf",
	},

	{
		query: "Fully_Open_Ingress.q",
		file:  "Fully_Open_Ingress.tf",
		expectedResults: []expectedResult{
			{
				line:     91,
				severity: "High",
				name:     "Fully open Ingress",
			},
		},
	},
	{
		query: "Fully_Open_Ingress.q",
		file:  "Fully_Open_Ingress_success.tf",
	},
	{
		query: "Hard_Coded_AWS_Access_Key.q",
		file:  "Hard_Coded_AWS_Access_Key.tf",
		expectedResults: []expectedResult{
			{
				line:     14,
				severity: "Low",
				name:     "Hardcoded AWS access key",
			},
		},
	},
	{
		query: "Hard_Coded_AWS_Access_Key.q",
		file:  "Hard_Coded_AWS_Access_Key_success.tf",
	},
	{
		query: "IAM_policies_allow_all.q",
		file:  "IAM_policies_allow_all.tf",
		expectedResults: []expectedResult{
			{
				line:     32,
				severity: "Medium",
				name:     "Allow all IAM policies",
			},
		},
	},
	{
		query: "IAM_policies_allow_all.q",
		file:  "IAM_policies_allow_all_success.tf",
	},
	{
		query: "IAM_policies_attached_to_User.q",
		file:  "IAM_policies_attached_to_User.tf",
		expectedResults: []expectedResult{
			{
				line:     16,
				severity: "Low",
				name:     "IAM policies attached to user",
			},
		},
	},
	{
		query: "IAM_policies_attached_to_User.q",
		file:  "IAM_policies_attached_to_User_success.tf",
	},
	{
		query: "IAM_Policies_with_Full_Pivileges.q",
		file:  "IAM_Policies_with_Full_Pivileges.tf",
		expectedResults: []expectedResult{
			{
				line:     1,
				severity: "Medium",
				name:     "IAM policies with full privileges",
			},
		},
	},
	{
		query: "IAM_Policies_with_Full_Pivileges.q",
		file:  "IAM_Policies_with_Full_Pivileges_success.tf",
	},
	{
		query: "IAM_Role_Allows_Public_Assume.q",
		file:  "IAM_Role_Allows_Public_Assume.tf",
		expectedResults: []expectedResult{
			{
				line:     15,
				severity: "Low",
				name:     "IAM role allows public assume",
			},
		},
	},
	{
		query: "IAM_Role_Allows_Public_Assume.q",
		file:  "IAM_Role_Allows_Public_Assume_success.tf",
	},
}

func TestQueries(t *testing.T) {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: ioutil.Discard})
	log.Output(ioutil.Discard)
	for _, testCase := range testCases {
		t.Run(testCase.query, func(t *testing.T) {
			ctrl := gomock.NewController(t)
			defer ctrl.Finish()

			ctx := context.Background()
			scanID := "scanID"
			fileID := 111

			storage := mock.NewMockFilesStorage(ctrl)
			storage.EXPECT().GetFiles(gomock.Eq(ctx), gomock.Eq(scanID), gomock.Any()).
				DoAndReturn(func(ctx context.Context, scanID, filter string) (model.FileMetadatas, error) {
					filePath := path.Join("./test-data", testCase.file)
					f, err := os.Open(filePath)
					if err != nil {
						return nil, err
					}

					content, err := ioutil.ReadAll(f)
					if err != nil {
						return nil, err
					}

					jsonContent, err := parser.NewDefault().Parse(filePath, content)
					if err != nil {
						return nil, err
					}

					return []model.FileMetadata{
						{
							ID:           fileID,
							ScanID:       scanID,
							JSONData:     jsonContent,
							OriginalData: string(content),
							Kind:         model.KindTerraform,
							FileName:     filePath,
							JSONHash:     0,
						},
					}, nil
				})

			storage.EXPECT().SaveVulnerabilities(gomock.Eq(ctx), gomock.Any()).
				DoAndReturn(func(_ context.Context, results []model.Vulnerability) error {
					assert.Len(t, results, len(testCase.expectedResults), "Found issues and expected doesn't match")

					for i, item := range testCase.expectedResults {
						if i > len(results)-1 {
							t.Fatalf("Not enough results detected, expected %d, found %d", len(testCase.expectedResults), len(results))
						}

						result := results[i]
						assert.NotNil(t, result.Line, "Line should be detected")
						assert.Equal(t, item.line, *result.Line, "Not corrected detected line")
						assert.Equal(t, item.severity, result.Severity, "Invalid severity")
						assert.Equal(t, item.name, result.QueryName, "Invalid query name")
						assert.Equal(t, fileID, result.FileID)
					}

					return nil
				})

			queriesSource := mock.NewMockQueriesSource(ctrl)
			queriesSource.EXPECT().GetQueries().
				DoAndReturn(func() ([]model.QueryMetadata, error) {
					qCode, err := ioutil.ReadFile(path.Join("./../assets/queries", testCase.query))
					if err != nil {
						return nil, fmt.Errorf("query source: %w", err)
					}

					return []model.QueryMetadata{
						{
							FileName: testCase.query,
							Content:  string(qCode),
						},
					}, nil
				})

			inspector, err := engine.NewInspector(ctx, queriesSource, storage)
			assert.Nil(t, err)

			err = inspector.Inspect(ctx, scanID)
			assert.Nil(t, err)
		})
	}
}
