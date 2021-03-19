package resolver

import (
	"errors"
	"os"
	"path/filepath"

	"github.com/Checkmarx/kics/pkg/model"
)

type kindResolver interface {
	// GetKind() model.FileKind
	Resolve(filePath string) (model.RenderedFiles, error)
	SupportedTypes() []model.FileKind
}

type Resolver struct {
	resolvers map[model.FileKind]kindResolver
}

type Builder struct {
	resolvers []kindResolver
}

// NewBuilder creates a new Builder's reference
func NewBuilder() *Builder {
	return &Builder{}
}

func (b *Builder) Add(p kindResolver) *Builder {
	b.resolvers = append(b.resolvers, p)
	return b
}

func (b *Builder) Build() (*Resolver, error) {
	resolvers := make(map[model.FileKind]kindResolver, len(b.resolvers))
	for _, resolver := range b.resolvers {
		for _, typeRes := range resolver.SupportedTypes() {
			resolvers[typeRes] = resolver
		}
	}

	return &Resolver{
		resolvers: resolvers,
	}, nil
}

// ErrNotSupportedFile represents an error when a file is not supported by KICS
var ErrNotSupportedFile = errors.New("unsupported file to parse")

func (r *Resolver) Resolve(filePath string, kind model.FileKind) (model.RenderedFiles, error) {
	if r, ok := r.resolvers[kind]; ok {
		obj, err := r.Resolve(filePath)
		if err != nil {
			return model.RenderedFiles{}, nil
		}
		return obj, nil
	}
	// need to log here
	return model.RenderedFiles{}, nil
}

func (r *Resolver) GetType(filePath string) model.FileKind {
	if _, err := os.Stat(filepath.Join(filePath, "Chart.yaml")); err == nil {
		return model.KINDHELM
	}
	return model.KindCOMMON
}

// func Render(path string) (model.RenderedFiles, error) {
// 	// var rfiles = model.RenderedFiles{}
// 	// err := filepath.Walk(path, func(path string, info fs.FileInfo, err error) error {
// 	// 	if info.IsDir() {
// 	// 		if _, err := os.Stat(filepath.Join(path, "Chart.yaml")); err == nil {
// 	// 			splits, errors := renderHelm(path)
// 	// 			if errors != nil {
// 	// 				return nil
// 	// 			}
// 	// 			rfiles.Exclude = append(rfiles.Exclude, path)
// 	// 			for _, split := range *splits {
// 	// 				filepath := filepath.Join(filepath.Dir(path), split.path)
// 	// 				rfiles.HelmFile = append(rfiles.HelmFile, model.RenderedFile{
// 	// 					FileName:     filepath,
// 	// 					Content:      split.content,
// 	// 					OriginalData: split.original,
// 	// 					SplitID:      split.splitID,
// 	// 				})
// 	// 			}
// 	// 		} else if os.IsNotExist(err) {
// 	// 			return nil
// 	// 		}
// 	// 	}
// 	// 	return nil
// 	// })
// 	// if err != nil {
// 	// 	return model.RenderedFiles{}, err
// 	// }
// 	// return rfiles, nil

// 	var rfiles = model.RenderedFiles{}
// 	if _, err := os.Stat(filepath.Join(path, "Chart.yaml")); err == nil {
// 		splits, errors := renderHelm(path)
// 		if errors != nil {
// 			return nil
// 		}
// 		rfiles.Exclude = append(rfiles.Exclude, path)
// 		for _, split := range *splits {
// 			filepath := filepath.Join(filepath.Dir(path), split.path)
// 			rfiles.HelmFile = append(rfiles.HelmFile, model.RenderedFile{
// 				FileName:     filepath,
// 				Content:      split.content,
// 				OriginalData: split.original,
// 				SplitID:      split.splitID,
// 			})
// 		}
// 	} else if os.IsNotExist(err) {
// 		return nil
// 	}
// }

// // renderHelm will use helm binary to render helm templates
// func renderHelm(path string) (*[]splitedYaml, error) {
// 	client := newClient()
// 	test, err := runInstall([]string{path}, client, &values.Options{}, nil)
// 	if err != nil {
// 		return nil, err
// 	}
// 	return splitYaml(test)
// }

// // splitYaml will split the rendered file and return its content by template as well as the template path
// func splitYaml(template *release.Release) (*[]splitedYaml, error) {
// 	templates := make([]*chart.File, 0)
// 	templates = templateMaker(templates, template.Chart, template.Chart.Name())
// 	splitSlice := []splitedYaml{}
// 	testSplit := strings.Split(template.Manifest, "---")
// 	origData := convertToMap(templates)
// 	for _, splited := range testSplit {
// 		var lineID string
// 		for _, line := range strings.Split(splited, "\n") {
// 			if strings.Contains(line, "# KICS_HELM_ID_") {
// 				lineID = line
// 				break
// 			}
// 		}
// 		path := strings.Split(strings.TrimLeft(splited, "\n# Source:"), "\n") // need to get id here to be passed
// 		if path[0] == "" || strings.Contains(path[0], "secrets.yaml") || strings.Contains(path[0], "secret.yaml") {
// 			continue
// 		}
// 		if origData[path[0]] == nil {
// 			continue
// 		}
// 		splitSlice = append(splitSlice, splitedYaml{
// 			path:     path[0],
// 			content:  []byte(splited),
// 			original: origData[path[0]],
// 			splitID:  lineID,
// 		})
// 	}
// 	return &splitSlice, nil
// }

// func convertToMap(files []*chart.File) map[string][]byte {
// 	mapFiles := make(map[string][]byte)
// 	for _, file := range files {
// 		mapFiles[file.Name] = file.Data
// 	}
// 	return mapFiles
// }

// func templateMaker(template []*chart.File, charts *chart.Chart, name string) []*chart.File {
// 	if name != charts.Name() {
// 		name = filepath.Join(name, charts.Name())
// 	}
// 	for _, temp := range charts.Templates {
// 		temp.Name = filepath.Join(name, temp.Name)
// 	}
// 	template = append(template, charts.Templates...)
// 	for _, dep := range charts.Dependencies() {
// 		template = templateMaker(template, dep, filepath.Join(name, "charts"))
// 	}
// 	return template
// }
