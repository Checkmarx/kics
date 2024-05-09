package storage

import (
	"context"
	"fmt"
	"sync"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/rs/zerolog/log"
)

var (
	memoryMu sync.Mutex
)

// MemoryStorage is scans' results representation
type MemoryStorage struct {
	vulnerabilities []model.Vulnerability
	allFiles        model.FileMetadatas
}

// SaveFile adds a new file metadata to files collection
func (m *MemoryStorage) SaveFile(_ context.Context, metadata *model.FileMetadata) error {
	m.allFiles = append(m.allFiles, *metadata)
	return nil
}

// GetFiles returns a collection of files saved on MemoryStorage
func (m *MemoryStorage) GetFiles(_ context.Context, _ string) (model.FileMetadatas, error) {
	return m.allFiles, nil
}

// SaveVulnerabilities adds a list of vulnerabilities to vulnerabilities collection
func (m *MemoryStorage) SaveVulnerabilities(_ context.Context, vulnerabilities []model.Vulnerability) error {
	defer memoryMu.Unlock()
	memoryMu.Lock()
	m.vulnerabilities = append(m.vulnerabilities, vulnerabilities...)
	return nil
}

// GetVulnerabilities returns a collection of vulnerabilities saved on MemoryStorage
func (m *MemoryStorage) GetVulnerabilities(_ context.Context, _ string) ([]model.Vulnerability, error) {
	return m.getUniqueVulnerabilities(), nil
}

func (m *MemoryStorage) getUniqueVulnerabilities() []model.Vulnerability {
	vulnDictionary := make(map[string]model.Vulnerability)
	for i := range m.vulnerabilities {
		key := fmt.Sprintf("%s:%s:%d:%s:%s:%s",
			m.vulnerabilities[i].QueryID,
			m.vulnerabilities[i].FileName,
			m.vulnerabilities[i].Line,
			m.vulnerabilities[i].SimilarityID,
			m.vulnerabilities[i].SearchKey,
			m.vulnerabilities[i].KeyActualValue,
		)
		vulnDictionary[key] = m.vulnerabilities[i]
	}

	var uniqueVulnerabilities []model.Vulnerability
	for key := range vulnDictionary {
		uniqueVulnerabilities = append(uniqueVulnerabilities, vulnDictionary[key])
	}
	if len(uniqueVulnerabilities) == 0 {
		return m.vulnerabilities
	}
	return uniqueVulnerabilities
}

// GetScanSummary is not supported by MemoryStorage
func (m *MemoryStorage) GetScanSummary(_ context.Context, _ []string) ([]model.SeveritySummary, error) {
	return nil, nil
}

// NewMemoryStorage creates a new MemoryStorage empty and returns it
func NewMemoryStorage() *MemoryStorage {
	log.Debug().Msg("storage.NewMemoryStorage()")
	return &MemoryStorage{
		allFiles:        make(model.FileMetadatas, 0),
		vulnerabilities: make([]model.Vulnerability, 0),
	}
}
