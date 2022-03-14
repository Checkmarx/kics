package utils

import (
	"regexp"

	"github.com/rs/zerolog/log"
	vault "github.com/sosedoff/ansible-vault-go"
)

// DecryptAnsibleVault verifies if the fileContent is encrypted by ansible-vault. If yes, the function decrypts it
func DecryptAnsibleVault(fileContent []byte, secret string) []byte {
	match, err := regexp.MatchString(`^\s*\$ANSIBLE_VAULT.*`, string(fileContent))
	if err != nil {
		return fileContent
	}
	if secret != "" && match {
		content, err := vault.Decrypt(string(fileContent), secret)

		if err == nil {
			log.Info().Msg("Decrypting Ansible Vault file")
			fileContent = []byte(content)
		}
	}
	return fileContent
}
