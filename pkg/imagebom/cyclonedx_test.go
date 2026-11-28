package imagebom

import (
	"encoding/json"
	"strings"
	"testing"
)

func TestBuildCycloneDx_Header(t *testing.T) {
	bom := BuildCycloneDx(nil)

	if bom.BOMFormat != "CycloneDX" {
		t.Errorf("bomFormat = %q", bom.BOMFormat)
	}
	if bom.SpecVersion != "1.5" {
		t.Errorf("specVersion = %q", bom.SpecVersion)
	}
	if bom.Version != 1 {
		t.Errorf("version = %d", bom.Version)
	}
	if !strings.HasPrefix(bom.SerialNumber, "urn:uuid:") {
		t.Errorf("serialNumber = %q", bom.SerialNumber)
	}
	if bom.Metadata.Timestamp == "" {
		t.Error("metadata.timestamp empty")
	}
	if len(bom.Metadata.Tools) != 1 || bom.Metadata.Tools[0].Name != "KICS" {
		t.Errorf("tools = %+v", bom.Metadata.Tools)
	}
}

func TestBuildCycloneDx_EmptyMarshalsToArray(t *testing.T) {
	b, err := json.Marshal(BuildCycloneDx(nil))
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(string(b), `"components":[]`) {
		t.Errorf("empty components should marshal to []: %s", b)
	}
}

func TestBuildCycloneDx_Component(t *testing.T) {
	img, err := ParseImageRef("gcr.io/proj/app:v2")
	if err != nil {
		t.Fatal(err)
	}
	img.Sources = []Source{{File: "deploy.yaml", Line: 11}, {File: "b.yaml", Line: 3}}

	bom := BuildCycloneDx([]Image{img})
	if len(bom.Components) != 1 {
		t.Fatalf("got %d components", len(bom.Components))
	}
	c := bom.Components[0]

	if c.Type != "container" {
		t.Errorf("type = %q, want container", c.Type)
	}
	if c.Name != "proj/app" {
		t.Errorf("name = %q, want proj/app", c.Name)
	}
	if c.Version != "v2" {
		t.Errorf("version = %q, want v2", c.Version)
	}
	if c.PURL != "pkg:docker/proj/app@v2?repository_url=gcr.io" {
		t.Errorf("purl = %q", c.PURL)
	}
	if c.BOMRef != img.Key() {
		t.Errorf("bom-ref = %q, want %q", c.BOMRef, img.Key())
	}

	// Provenance: one file + one line property per source.
	var files, lines int
	for _, p := range c.Properties {
		switch p.Name {
		case "kics:source:file":
			files++
		case "kics:source:line":
			lines++
		}
	}
	if files != 2 || lines != 2 {
		t.Errorf("properties file=%d line=%d, want 2/2: %+v", files, lines, c.Properties)
	}
}
