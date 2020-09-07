package source

import (
	"context"
	"io"
)

type Sink func(ctx context.Context, filename string, content io.ReadCloser) error
