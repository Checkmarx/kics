package console

import (
	"bytes"
	"io/ioutil"
	"reflect"
	"strings"
	"testing"

	"github.com/Checkmarx/kics/pkg/engine/source"
	"github.com/stretchr/testify/require"
)

func TestConsole_NewListPlatformsCmd(t *testing.T) {
	cmd := NewListPlatformsCmd()
	b := bytes.NewBufferString("")
	cmd.SetOut(b)        // Change output of cobra cmd to buffer
	err := cmd.Execute() // Execute cmd
	require.NoError(t, err)
	out, err := ioutil.ReadAll(b) // Read cmd Output form Buffer
	require.NoError(t, err)
	plat := source.ListSupportedPlatforms()
	got := strings.Split(strings.TrimSpace(string(out)), "\n")
	if !reflect.DeepEqual(got, plat) {
		t.Errorf("Cobra = %v, expect = %v", got, plat)
	}
}
