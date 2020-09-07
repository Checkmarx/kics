package storage

import (
	"context"

	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/rs/zerolog/log"
)

type MemoryStorage struct {
	files map[int]*model.FileMetadata
	index int
}

func (m *MemoryStorage) SaveFile(_ context.Context, metadata *model.FileMetadata) error {
	metadata.ID = m.index
	m.files[m.index] = metadata
	m.index++
	return nil
}

func (m *MemoryStorage) GetFiles(_ context.Context, _, _ string) (model.FileMetadatas, error) {
	slice := make([]model.FileMetadata, 0, len(m.files))
	for _, file := range m.files {
		slice = append(slice, *file)
	}

	return slice, nil
}

func (m *MemoryStorage) SaveVulnerabilities(_ context.Context, vulnerabilities []model.Vulnerability) error {
	for _, v := range vulnerabilities {
		if v.Line != nil {
			log.Info().Msgf("[%s] %s:%d %s", v.Severity, m.files[v.FileID].FileName, *v.Line, v.QueryName)
			continue
		}

		log.Info().Msgf("[%s] %s: %s", v.Severity, m.files[v.FileID].FileName, v.QueryName)
	}

	return nil
}

func (m *MemoryStorage) GetResults(ctx context.Context, _ string) ([]model.ResultItem, error) {
	return nil, nil
}

func NewMemoryStorage() *MemoryStorage {
	return &MemoryStorage{
		files: make(map[int]*model.FileMetadata),
	}
}
