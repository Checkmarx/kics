package helm

import (
	"path/filepath"
	"strings"

	"github.com/Checkmarx/kics/pkg/model"
	"helm.sh/helm/v3/pkg/chart"
	"helm.sh/helm/v3/pkg/cli/values"
	"helm.sh/helm/v3/pkg/release"
)

type Resolver struct {
}

type splitManifest struct {
	path     string
	content  []byte
	original []byte
	splitID  string
}

func (r *Resolver) Resolve(filePath string) (model.RenderedFiles, error) {
	var rfiles = model.RenderedFiles{}
	splits, err := renderHelm(filePath)
	if err != nil {
		return model.RenderedFiles{}, nil
	}
	for _, split := range *splits {
		origpath := filepath.Join(filepath.Dir(filePath), split.path)
		rfiles.File = append(rfiles.File, model.RenderedFile{
			FileName:     origpath,
			Content:      split.content,
			OriginalData: split.original,
			SplitID:      split.splitID,
		})
	}
	return rfiles, nil
}

func (r *Resolver) SupportedTypes() []model.FileKind {
	return []model.FileKind{model.KINDHELM}
}

// renderHelm will use helm binary to render helm templates
func renderHelm(path string) (*[]splitManifest, error) {
	client := newClient()
	test, err := runInstall([]string{path}, client, &values.Options{}, nil)
	if err != nil {
		return nil, err
	}
	return splitYaml(test)
}

// splitYaml will split the rendered file and return its content by template as well as the template path
func splitYaml(template *release.Release) (*[]splitManifest, error) {
	templates := make([]*chart.File, 0)
	templates = templateMaker(templates, template.Chart, template.Chart.Name())
	splitSlice := []splitManifest{}
	testSplit := strings.Split(template.Manifest, "---")
	origData := convertToMap(templates)
	for _, splited := range testSplit {
		var lineID string
		for _, line := range strings.Split(splited, "\n") {
			if strings.Contains(line, "# KICS_HELM_ID_") {
				lineID = line
				break
			}
		}
		path := strings.Split(strings.TrimLeft(splited, "\n# Source:"), "\n") // need to get id here to be passed
		if path[0] == "" || strings.Contains(path[0], "secrets.yaml") || strings.Contains(path[0], "secret.yaml") {
			continue
		}
		if origData[path[0]] == nil {
			continue
		}
		splitSlice = append(splitSlice, splitManifest{
			path:     path[0],
			content:  []byte(splited),
			original: origData[path[0]],
			splitID:  lineID,
		})
	}
	return &splitSlice, nil
}

func convertToMap(files []*chart.File) map[string][]byte {
	mapFiles := make(map[string][]byte)
	for _, file := range files {
		mapFiles[file.Name] = file.Data
	}
	return mapFiles
}

func templateMaker(template []*chart.File, charts *chart.Chart, name string) []*chart.File {
	if name != charts.Name() {
		name = filepath.Join(name, charts.Name())
	}
	for _, temp := range charts.Templates {
		temp.Name = filepath.Join(name, temp.Name)
	}
	template = append(template, charts.Templates...)
	for _, dep := range charts.Dependencies() {
		template = templateMaker(template, dep, filepath.Join(name, "charts"))
	}
	return template
}
