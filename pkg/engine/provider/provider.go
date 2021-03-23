package provider

import (
	"context"
	"io"
	"os"

	"github.com/Checkmarx/kics/pkg/model"
)

// Sink defines a sink function to be passed as reference to functions
type Sink func(ctx context.Context, filename string, content io.ReadCloser) error

// SourceProvider is the interface that wraps the basic GetSources method.
// GetBasePath returns base path of FileSystemSourceProvider
// GetSources receives context, receive ID, extensions supported and a sink function to save sources
type SourceProvider interface {
	GetBasePath() string
	GetSources(ctx context.Context, extensions model.Extensions, sink Sink) error
	checkConditions(info os.FileInfo, extensions model.Extensions, path string) (bool, error)
}
