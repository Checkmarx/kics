package helm

import (
	"reflect"
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/utils"
	"github.com/rs/zerolog"
)

var OriginalData1 = `# KICS_HELM_ID_0:
apiVersion: v1
kind: Pod
metadata:
  name: "{{ include "test_helm.fullname" . }}-test-connection"
  labels:
    {{- include "test_helm.labels" . | nindent 4 }}
  annotations:
	"helm.sh/hook": test
spec:
  containers:
    - name: wget
      image: busybox
	  command: ['wget']
	  args: ['{{ include "test_helm.fullname" . }}:{{ .Values.service.port }}']
    restartPolicy: Never
`

var OriginalData2 = `# KICS_HELM_ID_0:
apiVersion: v1
kind: Pod
metadata:
  name: "{{ include "test_helm.fullname" . }}-test-connection"
  labels:
    {{- include "test_helm.labels" . | nindent 4 }}
  annotations:
	"helm.sh/hook": test
spec:
  containers:
    - name: wget
      image: busybox
	  command: ['wget']
	  args: ['{{ include "test_helm.fullname" . }}:{{ .Values.service.port }}']
    restartPolicy: Never
  containers:
    - name: wget2
      image: busybox
	  command: ['wget']
	  args: ['{{ include "test_helm.fullname" . }}:{{ .Values.service.port }}']
    restartPolicy: Never
`

var OriginalData3 = `# KICS_HELM_ID_0:
apiVersion: v1
kind: Pod
metadata:
  name: "{{ include "test_helm.fullname" . }}-test-connection"
  labels:
    {{- include "test_helm.labels" . | nindent 4 }}
  annotations:
	"helm.sh/hook": test
spec:
  containers:
    - name: wget
      image: busybox
	  command: ['wget']
	  args: ['{{ include "test_helm.fullname" . }}:{{ .Values.service.port }}']
    restartPolicy: Never
---
# KICS_HELM_ID_1:
apiVersion: v1
kind: Pod
metadata:
  name: "{{ include "test_helm.fullname" . }}-test-dups"
  labels:
    {{- include "test_helm.labels" . | nindent 4 }}
  annotations:
	"helm.sh/hook": test
spec:
  containers:
    - name: wget
      image: busybox
	  command: ['wget']
	  args: ['{{ include "test_helm.fullname" . }}:{{ .Values.service.port }}']
    restartPolicy: Never
`

func TestEngine_detectHelmLine(t *testing.T) { //nolint
	type args struct {
		file          *model.FileMetadata
		searchKey     string
		logWithFields *zerolog.Logger
		outputLines   int
	}

	tests := []struct {
		name string
		args args
		want model.VulnerabilityLines
	}{
		{
			name: "test_detect_helm_line",
			args: args{
				file: &model.FileMetadata{
					ID:                "1",
					ScanID:            "console",
					Document:          model.Document{},
					Kind:              model.KindHELM,
					FilePath:          "test-connection.yaml",
					HelmID:            "# KICS_HELM_ID_0",
					OriginalData:      OriginalData1,
					LinesOriginalData: utils.SplitLines(OriginalData1),
					Content:           ``,
				},
				searchKey:     "KICS_HELM_ID_0.metadata.name={{RELEASE-NAME-test_helm-test-connection}}.spec.containers",
				logWithFields: &zerolog.Logger{},
				outputLines:   1,
			},
			want: model.VulnerabilityLines{
				Line: 10,
				VulnLines: &[]model.CodeLine{
					{
						Position: 10,
						Line:     "  containers:",
					},
				},
				LineWithVulnerability: "  containers:",
				ResolvedFile:          "test-connection.yaml",
			},
		},
		{
			name: "test_dup_values",
			args: args{
				file: &model.FileMetadata{
					ID:       "1",
					ScanID:   "console",
					Document: model.Document{},
					Kind:     model.KindHELM,
					FilePath: "test-dup_values.yaml",
					IDInfo: map[int]interface{}{0: map[int]int{0: 0, 1: 1, 2: 2, 3: 3, 4: 4,
						5: 5, 6: 6, 7: 7, 8: 8, 9: 9, 10: 10, 11: 11, 12: 12, 13: 13, 14: 14, 15: 15, 16: 16, 17: 17,
						18: 18, 19: 19, 21: 21, 22: 22}},
					HelmID:            "# KICS_HELM_ID_0",
					OriginalData:      OriginalData2,
					LinesOriginalData: utils.SplitLines(OriginalData2),
					Content:           ``,
				},
				searchKey:     "KICS_HELM_ID_0.metadata.name={{RELEASE-NAME-test_helm-test-connection}}.spec.containers",
				logWithFields: &zerolog.Logger{},
				outputLines:   1,
			},
			want: model.VulnerabilityLines{
				Line: 9,
				VulnLines: &[]model.CodeLine{
					{
						Position: 9,
						Line:     "spec:",
					},
				},
				LineWithVulnerability: "spec:",
				ResolvedFile:          "test-dup_values.yaml",
			},
		},
		{
			name: "test_detect_helm_with_dups",
			args: args{
				file: &model.FileMetadata{
					ID:                "1",
					ScanID:            "console",
					Document:          model.Document{},
					Kind:              model.KindHELM,
					FilePath:          "test-dups.yaml",
					HelmID:            "# KICS_HELM_ID_1",
					OriginalData:      OriginalData3,
					LinesOriginalData: utils.SplitLines(OriginalData3),
					Content:           ``,
				},
				searchKey:     "KICS_HELM_ID_1.metadata.name={{RELEASE-NAME-test_helm-test-connection}}.spec.containers",
				logWithFields: &zerolog.Logger{},
				outputLines:   1,
			},
			want: model.VulnerabilityLines{
				Line: 26,
				VulnLines: &[]model.CodeLine{
					{
						Position: 26,
						Line:     "  containers:",
					},
				},
				LineWithVulnerability: "  containers:",
				ResolvedFile:          "test-dups.yaml",
			},
		},
	}

	for _, tt := range tests {
		detector := DetectKindLine{}
		t.Run(tt.name, func(t *testing.T) {
			got := detector.DetectLine(tt.args.file, tt.args.searchKey, tt.args.outputLines, tt.args.logWithFields)
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("detectHelmLine() = %v, want = %v", got, tt.want)
			}
		})
	}
}
