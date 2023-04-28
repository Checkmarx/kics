package telemetry

import (
	"errors"
	"testing"

	"github.com/Checkmarx/kics/internal/tracker"
	"github.com/Checkmarx/kics/pkg/model"
	mockclient "github.com/Checkmarx/kics/pkg/telemetry/mock"
	"github.com/stretchr/testify/require"
)

func TestDescriptions_CheckVersion(t *testing.T) {
	mt := &tracker.CITracker{}
	telemetryClient = &mockclient.MockTelemetryClient{}
	mockclient.CheckConnection = func() error {
		return nil
	}
	mockclient.CheckVersion = func(version string) (model.Version, error) {
		return model.Version{
			Latest:           false,
			LatestVersionTag: "1.4.5",
		}, nil
	}

	want := model.Version{
		Latest:           false,
		LatestVersionTag: "1.4.5",
	}

	CheckVersion(mt)
	require.Equal(t, want, mt.Version)

	mockclient.CheckVersion = func(version string) (model.Version, error) {
		return model.Version{}, errors.New("Check version mock error")
	}

	want = model.Version{
		Latest: true,
	}

	CheckVersion(mt)
	require.Equal(t, want, mt.Version)

	mockclient.CheckConnection = func() error {
		return errors.New("Check connection mock error")
	}

	CheckVersion(mt)
	require.Equal(t, want, mt.Version)
}
