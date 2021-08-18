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

	wg := &sync.WaitGroup{}
	prog := make(chan int64)
	for _, tt := range tests {
		wg.Add(1)
		t.Run(tt.name, func(t *testing.T) {
			pb := NewProgressBar(tt.fields.label, tt.fields.total, prog, wg, tt.silent)
			go pb.Start()

			for i := 0; i <= tt.counter; i++ {
				prog <- 1
			}
			require.Equal(t, int64(tt.counter), pb.pBar.Current())
		})
	}

	go func() {
		defer func() {
			close(prog)
		}()
		wg.Wait()
	}()
}
