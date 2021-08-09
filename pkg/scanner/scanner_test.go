package scanner

import (
	"context"
	"path/filepath"
	"testing"

	"github.com/Checkmarx/kics/internal/storage"
	"github.com/Checkmarx/kics/internal/tracker"
	"github.com/Checkmarx/kics/pkg/engine"
	"github.com/Checkmarx/kics/pkg/engine/provider"
	"github.com/Checkmarx/kics/pkg/engine/source"
	"github.com/Checkmarx/kics/pkg/kics"
	"github.com/Checkmarx/kics/pkg/parser"
	"github.com/Checkmarx/kics/pkg/progress"
	"github.com/Checkmarx/kics/pkg/resolver"
	"github.com/Checkmarx/kics/pkg/resolver/helm"
	"github.com/stretchr/testify/require"

	dockerParser "github.com/Checkmarx/kics/pkg/parser/docker"
	jsonParser "github.com/Checkmarx/kics/pkg/parser/json"
	terraformParser "github.com/Checkmarx/kics/pkg/parser/terraform"
	yamlParser "github.com/Checkmarx/kics/pkg/parser/yaml"
)

func TestScanner_StartScan(t *testing.T) {
	type args struct {
		scanID     string
		noProgress bool
	}
	type feilds struct {
		types          []string
		cloudProviders []string
	}
	tests := []struct {
		name   string
		args   args
		feilds feilds
	}{
		{
			name: "testing_start_scan",
			args: args{
				scanID:     "console",
				noProgress: true,
			},
			feilds: feilds{
				types:          []string{""},
				cloudProviders: []string{""},
			},
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			services, store, err := createServices(tt.feilds.types, tt.feilds.cloudProviders)
			require.NoError(t, err)
			err = StartScan(context.Background(), tt.args.scanID, progress.PbBuilder{}, services)
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
	querySource := source.NewFilesystemSource(filepath.FromSlash("../../assets/queries"), types, cloudProviders)

	inspector, err := engine.NewInspector(context.Background(),
		querySource, engine.DefaultVulnerabilityBuilder,
		t, &source.QueryInspectorParameters{}, map[string]bool{}, 60)
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
			SourceProvider: filesSource,
			Storage:        store,
			Parser:         parser,
			Inspector:      inspector,
			Tracker:        t,
			Resolver:       combinedResolver,
		})
	}
	return services, store, nil
}
