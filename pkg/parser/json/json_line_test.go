package json

import (
	"encoding/json"
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
)

func Test_initiateJSONLine(t *testing.T) {
	type args struct {
		doc []byte
	}
	tests := []struct {
		name string
		args args
		want *jsonLine
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := initiateJSONLine(tt.args.doc); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("initiateJSONLine() = %v, want %v", got, tt.want)
			}
		})
	}
}

func Test_jsonLineStruct_delimSetup(t *testing.T) {
	type fields struct {
		tmpParent   string
		pathArr     []string
		lastWasRune bool
		noremoveidx []string
		parent      string
	}
	type args struct {
		v json.Delim
	}
	tests := []struct {
		name   string
		fields fields
		args   args
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			j := &jsonLineStruct{
				tmpParent:   tt.fields.tmpParent,
				pathArr:     tt.fields.pathArr,
				lastWasRune: tt.fields.lastWasRune,
				noremoveidx: tt.fields.noremoveidx,
				parent:      tt.fields.parent,
			}
			j.delimSetup(tt.args.v)
		})
	}
}

func Test_jsonLineStruct_closeBrackets(t *testing.T) {
	type fields struct {
		tmpParent   string
		pathArr     []string
		lastWasRune bool
		noremoveidx []string
		parent      string
	}
	tests := []struct {
		name   string
		fields fields
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			j := &jsonLineStruct{
				tmpParent:   tt.fields.tmpParent,
				pathArr:     tt.fields.pathArr,
				lastWasRune: tt.fields.lastWasRune,
				noremoveidx: tt.fields.noremoveidx,
				parent:      tt.fields.parent,
			}
			j.closeBrackets()
		})
	}
}

func Test_jsonLine_setLineInfo(t *testing.T) {
	type fields struct {
		lineInfo map[string]model.Document
	}
	type args struct {
		doc map[string]interface{}
	}
	tests := []struct {
		name   string
		fields fields
		args   args
		want   map[string]interface{}
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			j := &jsonLine{
				lineInfo: tt.fields.lineInfo,
			}
			if got := j.setLineInfo(tt.args.doc); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("jsonLine.setLineInfo() = %v, want %v", got, tt.want)
			}
		})
	}
}

func Test_jsonLine_setLine(t *testing.T) {
	type fields struct {
		lineInfo map[string]model.Document
	}
	type args struct {
		val    map[string]interface{}
		def    int
		index  int
		father string
	}
	tests := []struct {
		name   string
		fields fields
		args   args
		want   map[string]model.LineObject
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			j := &jsonLine{
				lineInfo: tt.fields.lineInfo,
			}
			if got := j.setLine(tt.args.val, tt.args.def, tt.args.index, tt.args.father); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("jsonLine.setLine() = %v, want %v", got, tt.want)
			}
		})
	}
}

func Test_jsonLine_setSeqLines(t *testing.T) {
	type fields struct {
		lineInfo map[string]model.Document
	}
	type args struct {
		v       []interface{}
		line    interface{}
		father  string
		key     string
		lineArr []map[string]model.LineObject
		index   int
	}
	tests := []struct {
		name   string
		fields fields
		args   args
		want   []map[string]model.LineObject
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			j := &jsonLine{
				lineInfo: tt.fields.lineInfo,
			}
			if got := j.setSeqLines(tt.args.v, tt.args.line, tt.args.father, tt.args.key, tt.args.lineArr, tt.args.index); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("jsonLine.setSeqLines() = %v, want %v", got, tt.want)
			}
		})
	}
}
