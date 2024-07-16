package helm

import (
	"path/filepath"
	"regexp"
	"strconv"
	"strings"

	"github.com/Checkmarx/kics/v2/pkg/model"
	masterUtils "github.com/Checkmarx/kics/v2/pkg/utils"
	"github.com/pkg/errors"
	"helm.sh/helm/v3/pkg/chart"
	"helm.sh/helm/v3/pkg/cli/values"
	"helm.sh/helm/v3/pkg/release"
)

// Resolver is an instance of the helm resolver
type Resolver struct {
}

// splitManifest keeps the information of the manifest splitted by source
type splitManifest struct {
	path       string
	content    []byte
	original   []byte
	splitID    string
	splitIDMap map[int]interface{}
}

const (
	kicsHelmID = "# KICS_HELM_ID_"
)

// Resolve will render the passed helm chart and return its content ready for parsing
func (r *Resolver) Resolve(filePath string) (model.ResolvedFiles, error) {
	// handle panic during resolve process
	defer func() {
		if r := recover(); r != nil {
			errMessage := "Recovered from panic during resolve of file " + filePath
			masterUtils.HandlePanic(r, errMessage)
		}
	}()
	splits, excluded, err := renderHelm(filePath)
	if err != nil { // return error to be logged
		return model.ResolvedFiles{}, errors.New("failed to render helm chart")
	}
	var rfiles = model.ResolvedFiles{
		Excluded: excluded,
	}
	for _, split := range *splits {
		subFolder := filepath.Base(filePath)

		splitPath := strings.Split(split.path, getPathSeparator(split.path))

		splited := filepath.Join(splitPath[1:]...)

		origpath := filepath.Join(filepath.Dir(filePath), subFolder, splited)
		rfiles.File = append(rfiles.File, model.ResolvedHelm{
			FileName:     origpath,
			Content:      split.content,
			OriginalData: split.original,
			SplitID:      split.splitID,
			IDInfo:       split.splitIDMap,
		})
	}
	return rfiles, nil
}

// SupportedTypes returns the supported fileKinds for this resolver
func (r *Resolver) SupportedTypes() []model.FileKind {
	return []model.FileKind{model.KindHELM}
}

// renderHelm will use helm library to render helm charts
func renderHelm(path string) (*[]splitManifest, []string, error) {
	client := newClient()
	manifest, excluded, err := runInstall([]string{path}, client, &values.Options{})
	if err != nil {
		return nil, []string{}, err
	}
	splitted, err := splitManifestYAML(manifest)
	if err != nil {
		return nil, []string{}, err
	}
	return splitted, excluded, nil
}

// splitManifestYAML will split the rendered file and return its content by template as well as the template path
func splitManifestYAML(template *release.Release) (*[]splitManifest, error) {
	sources := make([]*chart.File, 0)
	sources = updateName(sources, template.Chart, template.Chart.Name())
	var splitedManifest []splitManifest
	splitedSource := strings.Split(template.Manifest, "---") // split manifest by '---'
	origData := toMap(sources)
	for _, splited := range splitedSource {
		var lineID string
		for _, line := range strings.Split(splited, "\n") {
			if strings.Contains(line, kicsHelmID) {
				lineID = line // get auxiliary line id
				break
			}
		}
		path := strings.Split(strings.TrimPrefix(splited, "\n# Source: "), "\n") // get source of split yaml
		// ignore auxiliary files used to render chart
		if path[0] == "" {
			continue
		}
		if origData[filepath.FromSlash(path[0])] == nil {
			continue
		}
		idMap, err := getIDMap(origData[filepath.FromSlash(path[0])])
		if err != nil {
			return nil, err
		}
		splitedManifest = append(splitedManifest, splitManifest{
			path:       path[0],
			content:    []byte(strings.ReplaceAll(splited, "\r", "")),
			original:   origData[filepath.FromSlash(path[0])], // get original data from template
			splitID:    lineID,
			splitIDMap: idMap,
		})
	}
	return &splitedManifest, nil
}

// toMap will convert to map original data having the path as it's key
func toMap(files []*chart.File) map[string][]byte {
	mapFiles := make(map[string][]byte)
	for _, file := range files {
		mapFiles[file.Name] = []byte(strings.ReplaceAll(string(file.Data), "\r", ""))
	}
	return mapFiles
}

// updateName will update the templates name as well as its dependencies
func updateName(template []*chart.File, charts *chart.Chart, name string) []*chart.File {
	if name != charts.Name() {
		name = filepath.Join(name, charts.Name())
	}
	for _, temp := range charts.Templates {
		temp.Name = filepath.Join(name, temp.Name)
	}
	template = append(template, charts.Templates...)
	for _, dep := range charts.Dependencies() {
		template = updateName(template, dep, filepath.Join(name, "charts"))
	}
	return template
}

// getIdMap will construct a map with ids with the corresponding lines as keys
// for use in detector
func getIDMap(originalData []byte) (map[int]interface{}, error) {
	ids := make(map[int]interface{})
	mapLines := make(map[int]int)
	idHelm := -1
	for line, stringLine := range strings.Split(string(originalData), "\n") {
		if strings.Contains(stringLine, kicsHelmID) {
			id, err := strconv.Atoi(strings.TrimSuffix(strings.TrimPrefix(stringLine, kicsHelmID), ":"))
			if err != nil {
				return nil, err
			}
			if idHelm == -1 {
				idHelm = id
				mapLines[line] = line
			} else {
				ids[idHelm] = mapLines
				mapLines = make(map[int]int)
				idHelm = id
				mapLines[line] = line
			}
		} else if idHelm != -1 {
			mapLines[line] = line
		}
	}
	ids[idHelm] = mapLines

	return ids, nil
}

func getPathSeparator(path string) string {
	if matched, err := regexp.MatchString(`[a-zA-Z0-9_\/-]+(\[a-zA-Z0-9_\/-]+)*`, path); matched && err == nil {
		return "/"
	} else if matched, err := regexp.MatchString(`[a-z0-9_.$-]+(\\[a-z0-9_.$-]+)*`, path); matched && err == nil {
		return "\\"
	}
	return ""
}
