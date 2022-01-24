//go:build !dev
// +build !dev

package terraformer

import (
	"context"
	"io/fs"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"

	tfLogger "log"

	"github.com/Checkmarx/kics/pkg/terraformer/aws"
	importer "github.com/GoogleCloudPlatform/terraformer/cmd"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

const terraformerPathLength = 3

// Path is a struct that contains the terraformer path information
type Path struct {
	CloudProvider string
	Region        []string
	Resource      []string
}

// CloudProvider is an interface that defines the methods that a cloud provider must implement
type CloudProvider interface {
	Import(ctx context.Context, options *importer.ImportOptions, destination string) error
}

func (t *Path) createTfOptions(destination, region string) *importer.ImportOptions {
	return &importer.ImportOptions{
		Resources:     t.Resource,
		Excludes:      []string{""},
		PathPattern:   filepath.Join(destination, "{service}"),
		PathOutput:    "generated",
		State:         "local",
		Bucket:        "",
		Profile:       "",
		Verbose:       false,
		Zone:          "",
		Regions:       []string{region},
		Projects:      []string{""},
		ResourceGroup: "",
		Connect:       true,
		Compact:       false,
		Filter:        []string{},
		Plan:          false,
		Output:        "hcl",
		RetryCount:    5,
		RetrySleepMs:  300,
	}
}

// Import imports the terraformer resources into the destination using terraformer
func Import(terraformerPath, destinationPath string) (string, error) {
	log.Info().Msg("importing terraformer resources")
	tfLogger.SetOutput(ioutil.Discard)
	pathOptions, err := extractTerraformerOptions(terraformerPath)
	if err != nil {
		return "", errors.Wrap(err, "wrong terraformer path syntax")
	}
	ctx := context.Background()
	if destinationPath == "" {
		destinationPath, err = os.Getwd()
		if err != nil {
			return "", errors.Wrap(err, "failed to get working directory")
		}
	}

	destination := filepath.Join(destinationPath, "kics-extract-terraformer")

	var provider CloudProvider

	switch pathOptions.CloudProvider {
	case "aws":
		provider = aws.CloudProvider{}
	default:
		return "", errors.New("unsupported Cloud Provider")
	}

	for _, region := range pathOptions.Region {
		regionDest := filepath.Join(destination, region)
		err = provider.Import(ctx, pathOptions.createTfOptions(regionDest, region), destination)
		if err != nil {
			return "", err
		}
	}

	cleanUnwantedFiles(destination)

	return destination, nil
}

func extractTerraformerOptions(path string) (*Path, error) {
	pathInfo := strings.Split(path, ":")
	if len(pathInfo) != terraformerPathLength {
		return nil, errors.New("wrong terraformer path syntax")
	}
	return &Path{
		CloudProvider: pathInfo[0],
		Region:        strings.Split(pathInfo[2], "/"),
		Resource:      strings.Split(pathInfo[1], "/"),
	}, nil
}

func cleanUnwantedFiles(destination string) {
	err := filepath.Walk(destination, func(path string, info fs.FileInfo, err error) error {
		if info != nil {
			deleteOutputFile(path, info)
		}
		return nil
	})

	if err != nil {
		log.Err(err).Msg("failed to clean unwanted files")
	}
}

func deleteOutputFile(path string, output fs.FileInfo) {
	if output.Name() == "outputs.tf" {
		err := os.Remove(path)
		if err != nil {
			log.Err(err).Msgf("failed to remove outputs.tf in path %s", path)
		}
	}
}
