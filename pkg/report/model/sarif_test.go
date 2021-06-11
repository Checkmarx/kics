package model

import (
	"testing"

	"github.com/Checkmarx/kics/internal/constants"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/stretchr/testify/require"
)

// TestNewSarifReport tests if creates a sarif report correctly
func TestNewSarifReport(t *testing.T) {
	sarif := NewSarifReport().(*sarifReport)
	require.Equal(t, "https://raw.githubusercontent.com/oasis-tcs/sarif-spec/master/Schemata/sarif-schema-2.1.0.json", sarif.Schema)
	require.Equal(t, "2.1.0", sarif.SarifVersion)
	require.Equal(t, "KICS", sarif.Runs[0].Tool.Driver.ToolName)
	require.Equal(t, constants.URL, sarif.Runs[0].Tool.Driver.ToolURI)
	require.Equal(t, constants.Fullname, sarif.Runs[0].Tool.Driver.ToolFullName)
	require.Equal(t, constants.Version, sarif.Runs[0].Tool.Driver.ToolVersion)
}

type sarifTest struct {
	name string
	vq   []model.VulnerableQuery
	want sarifReport
}

var sarifTests = []sarifTest{
	{
		name: "Should not create any rule",
		vq: []model.VulnerableQuery{
			{
				QueryName:   "test",
				QueryID:     "1",
				Description: "test description",
				QueryURI:    "https://www.test.com",
				Severity:    model.SeverityHigh,
				Files:       []model.VulnerableFile{},
			},
		},
		want: sarifReport{
			Runs: initSarifRun(),
		},
	},
	{
		name: "Should create one occurrence",
		vq: []model.VulnerableQuery{
			{
				QueryName:   "test",
				QueryID:     "1",
				Description: "test description",
				QueryURI:    "https://www.test.com",
				Severity:    model.SeverityHigh,
				Files: []model.VulnerableFile{
					{KeyActualValue: "test", FileName: "test.json", Line: 1},
				},
			},
		},
		want: sarifReport{
			Runs: []SarifRun{
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
										ArtifactLocation: sarifArtifactLocation{ArtifactURI: ""},
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
		vq: []model.VulnerableQuery{
			{
				QueryName:   "test",
				QueryID:     "1",
				Description: "test description",
				QueryURI:    "https://www.test.com",
				Category:    "test",
				Severity:    model.SeverityHigh,
				Files: []model.VulnerableFile{
					{KeyActualValue: "test", FileName: "", Line: 1},
				},
			},
			{
				QueryName:   "test",
				QueryID:     "1",
				Description: "test description",
				QueryURI:    "https://www.test.com",
				Category:    "test",
				Severity:    model.SeverityHigh,
				Files: []model.VulnerableFile{
					{KeyActualValue: "test", FileName: "", Line: 1},
				},
			},
			{
				QueryName:   "test info",
				QueryID:     "2",
				Description: "test description",
				QueryURI:    "https://www.test.com",
				Category:    "test",
				Severity:    model.SeverityInfo,
				Files: []model.VulnerableFile{
					{KeyActualValue: "test", FileName: "", Line: 1},
				},
			},
		},
		want: sarifReport{
			Runs: []SarifRun{
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
										ArtifactLocation: sarifArtifactLocation{ArtifactURI: ""},
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
										ArtifactLocation: sarifArtifactLocation{ArtifactURI: ""},
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
										ArtifactLocation: sarifArtifactLocation{ArtifactURI: ""},
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

func TestBuildSarifIssue(t *testing.T) {
	for _, tt := range sarifTests {
		t.Run(tt.name, func(t *testing.T) {
			result := NewSarifReport().(*sarifReport)
			for _, vq := range tt.vq {
				result.BuildSarifIssue(&vq)
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
