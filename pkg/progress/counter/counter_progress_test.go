package counter

import (
	"sync"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestCounter_Start(t *testing.T) {
	type fields struct {
		label string
		Total int
	}
	tests := []struct {
		name   string
		fields fields
		silent bool
	}{
		{
			name: "test_counter_progress_bar",
			fields: fields{
				label: "test",
				Total: 10,
			},
			silent: false,
		},
		{
			name: "test_counter_progress_bar_silent",
			fields: fields{
				label: "test",
				Total: 10,
			},
			silent: true,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			wg := &sync.WaitGroup{}
			prog := make(chan int64)

			wg.Add(1)
			pb := NewProgressBar(tt.fields.label, int64(tt.fields.Total), prog, wg, tt.silent)
			go pb.Start()

			for i := 0; i < tt.fields.Total; i++ {
				prog <- 1
			}

			wg.Wait()
			require.Equal(t, int64(tt.fields.Total), pb.pBar.Current())
		})
	}
}
