package kuberneter

import (
	"reflect"
	"testing"
)

func TestExtractK8sAPIOptions(t *testing.T) {
	supportedKinds := buildSupportedKinds()
	defer func() { supportedKinds = nil }()

	type args struct {
		kuberneterPath string
	}
	tests := []struct {
		name    string
		args    args
		want    *K8sAPIOptions
		wantErr bool
	}{
		{
			name: "right extractK8sAPIOptions length",
			args: args{
				kuberneterPath: "*:*:*",
			},
			want: &K8sAPIOptions{
				Namespaces:  []string{""},
				APIVersions: []string{"*"},
				Kinds:       []string{"*"},
			},
			wantErr: false,
		},
		{
			name: "wrong extractK8sAPIOptions length",
			args: args{
				kuberneterPath: "*:*",
			},
			want:    &K8sAPIOptions{},
			wantErr: true,
		},
		{
			name: "wrong apiVersion",
			args: args{
				kuberneterPath: "*:cosmic:*",
			},
			want:    &K8sAPIOptions{},
			wantErr: true,
		},
		{
			name: "wrong kind",
			args: args{
				kuberneterPath: "*:*:Pox",
			},
			want:    &K8sAPIOptions{},
			wantErr: true,
		},
		{
			name: "right extractK8sAPIOptions",
			args: args{
				kuberneterPath: "default+cosmic:apps/v1+core/v1:Pod+Deployment",
			},
			want: &K8sAPIOptions{
				Namespaces:  []string{"default", "cosmic"},
				APIVersions: []string{"apps/v1", "core/v1"},
				Kinds:       []string{"Pod", "Deployment"},
			},
			wantErr: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := extractK8sAPIOptions(tt.args.kuberneterPath, supportedKinds)
			if (err != nil) != tt.wantErr {
				t.Errorf("extractK8sAPIOptions() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("extractK8sAPIOptions() = %v, want %v", got, tt.want)
			}
		})
	}
}
