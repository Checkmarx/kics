package helm

import (
	"fmt"
	"io"
	"log"
	"os"
	"path/filepath"
	"strings"

	"github.com/pkg/errors"
	"helm.sh/helm/v3/pkg/action"
	"helm.sh/helm/v3/pkg/chart"
	"helm.sh/helm/v3/pkg/chart/loader"
	"helm.sh/helm/v3/pkg/chartutil"
	"helm.sh/helm/v3/pkg/cli"
	"helm.sh/helm/v3/pkg/cli/values"
	"helm.sh/helm/v3/pkg/getter"
	"helm.sh/helm/v3/pkg/release"
)

// credit: https://github.com/helm/helm

var (
	settings = cli.New()
)

func runInstall(args []string, client *action.Install,
	valueOpts *values.Options) (*release.Release, []string, error) {
	log.SetOutput(io.Discard)
	defer log.SetOutput(os.Stderr)
	if client.Version == "" && client.Devel {
		client.Version = ">0.0.0-0"
	}

	name, charts, err := client.NameAndChart(args)
	if err != nil {
		return nil, []string{}, err
	}
	client.ReleaseName = name

	cp, err := client.LocateChart(charts, settings)
	if err != nil {
		return nil, []string{}, err
	}

	p := getter.All(settings)
	vals, err := valueOpts.MergeValues(p)
	if err != nil {
		return nil, []string{}, err
	}

	// Check chart dependencies to make sure all are present in /charts
	chartRequested, err := loader.Load(cp)
	if err != nil {
		return nil, []string{}, err
	}

	excluded := getExcluded(chartRequested, cp)

	chartRequested = setID(chartRequested)

	if instErr := checkIfInstallable(chartRequested); instErr != nil {
		return nil, []string{}, instErr
	}

	client.Namespace = "kics-namespace"
	helmRelease, err := client.Run(chartRequested, vals)
	if err != nil {
		return nil, []string{}, err
	}
	return helmRelease, excluded, nil
}

// checkIfInstallable validates if a chart can be installed
//
// Application chart type is only installable
func checkIfInstallable(ch *chart.Chart) error {
	switch ch.Metadata.Type {
	case "", "application":
		return nil
	}
	return errors.Errorf("%s charts are not installable", ch.Metadata.Type)
}

// newClient will create a new instance on helm client used to render the chart
func newClient() *action.Install {
	cfg := new(action.Configuration)
	client := action.NewInstall(cfg)
	client.DryRun = true
	client.ReleaseName = "kics-helm"
	client.Replace = true // Skip the name check
	client.ClientOnly = true
	client.APIVersions = chartutil.VersionSet([]string{})
	client.IncludeCRDs = false
	return client
}

// setID will add auxiliary lines for each template as well as its dependencies
func setID(chartReq *chart.Chart) *chart.Chart {
	for _, temp := range chartReq.Templates {
		temp = addID(temp)
		if temp != nil {
			continue
		}
	}
	for _, dep := range chartReq.Dependencies() {
		dep = setID(dep)
		if dep != nil {
			continue
		}
	}
	return chartReq
}

// addID will add auxiliary lines used to detect line
// one for each "apiVersion:" where the id will be the line
func addID(file *chart.File) *chart.File {
	split := strings.Split(string(file.Data), "\n")
	for i := 0; i < len(split); i++ {
		if strings.Contains(split[i], "apiVersion:") {
			split = append(split, "")
			copy(split[i+1:], split[i:])
			split[i] = fmt.Sprintf("# KICS_HELM_ID_%d:", i)
			i++
		}
	}
	file.Data = []byte(strings.Join(split, "\n"))
	return file
}

// getExcluded will return all files rendered to be excluded from scan
func getExcluded(charterino *chart.Chart, chartpath string) []string {
	excluded := make([]string, 0)
	for _, file := range charterino.Raw {
		excluded = append(excluded, filepath.Join(chartpath, file.Name))
	}

	return excluded
}
