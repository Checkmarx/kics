package imagebom

import (
	"testing"

	yamlParser "github.com/Checkmarx/kics/v2/pkg/parser/yaml"
)

func parseYAML(t *testing.T, name, content string) map[string]interface{} {
	t.Helper()
	docs, _, err := (&yamlParser.Parser{}).Parse(name, []byte(content))
	if err != nil {
		t.Fatalf("parse: %v", err)
	}
	return docs[0]
}

func sourceFor(images []Image, ref string) *Image {
	for i := range images {
		if images[i].Ref == ref {
			return &images[i]
		}
	}
	return nil
}

func TestExtractYAMLImages_Kubernetes(t *testing.T) {
	k8s := `apiVersion: apps/v1
kind: Deployment
spec:
  template:
    spec:
      initContainers:
      - name: init
        image: busybox:1.36
      containers:
      - name: app
        image: nginx:1.21
`
	doc := parseYAML(t, "deploy.yaml", k8s)
	images := extractYAMLImages(doc, "deploy.yaml")

	got := refsOf(images)
	want := []string{"busybox:1.36", "nginx:1.21"}
	if len(got) != len(want) || got[0] != want[0] || got[1] != want[1] {
		t.Fatalf("got %v, want %v", got, want)
	}

	nginx := sourceFor(images, "nginx:1.21")
	if nginx.Sources[0].Line != 11 {
		t.Errorf("nginx line = %d, want 11", nginx.Sources[0].Line)
	}
	busybox := sourceFor(images, "busybox:1.36")
	if busybox.Sources[0].Line != 8 {
		t.Errorf("busybox line = %d, want 8", busybox.Sources[0].Line)
	}
	if nginx.Sources[0].File != "deploy.yaml" {
		t.Errorf("file = %q", nginx.Sources[0].File)
	}
}

func TestExtractYAMLImages_Compose(t *testing.T) {
	compose := `services:
  web:
    image: redis:7
  db:
    image: postgres:16
`
	doc := parseYAML(t, "docker-compose.yml", compose)
	got := refsOf(extractYAMLImages(doc, "docker-compose.yml"))

	want := []string{"postgres:16", "redis:7"}
	if len(got) != len(want) || got[0] != want[0] || got[1] != want[1] {
		t.Fatalf("got %v, want %v", got, want)
	}
}

func TestExtractYAMLImages_IgnoresNonStringImage(t *testing.T) {
	// An "image" key whose value is not a string (e.g. a build block) must not
	// crash or produce a bogus entry.
	y := `services:
  web:
    image:
      context: .
`
	doc := parseYAML(t, "docker-compose.yml", y)
	got := extractYAMLImages(doc, "docker-compose.yml")
	if len(got) != 0 {
		t.Fatalf("got %v, want none", refsOf(got))
	}
}
