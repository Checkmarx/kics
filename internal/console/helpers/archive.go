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

const MimeTypeZip = "application/zip"

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
			PathExtractionMap[filepath.Base(destination)] = absPath

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

func unzip(src string, destination string) ([]string, error) {
	var filenames []string

	r, err := zip.OpenReader(src)
	if err != nil {
		return filenames, err
	}

	defer r.Close()

	for _, f := range r.File {
		fpath := filepath.Join(destination, f.Name)

		if !strings.HasPrefix(fpath, filepath.Clean(destination)+string(os.PathSeparator)) {
			return filenames, fmt.Errorf("%s is an invalid filepath", fpath)
		}

		filenames = append(filenames, fpath)

		if f.FileInfo().IsDir() {
			os.MkdirAll(fpath, os.ModePerm)
			continue
		}

		if err = os.MkdirAll(filepath.Dir(fpath), os.ModePerm); err != nil {
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

		_, err = io.Copy(outFile, rc)

		outFile.Close()
		rc.Close()
		if err != nil {
			return filenames, err
		}
	}

	return filenames, nil
}
