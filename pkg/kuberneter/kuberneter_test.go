package kuberneter

import (
	"bytes"
	"context"
	"encoding/base64"
	"encoding/pem"
	"net/http"
	"net/http/httptest"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"text/template"

	"github.com/stretchr/testify/require"
	"k8s.io/client-go/rest"
	"sigs.k8s.io/controller-runtime/pkg/client"
)

const mockK8sAPITokenValue = "sample-mock-bearer-token"

type envVar struct {
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
		args           []envVar
		expectedResult bool
	}{
		{
			name: "has_K8S_CA_FILE",
			args: []envVar{
				{
					name:  "K8S_CA_FILE",
					value: "path/to/file",
				},
			},
			expectedResult: true,
		},
		{
			name: "has_valid_K8S_CA_DATA",
			args: []envVar{
				{
					name:  "K8S_CA_DATA",
					value: "U09NRSBURVNUIERBVEE=",
				},
			},
			expectedResult: true,
		},
		{
			name: "has_invalid_K8S_CA_DATA",
			args: []envVar{
				{
					name:  "K8S_CA_DATA",
					value: "U09NRSBURVNUIERBVEE=asd",
				},
			},
			expectedResult: false,
		},
		{
			name:           "has_no_CA_FILE",
			args:           []envVar{},
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

func Test_HasClientCertificate_envVars(t *testing.T) {

	tests := []struct {
		name           string
		args           []envVar
		expectedResult bool
	}{
		{
			name: "has_K8S_CERT_FILE_and_K8S_KEY_FILE",
			args: []envVar{
				{
					name:  "K8S_CERT_FILE",
					value: "path/to/file",
				},
				{
					name:  "K8S_KEY_FILE",
					value: "path/to/file",
				},
			},
			expectedResult: true,
		},
		{
			name: "has_valid_K8S_CERT_DATA_and_K8S_KEY_FILE",
			args: []envVar{
				{
					name:  "K8S_CERT_DATA",
					value: "U09NRSBURVNUIERBVEE=",
				},
				{
					name:  "K8S_KEY_FILE",
					value: "path/to/file",
				},
			},
			expectedResult: true,
		},
		{
			name: "has_invalid_K8S_CERT_DATA",
			args: []envVar{
				{
					name:  "K8S_CERT_DATA",
					value: "U09NRSBURVNUIERBVEE=asd",
				},
			},
			expectedResult: false,
		},
		{
			name: "has_invalid_K8S_KEY_DATA",
			args: []envVar{
				{
					name:  "K8S_CERT_FILE",
					value: "path/to/file",
				},
				{
					name:  "K8S_KEY_DATA",
					value: "U09NRSBURVNUIERBVEE=asd",
				},
			},
			expectedResult: false,
		},
		{
			name: "has_valid_K8S_KEY_DATA",
			args: []envVar{
				{
					name:  "K8S_CERT_FILE",
					value: "path/to/file",
				},
				{
					name:  "K8S_KEY_DATA",
					value: "U09NRSBURVNUIERBVEE=",
				},
			},
			expectedResult: true,
		},
		{
			name:           "has_no_K8S_CERT_DATA_or_K8S_CERT_FILE",
			args:           []envVar{},
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
			v := k8Client.hasClientCertificate()
			require.Equal(t, tt.expectedResult, v)
			for _, env := range tt.args {
				os.Unsetenv(env.name)
			}
		})
	}
}

func Test_HasServiceAccountToken_envVars(t *testing.T) {

	tests := []struct {
		name           string
		args           []envVar
		expectedResult bool
	}{
		{
			name: "has_K8S_SA_TOKEN_FILE",
			args: []envVar{
				{
					name:  "K8S_SA_TOKEN_FILE",
					value: "path/to/file",
				},
			},
			expectedResult: true,
		},
		{
			name: "has_K8S_SA_TOKEN_DATA",
			args: []envVar{
				{
					name:  "K8S_SA_TOKEN_DATA",
					value: "U09NRSBURVNUIERBVEE=",
				},
			},
			expectedResult: true,
		},
		{
			name:           "has_no_SA_TOKEN",
			args:           []envVar{},
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
			v := k8Client.hasServiceAccountToken()
			require.Equal(t, tt.expectedResult, v)
			for _, env := range tt.args {
				os.Unsetenv(env.name)
			}
		})
	}
}

