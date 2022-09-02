package cpio

import (
	"errors"
	"fmt"
	"io"
)

var (
	// ErrWriteTooLong indicates that an attempt was made to write more than
	// Header.Size bytes to the current file.
	ErrWriteTooLong = errors.New("cpio: write too long")

	// ErrWriteAfterClose indicates that an attempt was made to write to the
	// CPIO archive after it was closed.
	ErrWriteAfterClose = errors.New("cpio: write after close")
)

var trailer = &Header{
	Name:  headerEOF,
	Links: 1,
}

var zeroBlock [4]byte

// Writer provides sequential writing of a CPIO archive. Write.WriteHeader
// begins a new file with the provided Header, and then Writer can be treated as
// an io.Writer to supply that file's data.
type Writer struct {
	w      io.Writer
	nb     int64 // number of unwritten bytes for current file entry
	pad    int64 // amount of padding to write after current file entry
	inode  int64
	err    error
	closed bool
}

// NewWriter creates a new Writer writing to w.
func NewWriter(w io.Writer) *Writer {
	return &Writer{w: w}
}

// Flush finishes writing the current file's block padding. The current file
// must be fully written before Flush can be called.
//
// This is unnecessary as the next call to WriteHeader or Close will implicitly
// flush out the file's padding.
func (w *Writer) Flush() error {
	if w.nb > 0 {
		w.err = fmt.Errorf("cpio: missed writing %d bytes", w.nb)
		return w.err
	}
	_, w.err = w.w.Write(zeroBlock[:w.pad])
	if w.err != nil {
		return w.err
	}
	w.nb = 0
	w.pad = 0
	return w.err
}

// WriteHeader writes hdr and prepares to accept the file's contents. The
// Header.Size determines how many bytes can be written for the next file. If
// the current file is not fully written, then this returns an error. This
// implicitly flushes any padding necessary before writing the header.
func (w *Writer) WriteHeader(hdr *Header) (err error) {
	if w.closed {
		return ErrWriteAfterClose
	}
	if w.err == nil {
		w.Flush()
	}
	if w.err != nil {
		return w.err
	}
	if hdr.Name != headerEOF {
		// TODO: should we be mutating hdr here?
		// ensure all inodes are unique
		w.inode++
		if hdr.Inode == 0 {
			hdr.Inode = w.inode
		}

		// ensure file type is set
		if hdr.Mode&^ModePerm == 0 {
			hdr.Mode |= TypeReg
		}

		// ensure regular files have at least 1 inbound link
		if hdr.Links < 1 && hdr.Mode.IsRegular() {
			hdr.Links = 1
		}
	}

	w.nb = hdr.Size
	w.pad, w.err = writeSVR4Header(w.w, hdr)
	return
}

// Write writes to the current file in the CPIO archive. Write returns the error
// ErrWriteTooLong if more than Header.Size bytes are written after WriteHeader.
//
// Calling Write on special types like TypeLink, TypeSymlink, TypeChar,
// TypeBlock, TypeDir, and TypeFifo returns (0, ErrWriteTooLong) regardless of
// what the Header.Size claims.
func (w *Writer) Write(p []byte) (n int, err error) {
	if w.closed {
		err = ErrWriteAfterClose
		return
	}
	overwrite := false
	if int64(len(p)) > w.nb {
		p = p[0:w.nb]
		overwrite = true
	}
	n, err = w.w.Write(p)
	w.nb -= int64(n)
	if err == nil && overwrite {
		err = ErrWriteTooLong
		return
	}
	w.err = err
	return
}

// Close closes the CPIO archive by flushing the padding, and writing the
// footer. If the current file (from a prior call to WriteHeader) is not fully
// written, then this returns an error.
func (w *Writer) Close() error {
	if w.err != nil || w.closed {
		return w.err
	}
	w.err = w.WriteHeader(trailer)
	if w.err != nil {
		return w.err
	}
	w.Flush()
	w.closed = true
	return w.err
}
