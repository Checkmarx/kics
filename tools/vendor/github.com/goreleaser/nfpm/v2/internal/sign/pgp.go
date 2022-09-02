package sign

import (
	"bytes"
	"crypto"
	"errors"
	"fmt"
	"io"
	"io/ioutil"
	"strconv"
	"unicode"

	"github.com/ProtonMail/go-crypto/openpgp"
	"github.com/ProtonMail/go-crypto/openpgp/clearsign"
	"github.com/ProtonMail/go-crypto/openpgp/packet"
	"github.com/goreleaser/nfpm/v2"
)

// PGPSigner returns a PGP signer that creates a detached non-ASCII-armored
// signature and is compatible with rpmpack's signature API.
func PGPSigner(keyFile, passphrase string) func([]byte) ([]byte, error) {
	return PGPSignerWithKeyID(keyFile, passphrase, nil)
}

// PGPSignerWithKeyID returns a PGP signer that creates a detached non-ASCII-armored
// signature and is compatible with rpmpack's signature API.
func PGPSignerWithKeyID(keyFile, passphrase string, hexKeyId *string) func([]byte) ([]byte, error) {
	return func(data []byte) ([]byte, error) {
		keyId, err := parseKeyID(hexKeyId)
		if err != nil {
			return nil, fmt.Errorf("%v is not a valid key id: %w", hexKeyId, err)
		}

		key, err := readSigningKey(keyFile, passphrase)
		if err != nil {
			return nil, &nfpm.ErrSigningFailure{Err: err}
		}

		var signature bytes.Buffer

		err = openpgp.DetachSign(&signature, key, bytes.NewReader(data), &packet.Config{
			SigningKeyId: keyId,
			DefaultHash:  crypto.SHA256,
		})
		if err != nil {
			return nil, &nfpm.ErrSigningFailure{Err: err}
		}

		return signature.Bytes(), nil
	}
}

// PGPArmoredDetachSign creates an ASCII-armored detached signature.
func PGPArmoredDetachSign(message io.Reader, keyFile, passphrase string) ([]byte, error) {
	return PGPArmoredDetachSignWithKeyID(message, keyFile, passphrase, nil)
}

// PGPArmoredDetachSignWithKeyID creates an ASCII-armored detached signature.
func PGPArmoredDetachSignWithKeyID(message io.Reader, keyFile, passphrase string, hexKeyId *string) ([]byte, error) {
	keyId, err := parseKeyID(hexKeyId)
	if err != nil {
		return nil, fmt.Errorf("%v is not a valid key id: %w", hexKeyId, err)
	}

	key, err := readSigningKey(keyFile, passphrase)
	if err != nil {
		return nil, fmt.Errorf("armored detach sign: %w", err)
	}

	var signature bytes.Buffer

	err = openpgp.ArmoredDetachSign(&signature, key, message, &packet.Config{
		SigningKeyId: keyId,
		DefaultHash:  crypto.SHA256,
	})
	if err != nil {
		return nil, fmt.Errorf("armored detach sign: %w", err)
	}

	return signature.Bytes(), nil
}

func PGPClearSignWithKeyID(message io.Reader, keyFile, passphrase string, hexKeyId *string) ([]byte, error) {
	keyId, err := parseKeyID(hexKeyId)
	if err != nil {
		return nil, fmt.Errorf("%v is not a valid key id: %w", hexKeyId, err)
	}

	key, err := readSigningKey(keyFile, passphrase)
	if err != nil {
		return nil, fmt.Errorf("clear sign: %w", err)
	}

	var signature bytes.Buffer

	writeCloser, err := clearsign.Encode(&signature, key.PrivateKey, &packet.Config{
		SigningKeyId: keyId,
		DefaultHash:  crypto.SHA256,
	})
	if err != nil {
		return nil, fmt.Errorf("clear sign: %w", err)
	}

	if _, err := io.Copy(writeCloser, message); err != nil {
		return nil, fmt.Errorf("clear sign: %w", err)
	}

	if err := writeCloser.Close(); err != nil {
		return nil, fmt.Errorf("clear sign: %w", err)
	}

	return signature.Bytes(), nil
}

