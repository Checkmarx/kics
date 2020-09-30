package aws

import (
	"io/ioutil"
	"os"
	"testing"

	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
)

func TestMain(m *testing.M) {
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: ioutil.Discard})
	os.Exit(m.Run())
}

func ptrToString(v string) *string {
	return &v
}
