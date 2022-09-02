package cpio

import (
	"io"
	"io/ioutil"
)

// Reader provides sequential access to the contents of a CPIO archive.
// Reader.Next advances to the next file in the archive (including the first),
// and then Reader can be treated as an io.Reader to access the file's data.
type Reader struct {
	r   io.Reader // underlying file reader
	hdr *Header   // current Header
	eof int64     // bytes until the end of the current file
}

// NewReader creates a new Reader reading from r.
func NewReader(r io.Reader) *Reader {
	return &Reader{
		r: r,
	}
}

// Read reads from the current file in the CPIO archive. It returns (0, io.EOF)
// when it reaches the end of that file, until Next is called to advance to the
// next file.
//
// Calling Read on special types like TypeLink, TypeSymlink, TypeChar,
// TypeBlock, TypeDir, and TypeFifo returns (0, io.EOF) regardless of what the
// Header.Size claims.
func (r *Reader) Read(p []byte) (n int, err error) {
	if r.hdr == nil || r.eof == 0 {
		return 0, io.EOF
	}
	rn := len(p)
	if r.eof < int64(rn) {
		rn = int(r.eof)
	}
	n, err = r.r.Read(p[0:rn])
	r.eof -= int64(n)
	return
}

// Next advances to the next entry in the CPIO archive. The Header.Size
// determines how many bytes can be read for the next file. Any remaining data
// in the current file is automatically discarded.
//
// io.EOF is returned at the end of the input.
func (r *Reader) Next() (*Header, error) {
	if r.hdr == nil {
		return r.next()
	}
	skp := r.eof + r.hdr.pad
	if skp > 0 {
		_, err := io.CopyN(ioutil.Discard, r.r, skp)
		if err != nil {
			return nil, err
		}
	}
	return r.next()
}

func (r *Reader) next() (*Header, error) {
	r.eof = 0
	hdr, err := readSVR4Header(r.r)
	if err != nil {
		return nil, err
	}
	r.hdr = hdr
	r.eof = hdr.Size
	return hdr, nil
}
