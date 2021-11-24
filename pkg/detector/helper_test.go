package detector

import (
	"fmt"
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/test"
	"github.com/stretchr/testify/require"
)

// TestSelectLineWithMinimumDistance tests the functions [SelectLineWithMinimumDistance()] and all the methods called by them
func TestSelectLineWithMinimumDistance(t *testing.T) {
	values := []struct {
		distances      map[int]int
		startingFrom   int
		expectedResult int
	}{
		{
			distances: map[int]int{
				12: 0,
			},
			startingFrom:   0,
			expectedResult: 12,
		},
		{
			distances: map[int]int{
				12: 0,
				24: 0,
			},
			startingFrom:   11,
			expectedResult: 12,
		},
		{
			distances: map[int]int{
				1: 26,
				2: 5,
				3: 0,
			},
			startingFrom:   1,
			expectedResult: 3,
		},
	}

	for i, testCase := range values {
		t.Run(fmt.Sprintf("selectLineWithMinimumDistance-%d", i), func(t *testing.T) {
			v := SelectLineWithMinimumDistance(testCase.distances, testCase.startingFrom)
			require.Equal(t, testCase.expectedResult, v)
		})
	}
}

// TestGetBracketValues tests the functions [getBracketValues()] and all the methods called by them
func TestGetBracketValues(t *testing.T) {
	type args struct {
		expr string
	}
	tests := []struct {
		name string
		args args
		want [][]string
	}{
		{
			name: "no_brackets",
			args: args{
				expr: "password",
			},
			want: [][]string{
				{
					"{{password}}",
					"password",
				},
			},
		},
		{
			name: "single_brackets",
			args: args{
				expr: "{{password}}",
			},
			want: [][]string{
				{
					"{{password}}",
					"password",
				},
			},
		},
		{
			name: "double_brackets",
			args: args{
				expr: "{{ {{password}} }}",
			},
			want: [][]string{
				{
					"{{ {{password}} }}",
					" {{password}} ",
				},
			},
		},
		{
			name: "multiple_brackets",
			args: args{
				expr: "FROM={{open-jdk}}.{{ {{password}} }}",
			},
			want: [][]string{
				{
					"{{open-jdk}}",
					"open-jdk",
				},
				{
					"{{ {{password}} }}",
					" {{password}} ",
				},
			},
		},
		{
			name: "single_brackets",
			args: args{
				expr: "paths.{{user/{id}}}",
			},
			want: [][]string{
				{
					"{{user/{id}}}",
					"user/{id}",
				},
			},
		},
		{
			name: "interpolated_brackets",
			args: args{
				expr: "name={{interpolated {{ interpolated.brackets }} brackets {{ interpolated.brackets }}}}.{{interpolated.brackets}}",
			},
			want: [][]string{
				{
					"{{interpolated {{ interpolated.brackets }} brackets {{ interpolated.brackets }}}}",
					"interpolated {{ interpolated.brackets }} brackets {{ interpolated.brackets }}",
				},
				{
					"{{interpolated.brackets}}",
					"interpolated.brackets",
				},
			},
		},
	}

	for _, tt := range tests {
		var got [][]string
		t.Run(tt.name, func(t *testing.T) {
			got = GetBracketValues(tt.args.expr, got, "")
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("DefaultVulnerabilityBuilder() = %v, want %v", got, tt.want)
			}
		})
	}
}

// TestGetAdjacents tests the functions [GetAdjacents()] and all the methods called by them
func TestGetAdjacents(t *testing.T) { //nolint
	type args struct {
		idx   int
		adj   int
		lines []string
	}
	tests := []struct {
		name string
		args args
		want []model.CodeLine
	}{
		{
			name: "test_start_of_file",
			args: args{
				idx: 0,
				adj: 3,
				lines: []string{
					"firstline",
					"secondline",
					"thirdline",
					"forthline",
				},
			},
			want: []model.CodeLine{
				{
					Position: 1,
					Line:     "firstline",
				},
				{
					Position: 2,
					Line:     "secondline",
				},
				{
					Position: 3,
					Line:     "thirdline",
				},
			},
		},
		{
			name: "test_end_of_file",
			args: args{
				idx: 3,
				adj: 3,
				lines: []string{
					"firstline",
					"secondline",
					"thirdline",
					"forthline",
				},
			},
			want: []model.CodeLine{
				{
					Position: 3,
					Line:     "secondline",
				},
				{
					Position: 4,
					Line:     "thirdline",
				},
				{
					Position: 5,
					Line:     "forthline",
				},
			},
		},
		{
			name: "test_midle_of_file",
			args: args{
				idx: 1,
				adj: 3,
				lines: []string{
					"firstline",
					"secondline",
					"thirdline",
					"forthline",
				},
			},
			want: []model.CodeLine{
				{
					Position: 1,
					Line:     "firstline",
				},
				{
					Position: 2,
					Line:     "secondline",
				},
				{
					Position: 3,
					Line:     "thirdline",
				},
			},
		},
		{
			name: "test_even_adj",
			args: args{
				idx: 1,
				adj: 2,
				lines: []string{
					"firstline",
					"secondline",
					"thirdline",
					"forthline",
				},
			},
			want: []model.CodeLine{
				{
					Position: 2,
					Line:     "secondline",
				},
				{
					Position: 3,
					Line:     "thirdline",
				},
			},
		},
		{
			name: "test_even_adj_first_line",
			args: args{
				idx: 0,
				adj: 2,
				lines: []string{
					"firstline",
					"secondline",
					"thirdline",
					"forthline",
				},
			},
			want: []model.CodeLine{
				{
					Position: 1,
					Line:     "firstline",
				},
				{
					Position: 2,
					Line:     "secondline",
				},
			},
		},
		{
			name: "test_one_adj",
			args: args{
				idx: 3,
				adj: 1,
				lines: []string{
					"firstline",
					"secondline",
					"thirdline",
					"forthline",
				},
			},
			want: []model.CodeLine{
				{
					Position: 4,
					Line:     "forthline",
				},
			},
		},
		{
			name: "test_adj_bigger_than_file",
			args: args{
				idx: 3,
				adj: 5,
				lines: []string{
					"firstline",
					"secondline",
					"thirdline",
					"forthline",
				},
			},
			want: []model.CodeLine{
				{
					Position: 1,
					Line:     "firstline",
				},
				{
					Position: 2,
					Line:     "secondline",
				},
				{
					Position: 3,
					Line:     "thirdline",
				},
				{
					Position: 4,
					Line:     "forthline",
				},
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := GetAdjacentVulnLines(tt.args.idx, tt.args.adj, tt.args.lines)
			gotStrVulnerabilities, err := test.StringifyStruct(got)
			require.Nil(t, err)
			wantStrVulnerabilities, err := test.StringifyStruct(tt.want)
			require.Nil(t, err)
			if !reflect.DeepEqual(gotStrVulnerabilities, wantStrVulnerabilities) {
				t.Errorf("getAdjacents() = %v, want = %v", gotStrVulnerabilities, wantStrVulnerabilities)
			}
		})
	}
}
