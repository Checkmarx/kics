package console

import (
	"bytes"
	"io"
	"reflect"
	"testing"

	"github.com/stretchr/testify/require"
)

// TestGenerateIDCommand tests kics generate ID command

func TestConsole_NewGenerateIDCmd(t *testing.T) {
	cmd := NewGenerateIDCmd()
	b := bytes.NewBufferString("")
	cmd.SetOut(b)
	err := cmd.Execute()
	require.NoError(t, err)
	out, err := io.ReadAll(b)
	require.NoError(t, err)
	if reflect.DeepEqual(string(out), "") {
		t.Errorf("generate-id is empty")
	}
}
