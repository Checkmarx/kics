package model

import (
	"reflect"
	"testing"

	"gopkg.in/yaml.v3"
)

func TestDocument_UnmarshalYAML(t *testing.T) {
	type args struct {
		value *yaml.Node
	}
	tests := []struct {
		name    string
		m       *Document
		args    args
		wantErr bool
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if err := tt.m.UnmarshalYAML(tt.args.value); (err != nil) != tt.wantErr {
				t.Errorf("Document.UnmarshalYAML() error = %v, wantErr %v", err, tt.wantErr)
			}
		})
	}
}

func Test_unmarshal(t *testing.T) {
	type args struct {
		val *yaml.Node
	}
	tests := []struct {
		name string
		args args
		want interface{}
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := unmarshal(tt.args.val); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("unmarshal() = %v, want %v", got, tt.want)
			}
		})
	}
}

func Test_getLines(t *testing.T) {
	type args struct {
		val *yaml.Node
		def int
	}
	tests := []struct {
		name string
		args args
		want map[string]LineObject
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := getLines(tt.args.val, tt.args.def); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("getLines() = %v, want %v", got, tt.want)
			}
		})
	}
}

func Test_getSeqLines(t *testing.T) {
	type args struct {
		val *yaml.Node
		def int
	}
	tests := []struct {
		name string
		args args
		want map[string]LineObject
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := getSeqLines(tt.args.val, tt.args.def); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("getSeqLines() = %v, want %v", got, tt.want)
			}
		})
	}
}

func Test_scalarNodeResolver(t *testing.T) {
	type args struct {
		val *yaml.Node
	}
	tests := []struct {
		name string
		args args
		want interface{}
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := scalarNodeResolver(tt.args.val); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("scalarNodeResolver() = %v, want %v", got, tt.want)
			}
		})
	}
}

func Test_transformBoolScalarNode(t *testing.T) {
	type args struct {
		value string
	}
	tests := []struct {
		name string
		args args
		want bool
	}{
		// TODO: Add test cases.
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := transformBoolScalarNode(tt.args.value); got != tt.want {
				t.Errorf("transformBoolScalarNode() = %v, want %v", got, tt.want)
			}
		})
	}
}
