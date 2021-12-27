package provider

import (
	"io/fs"
	"io/ioutil"
	"log"
	"os"
	"path/filepath"

	importer "github.com/GoogleCloudPlatform/terraformer/cmd"
	awsterraformer "github.com/GoogleCloudPlatform/terraformer/providers/aws"
)

func createOptions() (*importer.ImportOptions, string) {
	destination := filepath.Join(os.TempDir(), "kics-extract-"+nextRandom())
	return &importer.ImportOptions{
		Resources:     []string{"subnet"},
		Excludes:      []string{""},
		PathPattern:   destination + "/{service}",
		PathOutput:    "generated",
		State:         "local",
		Bucket:        "",
		Profile:       "default",
		Verbose:       false,
		Zone:          "",
		Regions:       []string{"eu-west-1"},
		Projects:      []string{""},
		ResourceGroup: "",
		Connect:       true,
		Compact:       false,
		Filter:        []string{},
		Plan:          false,
		Output:        "hcl",
		RetryCount:    5,
		RetrySleepMs:  300,
	}, destination
}

func terraformerImportAWS() (string, error) {
	provider := &awsterraformer.AWSProvider{}

	options, dest := createOptions()
	log.SetOutput(ioutil.Discard)
	err := importer.Import(provider, *options, []string{"eu-west-1", ""})
	errW := filepath.Walk(dest, func(path string, info fs.FileInfo, err error) error {
		if info.Name() == "outputs.tf" {
			os.Remove(path)
		}
		return nil
	})

	if errW != nil {
		return "", errW
	}
	return dest, err
}
