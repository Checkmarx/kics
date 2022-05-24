package metrics

import (
	"strings"
	"testing"
	"time"

	"github.com/stretchr/testify/require"
)

func TestMetrics_InitializeMetrics(t *testing.T) {
	type args struct {
		metric string
		ci     bool
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
				ci:     true,
			},
			wantErr: false,
			disable: false,
		},
		{
			name: "test_initialize_metrics_mem",
			args: args{
				metric: "mem",
				ci:     true,
			},
			wantErr: false,
			disable: false,
		},
		{
			name: "test_initialize_metrics_empty",
			args: args{
				metric: "",
				ci:     true,
			},
			wantErr: false,
			disable: true,
		},
		{
			name: "test_initialize_metrics_unknown",
			args: args{
				metric: "unknown",
				ci:     true,
			},
			wantErr: true,
			disable: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := InitializeMetrics(tt.args.metric, tt.args.ci)
			if (err != nil) != tt.wantErr {
				t.Errorf("InitializeMetrics = %v, wantErr = %v", err, tt.wantErr)
			}
			require.Equal(t, Metric.Disable, tt.disable)
		})
	}
}

func TestMetrics_formatTotal(t *testing.T) { //nolint
	type args struct {
		b             int64
		typeMap       map[string]float64
		defaultMetric string
	}
	tests := []struct {
		name   string
		args   args
		want   string
		metric metricType
		ci     bool
	}{
		{
			name: "test_format_total_cpu",
			args: args{
				b:             100,
				typeMap:       cpuMap,
				defaultMetric: "ms",
			},
			metric: &cpuMetric{},
			want:   "100.00ns",
			ci:     false,
		},
		{
			name: "test_format_total_cpu_ms",
			args: args{
				b:             10000000,
				typeMap:       cpuMap,
				defaultMetric: "ms",
			},
			metric: &cpuMetric{},
			want:   "10.00ms",
			ci:     false,
		},
		{
			name: "test_format_total_cpu_h",
			args: args{
				b:             10000000000000,
				typeMap:       cpuMap,
				defaultMetric: "ms",
			},
			metric: &cpuMetric{},
			want:   "2.78hrs",
			ci:     false,
		},
		{
			name: "test_format_total_mem_b",
			args: args{
				b:             100,
				typeMap:       memoryMap,
				defaultMetric: "B",
			},
			metric: &memMetric{},
			want:   "100.00B",
			ci:     false,
		},
		{
			name: "test_format_total_mem_mb",
			args: args{
				b:             10000000,
				typeMap:       memoryMap,
				defaultMetric: "B",
			},
			metric: &memMetric{},
			want:   "9.54MB",
			ci:     false,
		},
		{
			name: "test_format_total_mem_tb",
			args: args{
				b:             10000000000000,
				typeMap:       memoryMap,
				defaultMetric: "B",
			},
			metric: &memMetric{},
			want:   "9.09TB",
			ci:     false,
		},
		{
			name: "test_format_total_cpu_nan",
			args: args{
				b:             0,
				typeMap:       cpuMap,
				defaultMetric: "B",
			},
			metric: &memMetric{},
			want:   "0.00",
			ci:     false,
		},
		{
			name: "test_format_total_mem_nan",
			args: args{
				b:             0,
				typeMap:       memoryMap,
				defaultMetric: "B",
			},
			metric: &memMetric{},
			want:   "0.00",
			ci:     false,
		},
		{
			name: "test_format_total_mem_mb_ci",
			args: args{
				b:             10000000,
				typeMap:       memoryMap,
				defaultMetric: "B",
			},
			metric: &memMetric{},
			want:   "10000000B",
			ci:     true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			m := Metrics{
				metric:    tt.metric,
				metricsID: "test",
				location:  "",
				total:     0,
				Disable:   false,
				ci:        tt.ci,
			}
			got := m.formatTotal(tt.args.b, tt.args.typeMap, tt.args.defaultMetric)
			require.Equal(t, tt.want, got)
		})
	}
}

func TestMetrics_Start_Stop(t *testing.T) {
	type args struct {
		location string
	}
	type fields struct {
		value      string
		allocation []string
		ci         bool
	}
	tests := []struct {
		name     string
		args     args
		fields   fields
		disabled bool
	}{
		{
			name: "test_cpu_start_stop",
			args: args{
				location: "test_location",
			},
			fields: fields{
				value:      "cpu",
				allocation: []string{"1", "2", "3"},
				ci:         false,
			},
			disabled: false,
		},
		{
			name: "test_mem_start_stop",
			args: args{
				location: "test_location",
			},
			fields: fields{
				value: "mem",
				ci:    false,
				allocation: []string{
					"1", "2", "3", "4", "5",
					"6", "7", "8", "9", "10",
					"11", "12", "13", "14", "15",
					"16", "17", "18", "19", "20",
				},
			},
			disabled: false,
		},
		{
			name: "test_metrics_disabled",
			args: args{
				location: "test_location",
			},
			fields: fields{
				value:      "",
				ci:         false,
				allocation: []string{"1", "2", "3"},
			},
			disabled: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			err := InitializeMetrics(tt.fields.value, tt.fields.ci)
			require.NoError(t, err)
			metricFunc(tt.fields.allocation, tt.args.location)
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
	}
	for range allocation {
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
