package helpers

import (
	"context"
	"os"
	"os/signal"
	"sync"

	progressBar "github.com/Checkmarx/kics/pkg/progress/reader"
	"github.com/rs/zerolog/log"

	"github.com/hashicorp/go-getter"
)

const (
	channelLength = 2
)

type extractedPath struct {
	Path          []string
	ExtrectionMap map[string]string
	RemoveTmp     []string
}

type getterStruct struct {
	ctx         context.Context
	cancel      context.CancelFunc
	mode        getter.ClientMode
	pwd         string
	opts        []getter.ClientOption
	destination string
	source      string
}

func GetSources(source []string, progress, insecure bool) (extractedPath, error) {
	returnStr := extractedPath{
		Path:          []string{},
		ExtrectionMap: make(map[string]string),
		RemoveTmp:     []string{},
	}
	for _, path := range source {
		destination, err := os.MkdirTemp("", "kics-extract-*")
		if err != nil {
			return extractedPath{}, err
		}

		err = os.RemoveAll(destination)
		if err != nil {
			return extractedPath{}, err
		}

		// Get the mode
		mode := getter.ClientModeAny

		pwd, err := os.Getwd()
		if err != nil {
			log.Fatal().Msgf("Error getting wd: %s", err)
		}

		opts := []getter.ClientOption{getter.WithProgress(&progressBar.PBar{})}

		if insecure {
			log.Warn().Msg("WARNING: Using Insecure TLS transport!")
			opts = append(opts, getter.WithInsecure())
		}

		ctx, cancel := context.WithCancel(context.Background())

		st := getterStruct{
			ctx:         ctx,
			cancel:      cancel,
			mode:        mode,
			pwd:         pwd,
			opts:        opts,
			destination: destination,
			source:      path,
		}

		dst := getPaths(st)
		returnStr.RemoveTmp = append(returnStr.RemoveTmp, dst)
		dst = checkSymLink(dst)
		returnStr.ExtrectionMap[dst] = path
		returnStr.Path = append(returnStr.Path, dst)
	}

	return returnStr, nil
}

func getPaths(g getterStruct) string {

	// Build the client
	client := &getter.Client{
		Ctx:     g.ctx,
		Src:     g.source,
		Dst:     g.destination,
		Pwd:     g.pwd,
		Mode:    g.mode,
		Options: g.opts,
	}

	wg := sync.WaitGroup{}
	wg.Add(1)
	errChan := make(chan error, channelLength)
	go func() {
		defer wg.Done()
		defer g.cancel()
		if err := client.Get(); err != nil {
			errChan <- err
		}
	}()

	c := make(chan os.Signal, channelLength)
	signal.Notify(c, os.Interrupt)

	select {
	case sig := <-c:
		signal.Reset(os.Interrupt)
		g.cancel()
		wg.Wait()
		log.Printf("signal %v", sig)
	case <-g.ctx.Done():
		wg.Wait()
		log.Printf("success!")
	case err := <-errChan:
		wg.Wait()
		log.Fatal().Msgf("Error downloading: %s", err)
	}

	return g.destination
}

func checkSymLink(dst string) string {
	info, err := os.Lstat(dst)
	if err != nil {
		log.Error().Msgf("failed lstat for %s: %v", dst, err)
	}
	if info.Mode()&os.ModeSymlink != 0 {
		path, err := os.Readlink(dst)
		if err != nil {
			log.Error().Msgf("failed Readlink for %s: %v", dst, err)
		}
		dst = path
	}
	return dst
}
