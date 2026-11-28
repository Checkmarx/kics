package imagebom

import (
	"sort"
	"testing"

	"github.com/Checkmarx/kics/v2/pkg/parser/docker"
)

// parseDockerfile is a test helper that runs the real Dockerfile parser so the
// extractor is exercised against production document shapes.
func parseDockerfile(t *testing.T, content string) map[string]interface{} {
	t.Helper()
	docs, _, err := (&docker.Parser{}).Parse("Dockerfile", []byte(content))
	if err != nil {
		t.Fatalf("parse: %v", err)
	}
	return docs[0]
}

func refsOf(images []Image) []string {
	out := make([]string, 0, len(images))
	for _, img := range images {
		out = append(out, img.Ref)
	}
	sort.Strings(out)
	return out
}

func TestExtractDockerfileImages_Simple(t *testing.T) {
	doc := parseDockerfile(t, "FROM nginx:1.21\nRUN echo hi\n")
	images := extractDockerfileImages(doc, "Dockerfile")

	got := refsOf(images)
	if len(got) != 1 || got[0] != "nginx:1.21" {
		t.Fatalf("got %v, want [nginx:1.21]", got)
	}
	if len(images[0].Sources) != 1 || images[0].Sources[0].Line != 1 {
		t.Errorf("source = %+v, want line 1", images[0].Sources)
	}
	if images[0].Sources[0].File != "Dockerfile" {
		t.Errorf("file = %q, want Dockerfile", images[0].Sources[0].File)
	}
}

func TestExtractDockerfileImages_MultiStageSkipsAlias(t *testing.T) {
	content := "FROM golang:1.22 AS build\nRUN go build\nFROM build\nCMD ./app\nFROM gcr.io/distroless/base:latest\nCOPY --from=build /app /app\n"
	doc := parseDockerfile(t, content)
	got := refsOf(extractDockerfileImages(doc, "Dockerfile"))

	want := []string{"gcr.io/distroless/base:latest", "golang:1.22"}
	if len(got) != len(want) {
		t.Fatalf("got %v, want %v", got, want)
	}
	for i := range want {
		if got[i] != want[i] {
			t.Fatalf("got %v, want %v", got, want)
		}
	}
}

func TestExtractDockerfileImages_SkipsScratch(t *testing.T) {
	content := "FROM scratch\nFROM redis:7\n"
	doc := parseDockerfile(t, content)
	got := refsOf(extractDockerfileImages(doc, "Dockerfile"))

	if len(got) != 1 || got[0] != "redis:7" {
		t.Fatalf("got %v, want [redis:7]", got)
	}
}

func TestExtractDockerfileImages_ResolvesArgDefault(t *testing.T) {
	// The parser resolves ARG defaults, yielding a real, scannable image.
	content := "ARG BASE=alpine:3.19\nFROM ${BASE}\n"
	doc := parseDockerfile(t, content)
	got := refsOf(extractDockerfileImages(doc, "Dockerfile"))

	if len(got) != 1 || got[0] != "alpine:3.19" {
		t.Fatalf("got %v, want [alpine:3.19]", got)
	}
}

func TestExtractDockerfileImages_SkipsUnresolvedTemplate(t *testing.T) {
	// No ARG default: the reference stays templated and cannot be scanned.
	content := "FROM ${UNDEFINED_BASE}\nFROM redis:7\n"
	doc := parseDockerfile(t, content)
	got := refsOf(extractDockerfileImages(doc, "Dockerfile"))

	if len(got) != 1 || got[0] != "redis:7" {
		t.Fatalf("got %v, want [redis:7]", got)
	}
}

func TestExtractDockerfileImages_KeepsPlatformFlagImage(t *testing.T) {
	doc := parseDockerfile(t, "FROM --platform=linux/amd64 node:18 AS build\n")
	got := refsOf(extractDockerfileImages(doc, "Dockerfile"))
	if len(got) != 1 || got[0] != "node:18" {
		t.Fatalf("got %v, want [node:18]", got)
	}
}
