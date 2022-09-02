package restclient

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"mime/multipart"
	"net/textproto"
)

// MultipartBuffer holds the Body & ContentType of the multipart body
type MultipartBuffer struct {
	Buffer      *bytes.Buffer
	ContentType string
}

// PayloadWithFiles returns the given payload as multipart body with all files in it
//goland:noinspection GoUnusedExportedFunction
func PayloadWithFiles(v interface{}, files ...File) (buffer *MultipartBuffer, err error) {
	body := &bytes.Buffer{}
	writer := multipart.NewWriter(body)
	writer.FormDataContentType()
	defer func() {
		_ = writer.Close()
	}()

	var payload []byte
	payload, err = json.Marshal(v)
	if err != nil {
		return
	}

	part, err := writer.CreatePart(partHeader(`form-data; name="payload_json"`, "application/json"))
	if err != nil {
		return
	}

	if _, err = part.Write(payload); err != nil {
		return
	}

	for i, file := range files {
		var name string
		if file.Flags.Has(FileFlagSpoiler) {
			name = "SPOILER_" + file.Name
		} else {
			name = file.Name
		}
		part, err = writer.CreatePart(partHeader(fmt.Sprintf(`form-data; name="file%d"; filename="%s"`, i, name), "application/octet-stream"))
		if err != nil {
			return
		}

		if _, err = io.Copy(part, file.Reader); err != nil {
			return
		}
	}

	buffer = &MultipartBuffer{
		Buffer:      body,
		ContentType: writer.FormDataContentType(),
	}
	return
}

func partHeader(contentDisposition string, contentType string) textproto.MIMEHeader {
	return textproto.MIMEHeader{
		"Content-Disposition": []string{contentDisposition},
		"Content-Type":        []string{contentType},
	}
}

// NewFile returns a new File struct with the given name, io.Reader & FileFlags
func NewFile(name string, reader io.Reader, flags ...FileFlags) File {
	return File{
		Name:   name,
		Reader: reader,
		Flags:  FileFlagNone.Add(flags...),
	}
}

// File holds all information about a given io.Reader
type File struct {
	Name   string
	Reader io.Reader
	Flags  FileFlags
}

// FileFlags are used to mark Attachments as Spoiler
type FileFlags int

// all FileFlags
const (
	FileFlagSpoiler FileFlags = 1 << iota
	FileFlagNone    FileFlags = 0
)

// Add allows you to add multiple FileFlags together, producing a new FileFlags
func (f FileFlags) Add(flags ...FileFlags) FileFlags {
	total := FileFlags(0)
	for _, flag := range flags {
		total |= flag
	}
	f |= total
	return f
}

// Remove allows you to subtract multiple FileFlags from the first, producing a new FileFlags
func (f FileFlags) Remove(flags ...FileFlags) FileFlags {
	total := FileFlags(0)
	for _, flag := range flags {
		total |= flag
	}
	f &^= total
	return f
}

// HasAll will ensure that the FileFlags includes all of the FileFlags(s) entered
func (f FileFlags) HasAll(flags ...FileFlags) bool {
	for _, flag := range flags {
		if !f.Has(flag) {
			return false
		}
	}
	return true
}

// Has will check whether the FileFlags contains another FileFlags
func (f FileFlags) Has(flag FileFlags) bool {
	return (f & flag) == flag
}

// MissingAny will check whether the FileFlags is missing any one of the FileFlags
func (f FileFlags) MissingAny(flags ...FileFlags) bool {
	for _, flag := range flags {
		if !f.Has(flag) {
			return true
		}
	}
	return false
}

// Missing will do the inverse of FileFlags.Has
func (f FileFlags) Missing(flag FileFlags) bool {
	return !f.Has(flag)
}
