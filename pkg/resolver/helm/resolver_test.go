package helm

import (
	"path/filepath"
	"reflect"
	"testing"

	"github.com/stretchr/testify/require"

	"github.com/Checkmarx/kics/v2/pkg/model"
)

func TestHelm_SupportedTypes(t *testing.T) {
	res := &Resolver{}
	want := []model.FileKind{model.KindHELM}
	t.Run("get_supported_type", func(t *testing.T) {
		got := res.SupportedTypes()
		if !reflect.DeepEqual(got, want) {
			t.Errorf("SupportedTypes() = %v, want = %v", got, want)
		}
	})
}

func TestHelm_Resolve(t *testing.T) { //nolint
	res := &Resolver{}
	type args struct {
		filePath string
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
				filePath: filepath.FromSlash("../../../test/fixtures/test_helm"),
			},
			want: model.ResolvedFiles{
				File: []model.ResolvedHelm{
					{
						SplitID:  "# KICS_HELM_ID_0:",
						FileName: filepath.FromSlash("../../../test/fixtures/test_helm/templates/service.yaml"),
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
		{
			name: "err_resolve",
			args: args{
				filePath: filepath.FromSlash("../../../test/fixtures/all_auth_users_get_read_access"),
			},
			want:    model.ResolvedFiles{},
			wantErr: true,
		},
		{
			name: "test_with_dependencies",
			args: args{
				filePath: filepath.FromSlash("../../../test/fixtures/test_helm_subchart"),
			},
			want: model.ResolvedFiles{
				File: []model.ResolvedHelm{
					{
						FileName: filepath.FromSlash("../../../test/fixtures/test_helm_subchart/templates/serviceaccount.yaml"),
						SplitID:  "# KICS_HELM_ID_1:",
						IDInfo: map[int]interface{}{1: map[int]int{1: 1, 2: 2, 3: 3, 4: 4,
							5: 5, 6: 6, 7: 7, 8: 8, 9: 9, 10: 10, 11: 11, 12: 12, 13: 13}},
						Content: []byte(`
# Source: test_helm_subchart/templates/serviceaccount.yaml
# KICS_HELM_ID_1:
apiVersion: v1
kind: ServiceAccount
metadata:
  name: kics-helm-test_helm_subchart
  labels:
    helm.sh/chart: test_helm_subchart-0.1.0
    app.kubernetes.io/name: test_helm_subchart
    app.kubernetes.io/instance: kics-helm
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
`),
						OriginalData: []byte(`{{- if .Values.serviceAccount.create -}}
# KICS_HELM_ID_1:
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "test_helm_subchart.serviceAccountName" . }}
  labels:
    {{- include "test_helm_subchart.labels" . | nindent 4 }}
  {{- with .Values.serviceAccount.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}
`),
					},
					{
						FileName: filepath.FromSlash("../../../test/fixtures/test_helm_subchart/charts/subchart/templates/service.yaml"),
						SplitID:  "# KICS_HELM_ID_0:",
						IDInfo: map[int]interface{}{0: map[int]int{0: 0, 1: 1, 2: 2, 3: 3, 4: 4,
							5: 5, 6: 6, 7: 7, 8: 8, 9: 9, 10: 10, 11: 11, 12: 12, 13: 13, 14: 14, 15: 15, 16: 16}},
						Content: []byte(`
# Source: test_helm_subchart/charts/subchart/templates/service.yaml
# KICS_HELM_ID_0:
apiVersion: v1
kind: Service
metadata:
  name: kics-helm-subchart
  labels:
    helm.sh/chart: subchart-0.1.0
    app.kubernetes.io/name: subchart
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
    app.kubernetes.io/name: subchart
    app.kubernetes.io/instance: kics-helm
`),
						OriginalData: []byte(`# KICS_HELM_ID_0:
apiVersion: v1
kind: Service
metadata:
  name: {{ include "subchart.fullname" . }}
  labels:
    {{- include "subchart.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
    - port: {{ .Values.service.port }}
      targetPort: http
      protocol: TCP
      name: http
  selector:
    {{- include "subchart.selectorLabels" . | nindent 4 }}
`),
					},
				},
			},
			wantErr: false,
		},
		{
			name: "test_filer_out_empty_files",
			args: args{
				filePath: filepath.FromSlash("../../../test/fixtures/helm_empty_file"),
			},
			want: model.ResolvedFiles{
				File: []model.ResolvedHelm{
					{
						FileName: filepath.FromSlash("../../../test/fixtures/helm_empty_file/templates/service.yaml"),
						SplitID:  "# KICS_HELM_ID_1:",
						IDInfo:   map[int]interface{}{1: map[int]int{1: 1, 2: 2, 3: 3, 4: 4, 5: 5, 6: 6, 7: 7, 8: 8, 9: 9, 10: 10, 11: 11, 12: 12, 13: 13, 14: 14, 15: 15, 16: 16, 17: 17, 18: 18, 19: 19, 20: 20, 21: 21}},
						Content: []byte(`
# Source: test/templates/service.yaml
# KICS_HELM_ID_1:
apiVersion: v1
kind: Service
metadata:
  name: some-random-value
  labels:
    app: some-random-value
spec:
  selector:
    app: some-random-value
  type: ClusterIP
  ports:
    - name: http
      port: 80
      targetPort: 3001
    - name: metrics
      port: 3000
      targetPort: 3000
`),
						OriginalData: []byte(`---
# KICS_HELM_ID_1:
apiVersion: v1
kind: Service
metadata:
  name: {{$.Values.deployment.image.value}}
  labels:
    app: {{$.Values.deployment.image.value}}
spec:
  selector:
    app: {{$.Values.deployment.image.value}}
  type: ClusterIP
  ports:
    - name: http
      port: 80
      targetPort: 3001
    - name: metrics
      port: 3000
      targetPort: 3000
---
---
`),
					},
				},
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got, err := res.Resolve(tt.args.filePath)
			if (err != nil) != tt.wantErr {
				t.Errorf("Resolve() = %v, wantErr = %v", err, tt.wantErr)
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

func Test_isEmptyFileRender(t *testing.T) {
	tests := []struct {
		name      string
		fileLines []string
		want      bool
	}{
		{
			name: "valid_file",
			fileLines: []string{
				"test/templates/service.yaml",
				"# KICS_HELM_ID_1:",
				"apiVersion: v1",
			},
			want: false,
		},
		{
			name: "single_element_only",
			fileLines: []string{
				"test/templates/service.yaml",
				"",
			},
			want: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := isEmptyFileRender(tt.fileLines)
			if got != tt.want {
				t.Errorf("isEmptyFileRender() = %v, want %v", got, tt.want)
			}
		})
	}
}
