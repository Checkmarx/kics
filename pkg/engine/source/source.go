//go:generate go run github.com/golang/mock/mockgen -package mock -source=./source.go -destination=../mock/source.go
package source

import "github.com/Checkmarx/kics/pkg/model"

// ExcludeQueries represents a struct with options to exclude queries and a list for each option
type ExcludeQueries struct {
	ByIDs        []string
	ByCategories []string
}

// QueriesSource wraps an interface that contains basic methods: GetQueries and GetGenericQuery
// GetQueries gets all queries from a QueryMetadata list
// GetGenericQuery gets a base query based in plataform's name
type QueriesSource interface {
	GetQueries(excludeQueries ExcludeQueries) ([]model.QueryMetadata, error)
	GetGenericQuery(platform string) (string, error)
}
