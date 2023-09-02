package utils

import (
	"fmt"

	"github.com/rs/zerolog/log"
)

func HandlePanic(r any, errMessage string) {
	err := fmt.Errorf("panic: %v", r)
	log.Err(err).Msg(errMessage)
}
