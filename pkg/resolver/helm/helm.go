package helm

import (
	"fmt"
	"io"
	"log"
	"os"
	"strings"

	"github.com/Checkmarx/kics/pkg/utils"
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
	valueOpts *values.Options) (*release.Release, error) {
	log.SetOutput(io.Discard)
	defer log.SetOutput(os.Stderr)
	if client.Version == "" && client.Devel {
		client.Version = ">0.0.0-0"
	}

	name, charts, err := client.NameAndChart(args)
	if err != nil {
		return nil, err
	}
	client.ReleaseName = name

	cp, err := client.ChartPathOptions.LocateChart(charts, settings)
	if err != nil {
		return nil, err
	}

	p := getter.All(settings)
	vals, err := valueOpts.MergeValues(p)
	if err != nil {
		return nil, err
	}

	// Check chart dependencies to make sure all are present in /charts
	chartRequested, err := loader.Load(cp)
	if err != nil {
		return nil, err
	}

	chartRequested = setID(chartRequested)

	if err := checkIfInstallable(chartRequested); err != nil {
		return nil, err
	}

	client.Namespace = "kics-namespace"
	return client.Run(chartRequested, vals)
}

// checkIfInstallable validates if a chart can be installed
//
// Application chart type is only installable
func checkIfInstallable(ch *chart.Chart) error {
	defer utils.PanicHandler()
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
		temp = addID(temp) //nolint
		if temp != nil {
			continue
		}
	}
	for _, dep := range chartReq.Dependencies() {
		dep = setID(dep) //nolint
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
