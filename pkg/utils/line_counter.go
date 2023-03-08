package utils

import (
	"bytes"
	"io"
	"os"
	"path/filepath"

	"github.com/rs/zerolog/log"
)

func LineCounter(path string) (int, error) {
	content, err := os.OpenFile(filepath.Clean(path), os.O_RDONLY, os.ModePerm)
	if err != nil {
		log.Error().Msgf("failed to open file: %s", err)
		return 0, err
	}

	buf := make([]byte, 32*1024)
	count := 0
	lineSep := []byte{'\n'}

	for {
		c, err := content.Read(buf)
		count += bytes.Count(buf[:c], lineSep)

		switch {
		case err == io.EOF:
			return count, nil

		case err != nil:
			return count, err
		}
	}
}
