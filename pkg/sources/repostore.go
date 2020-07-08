package sources

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"github.com/rs/zerolog/log"
	"io"
	"io/ioutil"
	"net/http"
	"net/url"
	"os"
	"path"
	"path/filepath"
	"strings"
	"sync"
	"time"
)

var supportedExtensions = map[string]struct{}{
	".hcl":      {},
	".sentinel": {},
	".json":     {},
}

type RepostoreSourceProvider struct {
	addr string
}

func NewRepostoreSourceProvider(addr string) *RepostoreSourceProvider {
	return &RepostoreSourceProvider{
		addr,
	}
}

func (s *RepostoreSourceProvider) DownloadSources(_ context.Context, scanID, dstPath string) error {
	return s.downloadSources(scanID, "", dstPath)
}

func (s *RepostoreSourceProvider) downloadSources(scanID, folder, dstPath string) error {
	var wg sync.WaitGroup // TODO will be faster if we move this to higher level
	infos, err := s.loadFolder(scanID, folder)
	if err != nil {
		return fmt.Errorf("failed to load source data: %w", err)
	}
	for _, info := range infos {
		if !info.IsDir {
			if fileSupported(info.Name) {
				wg.Add(1)
				go func() {
					defer wg.Done()
					if err := s.downloadFile(scanID, path.Join(folder, info.Name), filepath.Join(dstPath, folder)); err != nil {
						fmt.Println(err)
						// TODO handel error
					}
				}()
			}
		} else {
			if err := s.downloadSources(scanID, path.Join(folder, info.Name), dstPath); err != nil {
				return err
			}
		}
	}
	wg.Wait()
	return nil
}

func (s *RepostoreSourceProvider) loadFolder(scanID, folder string) ([]*FileInfo, error) {
	content, err := s.loadContent(scanID, folder)
	if err != nil {
		return nil, err
	}
	defer content.Close()
	data, err := ioutil.ReadAll(content)
	if err != nil {
		return nil, err
	}
	fileInfo := make([]*FileInfo, 0)
	err = json.Unmarshal(data, &fileInfo)
	return fileInfo, err
}

func (s *RepostoreSourceProvider) loadContent(scanID, location string) (io.ReadCloser, error) {
	u, err := url.Parse(s.addr)
	if err != nil {
		return nil, err
	}
	u.Path = path.Join("code", scanID, location)
	log.Trace().
		Msgf("Requesting code. url=%s", u.String())
	response, err := http.Get(u.String()) //nolint
	if err != nil {
		var e *url.Error
		// TODO temp solution for easy debugging, should be removed once we add tests
		if errors.As(err, &e) {
			accessibleURL := strings.Replace(e.URL, "minio:9000", "127.0.0.1:80/api/storage", -1)
			response, err = http.Get(accessibleURL)
			if err != nil {
				return nil, fmt.Errorf("failed to load sources : %w", err)
			}
		} else {
			return nil, fmt.Errorf("failed to load sources: %w", err)
		}
	}
	if response.StatusCode != http.StatusOK && response.StatusCode != http.StatusFound {
		return nil, fmt.Errorf("failed to load sources. status=%s", response.Status)
	}
	return response.Body, nil
}

func (s *RepostoreSourceProvider) downloadFile(scanID, file, dstPath string) error {
	content, err := s.loadContent(scanID, file)
	if err != nil {
		return err
	}
	defer content.Close()
	if err := os.MkdirAll(path.Join(dstPath, filepath.Dir(file)), os.ModePerm); err != nil {
		return err
	}
	outFile, err := os.Create(path.Join(dstPath, file))
	if err != nil {
		return err
	}
	defer outFile.Close()
	_, err = io.Copy(outFile, content)
	if err != nil {
		return err
	}
	return nil
}

type FileInfo struct {
	Name    string    `json:"name"`
	Size    int64     `json:"size"`
	ModTime time.Time `json:"modTime"`
	IsDir   bool      `json:"isDir"`
}

func fileSupported(filename string) bool {
	filename = strings.ToLower(filename)
	dots := getDotIndexes(filename)
	for _, dot := range dots {
		ext := filename[dot:]
		_, ok := supportedExtensions[ext]
		if ok {
			return true
		}
	}

	return false
}

// getDotIndexes supports two dots in the name, if filepath.Ext is not good enough
func getDotIndexes(filename string) []int {
	dots := make([]int, 0, 2)
	for i, letter := range filename {
		if letter == rune('.') {
			dots = append(dots, i)
		}
	}

	return dots
}
