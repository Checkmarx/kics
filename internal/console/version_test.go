package console

import (
	"bytes"
	"io"
	"reflect"
	"strings"
	"testing"

	"github.com/stretchr/testify/require"
)

func TestConsole_NewVersionCmd(t *testing.T) {
	cmd := NewVersionCmd()
	b := bytes.NewBufferString("")
	cmd.SetOutput(b)
	err := cmd.Execute()
	require.NoError(t, err)
	out, err := io.ReadAll(b)
	require.NoError(t, err)
	got := strings.Trim(string(out), "\n")
	v := getVersion()
	if !reflect.DeepEqual(got, v) {
		t.Errorf("version = %v, expect = %v", got, v)
	}
}
