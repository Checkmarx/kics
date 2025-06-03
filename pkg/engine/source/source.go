// Package source (go:generate go run -mod=mod github.com/golang/mock/mockgen -package mock -source=./$GOFILE -destination=../mock/$GOFILE)
package source

import (
	"encoding/json"
	"strings"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/open-policy-agent/opa/v1/ast"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

// QueryInspectorParameters is a struct that represents the optionn to select queries to be executed
type QueryInspectorParameters struct {
	IncludeQueries      IncludeQueries
	ExcludeQueries      ExcludeQueries
	ExperimentalQueries bool
	InputDataPath       string
	BomQueries          bool
}

// ExcludeQueries is a struct that represents the option to exclude queries by ids or by categories
type ExcludeQueries struct {
	ByIDs        []string
	ByCategories []string
	BySeverities []string
}

// IncludeQueries is a struct that represents the option to include queries by ID taking precedence over exclusion
type IncludeQueries struct {
	ByIDs []string
}

// RegoLibraries is a struct that contains the library code and its input data
type RegoLibraries struct {
	LibraryCode      string
	LibraryInputData string
}

// QueriesSource wraps an interface that contains basic methods: GetQueries and GetQueryLibrary
// GetQueries gets all queries from a QueryMetadata list
// GetQueryLibrary gets a library of rego functions given a plataform's name
type QueriesSource interface {
	GetQueries(querySelection *QueryInspectorParameters) ([]model.QueryMetadata, error)
	GetQueryLibrary(platform string) (RegoLibraries, error)
}

// mergeLibraries return custom library and embedded library merged, overwriting embedded library functions, if necessary
func mergeLibraries(customLib, embeddedLib string) (string, error) {
	if customLib == "" {
		return embeddedLib, nil
	}
	statements, _, err := ast.NewParser().WithRegoVersion(ast.RegoV0).WithReader(strings.NewReader(customLib)).Parse()
	if err != nil {
		log.Err(err).Msg("Could not parse custom library")
		return "", err
	}
	headers := make(map[string]string)
	variables := make(map[string]string)
	for _, st := range statements {
		if rule, ok := st.(*ast.Rule); ok {
			headers[string(rule.Head.Name)] = ""
		}
		if regoPackage, ok := st.(ast.Body); ok {
			variableSet := regoPackage.Vars(ast.SafetyCheckVisitorParams)
			for variable := range variableSet {
				variables[variable.String()] = ""
			}
		}
	}
	statements, _, err = ast.NewParser().WithRegoVersion(ast.RegoV0).WithReader(strings.NewReader(embeddedLib)).Parse()
	if err != nil {
		log.Err(err).Msg("Could not parse default library")
		return "", err
	}
	for _, st := range statements {
		if rule, ok := st.(*ast.Rule); ok {
			if _, remove := headers[string(rule.Head.Name)]; remove {
				embeddedLib = strings.Replace(embeddedLib, string(rule.Location.Text), "", 1)
			}
			continue
		}
		if regoPackage, ok := st.(*ast.Package); ok {
			firstHalf := strings.Join(strings.Split(embeddedLib, "\n")[:regoPackage.Location.Row-1], "\n")
			secondHalf := strings.Join(strings.Split(embeddedLib, "\n")[regoPackage.Location.Row+1:], "\n")
			embeddedLib = firstHalf + "\n" + secondHalf
			continue
		}
		if body, ok := st.(ast.Body); ok {
			variableSet := body.Vars(ast.SafetyCheckVisitorParams)
			for variable := range variableSet {
				if _, remove := variables[variable.String()]; remove {
					embeddedLib = strings.Replace(embeddedLib, string(body.Loc().Text), "", 1)
					break
				}
			}
		}
	}
	customLib += "\n" + embeddedLib

	return customLib, nil
}

// MergeInputData merges KICS input data with custom input data user defined
func MergeInputData(defaultInputData, customInputData string) (string, error) {
	if checkEmptyInputdata(customInputData) && checkEmptyInputdata(defaultInputData) {
		return emptyInputData, nil
	}
	if checkEmptyInputdata(defaultInputData) {
		return customInputData, nil
	}
	if checkEmptyInputdata(customInputData) {
		return defaultInputData, nil
	}

	dataJSON := map[string]interface{}{}
	customDataJSON := map[string]interface{}{}
	if unmarshalError := json.Unmarshal([]byte(defaultInputData), &dataJSON); unmarshalError != nil {
		return "", errors.Wrapf(unmarshalError, "failed to merge query input data")
	}
	if unmarshalError := json.Unmarshal([]byte(customInputData), &customDataJSON); unmarshalError != nil {
		return "", errors.Wrapf(unmarshalError, "failed to merge query input data")
	}

	for key, value := range customDataJSON {
		dataJSON[key] = value
	}
	mergedJSON, mergeErr := json.Marshal(dataJSON)
	if mergeErr != nil {
		return "", errors.Wrapf(mergeErr, "failed to merge query input data")
	}
	return string(mergedJSON), nil
}

func checkEmptyInputdata(inputData string) bool {
	return inputData == emptyInputData || inputData == ""
}
