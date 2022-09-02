package cpio

import (
	"errors"
	"fmt"
	"os"
	"time"
)

const (
	// TypeReg indicates a regular file
	TypeReg = 0100000

	// The following are header-only flags and may not have a data body.
	TypeSocket  = 0140000 // Socket
	TypeSymlink = 0120000 // Symbolic link
	TypeBlock   = 060000  // Block device node
	TypeDir     = 040000  // Directory
	TypeChar    = 020000  // Character device node
	TypeFifo    = 010000  // FIFO node
)

const (
	ModeSetuid = 04000 // Set uid
	ModeSetgid = 02000 // Set gid
	ModeSticky = 01000 // Save text (sticky bit)

	ModeType = 0170000 // Mask for the type bits
	ModePerm = 0777    // Unix permission bits
)

const (
	// headerEOF is the value of the filename of the last header in a CPIO archive.
	headerEOF = "TRAILER!!!"
)

var (
	// ErrHeader indicates there was an error decoding a CPIO header entry.
	ErrHeader = errors.New("cpio: invalid cpio header")
)

// A FileMode represents a file's mode and permission bits.
type FileMode uint32

func (m FileMode) String() string {
	return fmt.Sprintf("%#o", m)
}

// IsDir reports whether m describes a directory. That is, it tests for the
// TypeDir bit being set in m.
func (m FileMode) IsDir() bool {
	return m&TypeDir != 0
}

// IsRegular reports whether m describes a regular file. That is, it tests for
// the TypeReg bit being set in m.
func (m FileMode) IsRegular() bool {
	return m&^ModePerm == TypeReg
}

// Perm returns the Unix permission bits in m.
func (m FileMode) Perm() FileMode {
	return m & ModePerm
}

// A Header represents a single header in a CPIO archive. Some fields may not be
// populated.
//
// For forward compatibility, users that retrieve a Header from Reader.Next,
// mutate it in some ways, and then pass it back to Writer.WriteHeader should do
// so by creating a new Header and copying the fields that they are interested
// in preserving.
type Header struct {
	Name     string // Name of the file entry
	Linkname string // Target name of link (valid for TypeLink or TypeSymlink)
	Links    int    // Number of inbound links

	Size int64    // Size in bytes
	Mode FileMode // Permission and mode bits
	Uid  int      // User id of the owner
	Guid int      // Group id of the owner

	ModTime time.Time // Modification time

	Checksum uint32 // Computed checksum

	DeviceID int
	Inode    int64 // Inode number

	pad int64 // bytes to pad before next header
}

// FileInfo returns an fs.FileInfo for the Header.
func (h *Header) FileInfo() os.FileInfo {
	return fileInfo{h}
}

// FileInfoHeader creates a partially-populated Header from fi. If fi describes
// a symlink, FileInfoHeader records link as the link target. If fi describes a
// directory, a slash is appended to the name.
//
// Since fs.FileInfo's Name method returns only the base name of the file it
// describes, it may be necessary to modify Header.Name to provide the full path
// name of the file.
func FileInfoHeader(fi os.FileInfo, link string) (*Header, error) {
	if fi == nil {
		return nil, errors.New("cpio: FileInfo is nil")
	}
	if sys, ok := fi.Sys().(*Header); ok {
		// This FileInfo came from a Header (not the OS). Return a copy of the
		// original Header.
		h := &Header{}
		*h = *sys
		return h, nil
	}
	fm := fi.Mode()
	h := &Header{
		Name:    fi.Name(),
		Mode:    FileMode(fi.Mode().Perm()), // or'd with Mode* constants later
		ModTime: fi.ModTime(),
		Size:    fi.Size(),
	}
	switch {
	case fm.IsRegular():
		h.Mode |= TypeReg
	case fi.IsDir():
		h.Mode |= TypeDir
		h.Name += "/"
		h.Size = 0
	case fm&os.ModeSymlink != 0:
		h.Mode |= TypeSymlink
		h.Linkname = link
	case fm&os.ModeDevice != 0:
		if fm&os.ModeCharDevice != 0 {
			h.Mode |= TypeChar
		} else {
			h.Mode |= TypeBlock
		}
	case fm&os.ModeNamedPipe != 0:
		h.Mode |= TypeFifo
	case fm&os.ModeSocket != 0:
		h.Mode |= TypeSocket
	default:
		return nil, fmt.Errorf("cpio: unknown file mode %v", fm)
	}
	if fm&os.ModeSetuid != 0 {
		h.Mode |= ModeSetuid
	}
	if fm&os.ModeSetgid != 0 {
		h.Mode |= ModeSetgid
	}
	if fm&os.ModeSticky != 0 {
		h.Mode |= ModeSticky
	}
	return h, nil
}
