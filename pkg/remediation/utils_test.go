package remediation

import (
	"os"
	"path/filepath"
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/utils"
	"github.com/stretchr/testify/require"
)

func Test_GetRemediationSets(t *testing.T) {

	filePath := filepath.Join("..", "..", "test", "fixtures", "kics_auto_remediation", "terraform.tf")

	file1 := &File{
		FilePath:        filePath,
		Line:            1,
		Remediation:     "minimum_password_length = 14",
		RemediationType: "addition",
		SimilarityID:    "f282fa13cf5e4ffd4bbb0ee2059f8d0240edcd2ca54b3bb71633145d961de5ce",
		SearchKey:       "alicloud_ram_account_password_policy[corporate1]",
		ExpectedValue:   "'minimum_password_length' is defined and set to 14 or above ",
		ActualValue:     "'minimum_password_length' is not defined",
	}

	file2 := &File{
		FilePath:        filePath,
		Line:            5,
		Remediation:     "{\"after\":\"true\",\"before\":\"false\"}",
		RemediationType: "replacement",
		SimilarityID:    "87abbee5d0ec977ba193371c702dca2c040ea902d2e606806a63b66119ff89bc",
		SearchKey:       "resource.alicloud_ram_account_password_policy[corporate1].require_symbols",
		ExpectedValue:   "resource.alicloud_ram_account_password_policy[corporate1].require_symbols is set to 'true'",
		ActualValue:     "resource.alicloud_ram_account_password_policy[corporate1].require_symbols is configured as 'false'",
	}

	query1 := &Query{
		Files:   []File{*file1},
		QueryID: "a9dfec39-a740-4105-bbd6-721ba163c053",
	}

	query2 := &Query{
		Files:   []File{*file2},
		QueryID: "41a38329-d81b-4be4-aef4-55b2615d3282",
	}

	res := &Report{
		Queries: []Query{*query1, *query2},
	}

	replacement := &Remediation{
		Line:          5,
		Remediation:   "{\"after\":\"true\",\"before\":\"false\"}",
		SimilarityID:  "87abbee5d0ec977ba193371c702dca2c040ea902d2e606806a63b66119ff89bc",
		QueryID:       "41a38329-d81b-4be4-aef4-55b2615d3282",
		SearchKey:     "resource.alicloud_ram_account_password_policy[corporate1].require_symbols",
		ExpectedValue: "resource.alicloud_ram_account_password_policy[corporate1].require_symbols is set to 'true'",
		ActualValue:   "resource.alicloud_ram_account_password_policy[corporate1].require_symbols is configured as 'false'",
	}

	addition := &Remediation{
		Line:          1,
		Remediation:   "minimum_password_length = 14",
		SimilarityID:  "f282fa13cf5e4ffd4bbb0ee2059f8d0240edcd2ca54b3bb71633145d961de5ce",
		QueryID:       "a9dfec39-a740-4105-bbd6-721ba163c053",
		SearchKey:     "alicloud_ram_account_password_policy[corporate1]",
		ExpectedValue: "'minimum_password_length' is defined and set to 14 or above ",
		ActualValue:   "'minimum_password_length' is not defined",
	}

	var r, r2 Set

	r.Replacement = append(r.Replacement, *replacement)
	r.Addition = append(r.Addition, *addition)

	want := make(map[string]interface{})
	want[filePath] = r

	r2.Replacement = append(r2.Replacement, *replacement)
	want2 := make(map[string]interface{})
	want2[filePath] = r2

	type args struct {
		res     *Report
		include []string
	}

	tests := []struct {
		name                      string
		args                      args
		selectedRemediationNumber int
		want                      map[string]interface{}
	}{
		{
			name: "include all similarityID",
			args: args{
				res:     res,
				include: []string{"all"},
			},
			want:                      want,
			selectedRemediationNumber: 2,
		},
		{
			name: "include specific similarityID",
			args: args{
				res:     res,
				include: []string{"87abbee5d0ec977ba193371c702dca2c040ea902d2e606806a63b66119ff89bc"},
			},
			want:                      want2,
			selectedRemediationNumber: 1,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			s := &Summary{
				SelectedRemediationNumber:   0,
				ActualRemediationDoneNumber: 0,
			}
			if got := s.GetRemediationSets(*tt.args.res, tt.args.include); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("GetRemediationSets() = %v, want %v", got, tt.want)
			}
			require.Equal(t, s.SelectedRemediationNumber, tt.selectedRemediationNumber)
		})
	}
}

func Test_CreateTempFile(t *testing.T) {
	filePathCopyFrom := filepath.Join("..", "..", "test", "fixtures", "kics_auto_remediation", "terraform.tf")

	tmpFile := filepath.Join(os.TempDir(), "temporary-remediation-"+utils.NextRandom()+filepath.Ext(filePathCopyFrom))

	tests := []struct {
		name             string
		filePathCopyFrom string
		tmpFile          string
		want             string
	}{
		{
			name:             "create a temporary file with same content as the input",
			filePathCopyFrom: filePathCopyFrom,
			tmpFile:          tmpFile,
			want:             tmpFile,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := CreateTempFile(tt.filePathCopyFrom, tt.tmpFile)
			require.Equal(t, got, tt.want)
		})
	}
}
