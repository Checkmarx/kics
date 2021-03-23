package source

import (
	"context"
	"io"
)

// Sink defines a sink function to be passed as reference to functions
type Sink func(ctx context.Context, filename string, content io.ReadCloser) error

// ResolverSink defines a sink function to be passed as reference to functions for resolved files/templates
type ResolverSink func(ctx context.Context, filename string) error
