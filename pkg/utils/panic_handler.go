package utils

import (
	"fmt"

	"github.com/rs/zerolog/log"
)

func HandlePanic(errMessage string) {
	if r := recover(); r != nil {
		err := fmt.Errorf("panic: %v", r)
		log.Err(err).Msg(errMessage)
	}
}
