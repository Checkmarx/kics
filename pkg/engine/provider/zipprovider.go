package provider

import (
	"archive/zip"
	"fmt"
	"io"
	"io/fs"
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

// ZipSystemSourceProvider provides a path extraction map
// that relates temporary dir with original path
type ZipSystemSourceProvider struct {
	// PathExtractionMap - relates temporary dir with original path
	PathExtractionMap map[string]string
}

// CheckAndExtractZip - verifies if a given absolute path is a zip file
// and if so extracts its contents to a temporary file
func (z *ZipSystemSourceProvider) CheckAndExtractZip(absPath string) (string, error) {
	file, err := os.Open(absPath)
	if err != nil {
		return "", err
	}

	defer file.Close()

	fInfo, err := file.Stat()
	if err != nil {
		return "", err
	}

	// skip if the path is a dir
	if !fInfo.IsDir() {
		if z.PathExtractionMap == nil {
			z.PathExtractionMap = make(map[string]string)
		}

		contentType, err := getFileContentType(file)
		if err != nil {
			return "", err
		}

		if contentType == MimeTypeZip {
			destination, err := os.MkdirTemp("", "kics-extract-*")
			z.PathExtractionMap[filepath.ToSlash(destination)] = filepath.ToSlash(absPath)

			if err != nil {
				return "", err
			}

			_, err = unzip(file, fInfo, destination)
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

func unzip(fileReader io.ReaderAt, fInfo fs.FileInfo, destination string) ([]string, error) {
	var filenames []string

	zipReader, err := zip.NewReader(fileReader, fInfo.Size())
	if err != nil {
		return filenames, err
	}

	for _, file := range zipReader.File {
		fpath := filepath.Join(destination, filepath.Clean(file.Name))

		if !strings.HasPrefix(fpath, filepath.Clean(destination)+string(os.PathSeparator)) {
			return filenames, fmt.Errorf("%s is an invalid filepath", fpath)
		}

		filenames = append(filenames, fpath)

		if file.FileInfo().IsDir() {
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
			file.Mode())
		if err != nil {
			return filenames, err
		}

		defer outFile.Close()

		fileReadCloser, err := file.Open()
		if err != nil {
			return filenames, err
		}

		defer fileReadCloser.Close()

		for {
			_, err = io.CopyN(outFile, fileReadCloser, MaxZipChunkSize)
			if err != nil {
				if err == io.EOF {
					break
				}
				return filenames, err
			}
		}
	}

	return filenames, nil
}
