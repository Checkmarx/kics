package assets

import "embed" // used for embedding KICS libraries

//go:embed libraries/*.rego
var embeddedLibraries embed.FS

//go:embed libraries/*.json
var embeddedLibraryData embed.FS

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
