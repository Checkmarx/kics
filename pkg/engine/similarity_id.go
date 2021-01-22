package engine

import (
	"crypto/sha256"
	"encoding/hex"
	"path/filepath"

	"github.com/pkg/errors"
)

// ComputeSimilarityID This function receives four string parameters and computes a sha256 hash
func ComputeSimilarityID(filePath, queryID, searchKey, searchValue string) (*string, error) {
	standardizedPath, err := standardizeFilePath(filePath)
	if err != nil {
		return nil, errors.Wrap(err, "Unable to compute similarity id")
	}

	var stringNode = standardizedPath + queryID + searchKey + searchValue

	hashSum := sha256.Sum256([]byte(stringNode))

	return stringToPtrString(hex.EncodeToString(hashSum[:])), nil
}

func standardizeFilePath(path string) (string, error) {
	cleanPath := filepath.Clean(path)
	standardPath := filepath.ToSlash(cleanPath)
	if filepath.IsAbs(standardPath) {
		return "", errors.New("illegal absolute path to file")
	}
	return standardPath, nil
}
