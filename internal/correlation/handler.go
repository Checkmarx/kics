package correlation

import (
	"context"
	"net/http"
)

type ContextKey int

const (
	ContextField ContextKey = iota
)
const (
	RequestHeaderField = "X-Correlation-ID"
	MetadataField      = "x-correlation-id" // metadata is from GRPC and its always all lower case letters
)

func FromContext(ctx context.Context) string {
	corIDValue := ctx.Value(ContextField)
	if corIDValue != nil {
		return ctx.Value(ContextField).(string)
	}
	return ""
}

func FromHTTPRequest(r *http.Request) string {
	corID := r.Header.Get(RequestHeaderField)
	return corID
}

func AddToContext(ctx context.Context, correlationID string) context.Context {
	return context.WithValue(ctx, ContextField, correlationID)
}
