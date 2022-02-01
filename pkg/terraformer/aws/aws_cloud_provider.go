//go:build !dev
// +build !dev

package aws

import (
	"context"
	"errors"
	"sync"
	"time"

	importer "github.com/GoogleCloudPlatform/terraformer/cmd"
	awsterraformer "github.com/GoogleCloudPlatform/terraformer/providers/aws"
	"github.com/GoogleCloudPlatform/terraformer/terraformutils"
)

var terraformerTimeout = time.Minute * 3

// ImporterFunc is the function kics uses to import resources (for testing porpuses)
var ImporterFunc func(provider terraformutils.ProviderGenerator, options importer.ImportOptions, args []string) error = importer.Import

// CloudProvider is the AWS Cloud Provider
type CloudProvider struct{}

var provider = &awsterraformer.AWSProvider{}

// Import imports the terraformer resources into the destination using terraformer
func (a CloudProvider) Import(ctx context.Context, options *importer.ImportOptions, destination string) error {
	ctxT, cancel := context.WithTimeout(ctx, terraformerTimeout)
	defer cancel()
	wg := sync.WaitGroup{}
	done := make(chan error, 1)

	for _, region := range options.Regions {
		wg.Add(1)
		go func(region string) {
			defer wg.Done()
			done <- ImporterFunc(provider, *options, []string{region, ""})
		}(region)
	}

	go func() {
		defer close(done)
		wg.Wait()
	}()

	select {
	case err := <-done:
		return err
	case <-ctxT.Done():
		return errors.New("terraformer import execution timeout")
	}
}
