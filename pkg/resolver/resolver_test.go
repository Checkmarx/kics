package resolver

import (
	"path/filepath"
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/resolver/helm"
	"github.com/stretchr/testify/require"
)

func initializeBuilder() *Resolver {
	bd, _ := NewBuilder().
		Add(&helm.Resolver{}).
		Build()
	return bd
}

func TestGetType(t *testing.T) {
	res := initializeBuilder()
	type args struct {
		filepath string
	}
	tests := []struct {
		name string
		args args
		want model.FileKind
	}{
		{
			name: "get_helm_type",
			args: args{
				filepath: filepath.FromSlash("../../test/fixtures/test_helm"),
			},
			want: model.KindHELM,
		},
		{
			name: "get_no_type",
			args: args{
				filepath: filepath.FromSlash("../../test/fixtures/all_auth_users_get_read_access"),
			},
			want: model.KindCOMMON,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := res.GetType(tt.args.filepath)
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("GetType() = %v, want = %v", got, tt.want)
			}
		})
	}
}

func TestResolver_Resolve(t *testing.T) {
	res := initializeBuilder()
	type args struct {
		filePath string
		kind     model.FileKind
	}

	tests := []struct {
		name    string
		args    args
		want    model.ResolvedFiles
		wantErr bool
	}{
		{
			name: "test_resolve_helm",
			args: args{
				filePath: filepath.FromSlash("../../test/fixtures/test_helm"),
				kind:     model.KindHELM,
			},
			want: model.ResolvedFiles{
				File: []model.ResolvedHelm{
					{
						SplitID:  "# KICS_HELM_ID_0:",
						FileName: filepath.FromSlash("../../test/fixtures/test_helm/templates/service.yaml"),
						IDInfo: map[int]interface{}{0: map[int]int{0: 0, 1: 1, 2: 2, 3: 3, 4: 4,
							5: 5, 6: 6, 7: 7, 8: 8, 9: 9, 10: 10, 11: 11, 12: 12, 13: 13, 14: 14, 15: 15, 16: 16}},
						Content: []byte(`
# Source: test_helm/templates/service.yaml
# KICS_HELM_ID_0:
apiVersion: v1
kind: Service
metadata:
  name: kics-helm-test_helm
  labels:
    helm.sh/chart: test_helm-0.1.0
    app.kubernetes.io/name: test_helm
    app.kubernetes.io/instance: kics-helm
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
spec:
  type: ClusterIP
  ports:
    - port: 80
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app.kubernetes.io/name: test_helm
    app.kubernetes.io/instance: kics-helm
`),
						OriginalData: []byte(`# KICS_HELM_ID_0:
apiVersion: v1
kind: Service
metadata:
  name: {{ include "test_helm.fullname" . }}
  labels:
    {{- include "test_helm.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: http
      protocol: TCP
      name: http
  selector:
    {{- include "test_helm.selectorLabels" . | nindent 4 }}
`),
					},
				},
			},
			wantErr: false,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := res.Resolve(tt.args.filePath, tt.args.kind)
			if (err != nil) != tt.wantErr {
				t.Errorf("Resolve() error = %v, wantErr = %v", err, tt.wantErr)
			}
			if !reflect.DeepEqual(got.File, tt.want.File) {
				t.Errorf("Resolve() = %v, want = %v", got, tt.want)
			}
			if err == nil {
				require.NotEmpty(t, got.Excluded)
			}
		})
	}
}
