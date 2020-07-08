package sources

import "context"

type SourceProvider interface {
	DownloadSources(ctx context.Context, scanID, dstPath string) error
}
