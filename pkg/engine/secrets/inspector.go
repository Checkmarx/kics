package secrets

import (
	"context"

	engine "github.com/Checkmarx/kics/pkg/engine"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/rs/zerolog/log"
)

type Inspector struct {
	ctx            context.Context
	tracker        engine.Tracker
	excludeResults map[string]bool
}

func NewInspector(ctx context.Context, tracker engine.Tracker, excludeResults map[string]bool) (*Inspector, error) {
	return &Inspector{
		ctx:            ctx,
		tracker:        tracker,
		excludeResults: excludeResults,
	}, nil
}

func (c *Inspector) Inspect(ctx context.Context, files model.FileMetadatas) ([]model.Vulnerability, error) {
	for _, file := range files {
		log.Info().Msg(file.FilePath)
		c.tracker.TrackScanSecrets()
	}
	return nil, nil
}
