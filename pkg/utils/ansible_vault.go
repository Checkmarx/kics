package utils

import (
	"regexp"

	vault "github.com/sosedoff/ansible-vault-go"
)

// DecryptAnsibleVault verifies if the fileContent is encrypted by ansible-vault. If yes, the function decrypts it
func DecryptAnsibleVault(fileContent []byte, secret string) []byte {
	match, _ := regexp.MatchString(`^\s*\$ANSIBLE_VAULT.*`, string(fileContent))
	if secret != "" && match {
		content, err := vault.Decrypt(string(fileContent), secret)

		if err == nil {
			fileContent = []byte(content)
		}
	}
	return fileContent
}
