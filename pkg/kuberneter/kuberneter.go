/*
Package kuberneter implements calls to the Kubernetes API in order to scan the runtime information of the resources
*/
package kuberneter

import (
	"context"
	"os"
	"path/filepath"
	"strings"
	"sync"

	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
	"k8s.io/apimachinery/pkg/api/meta"
	"sigs.k8s.io/controller-runtime/pkg/client"
)

type k8sAPICall struct {
	client          client.Client
	options         *K8sAPIOptions
	ctx             *context.Context
	destinationPath string
}

type supportedKinds map[string]map[string]interface{}

var getK8sClientFunc = getK8sClient // for testing purposes

// Import imports the k8s cluster resources into the destination using kuberneter path
func Import(ctx context.Context, kuberneterPath, destinationPath string) (string, error) {
	log.Info().Msg("importing k8s cluster resources")

	supportedKinds := buildSupportedKinds()
	defer func() { supportedKinds = nil }()

	// extract k8s API options
	k8sAPIOptions, err := extractK8sAPIOptions(kuberneterPath, supportedKinds)
	if err != nil {
		return "", err
	}

	// get the k8s client
	c, err := getK8sClientFunc()
	if err != nil {
		return "", err
	}

	// create folder to save k8s resources
	destination, err := getDestinationFolder(destinationPath)
	if err != nil {
		return "", err
	}

	if c == nil {
		return destination, errors.New("failed to get client")
	}

	info := &k8sAPICall{
		client:          c,
		options:         k8sAPIOptions,
		ctx:             &ctx,
		destinationPath: destination,
	}

	// list and save k8s resources
	for i := range k8sAPIOptions.Namespaces {
		info.listK8sResources(i, supportedKinds)
	}

	return destination, nil
}

func (info *k8sAPICall) listK8sResources(idx int, supKinds *supportedKinds) {
	var wg sync.WaitGroup
	for apiVersion := range *supKinds {
		kinds := (*supKinds)[apiVersion]

		if isTarget(apiVersion, info.options.APIVersions) {
			wg.Add(1)
			go info.listKinds(apiVersion, kinds, info.options.Namespaces[idx], &wg)
		}
	}
	wg.Wait()
}

func (info *k8sAPICall) listKinds(apiVersion string, kinds map[string]interface{}, namespace string, wg *sync.WaitGroup) {
	defer wg.Done()
	sb := &strings.Builder{}

	apiVersionFolder := filepath.Join(info.destinationPath, apiVersion)

	if err := os.MkdirAll(apiVersionFolder, dirPerms); err != nil {
		log.Error().Msgf("unable to create folder %s: %s", apiVersionFolder, err)
		return
	}

	for kind := range kinds {
		kindList := kinds[kind]

		if !isTarget(kind, info.options.Kinds) {
			continue
		}

		if _, ok := kindList.(client.ObjectList); !ok {
			continue
		}

		resource := kindList.(client.ObjectList)
		err := info.client.List(*info.ctx, resource, client.InNamespace(namespace))
		if err != nil {
			log.Info().Msgf("failed to list %s: %s", apiVersion, err)
		}

		objList, err := meta.ExtractList(resource)
		if err != nil {
			log.Info().Msgf("failed to extract list: %s", err)
		}

		log.Info().Msgf("KICS found %d %s(s) in %s from %s", len(objList), kind, getNamespace(namespace), apiVersion)

		for i := range objList {
			item := objList[i]
			sb = info.getResource(item, apiVersion, kind, sb)
		}

		if sb.String() != "" {
			info.saveK8sResources(kind, sb.String(), apiVersionFolder)
		}
		sb.Reset()
	}
}
