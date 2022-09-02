package cpio

import (
	"os"
	"path"
	"time"
)

// fileInfo implements fs.FileInfo.
type fileInfo struct {
	h *Header
}

// Name returns the base name of the file.
func (fi fileInfo) Name() string {
	if fi.IsDir() {
		return path.Base(path.Clean(fi.h.Name))
	}
	return path.Base(fi.h.Name)
}

func (fi fileInfo) Size() int64        { return fi.h.Size }
func (fi fileInfo) IsDir() bool        { return fi.Mode().IsDir() }
func (fi fileInfo) ModTime() time.Time { return fi.h.ModTime }
func (fi fileInfo) Sys() interface{}   { return fi.h }

func (fi fileInfo) Mode() (mode os.FileMode) {
	mode = os.FileMode(fi.h.Mode).Perm()
	if fi.h.Mode&ModeSetuid != 0 {
		mode |= os.ModeSetuid
	}
	if fi.h.Mode&ModeSetgid != 0 {
		mode |= os.ModeSetgid
	}
	if fi.h.Mode&ModeSticky != 0 {
		mode |= os.ModeSticky
	}
	m := os.FileMode(fi.h.Mode) & ModeType
	if m == TypeDir {
		mode |= os.ModeDir
	}
	if m == TypeFifo {
		mode |= os.ModeNamedPipe
	}
	if m == TypeSymlink {
		mode |= os.ModeSymlink
	}
	if m == TypeBlock {
		mode |= os.ModeDevice
	}
	if m == TypeChar {
		mode |= os.ModeDevice | os.ModeCharDevice
	}
	if m == TypeSocket {
		mode |= os.ModeSocket
	}
	return mode
}
