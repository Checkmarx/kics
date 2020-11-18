package context

import (
	"context"

	"github.com/Checkmarx/kics/internal/correlation"
)

func ForwardContext(ctx context.Context) context.Context {
	corrID := correlation.FromContext(ctx)

	return correlation.ToGRPCOutgoingContext(ctx, corrID)
}
