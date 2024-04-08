package scan

import (
	"context"
	"testing"
	"time"

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

func Test_PerformScan_Successful(t *testing.T) {

	params := &Parameters{

		PreviewLines:   3,
		ExcludeResults: []string{},
	}
	client, err := NewClient(params, nil, nil)
	require.NoError(t, err, "error creating client")
	ctx := context.Background()
	err = client.PerformScan(ctx)
	require.NoError(t, err, "error during scan")
	require.NotEqual(t, time.Time{}, client.ScanStartTime, "ScanStartTime was not set")
}
