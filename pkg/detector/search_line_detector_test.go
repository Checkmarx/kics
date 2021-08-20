package detector

import (
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
)

func TestGetLineBySearchLine(t *testing.T) {
	type args struct {
		pathComponents []string
		file           *model.FileMetadata
	}
	tests := []struct {
		name    string
		args    args
		want    int
		wantErr bool
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := GetLineBySearchLine(tt.args.pathComponents, tt.args.file)
			if (err != nil) != tt.wantErr {
				t.Errorf("GetLineBySearchLine() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if got != tt.want {
				t.Errorf("GetLineBySearchLine() = %v, want %v", got, tt.want)
			}
		})
	}
}

func Test_searchLineDetector_preparePath(t *testing.T) {
	type fields struct {
		content           []byte
		resolvedPath      string
		resolvedArrayPath string
		targetObj         string
	}
	type args struct {
		pathItems []string
	}
	tests := []struct {
		name   string
		fields fields
		args   args
		want   int
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			d := &searchLineDetector{
				content:           tt.fields.content,
				resolvedPath:      tt.fields.resolvedPath,
				resolvedArrayPath: tt.fields.resolvedArrayPath,
				targetObj:         tt.fields.targetObj,
			}
			if got := d.preparePath(tt.args.pathItems); got != tt.want {
				t.Errorf("searchLineDetector.preparePath() = %v, want %v", got, tt.want)
			}
		})
	}
}

func Test_searchLineDetector_getResult(t *testing.T) {
	type fields struct {
		content           []byte
		resolvedPath      string
		resolvedArrayPath string
		targetObj         string
	}
	tests := []struct {
		name   string
		fields fields
		want   int
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			d := &searchLineDetector{
				content:           tt.fields.content,
				resolvedPath:      tt.fields.resolvedPath,
				resolvedArrayPath: tt.fields.resolvedArrayPath,
				targetObj:         tt.fields.targetObj,
			}
			if got := d.getResult(); got != tt.want {
				t.Errorf("searchLineDetector.getResult() = %v, want %v", got, tt.want)
			}
		})
	}
}
