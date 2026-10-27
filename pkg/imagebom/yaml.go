package imagebom

import (
	"strings"

	"github.com/rs/zerolog/log"
)

const (
	kicsLinesKey  = "_kics_lines"
	kicsLineKey   = "_kics_line"
	kicsArrKey    = "_kics_arr"
	kicsFieldPref = "_kics_"
)

// extractYAMLImages walks a parsed YAML/JSON document (Kubernetes, Helm-rendered
// templates, docker-compose) and collects every string value under an "image"
// key. Line numbers are recovered from the parallel "_kics_lines" tree KICS
// stores alongside the data.
func extractYAMLImages(doc map[string]interface{}, file string) []Image {
	var images []Image
	walkYAMLNode(doc, nil, file, &images)
	return images
}

// walkYAMLNode recurses through the document. lineMap holds the "_kics_lines"
// entries that describe the current node's fields; it is supplied by the parent
// for array elements (which do not carry their own "_kics_lines").
func walkYAMLNode(node interface{}, lineMap map[string]interface{}, file string, out *[]Image) {
	m, ok := node.(map[string]interface{})
	if !ok {
		return
	}

	// A nested map carries its own "_kics_lines"; array-element maps rely on the
	// lineMap passed down from the parent.
	if self, ok := m[kicsLinesKey].(map[string]interface{}); ok {
		lineMap = self
	}

	for key, val := range m {
		if strings.HasPrefix(key, kicsFieldPref) {
			continue
		}

		switch child := val.(type) {
		case string:
			if key == "image" {
				addYAMLImage(child, file, scalarLine(lineMap, key), out)
			}
		case map[string]interface{}:
			walkYAMLNode(child, nil, file, out)
		case []interface{}:
			elemLines := arrayLineMaps(lineMap, key)
			for i, item := range child {
				var lm map[string]interface{}
				if i < len(elemLines) {
					lm = elemLines[i]
				}
				walkYAMLNode(item, lm, file, out)
			}
		}
	}
}

func addYAMLImage(ref, file string, line int, out *[]Image) {
	img, err := ParseImageRef(ref)
	if err != nil {
		log.Warn().Msgf("image-bom: skipping unparseable image %q in %s: %v", ref, file, err)
		return
	}
	img.Sources = []Source{{File: file, Line: line}}
	*out = append(*out, img)
}

// scalarLine returns the line number recorded for a scalar field.
func scalarLine(lineMap map[string]interface{}, field string) int {
	entry, ok := lineMap[kicsFieldPref+field].(map[string]interface{})
	if !ok {
		return 0
	}
	if line, ok := entry[kicsLineKey].(float64); ok {
		return int(line)
	}
	return 0
}

// arrayLineMaps returns the per-element "_kics_lines" maps for an array field.
func arrayLineMaps(lineMap map[string]interface{}, field string) []map[string]interface{} {
	entry, ok := lineMap[kicsFieldPref+field].(map[string]interface{})
	if !ok {
		return nil
	}
	arr, ok := entry[kicsArrKey].([]interface{})
	if !ok {
		return nil
	}
	out := make([]map[string]interface{}, 0, len(arr))
	for _, item := range arr {
		if m, ok := item.(map[string]interface{}); ok {
			out = append(out, m)
		} else {
			out = append(out, nil)
		}
	}
	return out
}
