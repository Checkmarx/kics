package helpers

import (
	"archive/zip"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"strings"
)

const (
	// MimeTypeZip - application/zip MIME type
	MimeTypeZip = "application/zip"
	// MaxZipChunkSize - size of the chunks for io.CopyN operation
	MaxZipChunkSize = 1024
)

// PathExtractionMap - relates temporary dir with original path
var PathExtractionMap map[string]string

// CheckAndExtractZip - verifies if a given absolute path is a zip file
// and if so extracts its contents to a temporary file
func CheckAndExtractZip(absPath string) (string, error) {
	f, err := os.Open(absPath)
	if err != nil {
		return "", err
	}
	fi, err := f.Stat()
	if err != nil {
		return "", err
	}

	// skip if the path is a dir
	if !fi.IsDir() {
		if PathExtractionMap == nil {
			PathExtractionMap = make(map[string]string)
		}

		contentType, err := getFileContentType(f)
		if err != nil {
			return "", err
		}

		if contentType == MimeTypeZip {
			destination, err := os.MkdirTemp("", "kics-extract-*")
			PathExtractionMap[destination] = absPath

			if err != nil {
				return "", err
			}

			_, err = unzip(absPath, destination)
			if err != nil {
				return "", err
			}

			absPath = destination
		}
	}

	return absPath, nil
}

func getFileContentType(out *os.File) (string, error) {
	buffer := make([]byte, 512)

	_, err := out.Read(buffer)
	if err != nil {
		return "", err
	}

	contentType := http.DetectContentType(buffer)

	return contentType, nil
}

func unzip(src, destination string) ([]string, error) {
	var filenames []string

	r, err := zip.OpenReader(filepath.Clean(src))
	if err != nil {
		return filenames, err
	}

	defer r.Close()

	for _, f := range r.File {
		fpath := filepath.Join(destination, filepath.Clean(f.Name))

		if !strings.HasPrefix(fpath, filepath.Clean(destination)+string(os.PathSeparator)) {
			return filenames, fmt.Errorf("%s is an invalid filepath", fpath)
		}

		filenames = append(filenames, fpath)

		if f.FileInfo().IsDir() {
			err := os.MkdirAll(fpath, os.ModePerm)
			if err != nil {
				return nil, err
			}
			continue
		}

		if err := os.MkdirAll(filepath.Dir(fpath), os.ModePerm); err != nil {
			return filenames, err
		}

		outFile, err := os.OpenFile(fpath,
			os.O_WRONLY|os.O_CREATE|os.O_TRUNC,
			f.Mode())
		if err != nil {
			return filenames, err
		}

		rc, err := f.Open()
		if err != nil {
			return filenames, err
		}

		for {
			_, err = io.CopyN(outFile, rc, MaxZipChunkSize)
			if err != nil {
				if err == io.EOF {
					break
				}

				outFile.Close()
				rc.Close()
				return filenames, err
			}
		}

		outFile.Close()
		rc.Close()
	}

	return filenames, nil
}
