// Package source (go:generate go run -mod=mod github.com/golang/mock/mockgen -package mock -source=./$GOFILE -destination=../mock/$GOFILE)
package source

import "github.com/Checkmarx/kics/pkg/model"

// QuerySelectionFilter is a struct that represents the optionn to select queries to be executed
type QuerySelectionFilter struct {
	IncludeQueries IncludeQueries
	ExcludeQueries ExcludeQueries
}

// ExcludeQueries is a struct that represents the option to exclude queries by ids or by categories
type ExcludeQueries struct {
	ByIDs        []string
	ByCategories []string
}

// IncludeQueries is a struct that represents the option to include queries by ID taking precedence over exclusion
type IncludeQueries struct {
	ByIDs []string
}

// QueriesSource wraps an interface that contains basic methods: GetQueries and GetQueryLibrary
// GetQueries gets all queries from a QueryMetadata list
// GetQueryLibrary gets a library of rego functions given a plataform's name
type QueriesSource interface {
	GetQueries(querySelection QuerySelectionFilter) ([]model.QueryMetadata, error)
	GetQueryLibrary(platform string) (string, error)
}
