package api

import (
	"runtime/debug"
	"strings"
)

// Github is the disgohook github url
const Github = "https://github.com/DisgoOrg/disgohook"

// Version returns the current used disgohook version in the format vx.x.x
var Version = getVersion()

func getVersion() string {
	bi, ok := debug.ReadBuildInfo()
	if ok {
		for _, dep := range bi.Deps {
			if strings.Contains(Github, dep.Path) {
				return dep.Version
			}
		}
	}
	return "unknown"
}
