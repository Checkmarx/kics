package kics

import (
	"context"
	"testing"

	"github.com/Checkmarx/kics/v2/assets"
	"github.com/Checkmarx/kics/v2/internal/storage"
	"github.com/Checkmarx/kics/v2/internal/tracker"
	"github.com/Checkmarx/kics/v2/pkg/engine"
	"github.com/Checkmarx/kics/v2/pkg/engine/provider"
	"github.com/Checkmarx/kics/v2/pkg/engine/secrets"
	"github.com/Checkmarx/kics/v2/pkg/engine/source"
	"github.com/Checkmarx/kics/v2/pkg/parser"
	yamlParser "github.com/Checkmarx/kics/v2/pkg/parser/yaml"
	"github.com/Checkmarx/kics/v2/pkg/resolver"
	"github.com/Checkmarx/kics/v2/pkg/resolver/helm"
	"github.com/rs/zerolog/log"
	"github.com/stretchr/testify/require"
)

func Test_ResolverSink(t *testing.T) {
	ctx := context.Background()
	tests := []struct {
		name                  string
		path                  string
		service               Service
		expectedExcludedCount int
	}{
		{
			name: "test resolver sink",
			path: "./../../test/fixtures/helm_ignore/test",
			service: MockService(
				[]string{"./../../test/fixtures/helm_ignore/test"},
				[]string{"Kubernetes"},
				[]string{},
				10,
				60,
				100,
				ctx),
			expectedExcludedCount: 11,
		},
		{
			name: "test resolver sink no helm",
			path: "./../../test/fixtures/test_scan_cloudfront_logging_disabled",
			service: MockService(
				[]string{"./../../test/fixtures/test_scan_cloudfront_logging_disabled"},
				[]string{"CloudFormation"},
				[]string{"aws"},
				10,
				60,
				100,
				ctx),
			expectedExcludedCount: 0,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			s := tt.service

			excluded, err := s.resolverSink(ctx, tt.path, "", false, 15)
			if err != nil {
				t.Fatalf(`ResolverSink failed for path %s with error: %v`, tt.path, err)
			}

			require.Equal(t, tt.expectedExcludedCount, len(excluded))
		})
	}
}

func Test_ResolverSink_ParseError(t *testing.T) {
	ctx := context.Background()
	tests := []struct {
		name                string
		path                string
		service             Service
		expectedErrorString string
	}{
		{
			name: "test resolver sink",
			path: "./../../test/fixtures/helm_template_parser_error/test",
			service: MockService(
				[]string{"./../../test/fixtures/helm_template_parser_error/test"},
				[]string{"Kubernetes"},
				[]string{},
				10,
				60,
				100,
				ctx),
			expectedErrorString: "failed to render helm chart",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			s := tt.service
			_, err := s.resolverSink(ctx, tt.path, "", false, 15)
			require.EqualError(t, err, tt.expectedErrorString)
		})
	}
}

func MockService(paths []string,
	platforms []string,
	cloudProviders []string,
	previewLines int,
	queryExecTimeout int,
	maxFileSizeFlag int,
	ctx context.Context) Service {

	path := paths[0]

	filesSource, err := provider.NewFileSystemSourceProvider(paths, []string{})
	if err != nil {
		log.Error().Msgf(`Failed to get File Sources for path %s with error: %v`, path, err)
	}

	querySource := source.NewFilesystemSource(
		[]string{},
		platforms,
		cloudProviders,
		"",
		false)

	combinedParser, err := parser.NewBuilder().
		Add(&yamlParser.Parser{}).
		Build(querySource.Types, querySource.CloudProviders)
	if err != nil {
		log.Error().Msgf(`Failed to build parser for path %s with error: %v`, path, err)
	}

	mockTracker, err := tracker.NewTracker(previewLines)
	if err != nil {
		log.Error().Msgf(`Failed to build tracker for path %s with error: %v`, path, err)
	}

	queryFilter := source.QueryInspectorParameters{}

	inspector, err := engine.NewInspector(ctx,
		querySource,
		engine.DefaultVulnerabilityBuilder,
		mockTracker,
		&queryFilter,
		map[string]bool{},
		queryExecTimeout,
		false,
		true,
		1,
		false,
	)
	if err != nil {
		log.Error().Msgf(`Failed to build inspector for path %s with error: %v`, path, err)
	}

	regexRulesContent := assets.SecretsQueryRegexRulesJSON

	secretsInspector, err := secrets.NewInspector(
		ctx,
		map[string]bool{},
		mockTracker,
		&queryFilter,
		false,
		queryExecTimeout,
		regexRulesContent,
		false,
	)
	if err != nil {
		log.Error().Msgf(`Failed to build secretsInspector with error: %v`, err)
	}

	mockResolver, err := resolver.NewBuilder().Add(&helm.Resolver{}).Build()
	if err != nil {
		log.Error().Msgf(`Failed to build mockResolver with error: %v`, err)
	}

	return Service{
		SourceProvider:   filesSource,
		Storage:          storage.NewMemoryStorage(),
		Parser:           combinedParser[0],
		Inspector:        inspector,
		SecretsInspector: secretsInspector,
		Tracker:          mockTracker,
		MaxFileSize:      maxFileSizeFlag,
		Resolver:         mockResolver,
	}
}
