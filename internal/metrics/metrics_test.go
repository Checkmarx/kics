package metrics

import (
	"strings"
	"testing"
	"time"

	"github.com/spf13/pflag"
	"github.com/stretchr/testify/require"
)

func TestMetrics_InitializeMetrics(t *testing.T) {
	type args struct {
		metric mockFlagValue
	}
	tests := []struct {
		name    string
		args    args
		wantErr bool
		disable bool
	}{
		{
			name: "test_initialize_metrics_cpu",
			args: args{
				metric: "cpu",
			},
			wantErr: false,
			disable: false,
		},
		{
			name: "test_initialize_metrics_mem",
			args: args{
				metric: "mem",
			},
			wantErr: false,
			disable: false,
		},
		{
			name: "test_initialize_metrics_empty",
			args: args{
				metric: "",
			},
			wantErr: false,
			disable: true,
		},
		{
			name: "test_initialize_metrics_unknown",
			args: args{
				metric: "unknown",
			},
			wantErr: true,
			disable: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := InitializeMetrics(&pflag.Flag{
				Value: tt.args.metric,
			})
			if (err != nil) != tt.wantErr {
				t.Errorf("InitializeMetrics = %v, wantErr = %v", err, tt.wantErr)
			}
			require.Equal(t, Metric.Disable, tt.disable)
		})
	}
}

type mockFlagValue string

func (m mockFlagValue) String() string {
	return string(m)
}

func (m mockFlagValue) Set(string) error {
	return nil
}
func (m mockFlagValue) Type() string {
	return string(m)
}

func TestMetrics_formatTotal(t *testing.T) {
	type args struct {
		b       int64
		typeMap map[string]float64
	}
	tests := []struct {
		name string
		args args
		want string
	}{
		{
			name: "test_format_total_cpu",
			args: args{
				b:       100,
				typeMap: cpuMap,
			},
			want: "100.00ns",
		},
		{
			name: "test_format_total_cpu_ms",
			args: args{
				b:       10000000,
				typeMap: cpuMap,
			},
			want: "10.00ms",
		},
		{
			name: "test_format_total_cpu_h",
			args: args{
				b:       10000000000000,
				typeMap: cpuMap,
			},
			want: "2.78hrs",
		},
		{
			name: "test_format_total_mem_b",
			args: args{
				b:       100,
				typeMap: memoryMap,
			},
			want: "100.00B",
		},
		{
			name: "test_format_total_mem_mb",
			args: args{
				b:       10000000,
				typeMap: memoryMap,
			},
			want: "9.54MB",
		},
		{
			name: "test_format_total_mem_tb",
			args: args{
				b:       10000000000000,
				typeMap: memoryMap,
			},
			want: "9.09TB",
		},
		{
			name: "test_format_total_cpu_nan",
			args: args{
				b:       0,
				typeMap: cpuMap,
			},
			want: "0.00",
		},
		{
			name: "test_format_total_mem_nan",
			args: args{
				b:       0,
				typeMap: memoryMap,
			},
			want: "0.00",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := formatTotal(tt.args.b, tt.args.typeMap)
			require.Equal(t, tt.want, got)
		})
	}
}

func TestMetrics_Start_Stop(t *testing.T) {
	type args struct {
		location string
	}
	type feilds struct {
		value      mockFlagValue
		allocation []string
	}
	tests := []struct {
		name     string
		args     args
		feilds   feilds
		disabled bool
	}{
		{
			name: "test_cpu_start_stop",
			args: args{
				location: "test_location",
			},
			feilds: feilds{
				value:      "cpu",
				allocation: []string{"1", "2", "3"},
			},
			disabled: false,
		},
		{
			name: "test_mem_start_stop",
			args: args{
				location: "test_location",
			},
			feilds: feilds{
				value:      "mem",
				allocation: []string{"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"},
			},
			disabled: false,
		},
		{
			name: "test_metrics_disabled",
			args: args{
				location: "test_location",
			},
			feilds: feilds{
				value:      "",
				allocation: []string{"1", "2", "3"},
			},
			disabled: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := InitializeMetrics(&pflag.Flag{
				Value: tt.feilds.value,
			})
			require.NoError(t, err)
			metricFunc(tt.feilds.allocation, tt.args.location)
			if !tt.disabled {
				require.NotEmpty(t, Metric.total)
			}
		})
	}
}

func metricFunc(allocation []string, location string) {
	defer Metric.Stop()
	Metric.Start(location)
	t := make([]string, 0, len(allocation))
	done := make(chan int)
	for _, alloc := range allocation {
		t = append(t, alloc)
		strings.Join(t, "")
		go func() {
			for {
				select {
				case <-done:
					return
				default:
					continue
				}
			}
		}()
	}
	time.Sleep(time.Second * 3)
	close(done)
}
