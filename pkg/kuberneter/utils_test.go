package kuberneter

import (
	"reflect"
	"testing"

	"github.com/stretchr/testify/require"
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

func Test_GetAPIVersion(t *testing.T) {
	tests := []struct {
		name          string
		apiName       string
		expectedValue string
	}{
		{
			name:          "core/v1 api version",
			apiName:       "core/v1",
			expectedValue: "v1",
		},
		{
			name:          "v2 api version",
			apiName:       "v2",
			expectedValue: "v2",
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			v := getAPIVersion(tt.apiName)
			require.Equal(t, v, tt.expectedValue)
		})
	}

}

func Test_IsTarget(t *testing.T) {
	tests := []struct {
		name          string
		target        string
		targetOpts    []string
		expectedValue bool
	}{
		{
			name:          "wildcard Target Options",
			target:        "Pod",
			targetOpts:    []string{"*"},
			expectedValue: true,
		},
		{
			name:          "target Options contains value",
			target:        "Pod",
			targetOpts:    []string{"Pod"},
			expectedValue: true,
		},
		{
			name:          "target Options not contains value",
			target:        "Pod",
			targetOpts:    []string{"Deployment"},
			expectedValue: false,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			v := isTarget(tt.target, tt.targetOpts)
			require.Equal(t, v, tt.expectedValue)
		})
	}

}

func Test_GetNamespace(t *testing.T) {
	tests := []struct {
		name          string
		namespace     string
		expectedValue string
	}{
		{
			name:          "empty namespace",
			namespace:     "",
			expectedValue: "all namespaces",
		},
		{
			name:          "not empty namespace",
			namespace:     "some",
			expectedValue: "the namespace some",
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			v := getNamespace(tt.namespace)
			require.Equal(t, v, tt.expectedValue)
		})
	}

}
