package correlation_test

import (
	"context"
	"net/http"
	"testing"

	"github.com/checkmarxDev/ice/internal/correlation"
	"github.com/stretchr/testify/assert"
)

func TestAddToContext(t *testing.T) {
	ctx := context.Background()
	before := ctx.Value(correlation.ContextField)
	assert.Nil(t, before, "Expect no value before adding it")
	corIDValue := "corID"
	ctx = correlation.AddToContext(ctx, corIDValue)
	after := ctx.Value(correlation.ContextField)
	assert.Equal(t, after, corIDValue, "Expect value after adding it")
}

func TestFromContext(t *testing.T) {
	corIDValue := "contextCorID"

	type args struct {
		ctx context.Context
	}
	tests := []struct {
		name string
		args args
		want string
	}{
		{"Context have correlationID", args{ctx: context.WithValue(context.Background(), correlation.ContextField, corIDValue)}, corIDValue},
		{"No correlationID should return empty", args{ctx: context.Background()}, ""},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := correlation.FromContext(tt.args.ctx); got != tt.want {
				t.Errorf("FromContext() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestFromHTTPRequest(t *testing.T) {
	corIDValue := "httpCorID"

	requestWithCorrID, err := http.NewRequest(http.MethodGet, "kuku", nil)
	assert.NoError(t, err)
	requestWithCorrID.Header.Add(correlation.RequestHeaderField, corIDValue)

	requestWithoutCorrID, err := http.NewRequest(http.MethodGet, "kuku", nil)
	assert.NoError(t, err)

	type args struct {
		r *http.Request
	}
	tests := []struct {
		name string
		args args
		want string
	}{
		{"Request contains correlation header", args{r: requestWithCorrID}, corIDValue},
		{"Request has no correlation header", args{r: requestWithoutCorrID}, ""},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if got := correlation.FromHTTPRequest(tt.args.r); got != tt.want {
				t.Errorf("FromHTTPRequest() = %v, want %v", got, tt.want)
			}
		})
	}
}
