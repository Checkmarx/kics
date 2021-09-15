package similarity

import (
	"crypto/sha256"
	"encoding/hex"
	"path/filepath"
	"strings"

	"github.com/rs/zerolog/log"
)

// ComputeSimilarityID This function receives four string parameters and computes a sha256 hash
func ComputeSimilarityID(basePaths []string, filePath, queryID, searchKey, searchValue string) (*string, error) {
	basePath := ""
	for _, path := range basePaths {
		if strings.Contains(filepath.ToSlash(filePath), filepath.ToSlash(path)) {
			basePath = filepath.ToSlash(path)
			break
		}
	}
	standardizedPath, err := standardizeToRelativePath(basePath, filePath)
	if err != nil {
		log.Debug().Msgf("Error while standardizing path: %s", err)
	}

	var stringNode = standardizedPath + queryID + searchKey + searchValue

	hashSum := sha256.Sum256([]byte(stringNode))

	similarity := hex.EncodeToString(hashSum[:])
	return &similarity, nil
}

func standardizeToRelativePath(basePath, path string) (string, error) {
	cleanPath := filepath.Clean(path)
	standardPath := filepath.ToSlash(cleanPath)
	basePath = filepath.ToSlash(basePath)
	relativeStandardPath, err := filepath.Rel(basePath, standardPath)
	if err != nil {
		return "", err
	}
	return filepath.ToSlash(relativeStandardPath), nil
}
