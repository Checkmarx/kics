package additional

import (
	"crypto/rsa"
	"crypto/x509"
	"encoding/pem"
	"os"
	"path/filepath"
	"regexp"
)

// CheckCertificateBody verifies if the attribute 'certificate_body' refers a file
func CheckCertificateBody(content string) (b bool, s string) {
	var re = regexp.MustCompile(`[0-9a-zA-Z-/\\_]+\.pem`)
	match := re.FindAllString(content, -1)

	if match == nil {
		return false, ""
	}

	return true, match[0]
}

func getCertificateInfo(filePath string) (a [3]int, i int) {
	certPEM, err := os.ReadFile(filePath)

	if err != nil {
		panic("Failed to read the file " + filePath)
	}

	block, _ := pem.Decode(certPEM)
	if block == nil {
		panic("Failed to parse the certificate PEM " + filePath)
	}
	cert, err := x509.ParseCertificate(block.Bytes)
	if err != nil {
		panic("Failed to parse the certificate" + filePath)
	}

	var date [3]int
	date[0] = cert.NotAfter.Year()
	date[1] = int(cert.NotAfter.Month())
	date[2] = cert.NotAfter.Day()

	var rsaBytes int

	switch t := cert.PublicKey.(type) {
	case *rsa.PublicKey:
		_ = t
		rsaBytes = cert.PublicKey.(*rsa.PublicKey).Size()
	default:
		rsaBytes = -1
	}

	return date, rsaBytes
}

// AddCertificateInfo gets and adds certificate information of a certificate file
func AddCertificateInfo(path, content string) map[string]interface{} {
	var filePath string

	if _, err := os.Stat(content); err != nil { // content is not a full valid path or is an incomplete path
		filePath = filepath.Join(filepath.Dir(path), content)
	} else { // content is a full valid path
		filePath = content
	}

	date, rsaBytes := getCertificateInfo(filePath)

	attributes := make(map[string]interface{})
	attributes["file"] = filePath
	attributes["expiration_date"] = date

	if rsaBytes != -1 {
		attributes["rsa_key_bytes"] = rsaBytes
	}

	return attributes
}
