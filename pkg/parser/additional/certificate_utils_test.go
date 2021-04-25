package additional

import (
	"path/filepath"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestAddCertificateInfo(t *testing.T) {
	path := filepath.Join("..", "..", "..", "test", "fixtures", "test_certificate", "positive.tf")
	certificatePath := "certificate.pem"

	info := AddCertificateInfo(path, certificatePath)

	require.NotEmpty(t, info)
}

func TestGetCertificateInfo(t *testing.T) {
	filePath := filepath.Join("..", "..", "..", "test", "fixtures", "test_certificate", "certificate.pem")

	date, _ := getCertificateInfo(filePath)

	require.NotEmpty(t, date)
	require.Equal(t, ".pem", filepath.Ext(filePath))
}

func TestCheckCertificateBody(t *testing.T) {
	content := "${file(certificate.pem)}"

	ok, pem := CheckCertificateBody(content)

	require.True(t, ok)
	require.NotEmpty(t, pem)
}
