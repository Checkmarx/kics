package utils

import (
	"crypto/rsa"
	"crypto/x509"
	"encoding/pem"
	"errors"
	"os"
	"path/filepath"
	"regexp"

	"github.com/rs/zerolog/log"
)

type certInfo struct {
	date        [3]int
	rsaKeyBytes int
}

// CheckCertificate verifies if the attribute 'certificate_body' refers a file
func CheckCertificate(content string) string {
	var re = regexp.MustCompile(`[0-9a-zA-Z-/\\_.]+\.pem`)

	match := re.FindString(content)

	return match
}

func getCertificateInfo(filePath string) (certInfo, error) {
	certPEM, err := os.ReadFile(filepath.Clean(filePath))

	if err != nil {
		return certInfo{}, err
	}

	block, _ := pem.Decode(certPEM)
	if block == nil {
		return certInfo{}, errors.New("failed to parse the certificate PEM")
	}
	cert, err := x509.ParseCertificate(block.Bytes)
	if err != nil {
		return certInfo{}, err
	}

	var certDate [3]int
	certDate[0] = cert.NotAfter.Year()
	certDate[1] = int(cert.NotAfter.Month())
	certDate[2] = cert.NotAfter.Day()

	var rsaBytes int

	switch t := cert.PublicKey.(type) {
	case *rsa.PublicKey:
		_ = t
		rsaBytes = cert.PublicKey.(*rsa.PublicKey).Size()
	default:
		rsaBytes = -1
	}

	return certInfo{date: certDate, rsaKeyBytes: rsaBytes}, nil
}

// AddCertificateInfo gets and adds certificate information of a certificate file
func AddCertificateInfo(path, content string) map[string]interface{} {
	var filePath string

	_, err := os.Stat(content)

	if err != nil { // content is not a full valid path or is an incomplete path
		log.Trace().Msgf("path to the certificate content is not a valid: %s", content)
		filePath = filepath.Join(filepath.Dir(path), content)
	} else { // content is a full valid path
		filePath = content
	}

	date, err := getCertificateInfo(filePath)

	if err == nil {
		attributes := make(map[string]interface{})
		attributes["file"] = filePath
		attributes["expiration_date"] = date.date

		if date.rsaKeyBytes != -1 {
			attributes["rsa_key_bytes"] = date.rsaKeyBytes
		}

		return attributes
	}

	log.Error().Msgf("Failed to get certificate path %s: %s", filePath, err)

	return nil
}
