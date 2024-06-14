package utils

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
