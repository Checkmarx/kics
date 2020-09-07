package source

import (
	"context"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"path"
	"strings"
	"sync"

	internalcontext "github.com/checkmarxDev/ice/internal/context"
	repo "github.com/checkmarxDev/repostore/pkg/api/v1"
	"github.com/pkg/errors"
	"google.golang.org/grpc"

	"github.com/rs/zerolog/log"
)

const fileRegex = `(.*)\.tf$`

type RepostoreSourceProvider struct {
	restAddr string
	client   repo.RepsotoreServiceClient
}

func NewRepostoreSourceProvider(
	ctx context.Context,
	restAddr, grpcAddr string,
) (*RepostoreSourceProvider, error) {
	cc, err := grpc.DialContext(ctx, grpcAddr, grpc.WithInsecure())
	if err != nil {
		return nil, errors.Wrap(err, "failed connect to repostore")
	}

	return &RepostoreSourceProvider{
		restAddr: restAddr,
		client:   repo.NewRepsotoreServiceClient(cc),
	}, nil
}

func (s *RepostoreSourceProvider) GetSources(ctx context.Context, scanID string, sink Sink) error {
	return s.doGetSources(ctx, scanID, sink)
}

func (s *RepostoreSourceProvider) doGetSources(ctx context.Context, scanID string, sink Sink) error {
	ctx = internalcontext.ForwardContext(ctx)
	var wg sync.WaitGroup
	stream, err := s.client.ListCommitFiles(ctx, &repo.ListCommitFilesRequest{Commit: &repo.Commit{Id: scanID}, Regex: fileRegex})
	if err != nil {
		return err
	}
	for {
		res, listFilesErr := stream.Recv()
		if listFilesErr == io.EOF {
			break
		}
		if listFilesErr != nil {
			return listFilesErr
		}
		wg.Add(1)
		go func(l *repo.ListCommitFilesResponse) {
			defer wg.Done()
			content, downloadFileErr := s.loadContent(scanID, l.Path)
			if downloadFileErr != nil {
				log.
					Err(err).
					Str("scanID", scanID).
					Str("path", l.Path).
					Msg("failed load file content")
			}

			if err := sink(ctx, l.Path, content); err != nil {
				log.
					Err(err).
					Str("scanID", scanID).
					Str("path", l.Path).
					Msg("failed sink file content")
			}
		}(res)
	}
	wg.Wait()
	return nil
}

func (s *RepostoreSourceProvider) loadContent(scanID, location string) (io.ReadCloser, error) {
	u, err := url.Parse(s.restAddr)
	if err != nil {
		return nil, err
	}
	u.Path = path.Join("code", scanID, location)
	log.Trace().Msgf("Requesting code. url=%s", u.String())
	response, err := http.Get(u.String()) //nolint
	if err != nil {
		var e *url.Error
		// TODO temp solution for easy debugging, should be removed once we add tests
		if errors.As(err, &e) {
			accessibleURL := strings.Replace(e.URL, "minio:9000", "127.0.0.1:80/storage", -1)
			response, err = http.Get(accessibleURL) // nolint
			if err != nil {
				return nil, errors.Wrap(err, "failed to load resource")
			}
		} else {
			return nil, errors.Wrap(err, "failed to load source")
		}
	}
	if response.StatusCode != http.StatusOK && response.StatusCode != http.StatusFound {
		return nil, fmt.Errorf("failed to load sources. status=%s", response.Status)
	}
	return response.Body, nil
}
