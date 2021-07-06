package counter

import (
	"sync"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestCounter_Start(t *testing.T) {
	type fields struct {
		label    string
		total    int64
		progress chan int64
		wg       *sync.WaitGroup
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
				label:    "test",
				total:    10,
				progress: make(chan int64),
				wg:       &sync.WaitGroup{},
			},
			silent: false,
		},
		{
			name:    "test_counter_progress_bar_silent",
			counter: 9,
			fields: fields{
				label:    "test",
				total:    10,
				progress: make(chan int64),
				wg:       &sync.WaitGroup{},
			},
			silent: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			tt.fields.wg.Add(1)
			pb := NewProgressBar(tt.fields.label, tt.fields.total, tt.fields.progress, tt.fields.wg, tt.silent)
			go pb.Start()
			for i := 0; i <= tt.counter; i++ {
				tt.fields.progress <- 1
			}

			go func() {
				defer func() {
					close(tt.fields.progress)
				}()
				tt.fields.wg.Wait()
			}()

			require.Equal(t, int64(tt.counter), pb.pBar.Current())
		})
	}
}
