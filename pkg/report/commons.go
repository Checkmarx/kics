package report

import (
	"os"

	"github.com/rs/zerolog/log"
)

func closeFile(path, filename string, file *os.File) {
	err := file.Close()
	if err != nil {
		log.Err(err).Msgf("failed to close file %s", path)
	}

	log.Info().Str("fileName", filename).Msgf("Results saved to file %s", path)
}
