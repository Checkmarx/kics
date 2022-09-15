package kuberneter

import (
	"context"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/stretchr/testify/require"
	"k8s.io/client-go/rest"
	"sigs.k8s.io/controller-runtime/pkg/client"
)

type env_var struct {
	name  string
	value string
}

func TestImport(t *testing.T) {
	type args struct {
		kuberneterPath string
	}

	tests := []struct {
		name      string
		k8sClient func() (client.Client, error)
		args      args
		want      string
		wantErr   bool
	}{
		{
			name: "test import right path and without client",
			k8sClient: func() (client.Client, error) {
				return nil, nil
			},
			args: args{
				kuberneterPath: "*:*:*",
			},
			want:    "kics-extract-kuberneter",
			wantErr: true,
		},
		{
			name: "test import path error",
			k8sClient: func() (client.Client, error) {
				return nil, nil
			},
			args: args{
				kuberneterPath: "*:*",
			},
			want:    "",
			wantErr: true,
		},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			getK8sClientFunc = tt.k8sClient
			got, err := Import(context.Background(), tt.args.kuberneterPath, "")
			if (err != nil) != tt.wantErr {
				t.Errorf("Import() error = %v, wantErr %v", err, tt.wantErr)
				return
			}
			if !strings.Contains(filepath.Base(got), filepath.Base(tt.want)) {
				t.Errorf("Import() = %v, want %v", filepath.Base(got), filepath.Base(tt.want))
			}
		})
	}
}

func Test_HasCAFile_envVars(t *testing.T) {

	tests := []struct {
		name           string
		args           []env_var
		expectedResult bool
	}{
		{
			name: "has_K8S_CA_FILE",
			args: []env_var{
				{
					name:  "K8S_CA_FILE",
					value: "path/to/file",
				},
			},
			expectedResult: true,
		},
		{
			name: "has_invalid_K8S_CA_DATA",
			args: []env_var{
				{
					name:  "K8S_CA_DATA",
					value: "U09NRSBURVNUIERBVEE=",
				},
			},
			expectedResult: true,
		},
		{
			name: "has_invalid_K8S_CA_DATA",
			args: []env_var{
				{
					name:  "K8S_CA_DATA",
					value: "U09NRSBURVNUIERBVEE=asd",
				},
			},
			expectedResult: false,
		},
		{
			name:           "has_no_CA_FILE",
			args:           []env_var{},
			expectedResult: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			k8Client := &K8sConfig{
				Config: &rest.Config{
					QPS:   100,
					Burst: 100,
				},
			}
			for _, env := range tt.args {
				os.Setenv(env.name, env.value)
			}
			v := k8Client.hasCertificateAuthority()
			require.Equal(t, tt.expectedResult, v)
			for _, env := range tt.args {
				os.Unsetenv(env.name)
			}
		})
	}
}
