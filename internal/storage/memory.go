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

func (m *MemoryStorage) GetFiles(_ context.Context, _, _ string) (model.FileMetadatas, error) {
	return m.allFiles, nil
}

func (m *MemoryStorage) SaveVulnerabilities(_ context.Context, vulnerabilities []model.Vulnerability) error {
	m.vulnerabilities = append(m.vulnerabilities, vulnerabilities...)

	return nil
}

func (m *MemoryStorage) GetResults(_ context.Context, _ string) ([]model.ResultItem, error) {
	res := make([]model.ResultItem, len(m.vulnerabilities))
	for i := range m.vulnerabilities {
		v := m.vulnerabilities[i]
		res[i] = model.ResultItem{
			ID:               i,
			FileName:         m.filesByID[v.FileID].FileName,
			Line:             v.Line,
			QueryName:        v.QueryName,
			Severity:         v.Severity,
			IssueType:        v.IssueType,
			KeyExpectedValue: v.KeyExpectedValue,
			KeyActualValue:   v.KeyActualValue,
		}
	}

	return res, nil
}

func NewMemoryStorage() *MemoryStorage {
	return &MemoryStorage{
		allFiles:        make(model.FileMetadatas, 0),
		filesByID:       make(map[int]*model.FileMetadata),
		vulnerabilities: make([]model.Vulnerability, 0),
	}
}
