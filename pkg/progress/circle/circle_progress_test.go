package circle

import (
	"fmt"
	"testing"

	"github.com/Checkmarx/kics/v2/internal/constants"
	"github.com/cheggaaa/pb/v3"
	"github.com/stretchr/testify/require"
)

func TestCircle_NewProgressBar(t *testing.T) {
	type args struct {
		label string
	}

	tests := []struct {
		name   string
		args   args
		silent bool
	}{
		{
			name: "test_new_circle_progress_bar",
			args: args{
				label: "testing",
			},
			silent: false,
		},
		{
			name: "test_new_circle_progress_bar_silent",
			args: args{
				label: "testing",
			},
			silent: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			newPb := pb.New64(constants.MaxInteger)
			tmp := fmt.Sprintf(`{{ %q }} {{(cycle . "↖" "↗" "↘" "↙" )}}`, tt.args.label)
			newPb.SetWidth(barWidth)
			newPb.SetTemplateString(tmp)

			got := NewProgressBar(tt.args.label, tt.silent)
			require.Equal(t, tt.args.label, got.label)
		})
	}
}

func TestCircle_Start(t *testing.T) {
	type fields struct {
		pbar ProgressBar
	}

	tests := []struct {
		name   string
		fields fields
	}{
		{
			name: "test_start",
			fields: fields{
				pbar: NewProgressBar("test", false),
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			go tt.fields.pbar.Start()
			err := tt.fields.pbar.Close()
			require.NoError(t, err)
		})
	}
}
