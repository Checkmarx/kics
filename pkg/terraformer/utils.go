package terraformer

import (
	"io/fs"
	"os"
	"path/filepath"

	"github.com/rs/zerolog/log"
)

// save saves the terraformer command output in the destination folder
func save(destination, output string, statErr error) {
	if statErr != nil {
		if err := os.MkdirAll(destination, os.ModePerm); err != nil {
			log.Error().Msgf("failed to mkdir: %s", err)
		}
	}

	filePath := filepath.Join(destination, "terraformer-output.txt")
	filepath.Clean(filePath)

	f, err := os.OpenFile(filePath, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, os.ModePerm)

	if err != nil {
		log.Error().Msgf("failed to open file '%s': %s", filePath, err)
	}

	defer func(f *os.File) {
		err = f.Close()
		if err != nil {
			log.Err(err).Msgf("failed to close file: %s", filePath)
		}
	}(f)

	if _, err = f.WriteString(output); err != nil {
		log.Error().Msgf("failed to write file '%s': %s", filePath, err)
	}
}

// cleanUnwantedFiles deletes the output files from the destination folder
func cleanUnwantedFiles(destination string) {
	err := filepath.Walk(destination, func(path string, info fs.FileInfo, err error) error {
		if info != nil {
			deleteOutputFile(path, info)
		}
		return nil
	})

	if err != nil {
		log.Err(err).Msg("failed to clean unwanted files")
	}
}

// deleteOutputFile deletes a 'outputs.tf' file
func deleteOutputFile(path string, output fs.FileInfo) {
	if output.Name() == "outputs.tf" {
		err := os.Remove(path)
		if err != nil {
			log.Err(err).Msgf("failed to remove outputs.tf in path %s", path)
		}
	}
}
