package storage

import (
	"context"

	"github.com/Checkmarx/kics/pkg/model"
)

type MemoryStorage struct {
	vulnerabilities []model.Vulnerability
	allFiles        model.FileMetadatas
}

func (m *MemoryStorage) SaveFile(_ context.Context, metadata *model.FileMetadata) error {
	m.allFiles = append(m.allFiles, *metadata)
	return nil
}

func (m *MemoryStorage) GetFiles(_ context.Context, _ string) (model.FileMetadatas, error) {
	return m.allFiles, nil
}

func (m *MemoryStorage) SaveVulnerabilities(_ context.Context, vulnerabilities []model.Vulnerability) error {
	m.vulnerabilities = append(m.vulnerabilities, vulnerabilities...)

	return nil
}

func (m *MemoryStorage) GetVulnerabilities(_ context.Context, _ string) ([]model.Vulnerability, error) {
	return m.vulnerabilities, nil
}

func (m *MemoryStorage) GetScanSummary(_ context.Context, _ []string) ([]model.SeveritySummary, error) {
	return nil, nil // unsupported for this storage type
}

func NewMemoryStorage() *MemoryStorage {
	return &MemoryStorage{
		allFiles:        make(model.FileMetadatas, 0),
		vulnerabilities: make([]model.Vulnerability, 0),
	}
}
