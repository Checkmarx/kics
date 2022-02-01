package descriptions

import (
	"testing"

	"github.com/Checkmarx/kics/internal/tracker"
	mockclient "github.com/Checkmarx/kics/pkg/descriptions/mock"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/stretchr/testify/require"
)

type mockTracker struct {
}

func TestDescriptions_CheckVersion(t *testing.T) {
	mt := &tracker.CITracker{}
	descClient = &mockclient.MockDecriptionsClient{}
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
}
