package source

import (
	"context"
	"io"
)

// Sink defines a sink function to be passed as reference to functions
type Sink func(ctx context.Context, filename string, content io.ReadCloser) error

// HelmSink defines a sink function to be passed as reference to functions
type ResolverSink func(ctx context.Context, filename string) error
