//go:generate go run -mod=mod github.com/golang/mock/mockgen -package mock -source=./$GOFILE -destination=../mock/$GOFILE
package source

import "github.com/Checkmarx/kics/pkg/model"

// ExcludeQueries represents a struct with options to exclude queries and a list for each option
type ExcludeQueries struct {
	ByIDs        []string
	ByCategories []string
}

// QueriesSource wraps an interface that contains basic methods: GetQueries and GetQueryLibrary
// GetQueries gets all queries from a QueryMetadata list
// GetQueryLibrary gets a library of rego functions given a plataform's name
type QueriesSource interface {
	GetQueries(excludeQueries ExcludeQueries) ([]model.QueryMetadata, error)
	GetQueryLibrary(platform string) (string, error)
}
