package utils

import (
	"bytes"
	"io"
	"os"
	"path/filepath"
	"unicode/utf8"

	"github.com/pkg/errors"
	"golang.org/x/text/encoding/unicode"
	"golang.org/x/text/transform"
)

// ReadFileToUTF8 reads a file and converts it to UTF-8 if needed.
func ReadFileToUTF8(path string) ([]byte, error) {
	bytesContent, err := os.ReadFile(filepath.Clean(path))
	if err != nil {
		return nil, err
	}
	return ReadFileContentToUTF8(bytesContent, path)
}

// ReadFileContentToUTF8 converts file content to UTF-8 if needed.
// This is similar to ReadFileToUTF8 but works on already-read content.
// It handles UTF-16 LE/BE with BOM, and validates UTF-8.
// This is critical for files extracted from ZIP archives on Windows,
// which may be encoded as UTF-16 LE with BOM (0xFF 0xFE).
func ReadFileContentToUTF8(content []byte, filename string) ([]byte, error) {
	if len(content) == 0 {
		return content, nil
	}

	// BOM detection
	if len(content) >= 2 {
		// UTF-16 LE BOM: 0xFF 0xFE
		if content[0] == 0xFF && content[1] == 0xFE {
			r := transform.NewReader(
				bytes.NewReader(content),
				unicode.UTF16(unicode.LittleEndian, unicode.ExpectBOM).NewDecoder(),
			)
			out, err := io.ReadAll(r)
			if err != nil {
				return nil, errors.Wrapf(err, "failed to decode UTF-16 LE with BOM for file %s", filename)
			}
			return out, nil
		}
		// UTF-16 BE BOM: 0xFE 0xFF
		if content[0] == 0xFE && content[1] == 0xFF {
			r := transform.NewReader(
				bytes.NewReader(content),
				unicode.UTF16(unicode.BigEndian, unicode.ExpectBOM).NewDecoder(),
			)
			out, err := io.ReadAll(r)
			if err != nil {
				return nil, errors.Wrapf(err, "failed to decode UTF-16 BE with BOM for file %s", filename)
			}
			return out, nil
		}
	}

	// If valid UTF-8, return as-is
	if utf8.Valid(content) {
		return content, nil
	}

	// If we reach here, the content is not UTF-8 and has no recognized BOM
	return nil, errors.Errorf("unsupported encoding for file %s: content must be UTF-8 or UTF-16 with BOM", filename)
}
