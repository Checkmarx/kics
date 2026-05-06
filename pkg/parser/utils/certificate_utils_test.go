package utils

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestAddCertificateInfo(t *testing.T) {
	path := filepath.Join("..", "..", "..", "test", "fixtures", "test_certificate", "positive.tf")
	certificatePath := "certificate.pem"

	info := AddCertificateInfo(path, certificatePath, nil, false)

	require.NotEmpty(t, info)
}

func TestGetCertificateInfo(t *testing.T) {
	filePath := filepath.Join("..", "..", "..", "test", "fixtures", "test_certificate", "certificate.pem")

	date, err := getCertificateInfo(filePath)

	require.NoError(t, err)
	require.NotEmpty(t, date)
	require.Equal(t, ".pem", filepath.Ext(filePath))
}

func TestCheckCertificateBody(t *testing.T) {
	content := "${file(certificate.pem)}"

	pem := CheckCertificate(content)

	require.NotEmpty(t, pem)
}

func TestAddCertificateInfo_StrictRejectsUnsafePath(t *testing.T) {
	allowedBase := t.TempDir()
	outsideDir := t.TempDir()
	defer os.Remove(allowedBase)
	defer os.Remove(outsideDir)
	outsideCert := filepath.Join(outsideDir, "cert.pem")
	require.NoError(t, os.WriteFile(outsideCert, []byte("placeholder"), 0o600))

	tfPath := filepath.Join(allowedBase, "main.tf")

	got := AddCertificateInfo(tfPath, outsideCert, []string{allowedBase}, true)

	require.Nil(t, got, "strict mode must reject certificate path outside allowed bases")
}

func TestAddCertificateInfo_StrictRejectsTraversalRelativePath(t *testing.T) {
	allowedBase := t.TempDir()
	siblingDir := t.TempDir()
	defer os.Remove(allowedBase)
	defer os.Remove(siblingDir)
	// Relative path that, when joined with the .tf file's directory, escapes
	// allowedBase. No file needs to exist: os.Stat on a relative path is
	// resolved against test CWD and fails, so the join branch is taken; the
	// cleaned join lands outside allowedBase and sanitize rejects.
	relEscape := filepath.Join("..", filepath.Base(siblingDir), "cert.pem")
	tfPath := filepath.Join(allowedBase, "main.tf")

	got := AddCertificateInfo(tfPath, relEscape, []string{allowedBase}, true)

	require.Nil(t, got, "strict mode must reject relative cert path that escapes allowed bases")
}
