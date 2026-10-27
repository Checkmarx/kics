// Package imagebom extracts Docker/OCI image references from parsed
// Infrastructure-as-Code documents and exports them as a CycloneDX Bill of
// Materials suitable for feeding container vulnerability scanners.
package imagebom

import (
	"fmt"

	"github.com/distribution/reference"
)

// Source records where an image reference was found.
type Source struct {
	File string
	Line int
}

// Image is a single Docker/OCI image reference discovered during a scan.
type Image struct {
	Ref        string // reference exactly as written in the source
	Registry   string // e.g. "docker.io" or "localhost:5000"
	Repository string // e.g. "library/nginx"
	Tag        string // e.g. "1.21" (empty when only a digest is given)
	Digest     string // e.g. "sha256:..." (empty when absent)
	Sources    []Source
}

// ParseImageRef parses a raw image reference into an Image, normalizing the
// registry and repository the same way Docker does.
func ParseImageRef(ref string) (Image, error) {
	named, err := reference.ParseNormalizedNamed(ref)
	if err != nil {
		return Image{}, err
	}

	img := Image{
		Ref:        ref,
		Registry:   reference.Domain(named),
		Repository: reference.Path(named),
	}

	if tagged, ok := named.(reference.Tagged); ok {
		img.Tag = tagged.Tag()
	}
	if digested, ok := named.(reference.Digested); ok {
		img.Digest = digested.Digest().String()
	}

	return img, nil
}

// version returns the tag or digest used to identify the image, defaulting to
// "latest" when neither is present (matching Docker's resolution behavior).
func (i Image) version() string {
	if i.Digest != "" {
		return i.Digest
	}
	if i.Tag != "" {
		return i.Tag
	}
	return "latest"
}

// Key returns a normalized identity used to deduplicate images.
func (i Image) Key() string {
	return fmt.Sprintf("%s/%s@%s", i.Registry, i.Repository, i.version())
}

// PURL returns the Package URL representation of the image.
func (i Image) PURL() string {
	purl := fmt.Sprintf("pkg:docker/%s@%s", i.Repository, i.version())
	if i.Registry != "" && i.Registry != "docker.io" {
		purl += "?repository_url=" + i.Registry
	}
	return purl
}
