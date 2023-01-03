package scan

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func Test_Client(t *testing.T) {
	params := &Parameters{
		PreviewLines:   3,
		ExcludeResults: []string{},
	}

	client, err := NewClient(params, nil, nil)

	require.NotNil(t, client)
	require.NoError(t, err)
}

func Test_ClientError(t *testing.T) {
	params := &Parameters{
		PreviewLines:   0,
		ExcludeResults: []string{},
	}

	client, err := NewClient(params, nil, nil)

	require.Nil(t, client)
	require.Error(t, err)
}
