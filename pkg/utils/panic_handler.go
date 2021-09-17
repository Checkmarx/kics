package utils

import "github.com/rs/zerolog/log"

// PanicHandler .....
func PanicHandler() {
	defer func() {
		if err := recover(); err != nil {
			log.Error().Msgf("Panic occurred: %s", err)
		}
	}()
}
