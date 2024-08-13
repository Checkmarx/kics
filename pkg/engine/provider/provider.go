/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
package provider

import (
	"context"
	"io"

	"github.com/Checkmarx/kics/pkg/model"
)

// Sink defines a sink function to be passed as reference to functions
type Sink func(ctx context.Context, filename string, content io.ReadCloser) error

// ResolverSink defines a sink function to be passed as reference to functions for resolved files/templates
type ResolverSink func(ctx context.Context, filename string) ([]string, error)

// SourceProvider is the interface that wraps the basic GetSources method.
// GetBasePath returns base path of FileSystemSourceProvider
// GetSources receives context, receive ID, extensions supported and a sink function to save sources
type SourceProvider interface {
	GetBasePaths() []string
	GetSources(ctx context.Context, extensions model.Extensions, sink Sink, resolverSink ResolverSink) error
}
