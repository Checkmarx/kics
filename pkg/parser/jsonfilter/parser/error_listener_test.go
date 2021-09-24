package parser

import (
	"reflect"
	"testing"

	"github.com/antlr/antlr4/runtime/Go/antlr"
	"github.com/stretchr/testify/require"
)

func TestNewCustomErrorListener(t *testing.T) {
	tests := []struct {
		name string
		want *CustomErrorListener
	}{
		{
			name: "test new custom error Listener",
			want: &CustomErrorListener{
				DefaultErrorListener: antlr.NewDefaultErrorListener(),
				Errors:               make([]*CustomSyntaxError, 0),
			},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := NewCustomErrorListener(); !reflect.DeepEqual(got, tt.want) {
				t.Errorf("NewCustomErrorListener() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestCustomErrorListener_HasErrors(t *testing.T) {
	type fields struct {
		DefaultErrorListener *antlr.DefaultErrorListener
		Errors               []*CustomSyntaxError
	}
	tests := []struct {
		name   string
		fields fields
		want   bool
	}{
		{
			name: "test custom error listener has 0 errors",
			fields: fields{
				DefaultErrorListener: antlr.NewDefaultErrorListener(),
				Errors:               make([]*CustomSyntaxError, 0),
			},
			want: false,
		},
		{
			name: "test custom error listener has 0 errors",
			fields: fields{
				DefaultErrorListener: antlr.NewDefaultErrorListener(),
				Errors:               make([]*CustomSyntaxError, 1),
			},
			want: true,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			c := &CustomErrorListener{
				DefaultErrorListener: tt.fields.DefaultErrorListener,
				Errors:               tt.fields.Errors,
			}
			if got := c.HasErrors(); got != tt.want {
				t.Errorf("CustomErrorListener.HasErrors() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestCustomErrorListener_SyntaxError(t *testing.T) {
	type fields struct {
		DefaultErrorListener *antlr.DefaultErrorListener
		Errors               []*CustomSyntaxError
	}
	type args struct {
		recognizer      antlr.Recognizer
		offendingSymbol interface{}
		line            int
		column          int
		msg             string
		e               antlr.RecognitionException
	}
	tests := []struct {
		name   string
		fields fields
		args   args
	}{
		{
			name: "custom error listen syntax error",
			fields: fields{
				DefaultErrorListener: antlr.NewDefaultErrorListener(),
				Errors:               make([]*CustomSyntaxError, 0),
			},
			args: args{
				recognizer:      nil,
				offendingSymbol: nil,
				line:            1,
				column:          1,
				msg:             "this is an error",
				e:               nil,
			},
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			c := &CustomErrorListener{
				DefaultErrorListener: tt.fields.DefaultErrorListener,
				Errors:               tt.fields.Errors,
			}
			c.SyntaxError(tt.args.recognizer, tt.args.offendingSymbol, tt.args.line, tt.args.column, tt.args.msg, tt.args.e)
			require.True(t, c.HasErrors())
		})
	}
}
