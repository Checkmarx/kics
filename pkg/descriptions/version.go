package descriptions

import (
	"github.com/Checkmarx/kics/v2/internal/constants"
	"github.com/Checkmarx/kics/v2/internal/tracker"
	"github.com/Checkmarx/kics/v2/pkg/model"
)

// CheckVersion - checks if using the latest version and saves that information in the tracker
func CheckVersion(t *tracker.CITracker) {
	baseVersionInfo := model.Version{
		Latest: true,
	}

	if err := descClient.CheckConnection(); err != nil {
		t.TrackVersion(baseVersionInfo)
		return
	}

	versionInfo, err := descClient.CheckLatestVersion(constants.Version)
	if err != nil {
		t.TrackVersion(baseVersionInfo)
		return
	}

	t.TrackVersion(versionInfo)
}
