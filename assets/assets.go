package assets

import "embed" // used for embedding KICS libraries

//go:embed libraries/*.rego
var embeddedLibraries embed.FS

//go:embed libraries/*.json
var embeddedLibraryData embed.FS

//go:embed queries/common/passwords_and_secrets/metadata.json
var SecretsQueryMetadataJSON string

//go:embed queries/common/passwords_and_secrets/regex_rules.json
var SecretsQueryRegexRulesJSON string

// GetEmbeddedLibrary returns the embedded library.rego for the platform passed in the argument
func GetEmbeddedLibrary(platform string) (string, error) {
	content, err := embeddedLibraries.ReadFile("libraries/" + platform + ".rego")

	return string(content), err
}

// GetEmbeddedLibrary returns the embedded library.rego for the platform passed in the argument
func GetEmbeddedLibraryData(platform string) (string, error) {
	content, err := embeddedLibraryData.ReadFile("libraries/" + platform + ".json")

	return string(content), err
}
