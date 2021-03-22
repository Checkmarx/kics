package resolver

import (
	"path/filepath"
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/resolver/helm"
)

func initilizeBuilder() *Resolver {
	bd, _ := NewBuilder().
		Add(&helm.Resolver{}).
		Build()
	return bd
}

func TestGetType(t *testing.T) {
	res := initilizeBuilder()
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
			want: model.KINDHELM,
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
	res := initilizeBuilder()
	type args struct {
		filePath string
		kind     model.FileKind
	}

	tests := []struct {
		name    string
		args    args
		want    model.RenderedFiles
		wantErr bool
	}{
		{
			name: "test_resolve_helm",
			args: args{
				filePath: filepath.FromSlash("../../test/fixtures/test_helm"),
				kind:     model.KINDHELM,
			},
			want: model.RenderedFiles{
				File: []model.RenderedFile{
					{
						SplitID:  "# KICS_HELM_ID_0:",
						FileName: filepath.FromSlash("../../test/fixtures/test_helm/templates/service.yaml"),
						Content: []byte(`
# Source: test_helm/templates/service.yaml
# KICS_HELM_ID_0:
apiVersion: v1
kind: Service
metadata:
  name: RELEASE-NAME-test_helm
  labels:
    helm.sh/chart: test_helm-0.1.0
    app.kubernetes.io/name: test_helm
    app.kubernetes.io/instance: RELEASE-NAME
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
    app.kubernetes.io/instance: RELEASE-NAME
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
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("Resolve() = %v, want = %v", got, tt.want)
			}
		})
	}
}
