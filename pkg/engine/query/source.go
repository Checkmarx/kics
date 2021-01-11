package query

import (
	"encoding/json"
	"io/ioutil"
	"os"
	"path"
	"path/filepath"
	"runtime"
	"strings"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/getsentry/sentry-go"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

const queryFileName = "query.rego"
const metadataFileName = "metadata.json"

type FilesystemSource struct {
	Source string
}

var (
	_, b, _, _ = runtime.Caller(0)
	basepath   = filepath.Dir(b)
)

func (s *FilesystemSource) GetGenericQuery(platform string) (string, error) {
	var basePath = "../../../assets/queries/generic/"
	var genericPath = filepath.Join(basepath, basePath)
	var content = "package generic.common"
	var errorMessage error

	if strings.Contains(platform, "commonQuery") {
		pathToLib := filepath.FromSlash(genericPath + "/common/library.rego")
		content, err := ioutil.ReadFile(pathToLib)
		if err != nil {
			log.Err(err)
		}
		return string(content), err
	} else if strings.Contains(platform, "ansible") {
		pathToLib := filepath.FromSlash(genericPath + "/ansible/library.rego")
		content, err := ioutil.ReadFile(pathToLib)
		if err != nil {
			log.Err(err)
		}
		return string(content), err
	} else if strings.Contains(platform, "cloudformation") {
		pathToLib := filepath.FromSlash(genericPath + "/cloudformation/library.rego")
		content, err := ioutil.ReadFile(pathToLib)
		if err != nil {
			log.Err(err)
		}
		return string(content), err
	} else if strings.Contains(platform, "dockerfile") {
		pathToLib := filepath.FromSlash(genericPath + "/dockerfile/library.rego")
		content, err := ioutil.ReadFile(pathToLib)
		if err != nil {
			log.Err(err)
		}
		return string(content), err
	} else if strings.Contains(platform, "k8s") {
		pathToLib := filepath.FromSlash(genericPath + "/k8s/library.rego")
		content, err := ioutil.ReadFile(pathToLib)
		if err != nil {
			log.Err(err)
		}
		return string(content), err
	} else if strings.Contains(platform, "terraform") {
		pathToLib := filepath.FromSlash(genericPath + "/terraform/library.rego")
		content, err := ioutil.ReadFile(pathToLib)
		if err != nil {
			log.Err(err)
		}
		return string(content), err
	}

	return content, errorMessage
}

func (s *FilesystemSource) GetQueries() ([]model.QueryMetadata, error) {
	queryDirs := make([]string, 0)
	err := filepath.Walk(s.Source,
		func(p string, f os.FileInfo, err error) error {
			if err != nil {
				return err
			}

			if f.IsDir() || f.Name() != queryFileName {
				return nil
			}

			queryDirs = append(queryDirs, filepath.Dir(p))
			return nil
		})
	if err != nil {
		return nil, errors.Wrap(err, "failed to get query Source")
	}

	queries := make([]model.QueryMetadata, 0, len(queryDirs))
	for _, queryDir := range queryDirs {
		query, errRQ := ReadQuery(queryDir)
		if errRQ != nil {
			sentry.CaptureException(errRQ)
			log.Err(errRQ).
				Msgf("Query provider failed to read query, query=%s", path.Base(queryDir))

			continue
		}

		queries = append(queries, query)
	}

	return queries, err
}

func ReadQuery(queryDir string) (model.QueryMetadata, error) {
	queryContent, err := ioutil.ReadFile(path.Join(queryDir, queryFileName))
	if err != nil {
		return model.QueryMetadata{}, errors.Wrapf(err, "failed to read query %s", path.Base(queryDir))
	}

	metadata := readMetadata(queryDir)
	platform := getPlatform(queryDir)

	return model.QueryMetadata{
		Query:    path.Base(queryDir),
		Content:  string(queryContent),
		Metadata: metadata,
		Platform: platform,
	}, nil
}

func readMetadata(queryDir string) map[string]interface{} {
	f, err := os.Open(path.Join(queryDir, metadataFileName))
	if err != nil {
		sentry.CaptureException(err)
		if os.IsNotExist(err) {
			log.Warn().
				Msgf("Queries provider can't find metadata, query=%s", path.Base(queryDir))

			return nil
		}

		log.Err(err).
			Msgf("Queries provider can't read metadata, query=%s", path.Base(queryDir))

		return nil
	}

	var metadata map[string]interface{}
	if err := json.NewDecoder(f).Decode(&metadata); err != nil {
		sentry.CaptureException(err)
		log.Err(err).
			Msgf("Queries provider can't unmarshal metadata, query=%s", path.Base(queryDir))

		return nil
	}

	return metadata
}

func getPlatform(platform string) string {
	if strings.Contains(platform, "commonQuery") {
		return "commonQuery"
	} else if strings.Contains(platform, "ansible") {
		return "ansible"
	} else if strings.Contains(platform, "cloudFormation") {
		return "cloudFormation"
	} else if strings.Contains(platform, "dockerfile") {
		return "dockerfile"
	} else if strings.Contains(platform, "k8s") {
		return "k8s"
	} else if strings.Contains(platform, "terraform") {
		return "terraform"
	}

	return "unknown"
}
