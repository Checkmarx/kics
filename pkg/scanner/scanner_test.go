package scanner

import (
	"context"
	"path/filepath"
	"testing"
	"time"

	"github.com/Checkmarx/kics/v2/assets"
	"github.com/Checkmarx/kics/v2/internal/storage"
	"github.com/Checkmarx/kics/v2/internal/tracker"
	"github.com/Checkmarx/kics/v2/pkg/engine"
	"github.com/Checkmarx/kics/v2/pkg/engine/provider"
	"github.com/Checkmarx/kics/v2/pkg/engine/secrets"
	"github.com/Checkmarx/kics/v2/pkg/engine/source"
	"github.com/Checkmarx/kics/v2/pkg/kics"
	"github.com/Checkmarx/kics/v2/pkg/parser"
	"github.com/Checkmarx/kics/v2/pkg/progress"
	"github.com/Checkmarx/kics/v2/pkg/resolver"
	"github.com/Checkmarx/kics/v2/pkg/resolver/helm"
	"github.com/stretchr/testify/require"

	dockerParser "github.com/Checkmarx/kics/v2/pkg/parser/docker"
	jsonParser "github.com/Checkmarx/kics/v2/pkg/parser/json"
	terraformParser "github.com/Checkmarx/kics/v2/pkg/parser/terraform"
	yamlParser "github.com/Checkmarx/kics/v2/pkg/parser/yaml"
)

var (
	sourcePath = []string{filepath.FromSlash("../../assets/queries")}
)

type testContext struct {
	ctx    context.Context
	cancel context.CancelFunc
}

func TestScanner_StartScan(t *testing.T) {
	type args struct {
		scanID     string
		noProgress bool
	}
	type fields struct {
		types          []string
		cloudProviders []string
	}

	ctx := context.Background()
	tests := []struct {
		name   string
		args   args
		fields fields
		ctx    testContext
	}{
		{
			name: "testing_start_scan_no_ctx_timeout",
			args: args{
				scanID:     "console",
				noProgress: true,
			},
			fields: fields{
				types:          []string{""},
				cloudProviders: []string{""},
			},
			ctx: createContext(ctx, time.Second*99999),
		},
		{
			name: "testing_start_scan_with_ctx_timeout",
			args: args{
				scanID:     "console",
				noProgress: true,
			},
			fields: fields{
				types:          []string{""},
				cloudProviders: []string{""},
			},
			ctx: createContext(ctx, time.Second*1),
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			defer tt.ctx.cancel()
			services, store, err := createServices(tt.fields.types, tt.fields.cloudProviders)
			require.NoError(t, err)
			err = StartScan(tt.ctx.ctx, tt.args.scanID, progress.PbBuilder{}, services)
			require.NoError(t, err)
			require.NotEmpty(t, &store)
		})
	}
}

func createServices(types, cloudProviders []string) (serviceSlice, *storage.MemoryStorage, error) {
	filesSource, err := provider.NewFileSystemSourceProvider([]string{filepath.FromSlash("../../test")}, []string{})
	if err != nil {
		return nil, nil, err
	}

	t := &tracker.CITracker{}
	querySource := source.NewFilesystemSource(sourcePath, types, cloudProviders, filepath.FromSlash("../../assets/libraries"), true)

	inspector, err := engine.NewInspector(context.Background(),
		querySource, engine.DefaultVulnerabilityBuilder,
		t, &source.QueryInspectorParameters{}, map[string]bool{}, 60, true, true, 1, false)
	if err != nil {
		return nil, nil, err
	}

	secretsInspector, err := secrets.NewInspector(
		context.Background(),
		map[string]bool{},
		t,
		&source.QueryInspectorParameters{},
		false,
		60,
		assets.SecretsQueryRegexRulesJSON,
		false,
	)
	if err != nil {
		return nil, nil, err
	}

	combinedParser, err := parser.NewBuilder().
		Add(&jsonParser.Parser{}).
		Add(&yamlParser.Parser{}).
		Add(terraformParser.NewDefault()).
		Add(&dockerParser.Parser{}).
		Build(types, cloudProviders)
	if err != nil {
		return nil, nil, err
	}

	combinedResolver, err := resolver.NewBuilder().
		Add(&helm.Resolver{}).
		Build()
	if err != nil {
		return nil, nil, err
	}

	store := storage.NewMemoryStorage()

	services := make([]*kics.Service, 0, len(combinedParser))

	for _, parser := range combinedParser {
		services = append(services, &kics.Service{
			SourceProvider:   filesSource,
			Storage:          store,
			Parser:           parser,
			Inspector:        inspector,
			SecretsInspector: secretsInspector,
			Tracker:          t,
			Resolver:         combinedResolver,
		})
	}
	return services, store, nil
}

func createContext(ctx context.Context, timeout time.Duration) testContext {
	ctx, cancel := context.WithTimeout(ctx, timeout)
	return testContext{
		ctx,
		cancel,
	}
}