// newMockK8sAPIServer starts a local TLS server standing in for a real k8s API server.
// It rejects every request with 401, which is what a cluster does when the presented
// bearer token is invalid, so getK8sClient exercises a real TLS handshake and a real
// token exchange instead of a bare connection failure.
func newMockK8sAPIServer(t *testing.T) *httptest.Server {
	server := httptest.NewTLSServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if got := r.Header.Get("Authorization"); got != "Bearer "+mockK8sAPITokenValue {
			t.Errorf("mock k8s API server: unexpected Authorization header %q", got)
		}
		w.WriteHeader(http.StatusUnauthorized)
	}))
	t.Cleanup(server.Close)
	return server
}

// renderKubeconfig fills in the sample_K8S_CONFIG_FILE.yaml template with the mock
// server's own URL and certificate, so the rendered kubeconfig points at a real,
// locally-reachable endpoint instead of a hardcoded fake host.
func renderKubeconfig(t *testing.T, server *httptest.Server) string {
	caPEM := pem.EncodeToMemory(&pem.Block{Type: "CERTIFICATE", Bytes: server.Certificate().Raw})

	tmplPath := getValidCertPath([]string{"..", "..", "test", "assets", "sample_K8S_CONFIG_FILE.yaml"})
	tmpl, err := template.ParseFiles(tmplPath)
	require.NoError(t, err)

	var rendered bytes.Buffer
	err = tmpl.Execute(&rendered, struct {
		CAData string
		Server string
		Token  string
	}{
		CAData: base64.StdEncoding.EncodeToString(caPEM),
		Server: server.URL,
		Token:  mockK8sAPITokenValue,
	})
	require.NoError(t, err)

	configPath := filepath.Join(t.TempDir(), "rendered_K8S_CONFIG_FILE.yaml")
	require.NoError(t, os.WriteFile(configPath, rendered.Bytes(), 0o600))
	return configPath
}

func Test_GetClient(t *testing.T) {
	mockServer := newMockK8sAPIServer(t)
	renderedConfigPath := renderKubeconfig(t, mockServer)

	tests := []struct {
		name    string
		args    []envVar
		wantErr bool
	}{
		{
			name: "has_K8S_CONFIG_FILE",
			args: []envVar{
				{
					name:  "K8S_CONFIG_FILE",
					value: renderedConfigPath,
				},
			},
			wantErr: true,
		},
		{
			name: "has_no_valid_K8S_CONFIG_FILE",
			args: []envVar{
				{
					name:  "K8S_CONFIG_FILE",
					value: getValidCertPath([]string{"..", "..", "test", "assets", "invalid.yaml"}),
				},
			},
			wantErr: true,
		},
		{
			name:    "has_no_envVars",
			args:    []envVar{},
			wantErr: true,
		},
		{
			name: "has_K8S_HOST",
			args: []envVar{
				{
					name:  "K8S_HOST",
					value: "https://127.0.0.1:1",
				},
			},
			wantErr: true,
		},
		{
			name: "has_K8S_HOST_with_invalid_SA_TOKEN_DATA",
			args: []envVar{
				{
					name:  "K8S_HOST",
					value: "https://127.0.0.1:1",
				},
				{
					name:  "K8S_CA_FILE",
					value: "/some/file",
				},
				{
					name:  "K8S_SA_TOKEN_DATA",
					value: "U09NRSBURVNUIERBVEE=",
				},
			},
			wantErr: true,
		},
		{
			name: "has_K8S_HOST_with_invalid_CERT_DATA_and_KEY_DATA",
			args: []envVar{
				{
					name:  "K8S_HOST",
					value: "https://127.0.0.1:1",
				},
				{
					name:  "K8S_CA_FILE",
					value: "/some/file",
				},
				{
					name:  "K8S_CERT_FILE",
					value: "/some/file",
				},
				{
					name:  "K8S_KEY_FILE",
					value: "/some/key/file",
				},
			},
			wantErr: true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			for _, env := range tt.args {
				os.Setenv(env.name, env.value)
			}
			_, err := getK8sClient()
			require.Equal(t, tt.wantErr, err != nil)
			for _, env := range tt.args {
				os.Unsetenv(env.name)
			}
		})
	}
}

func getValidCertPath(path []string) string {
	k8sCertPath := filepath.Join(path[:]...)
	finalPath := filepath.Join(k8sCertPath)
	return finalPath
}
