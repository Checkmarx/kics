package counter

import (
	"sync"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestCounter_Start(t *testing.T) {
	type fields struct {
		label string
		total int64
	}
	tests := []struct {
		name    string
		counter int
		fields  fields
		silent  bool
	}{
		{
			name:    "test_counter_progress_bar",
			counter: 9,
			fields: fields{
				label: "test",
				total: 10,
			},
			silent: false,
		},
		{
			name:    "test_counter_progress_bar_silent",
			counter: 9,
			fields: fields{
				label: "test",
				total: 10,
			},
			silent: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			wg := &sync.WaitGroup{}
			prog := make(chan int64)

			wg.Add(1)
			pb := NewProgressBar(tt.fields.label, tt.fields.total, prog, wg, tt.silent)
			go pb.Start()

			for i := 0; i < tt.counter; i++ {
				prog <- 1
			}

			close(prog)
			wg.Wait()

			require.Equal(t, int64(tt.counter), pb.pBar.Current())
		})
	}
}
