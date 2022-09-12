package kuberneter

import (
	"context"
	"path/filepath"
	"strings"
	"testing"

	"sigs.k8s.io/controller-runtime/pkg/client"
)

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
