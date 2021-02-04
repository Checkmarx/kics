package model

import (
	"testing"

	"github.com/stretchr/testify/require"
)

// TestCreateSarifReport tests if creates a sarif report correctly
func TestCreateSarifReport(t *testing.T) {
	sarif := NewSarifReport()
	require.Equal(t, "https://raw.githubusercontent.com/oasis-tcs/sarif-spec/master/Schemata/sarif-schema-2.1.0.json", sarif.Schema)
	require.Equal(t, "2.1.0", sarif.SarifVersion)
	require.Equal(t, "KICS", sarif.Runs[0].Tool.Driver.ToolName)
	require.Equal(t, "https://www.kics.io/", sarif.Runs[0].Tool.Driver.ToolURI)
	require.Equal(t, "Keeping Infrastructure as Code Secure", sarif.Runs[0].Tool.Driver.ToolFullName)
	require.Equal(t, "1.1.2", sarif.Runs[0].Tool.Driver.ToolVersion)
}

type test struct {
	name string
	vq   []VulnerableQuery
	want SarifReport
}

var tests = []test{
	{
		name: "Should not create any rule",
		vq: []VulnerableQuery{
			{
				QueryName:        "test",
				QueryID:          "1",
				QueryDescription: "test description",
				QueryURI:         "https://www.test.com",
				Severity:         SeverityHigh,
				Files:            []VulnerableFile{},
			},
		},
		want: SarifReport{
			Runs: initRun(),
		},
	},
	{
		name: "Should create one occurrence",
		vq: []VulnerableQuery{
			{
				QueryName:        "test",
				QueryID:          "1",
				QueryDescription: "test description",
				QueryURI:         "https://www.test.com",
				Severity:         SeverityHigh,
				Files: []VulnerableFile{
					{KeyActualValue: "test", FileName: "test.json", Line: 1},
				},
			},
		},
		want: SarifReport{
			Runs: []sarifRun{
				{
					Tool: sarifTool{
						Driver: sarifDriver{
							Rules: []sarifRule{
								{
									RuleID:               "1",
									RuleName:             "test",
									RuleShortDescription: sarifMessage{Text: "test"},
									RuleFullDescription:  sarifMessage{Text: "test description"},
									DefaultConfiguration: sarifConfiguration{
										Level: "error",
									},
									HelpURI: "https://www.test.com",
									RuleRelationships: []sarifDescriptorRelationship{
										{
											Target: sarifDescriptorReference{
												ReferenceID:    "CAT000",
												ReferenceIndex: 0,
												ToolComponent:  targetTemplate.ToolComponent,
											},
										},
									},
								},
							},
						},
					},
					Results: []sarifResult{
						{
							ResultRuleID:    "1",
							ResultRuleIndex: 0,
							ResultKind:      "fail",
							ResultMessage:   sarifMessage{Text: "test"},
							ResultLocations: []sarifLocation{
								{
									PhysicalLocation: sarifPhysicalLocation{
										ArtifactLocation: sarifArtifactLocation{ArtifactURI: "test.json"},
										Region:           sarifRegion{StartLine: 1},
									},
								},
							},
						},
					},
				},
			},
		},
	},
	{
		name: "Should create multiple occurrence",
		vq: []VulnerableQuery{
			{
				QueryName:        "test",
				QueryID:          "1",
				QueryDescription: "test description",
				QueryURI:         "https://www.test.com",
				QueryCategory:    "test",
				Severity:         SeverityHigh,
				Files: []VulnerableFile{
					{KeyActualValue: "test", FileName: "test.json", Line: 1},
				},
			},
			{
				QueryName:        "test",
				QueryID:          "1",
				QueryDescription: "test description",
				QueryURI:         "https://www.test.com",
				QueryCategory:    "test",
				Severity:         SeverityHigh,
				Files: []VulnerableFile{
					{KeyActualValue: "test", FileName: "test1.json", Line: 1},
				},
			},
			{
				QueryName:        "test info",
				QueryID:          "2",
				QueryDescription: "test description",
				QueryURI:         "https://www.test.com",
				QueryCategory:    "test",
				Severity:         SeverityInfo,
				Files: []VulnerableFile{
					{KeyActualValue: "test", FileName: "test2.json", Line: 1},
				},
			},
		},
		want: SarifReport{
			Runs: []sarifRun{
				{
					Tool: sarifTool{
						Driver: sarifDriver{
							Rules: []sarifRule{
								{
									RuleID:               "1",
									RuleName:             "test",
									RuleShortDescription: sarifMessage{Text: "test"},
									RuleFullDescription:  sarifMessage{Text: "test description"},
									DefaultConfiguration: sarifConfiguration{
										Level: "error",
									},
									HelpURI: "https://www.test.com",
									RuleRelationships: []sarifDescriptorRelationship{
										{
											Target: sarifDescriptorReference{
												ReferenceID:    "CAT001",
												ReferenceIndex: 1,
												ToolComponent:  targetTemplate.ToolComponent,
											},
										},
									},
								},
								{
									RuleID:               "2",
									RuleName:             "test info",
									RuleShortDescription: sarifMessage{Text: "test"},
									RuleFullDescription:  sarifMessage{Text: "test description"},
									DefaultConfiguration: sarifConfiguration{
										Level: "none",
									},
									HelpURI: "https://www.test.com",
									RuleRelationships: []sarifDescriptorRelationship{
										{
											Target: sarifDescriptorReference{
												ReferenceID:    "CAT001",
												ReferenceIndex: 1,
												ToolComponent:  targetTemplate.ToolComponent,
											},
										},
									},
								},
							},
						},
					},
					Results: []sarifResult{
						{
							ResultRuleID:    "1",
							ResultRuleIndex: 0,
							ResultKind:      "fail",
							ResultMessage:   sarifMessage{Text: "test"},
							ResultLocations: []sarifLocation{
								{
									PhysicalLocation: sarifPhysicalLocation{
										ArtifactLocation: sarifArtifactLocation{ArtifactURI: "test.json"},
										Region:           sarifRegion{StartLine: 1},
									},
								},
							},
						},
						{
							ResultRuleID:    "1",
							ResultRuleIndex: 0,
							ResultKind:      "fail",
							ResultMessage:   sarifMessage{Text: "test"},
							ResultLocations: []sarifLocation{
								{
									PhysicalLocation: sarifPhysicalLocation{
										ArtifactLocation: sarifArtifactLocation{ArtifactURI: "test1.json"},
										Region:           sarifRegion{StartLine: 1},
									},
								},
							},
						},
						{
							ResultRuleID:    "2",
							ResultRuleIndex: 1,
							ResultKind:      "informational",
							ResultMessage:   sarifMessage{Text: "test"},
							ResultLocations: []sarifLocation{
								{
									PhysicalLocation: sarifPhysicalLocation{
										ArtifactLocation: sarifArtifactLocation{ArtifactURI: "test2.json"},
										Region:           sarifRegion{StartLine: 1},
									},
								},
							},
						},
					},
				},
			},
		},
	},
}

func TestBuildIssue(t *testing.T) {
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := NewSarifReport()
			for _, vq := range tt.vq {
				result.BuildIssue(&vq)
			}
			require.Equal(t, len(tt.want.Runs[0].Results), len(result.Runs[0].Results))
			require.Equal(t, len(tt.want.Runs[0].Tool.Driver.Rules), len(result.Runs[0].Tool.Driver.Rules))
			if len(tt.want.Runs[0].Tool.Driver.Rules) > 0 {
				require.Equal(t, tt.want.Runs[0].Tool.Driver.Rules[0], result.Runs[0].Tool.Driver.Rules[0])
				require.Equal(t, tt.want.Runs[0].Results[0], result.Runs[0].Results[0])
			}
		})
	}
}
