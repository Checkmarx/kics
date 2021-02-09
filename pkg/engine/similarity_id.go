package engine

import (
	"crypto/sha256"
	"encoding/hex"
	"path/filepath"
)

// ComputeSimilarityID This function receives four string parameters and computes a sha256 hash
func ComputeSimilarityID(basePath, filePath, queryID, searchKey, searchValue string) (*string, error) {
	standardizedPath, err := standardizeToRelativePath(basePath, filePath)
	if err != nil {
		return nil, err
	}

	var stringNode = standardizedPath + queryID + searchKey + searchValue

	hashSum := sha256.Sum256([]byte(stringNode))

	return stringToPtrString(hex.EncodeToString(hashSum[:])), nil
}

func standardizeToRelativePath(basePath, path string) (string, error) {
	cleanPath := filepath.Clean(path)
	standardPath := filepath.ToSlash(cleanPath)
	basePath = filepath.ToSlash(basePath)
	relativeStandardPath, err := filepath.Rel(basePath, standardPath)
	if err != nil {
		return "", err
	}
	return relativeStandardPath, nil
}
