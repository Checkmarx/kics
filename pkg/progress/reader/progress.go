package reader

import (
	"io"
	"path/filepath"
	"sync"

	"github.com/cheggaaa/pb"
	"github.com/rs/zerolog/log"
)

type PBar struct {
	pool *pb.Pool
	pbs  int
	lock sync.Mutex
}

type readCloser struct {
	io.Reader
	close func() error
}

func (p *PBar) TrackProgress(src string, currentSize, totalSize int64, stream io.ReadCloser) (body io.ReadCloser) { //nolint
	p.lock.Lock()
	defer p.lock.Unlock()

	newPb := pb.New64(totalSize)
	newPb.Set64(currentSize)

	newPb.SetUnits(pb.U_BYTES)
	newPb.Prefix(filepath.Base(src))

	if p.pool == nil {
		p.pool = pb.NewPool()
		if err := p.pool.Start(); err != nil {
			log.Error().Msgf("got an error %v", err)
		}
	}

	p.pool.Add(newPb)
	reader := newPb.NewProxyReader(stream)
	p.pbs++

	return &readCloser{
		Reader: reader,
		close: func() error {
			p.lock.Lock()
			defer p.lock.Unlock()
			newPb.Finish()
			p.pbs--
			if p.pbs <= 0 {
				if err := p.pool.Stop(); err != nil {
					log.Error().Msgf("got an error %v", err)
				}
				p.pool = nil
			}
			return nil
		},
	}
}

func (c *readCloser) Close() error { return c.close() }
