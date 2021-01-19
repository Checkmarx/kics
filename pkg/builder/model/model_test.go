package model

import (
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
)

func TestCondition_Attr(t *testing.T) {
	type fields struct {
		Line       int
		IssueType  model.IssueType
		Path       []PathItem
		Value      interface{}
		Attributes map[string]interface{}
	}
	type args struct {
		name string
	}
	tests := []struct {
		name   string
		fields fields
		args   args
		want   interface{}
		want1  bool
	}{
		{
			name: "condition_attr",
			fields: fields{
				Line:      1,
				IssueType: "MissingAttribute",
				Path:      []PathItem{},
				Value:     nil,
				Attributes: map[string]interface{}{
					"test": "test2",
				},
			},
			args: args{
				name: "test",
			},
			want:  "test2",
			want1: true,
		},
		{
			name: "condition_attr_error",
			fields: fields{
				Line:      1,
				IssueType: "MissingAttribute",
				Path:      []PathItem{},
				Value:     nil,
				Attributes: map[string]interface{}{
					"test": "test2",
				},
			},
			args: args{
				name: "test3",
			},
			want:  nil,
			want1: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			c := Condition{
				Line:       tt.fields.Line,
				IssueType:  tt.fields.IssueType,
				Path:       tt.fields.Path,
				Value:      tt.fields.Value,
				Attributes: tt.fields.Attributes,
			}
			got, got1 := c.Attr(tt.args.name)
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("Condition.Attr() got = %v, want %v", got, tt.want)
			}
			if got1 != tt.want1 {
				t.Errorf("Condition.Attr() got1 = %v, want %v", got1, tt.want1)
			}
		})
	}
}

func TestCondition_AttrAsString(t *testing.T) {
	type fields struct {
		Line       int
		IssueType  model.IssueType
		Path       []PathItem
		Value      interface{}
		Attributes map[string]interface{}
	}
	type args struct {
		name string
	}
	tests := []struct {
		name   string
		fields fields
		args   args
		want   string
		want1  bool
	}{
		{
			name: "condition_attr",
			fields: fields{
				Line:      1,
				IssueType: "MissingAttribute",
				Path:      []PathItem{},
				Value:     nil,
				Attributes: map[string]interface{}{
					"test": "test2",
				},
			},
			args: args{
				name: "test",
			},
			want:  "test2",
			want1: true,
		},
		{
			name: "condition_attr_error",
			fields: fields{
				Line:      1,
				IssueType: "MissingAttribute",
				Path:      []PathItem{},
				Value:     nil,
				Attributes: map[string]interface{}{
					"test": "test2",
				},
			},
			args: args{
				name: "test3",
			},
			want:  "",
			want1: false,
		},
		{
			name: "condition_attr_string_error",
			fields: fields{
				Line:      1,
				IssueType: "MissingAttribute",
				Path:      []PathItem{},
				Value:     nil,
				Attributes: map[string]interface{}{
					"test": nil,
				},
			},
			args: args{
				name: "test",
			},
			want:  "",
			want1: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			c := Condition{
				Line:       tt.fields.Line,
				IssueType:  tt.fields.IssueType,
				Path:       tt.fields.Path,
				Value:      tt.fields.Value,
				Attributes: tt.fields.Attributes,
			}
			got, got1 := c.AttrAsString(tt.args.name)
			if got != tt.want {
				t.Errorf("Condition.AttrAsString() got = %v, want %v", got, tt.want)
			}
			if got1 != tt.want1 {
				t.Errorf("Condition.AttrAsString() got1 = %v, want %v", got1, tt.want1)
			}
		})
	}
}
