package helpers

import (
	"context"
	"os"
	"os/signal"
	"sync"

	"github.com/rs/zerolog/log"

	"github.com/hashicorp/go-getter"
)

func GetSources(source, modeStr string, progress, insecure bool) (string, error) {
	destination, err := os.MkdirTemp("", "kics-extract-*")
	if err != nil {
		return "", err
	}

	// Get the mode
	var mode getter.ClientMode
	switch modeStr {
	case "any":
		mode = getter.ClientModeAny
	case "file":
		mode = getter.ClientModeFile
	case "dir":
		mode = getter.ClientModeDir
	default:
		log.Fatal().Msgf("Invalid client mode, must be 'any', 'file', or 'dir': %s", modeStr)
		os.Exit(1)
	}

	pwd, err := os.Getwd()
	if err != nil {
		log.Fatal().Msgf("Error getting wd: %s", err)
	}

	opts := []getter.ClientOption{}

	if insecure {
		log.Warn().Msg("WARNING: Using Insecure TLS transport!")
		opts = append(opts, getter.WithInsecure())
	}

	ctx, cancel := context.WithCancel(context.Background())
	// Build the client
	client := &getter.Client{
		Ctx:     ctx,
		Src:     source,
		Dst:     destination,
		Pwd:     pwd,
		Mode:    mode,
		Options: opts,
	}

	wg := sync.WaitGroup{}
	wg.Add(1)
	errChan := make(chan error, 2)
	go func() {
		defer wg.Done()
		defer cancel()
		if err := client.Get(); err != nil {
			errChan <- err
		}
	}()

	c := make(chan os.Signal)
	signal.Notify(c, os.Interrupt)

	select {
	case sig := <-c:
		signal.Reset(os.Interrupt)
		cancel()
		wg.Wait()
		log.Printf("signal %v", sig)
	case <-ctx.Done():
		wg.Wait()
		log.Printf("success!")
	case err := <-errChan:
		wg.Wait()
		log.Fatal().Msgf("Error downloading: %s", err)
	}

	return destination, nil
}
