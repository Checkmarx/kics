package model

import (
	"os"
	"testing"

	"github.com/Checkmarx/kics/v2/internal/constants"
	"github.com/Checkmarx/kics/v2/pkg/model"
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
								{},
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

func TestInitCweCategories(t *testing.T) {
	cweIDs := []string{"22", "41", "203", "1188"}
	guids := map[string]string{"22": "1489b0c4-d7ce-4d31-af66-6382a01202e3", "41": "1489b0c4-d7ce-4d31-af66-6382a01202e4", "203": "1489b0c4-d7ce-4d31-af66-6382a01202e5", "1188": "1489b0c4-d7ce-4d31-af66-6382a01202e6"}
	expectedShortDescription22 := "The product uses external input to construct a pathname that is intended to identify a file or directory that is located underneath a restricted parent directory, but the product does not properly neutralize special elements within the pathname that can cause the pathname to resolve to a location that is outside of the restricted directory."
	expectedShortDescription41 := "The product is vulnerable to file system contents disclosure through path equivalence. Path equivalence involves the use of special characters in file and directory names. The associated manipulations are intended to generate multiple names for the same object."
	expectedShortDescription203 := "The product behaves differently or sends different responses under different circumstances in a way that is observable to an unauthorized actor, which exposes security-relevant information about the state of the product, such as whether a particular operation was successful or not."
	expectedShortDescription1188 := "The product initializes or sets a resource with a default that is intended to be changed by the administrator, but the default is not secure."

	currentDir, err := os.Getwd()
	if err != nil {
		t.Fatal(err)
	}

	defer os.Chdir(currentDir) // Change back to the original working directory when done

	for i := 0; i < 3; i++ {
		if err := os.Chdir(".."); err != nil {
			t.Fatal(err)
		}
	}

	result := initCweCategories(cweIDs, guids)

	require.Len(t, result, 4)
	// Test for CWE-ID 22
	require.Equal(t, "22", result[0].DefinitionID)
	require.Equal(t, "1489b0c4-d7ce-4d31-af66-6382a01202e3", result[0].DefinitionGUID)
	require.Equal(t, expectedShortDescription22, result[0].DefinitionShortDescription.Text)
	require.Equal(t, "https://cwe.mitre.org/data/definitions/22.html", result[0].HelpURI)
	// Test for CWE-ID 41
	require.Equal(t, "41", result[1].DefinitionID)
	require.Equal(t, "1489b0c4-d7ce-4d31-af66-6382a01202e4", result[1].DefinitionGUID)
	require.Equal(t, expectedShortDescription41, result[1].DefinitionShortDescription.Text)
	require.Equal(t, "https://cwe.mitre.org/data/definitions/41.html", result[1].HelpURI)
	// Test for CWE-ID 203
	require.Equal(t, "203", result[2].DefinitionID)
	require.Equal(t, "1489b0c4-d7ce-4d31-af66-6382a01202e5", result[2].DefinitionGUID)
	require.Equal(t, expectedShortDescription203, result[2].DefinitionShortDescription.Text)
	require.Equal(t, "https://cwe.mitre.org/data/definitions/203.html", result[2].HelpURI)
	// Test for CWE-ID 1188
	require.Equal(t, "1188", result[3].DefinitionID)
	require.Equal(t, "1489b0c4-d7ce-4d31-af66-6382a01202e6", result[3].DefinitionGUID)
	require.Equal(t, expectedShortDescription1188, result[3].DefinitionShortDescription.Text)
	require.Equal(t, "https://cwe.mitre.org/data/definitions/1188.html", result[3].HelpURI)
}
