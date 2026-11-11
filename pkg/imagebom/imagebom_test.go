package imagebom

import (
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/model"
)

func dockerFile(t *testing.T, path, content string) model.FileMetadata {
	t.Helper()
	return model.FileMetadata{
		FilePath: path,
		Kind:     model.KindDOCKER,
		Document: model.Document(parseDockerfile(t, content)),
	}
}

func yamlFile(t *testing.T, path, content string) model.FileMetadata {
	t.Helper()
	return model.FileMetadata{
		FilePath: path,
		Kind:     model.KindYAML,
		Document: model.Document(parseYAML(t, path, content)),
	}
}

func TestExtract_MixedSources(t *testing.T) {
	files := model.FileMetadatas{
		dockerFile(t, "Dockerfile", "FROM nginx:1.21\n"),
		yamlFile(t, "compose.yml", "services:\n  db:\n    image: postgres:16\n"),
	}

	got := refsOf(Extract(files))
	want := []string{"nginx:1.21", "postgres:16"}
	if len(got) != len(want) || got[0] != want[0] || got[1] != want[1] {
		t.Fatalf("got %v, want %v", got, want)
	}
}

func TestExtract_DeduplicatesAcrossFiles(t *testing.T) {
	files := model.FileMetadatas{
		dockerFile(t, "a/Dockerfile", "FROM nginx:1.21\n"),
		yamlFile(t, "b/pod.yaml", "spec:\n  containers:\n  - image: nginx:1.21\n"),
	}

	images := Extract(files)
	if len(images) != 1 {
		t.Fatalf("got %d images, want 1 (deduped): %v", len(images), refsOf(images))
	}
	if len(images[0].Sources) != 2 {
		t.Fatalf("got %d sources, want 2 merged: %+v", len(images[0].Sources), images[0].Sources)
	}
}

func TestExtract_SkipsUnsupportedKinds(t *testing.T) {
	files := model.FileMetadatas{
		{
			FilePath: "main.tf",
			Kind:     model.KindTerraform,
			Document: model.Document{"resource": "aws_instance"},
		},
	}
	if got := Extract(files); len(got) != 0 {
		t.Fatalf("got %v, want none", refsOf(got))
	}
}

func TestExtract_UsesLineInfoDocument(t *testing.T) {
	// In the real pipeline, FileMetadata.Document has _kics_lines stripped while
	// LineInfoDocument keeps the full tree. Extraction must read the latter so
	// image source lines are preserved.
	k8s := `spec:
  containers:
  - name: app
    image: nginx:1.21
`
	files := model.FileMetadatas{
		{
			FilePath:         "pod.yaml",
			Kind:             model.KindYAML,
			Document:         model.Document{}, // stripped payload, no image
			LineInfoDocument: parseYAML(t, "pod.yaml", k8s),
		},
	}

	images := Extract(files)
	if len(images) != 1 || images[0].Ref != "nginx:1.21" {
		t.Fatalf("got %v, want [nginx:1.21] from LineInfoDocument", refsOf(images))
	}
	if images[0].Sources[0].Line != 4 {
		t.Errorf("line = %d, want 4", images[0].Sources[0].Line)
	}
}

func TestExtract_StableOrder(t *testing.T) {
	files := model.FileMetadatas{
		dockerFile(t, "Dockerfile", "FROM redis:7\nFROM alpine:3.19\nFROM nginx:1.21\n"),
	}
	got := refsOf(Extract(files))
	want := []string{"alpine:3.19", "nginx:1.21", "redis:7"}
	for i := range want {
		if got[i] != want[i] {
			t.Fatalf("got %v, want sorted %v", got, want)
		}
	}
}
