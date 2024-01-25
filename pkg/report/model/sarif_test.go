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
	vq   []model.QueryResult
	want sarifReport
}

var sarifTests = []sarifTest{
	{
		name: "Should not create any rule",
		vq: []model.QueryResult{
			{
				QueryName:   "test",
				QueryID:     "1",
				Description: "test description",
				QueryURI:    "https://www.test.com",
				Severity:    model.SeverityHigh,
				Files:       []model.VulnerableFile{},
				CWE:         "",
			},
		},
		want: sarifReport{
			Runs: initSarifRun(),
		},
	},
	{
		name: "Should create one occurrence with valid startLine",
		vq: []model.QueryResult{
			{
				QueryName:   "test",
				QueryID:     "1",
				Description: "test description",
				QueryURI:    "https://www.test.com",
				Severity:    model.SeverityHigh,
				Files: []model.VulnerableFile{
					{KeyActualValue: "test", FileName: "test.json", Line: -1},
				},
				CWE: "",
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
									Relationships: []sarifRelationship{
										{
											Relationship: sarifDescriptorReference{
												ReferenceID:    "CAT000",
												ReferenceIndex: 0,
												ToolComponent: sarifComponentReference{
													ComponentReferenceGUID:  "58cdcc6f-fe41-4724-bfb3-131a93df4c3f",
													ComponentReferenceName:  "Categories",
													ComponentReferenceIndex: targetTemplate.ToolComponent.ComponentReferenceIndex,
												},
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
							ResultMessage:   sarifMessage{Text: "test", MessageProperties: sarifProperties{"platform": ""}},
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
		vq: []model.QueryResult{
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
				CWE: "",
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
				CWE: "22",
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
									Relationships: []sarifRelationship{
										{
											Relationship: sarifDescriptorReference{
												ReferenceID:    "CAT000",
												ReferenceIndex: 0,
												ToolComponent: sarifComponentReference{
													ComponentReferenceGUID:  "58cdcc6f-fe41-4724-bfb3-131a93df4c3f",
													ComponentReferenceName:  "Categories",
													ComponentReferenceIndex: targetTemplate.ToolComponent.ComponentReferenceIndex,
												},
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
									Relationships: []sarifRelationship{
										{
											Relationship: sarifDescriptorReference{
												ReferenceID:    "CAT000",
												ReferenceIndex: 0,
												ToolComponent: sarifComponentReference{
													ComponentReferenceGUID:  "58cdcc6f-fe41-4724-bfb3-131a93df4c3f",
													ComponentReferenceName:  "Categories",
													ComponentReferenceIndex: targetTemplate.ToolComponent.ComponentReferenceIndex,
												},
											},
										},
										{
											Relationship: sarifDescriptorReference{
												ReferenceID:   "22",
												ReferenceGUID: "1489b0c4-d7ce-4d31-af66-6382a01202e3",
												ToolComponent: sarifComponentReference{
													ComponentReferenceGUID:  "1489b0c4-d7ce-4d31-af66-6382a01202e3",
													ComponentReferenceName:  "CWE",
													ComponentReferenceIndex: targetTemplate.ToolComponent.ComponentReferenceIndex,
												},
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
							ResultMessage: sarifMessage{
								Text:              "test",
								MessageProperties: sarifProperties{"platform": ""},
							},
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
							ResultMessage: sarifMessage{
								Text:              "test",
								MessageProperties: sarifProperties{"platform": ""},
							},
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
					Taxonomies: []sarifTaxonomy{
						{
							TaxonomyGUID:             "58cdcc6f-fe41-4724-bfb3-131a93df4c3f",
							TaxonomyName:             "Categories",
							TaxonomyFullDescription:  sarifMessage{Text: "Category is not defined"},
							TaxonomyShortDescription: sarifMessage{Text: "Category is not defined"},
							TaxonomyDefinitions: []taxonomyDefinitions{
								{
									DefinitionGUID:             "",
									DefinitionName:             "Undefined Category",
									DefinitionID:               "CAT000",
									DefinitionShortDescription: cweMessage{Text: "Category is not defined"},
									DefinitionFullDescription:  cweMessage{Text: "Category is not defined"},
									HelpURI:                    "",
								},
							},
						},
						{
							TaxonomyGUID:                              "1489b0c4-d7ce-4d31-af66-6382a01202e3",
							TaxonomyName:                              "CWE",
							TaxonomyFullDescription:                   sarifMessage{Text: "The MITRE Common Weakness Enumeration"},
							TaxonomyShortDescription:                  sarifMessage{Text: "The MITRE Common Weakness Enumeration"},
							TaxonomyDownloadURI:                       "https://cwe.mitre.org/data/published/cwe_v4.13.pdf",
							TaxonomyIsComprehensive:                   true,
							TaxonomyLanguage:                          "en",
							TaxonomyMinRequiredLocDataSemanticVersion: "4.13",
							TaxonomyOrganization:                      "MITRE",
							TaxonomyRealeaseDateUtc:                   "2023-10-26",
							TaxonomyDefinitions: []taxonomyDefinitions{
								{
									DefinitionGUID:             "1489b0c4-d7ce-4d31-af66-6382a01202e3",
									DefinitionID:               "22",
									DefinitionShortDescription: cweMessage{Text: "The product uses external input to construct a pathname that is intended to identify a file or directory that is located underneath a restricted parent directory, but the product does not properly neutralize special elements within the pathname that can cause the pathname to resolve to a location that is outside of the restricted directory."},
									DefinitionFullDescription:  cweMessage{Text: "Many file operations are intended to take place within a restricted directory. By using special elements such as .. and / separators, attackers can escape outside of the restricted location to access files or directories that are elsewhere on the system. One of the most common special elements is the ../ sequence, which in most modern operating systems is interpreted as the parent directory of the current location. This is referred to as relative path traversal. Path traversal also covers the use of absolute pathnames such as /usr/local/bin, which may also be useful in accessing unexpected files. This is referred to as absolute path traversal. In many programming languages, the injection of a null byte (the 0 or NUL) may allow an attacker to truncate a generated filename to widen the scope of attack. For example, the product may add .txt to any pathname, thus limiting the attacker to text files, but a null injection may effectively remove this restriction."},
									HelpURI:                    "https://cwe.mitre.org/data/definitions/22.html",
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
				if len(result.Runs[0].Tool.Driver.Rules[0].Relationships) > 0 {
					if tt.vq[0].CWE == "" {
						// if CWE is empty, the result should expect one less relationship (only categories present)
						require.Equal(t, len(tt.want.Runs[0].Tool.Driver.Rules[0].Relationships), len(result.Runs[0].Tool.Driver.Rules[0].Relationships))
					} else {
						// if CWE is not empty, the relationships should be the expected number of relationships
						require.Equal(t, tt.want.Runs[0].Tool.Driver.Rules[0].Relationships, result.Runs[0].Tool.Driver.Rules[0].Relationships)
					}
				}
				require.Equal(t, tt.want.Runs[0].Results[0], result.Runs[0].Results[0])
			}
		})
	}
}
