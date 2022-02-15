//go:build !dev
// +build !dev

package terraformer

import (
	"context"
	"fmt"
	"io/fs"
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
	"time"

	tfLogger "log"

	"github.com/Checkmarx/kics/pkg/terraformer/aws"
	"github.com/Checkmarx/kics/pkg/terraformer/azure"
	"github.com/Checkmarx/kics/pkg/terraformer/gcp"
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
	Projects      []string
}

// CloudProvider is an interface that defines the methods that a cloud provider must implement
type CloudProvider interface {
	Import(ctx context.Context, options *importer.ImportOptions, destination string) error
}

func (t *Path) createTfOptions(destination, region string, projects []string) *importer.ImportOptions {
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
		Projects:      projects,
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

	destFolderName := fmt.Sprintf("kics-extract-terraformer-%s", time.Now().Format("01-02-2006"))

	destination := filepath.Join(destinationPath, destFolderName)

	var provider CloudProvider

	switch pathOptions.CloudProvider {
	case "aws":
		provider = aws.CloudProvider{}
	case "azure":
		provider = azure.CloudProvider{}
	case "gcp":
		provider = gcp.CloudProvider{}
	default:
		return "", errors.New("unsupported Cloud Provider")
	}

	for _, region := range pathOptions.Region {
		regionDest := filepath.Join(destination, region)
		err = provider.Import(ctx, pathOptions.createTfOptions(regionDest, region, pathOptions.Projects), destination)
		if err != nil {
			return "", err
		}
	}

	cleanUnwantedFiles(destination)

	return destination, nil
}

func extractTerraformerOptions(path string) (*Path, error) {
	pathInfo := strings.Split(path, ":")
	if len(pathInfo) != terraformerPathLength && len(pathInfo) != terraformerPathLength+1 {
		return nil, errors.New("wrong terraformer path syntax")
	}
	return &Path{
		CloudProvider: pathInfo[0],
		Region:        strings.Split(pathInfo[2], "/"),
		Resource:      strings.Split(pathInfo[1], "/"),
		Projects:      getProjects(pathInfo),
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

func getProjects(pathInfo []string) []string {
	if len(pathInfo) == terraformerPathLength+1 {
		return strings.Split(pathInfo[3], "/")
	}

	return []string{}
}
