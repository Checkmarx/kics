package model

import (
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/internal/constants"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/test"
)

// TestNewSonarQubeRepory tests the NewSonarQubeRepory function
func TestNewSonarQubeRepory(t *testing.T) {
	tests := []struct {
		name string
		want *SonarQubeReportBuilder
	}{
		{
			name: "New SonarQubeReportBuilder",
			want: &SonarQubeReportBuilder{
				version: "KICS " + constants.Version,
				report: &SonarQubeReport{
					Issues: make([]Issue, 0),
				},
			},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := NewSonarQubeRepory(); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("NewSonarQubeRepory() = %v, want %v", got, tt.want)
			}
		})
	}
}

// TestSonarQubeReportBuilder_BuildReport tests the BuildReport method of SonarQubeReportBuilder
func TestSonarQubeReportBuilder_BuildReport(t *testing.T) {
	type fields struct {
		version string
		report  *SonarQubeReport
	}
	type args struct {
		summary *model.Summary
	}
	tests := []struct {
		name   string
		fields fields
		args   args
		want   *SonarQubeReport
	}{
		{
			name: "Build Report",
			fields: fields{
				version: "KICS " + constants.Version,
				report: &SonarQubeReport{
					Issues: make([]Issue, 0),
				},
			},
			args: args{
				summary: &test.SummaryMock,
			},
			want: &SonarQubeReport{
				Issues: []Issue{
					{
						EngineID: "KICS " + constants.Version,
						RuleID:   "de7f5e83-da88-4046-871f-ea18504b1d43",
						Severity: "CRITICAL",
						Type:     "",
						PrimaryLocation: &Location{
							Message:  "ALB protocol is HTTP Description",
							FilePath: "positive.tf",
							TextRange: &Range{
								StartLine: 25,
							},
						},
						SecondaryLocations: []*Location{
							{
								Message:  "ALB protocol is HTTP Description",
								FilePath: "positive.tf",
								TextRange: &Range{
									StartLine: 19,
								},
							},
						},
					},
				},
			},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			s := &SonarQubeReportBuilder{
				version: tt.fields.version,
				report:  tt.fields.report,
			}
			if got := s.BuildReport(tt.args.summary); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("SonarQubeReportBuilder.BuildReport() = %v, want %v", got, tt.want)
			}
		})
	}
}
