package imagebom

import (
	"strconv"
	"time"

	"github.com/Checkmarx/kics/v2/internal/constants"
	"github.com/google/uuid"
)

// CycloneDxBOM is a minimal CycloneDX 1.5 document (JSON) describing the
// container images discovered during a scan.
type CycloneDxBOM struct {
	BOMFormat    string      `json:"bomFormat"`
	SpecVersion  string      `json:"specVersion"`
	SerialNumber string      `json:"serialNumber"`
	Version      int         `json:"version"`
	Metadata     Metadata    `json:"metadata"`
	Components   []Component `json:"components"`
}

// Metadata carries the timestamp and the tool that produced the BOM.
type Metadata struct {
	Timestamp string `json:"timestamp"`
	Tools     []Tool `json:"tools"`
}

// Tool identifies the tool that generated the BOM.
type Tool struct {
	Vendor  string `json:"vendor"`
	Name    string `json:"name"`
	Version string `json:"version"`
}

// Component is a single container image entry.
type Component struct {
	Type       string     `json:"type"`
	BOMRef     string     `json:"bom-ref"`
	Name       string     `json:"name"`
	Version    string     `json:"version"`
	PURL       string     `json:"purl"`
	Properties []Property `json:"properties,omitempty"`
}

// Property is a name/value pair used to carry KICS provenance.
type Property struct {
	Name  string `json:"name"`
	Value string `json:"value"`
}

// BuildCycloneDx converts the extracted images into a CycloneDX BOM.
func BuildCycloneDx(images []Image) *CycloneDxBOM {
	components := make([]Component, 0, len(images))
	for i := range images {
		components = append(components, toComponent(images[i]))
	}

	return &CycloneDxBOM{
		BOMFormat:    "CycloneDX",
		SpecVersion:  "1.5",
		SerialNumber: "urn:uuid:" + uuid.New().String(),
		Version:      1,
		Metadata: Metadata{
			Timestamp: time.Now().Format(time.RFC3339),
			Tools: []Tool{
				{Vendor: "Checkmarx", Name: "KICS", Version: constants.Version},
			},
		},
		Components: components,
	}
}

func toComponent(img Image) Component {
	properties := make([]Property, 0, len(img.Sources)*2)
	for _, src := range img.Sources {
		properties = append(properties,
			Property{Name: "kics:source:file", Value: src.File},
			Property{Name: "kics:source:line", Value: strconv.Itoa(src.Line)},
		)
	}

	return Component{
		Type:       "container",
		BOMRef:     img.Key(),
		Name:       img.Repository,
		Version:    img.version(),
		PURL:       img.PURL(),
		Properties: properties,
	}
}
