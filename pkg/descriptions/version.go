package descriptions

import (
	"github.com/Checkmarx/kics/internal/constants"
	"github.com/Checkmarx/kics/internal/tracker"
	"github.com/Checkmarx/kics/pkg/model"
)

// CheckVersion - checks if using the latest version and saves that information in the tracker
func CheckVersion(t *tracker.CITracker) error {
	versionInfo := model.Version{
		Latest: true,
	}

	if err := descClient.CheckConnection(); err != nil {
		t.TrackVersion(versionInfo)
		return err
	}

	versionInfo, err := descClient.CheckLatestVersion(constants.Version)
	if err != nil {
		t.TrackVersion(versionInfo)
		return err
	}

	t.TrackVersion(versionInfo)
	return err
}
