package imagebom

import (
	"strings"
	"testing"
)

func TestParseImageRef(t *testing.T) {
	digest := "sha256:" + strings.Repeat("a", 64)

	tests := []struct {
		name       string
		ref        string
		registry   string
		repository string
		tag        string
		digest     string
	}{
		{"simple tag", "nginx:1.21", "docker.io", "library/nginx", "1.21", ""},
		{"no tag", "redis", "docker.io", "library/redis", "", ""},
		{"registry with port", "localhost:5000/img:tag", "localhost:5000", "img", "tag", ""},
		{"digest only", "nginx@" + digest, "docker.io", "library/nginx", "", digest},
		{"registry namespace tag", "gcr.io/proj/app:v2", "gcr.io", "proj/app", "v2", ""},
		{"tag and digest", "alpine:3.19@" + digest, "docker.io", "library/alpine", "3.19", digest},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			img, err := ParseImageRef(tt.ref)
			if err != nil {
				t.Fatalf("ParseImageRef(%q) returned error: %v", tt.ref, err)
			}
			if img.Registry != tt.registry {
				t.Errorf("Registry = %q, want %q", img.Registry, tt.registry)
			}
			if img.Repository != tt.repository {
				t.Errorf("Repository = %q, want %q", img.Repository, tt.repository)
			}
			if img.Tag != tt.tag {
				t.Errorf("Tag = %q, want %q", img.Tag, tt.tag)
			}
			if img.Digest != tt.digest {
				t.Errorf("Digest = %q, want %q", img.Digest, tt.digest)
			}
			if img.Ref != tt.ref {
				t.Errorf("Ref = %q, want %q", img.Ref, tt.ref)
			}
		})
	}
}

func TestParseImageRefInvalid(t *testing.T) {
	for _, ref := range []string{"", "UPPER/CASE:tag", "with spaces"} {
		if _, err := ParseImageRef(ref); err == nil {
			t.Errorf("ParseImageRef(%q) expected error, got nil", ref)
		}
	}
}

func TestImagePURL(t *testing.T) {
	digest := "sha256:" + strings.Repeat("b", 64)
	tests := []struct {
		name string
		ref  string
		want string
	}{
		{"docker hub tag", "nginx:1.21", "pkg:docker/library/nginx@1.21"},
		{"no tag defaults latest", "redis", "pkg:docker/library/redis@latest"},
		{"digest", "nginx@" + digest, "pkg:docker/library/nginx@" + digest},
		{"custom registry", "gcr.io/proj/app:v2", "pkg:docker/proj/app@v2?repository_url=gcr.io"},
	}
	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			img, err := ParseImageRef(tt.ref)
			if err != nil {
				t.Fatalf("ParseImageRef(%q): %v", tt.ref, err)
			}
			if got := img.PURL(); got != tt.want {
				t.Errorf("PURL() = %q, want %q", got, tt.want)
			}
		})
	}
}

func TestImageKey(t *testing.T) {
	// Different spellings of the same image must produce the same key.
	a, err := ParseImageRef("nginx:1.21")
	if err != nil {
		t.Fatal(err)
	}
	b, err := ParseImageRef("docker.io/library/nginx:1.21")
	if err != nil {
		t.Fatal(err)
	}
	if a.Key() != b.Key() {
		t.Errorf("keys differ: %q vs %q", a.Key(), b.Key())
	}

	c, err := ParseImageRef("nginx:1.22")
	if err != nil {
		t.Fatal(err)
	}
	if a.Key() == c.Key() {
		t.Errorf("keys should differ for different tags: %q", a.Key())
	}
}
