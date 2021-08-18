package progress

import (
	"sync"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestInteger_Build(t *testing.T) {
	type args struct {
		label           string
		total           int
		wg              *sync.WaitGroup
		progressChannel chan int64
	}
	type fields struct {
		silent     bool
		ci         bool
		silentFlag bool
	}
	tests := []struct {
		name   string
		args   args
		fields fields
	}{
		{
			name: "test_string",
			args: args{
				label:           "test",
				total:           10,
				wg:              &sync.WaitGroup{},
				progressChannel: make(chan int64),
			},
			fields: fields{
				silent:     false,
				ci:         false,
				silentFlag: false,
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			pbarBuilder := InitializePbBuilder(tt.fields.silent, tt.fields.ci, tt.fields.silentFlag)
			got := pbarBuilder.BuildCounter(tt.args.label, tt.args.total, tt.args.wg, tt.args.progressChannel)
			require.NotNil(t, got)
		})
	}
}

func TestInteger_BuildCircle(t *testing.T) {
	type args struct {
		label string
	}
	type fields struct {
		silent     bool
		ci         bool
		silentFlag bool
	}
	tests := []struct {
		name   string
		args   args
		fields fields
	}{
		{
			name: "test_string",
			args: args{
				label: "test",
			},
			fields: fields{
				silent:     false,
				ci:         true,
				silentFlag: false,
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			pbarBuilder := InitializePbBuilder(tt.fields.silent, tt.fields.ci, tt.fields.silentFlag)
			got := pbarBuilder.BuildCircle(tt.args.label)
			require.NotNil(t, got)
		})
	}
}
