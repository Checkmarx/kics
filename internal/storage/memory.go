package storage

import (
	"context"

	"github.com/checkmarxDev/ice/pkg/model"
)

type MemoryStorage struct {
	vulnerabilities []model.Vulnerability

	allFiles  model.FileMetadatas
	filesByID map[int]*model.FileMetadata
	fileIndex int
}

func (m *MemoryStorage) SaveFile(_ context.Context, metadata *model.FileMetadata) error {
	m.allFiles = append(m.allFiles, *metadata)
	m.allFiles[m.fileIndex].ID = m.fileIndex

	m.filesByID[m.fileIndex] = metadata
	m.filesByID[m.fileIndex].ID = m.fileIndex

	m.fileIndex++
	return nil
}

func (m *MemoryStorage) GetFiles(_ context.Context, _ string) (model.FileMetadatas, error) {
	return m.allFiles, nil
}

func (m *MemoryStorage) SaveVulnerabilities(_ context.Context, vulnerabilities []model.Vulnerability) error {
	m.vulnerabilities = append(m.vulnerabilities, vulnerabilities...)

	return nil
}

func (m *MemoryStorage) GetResults(_ context.Context, _ string) ([]model.Vulnerability, error) {
	return m.vulnerabilities, nil
}

func NewMemoryStorage() *MemoryStorage {
	return &MemoryStorage{
		allFiles:        make(model.FileMetadatas, 0),
		filesByID:       make(map[int]*model.FileMetadata),
		vulnerabilities: make([]model.Vulnerability, 0),
	}
}
