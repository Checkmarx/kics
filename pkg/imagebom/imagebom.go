package imagebom

import (
	"sort"

	"github.com/Checkmarx/kics/v2/pkg/model"
)

// Extract collects the unique Docker/OCI image references found across all
// scanned files, merging provenance for images that appear more than once. The
// result is sorted by normalized reference for stable output.
func Extract(files model.FileMetadatas) []Image {
	deduped := make(map[string]*Image)

	for i := range files {
		for _, img := range extractFromFile(&files[i]) {
			key := img.Key()
			if existing, ok := deduped[key]; ok {
				existing.Sources = append(existing.Sources, img.Sources...)
				continue
			}
			clone := img
			deduped[key] = &clone
		}
	}

	images := make([]Image, 0, len(deduped))
	for _, img := range deduped {
		images = append(images, *img)
	}
	sort.Slice(images, func(i, j int) bool {
		return images[i].Key() < images[j].Key()
	})

	return images
}

// extractFromFile dispatches extraction based on the file kind. It reads from
// LineInfoDocument (which retains the "_kics_lines" tree) when available so
// image source lines are preserved, falling back to the stripped Document.
func extractFromFile(file *model.FileMetadata) []Image {
	doc := file.LineInfoDocument
	if doc == nil {
		doc = map[string]interface{}(file.Document)
	}

	switch file.Kind {
	case model.KindDOCKER:
		return extractDockerfileImages(doc, file.FilePath)
	case model.KindYAML, model.KindYML, model.KindHELM, model.KindJSON:
		return extractYAMLImages(doc, file.FilePath)
	default:
		return nil
	}
}