// PGPVerify is exported for use in tests and verifies an ASCII-armored or non-ASCII-armored
// signature using an ASCII-armored or non-ASCII-armored public key file. The signer
// identity is not explicitly checked, other that the obvious fact that the signer's key must
// be in the armoredPubKeyFile.
func PGPVerify(message io.Reader, signature []byte, armoredPubKeyFile string) error {
	keyFileContent, err := ioutil.ReadFile(armoredPubKeyFile)
	if err != nil {
		return fmt.Errorf("reading armored public key file: %w", err)
	}

	var keyring openpgp.EntityList

	if isASCII(keyFileContent) {
		keyring, err = openpgp.ReadArmoredKeyRing(bytes.NewReader(keyFileContent))
		if err != nil {
			return fmt.Errorf("decoding armored public key file: %w", err)
		}
	} else {
		keyring, err = openpgp.ReadKeyRing(bytes.NewReader(keyFileContent))
		if err != nil {
			return fmt.Errorf("decoding public key file: %w", err)
		}
	}

	if isASCII(signature) {
		_, err = openpgp.CheckArmoredDetachedSignature(keyring, message, bytes.NewReader(signature), nil)
		return err
	}

	_, err = openpgp.CheckDetachedSignature(keyring, message, bytes.NewReader(signature), nil)
	return err
}

func PGPReadMessage(message []byte, armoredPubKeyFile string) error {
	keyFileContent, err := ioutil.ReadFile(armoredPubKeyFile)
	if err != nil {
		return fmt.Errorf("reading armored public key file: %w", err)
	}

	var keyring openpgp.EntityList

	if isASCII(keyFileContent) {
		keyring, err = openpgp.ReadArmoredKeyRing(bytes.NewReader(keyFileContent))
		if err != nil {
			return fmt.Errorf("decoding armored public key file: %w", err)
		}
	} else {
		keyring, err = openpgp.ReadKeyRing(bytes.NewReader(keyFileContent))
		if err != nil {
			return fmt.Errorf("decoding public key file: %w", err)
		}
	}

	block, _ := clearsign.Decode(message)
	_, err = block.VerifySignature(keyring, nil)

	return err
}

func parseKeyID(hexKeyId *string) (uint64, error) {
	if hexKeyId == nil || *hexKeyId == "" {
		return 0, nil
	}

	result, err := strconv.ParseUint(*hexKeyId, 16, 64)
	if err != nil {
		return 0, err
	}
	return result, nil
}

var (
	errMoreThanOneKey = errors.New("more than one signing key in keyring")
	errNoKeys         = errors.New("no signing key in keyring")
	errNoPassword     = errors.New("key is encrypted but no passphrase was provided")
)

func readSigningKey(keyFile, passphrase string) (*openpgp.Entity, error) {
	fileContent, err := ioutil.ReadFile(keyFile)
	if err != nil {
		return nil, fmt.Errorf("reading PGP key file: %w", err)
	}

	var entityList openpgp.EntityList

	if isASCII(fileContent) {
		entityList, err = openpgp.ReadArmoredKeyRing(bytes.NewReader(fileContent))
		if err != nil {
			return nil, fmt.Errorf("decoding armored PGP keyring: %w", err)
		}
	} else {
		entityList, err = openpgp.ReadKeyRing(bytes.NewReader(fileContent))
		if err != nil {
			return nil, fmt.Errorf("decoding PGP keyring: %w", err)
		}
	}
	var key *openpgp.Entity

	for _, candidate := range entityList {
		if candidate.PrivateKey == nil {
			continue
		}

		if !candidate.PrivateKey.CanSign() {
			continue
		}

		if key != nil {
			return nil, errMoreThanOneKey
		}

		key = candidate
	}

	if key == nil {
		return nil, errNoKeys
	}

	if key.PrivateKey.Encrypted {
		if passphrase == "" {
			return nil, errNoPassword
		}
		pw := []byte(passphrase)
		err = key.PrivateKey.Decrypt(pw)
		if err != nil {
			return nil, fmt.Errorf("decrypt secret signing key: %w", err)
		}
		for _, sub := range key.Subkeys {
			if sub.PrivateKey != nil {
				if err := sub.PrivateKey.Decrypt(pw); err != nil {
					return nil, fmt.Errorf("gopenpgp: error in unlocking sub key: %w", err)
				}
			}
		}
	}

	return key, nil
}

func isASCII(s []byte) bool {
	for i := 0; i < len(s); i++ {
		if s[i] > unicode.MaxASCII {
			return false
		}
	}
	return true
}
