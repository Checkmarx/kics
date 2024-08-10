package descriptions

import (
	"github.com/DataDog/kics/internal/constants"
	"github.com/DataDog/kics/internal/tracker"
	"github.com/DataDog/kics/pkg/model"
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
