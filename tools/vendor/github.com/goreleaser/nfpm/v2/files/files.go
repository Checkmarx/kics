package files

import (
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"time"

	"github.com/goreleaser/nfpm/v2/internal/glob"
)

// Content describes the source and destination
// of one file to copy into a package.
type Content struct {
	Source      string           `yaml:"src,omitempty"`
	Destination string           `yaml:"dst,omitempty"`
	Type        string           `yaml:"type,omitempty"`
	Packager    string           `yaml:"packager,omitempty"`
	FileInfo    *ContentFileInfo `yaml:"file_info,omitempty"`
}

type ContentFileInfo struct {
	Owner string      `yaml:"owner,omitempty"`
	Group string      `yaml:"group"`
	Mode  os.FileMode `yaml:"mode,omitempty"`
	MTime time.Time   `yaml:"mtime,omitempty"`
	Size  int64       `yaml:"-"`
}

// Contents list of Content to process.
type Contents []*Content

func (c Contents) Len() int {
	return len(c)
}

func (c Contents) Swap(i, j int) {
	c[i], c[j] = c[j], c[i]
}

func (c Contents) Less(i, j int) bool {
	a, b := c[i], c[j]

	if a.Destination != b.Destination {
		return a.Destination < b.Destination
	}

	if a.Type != b.Type {
		return a.Type < b.Type
	}

	return a.Packager < b.Packager
}

func (c Contents) ContainsDestination(dst string) bool {
	for _, content := range c {
		if strings.TrimRight(content.Destination, "/") == strings.TrimRight(dst, "/") {
			return true
		}
	}

	return false
}

func (c *Content) WithFileInfoDefaults() *Content {
	cc := &Content{
		Source:      c.Source,
		Destination: c.Destination,
		Type:        c.Type,
		Packager:    c.Packager,
		FileInfo:    c.FileInfo,
	}
	if cc.FileInfo == nil {
		cc.FileInfo = &ContentFileInfo{}
	}
	if cc.FileInfo.Owner == "" {
		cc.FileInfo.Owner = "root"
	}
	if cc.FileInfo.Group == "" {
		cc.FileInfo.Group = "root"
	}
	if cc.Type == "dir" && cc.FileInfo.Mode == 0 {
		cc.FileInfo.Mode = 0o755
	}

	// determine if we still need info
	fileInfoAlreadyComplete := (!cc.FileInfo.MTime.IsZero() &&
		cc.FileInfo.Mode != 0 &&
		(cc.FileInfo.Size != 0 || cc.Type == "dir"))

	// only stat source when we actually need more information
	if cc.Source != "" && !fileInfoAlreadyComplete {
		info, err := os.Stat(cc.Source)
		if err == nil {
			if cc.FileInfo.MTime.IsZero() {
				cc.FileInfo.MTime = info.ModTime()
			}
			if cc.FileInfo.Mode == 0 {
				cc.FileInfo.Mode = info.Mode()
			}
			cc.FileInfo.Size = info.Size()
		}
	}

	if cc.FileInfo.MTime.IsZero() {
		cc.FileInfo.MTime = time.Now().UTC()
	}
	return cc
}

// Name to part of the os.FileInfo interface
func (c *Content) Name() string {
	return c.Source
}

// Size to part of the os.FileInfo interface
func (c *Content) Size() int64 {
	return c.FileInfo.Size
}

// Mode to part of the os.FileInfo interface
func (c *Content) Mode() os.FileMode {
	return c.FileInfo.Mode
}

// ModTime to part of the os.FileInfo interface
func (c *Content) ModTime() time.Time {
	return c.FileInfo.MTime
}

// IsDir to part of the os.FileInfo interface
func (c *Content) IsDir() bool {
	return false
}

// Sys to part of the os.FileInfo interface
func (c *Content) Sys() interface{} {
	return nil
}

// ExpandContentGlobs gathers all of the real files to be copied into the package.
func ExpandContentGlobs(contents Contents, disableGlobbing bool) (files Contents, err error) {
	for _, f := range contents {
		var globbed map[string]string

		switch f.Type {
		case "ghost", "symlink", "dir":
			// Ghost, symlinks and dirs need to be in the list, but dont glob
			// them because they do not really exist
			files = append(files, f.WithFileInfoDefaults())
		default:
			globbed, err = glob.Glob(f.Source, f.Destination, disableGlobbing)
			if err != nil {
				return nil, err
			}

			files, err = appendGlobbedFiles(files, globbed, f)
			if err != nil {
				return nil, err
			}
		}

	}

	err = checkNoCollisions(files)
	if err != nil {
		return nil, err
	}

	// sort the files for reproducibility and general cleanliness
	sort.Sort(files)

	return files, nil
}

func appendGlobbedFiles(all Contents, globbed map[string]string, origFile *Content) (Contents, error) {
	for src, dst := range globbed {
		// if the file has a FileInfo, we need to copy it but recalculate its size
		newFileInfo := origFile.FileInfo
		if newFileInfo != nil {
			newFileInfoVal := *newFileInfo
			newFileInfoVal.Size = 0
			newFileInfo = &newFileInfoVal
		}
		newFile := (&Content{
			Destination: ToNixPath(dst),
			Source:      ToNixPath(src),
			Type:        origFile.Type,
			FileInfo:    newFileInfo,
			Packager:    origFile.Packager,
		}).WithFileInfoDefaults()
		if dst, err := os.Readlink(src); err == nil {
			newFile.Source = dst
			newFile.Type = "symlink"
		}

		all = append(all, newFile)
	}

	return all, nil
}

var ErrContentCollision = fmt.Errorf("content collision")

func checkNoCollisions(contents Contents) error {
	alreadyPresent := map[string]*Content{}

	for _, elem := range contents {
		present, ok := alreadyPresent[elem.Destination]
		if ok && (present.Packager == "" || elem.Packager == "" || present.Packager == elem.Packager) {
			if elem.Type == "dir" {
				return fmt.Errorf("cannot add directory %q because it is already present: %w",
					elem.Destination, ErrContentCollision)
			}

			return fmt.Errorf(
				"cannot add %q because %q is already present at the same destination (%s): %w",
				elem.Source, present.Source, present.Destination, ErrContentCollision)
		}

		alreadyPresent[elem.Destination] = elem
	}

	return nil
}

// ToNixPath converts the given path to a nix-style path.
//
// Windows-style path separators are considered escape
// characters by some libraries, which can cause issues.
func ToNixPath(path string) string {
	return filepath.ToSlash(filepath.Clean(path))
}
