package provider

import (
	"context"
	"io/fs"
	"os"
	"os/signal"
	"path/filepath"
	"sync"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/rs/zerolog/log"

	"github.com/hashicorp/go-getter"
)

const (
	channelLength = 2
)

// ExtractedPath is a struct that contains the paths, temporary paths to remove
// and extraction map path of the sources
// Path is the slice of paths to scan
// ExtrectionMap is a map that correlates the temporary path to the givven path
// RemoveTmp is the slice containing temporary paths to be removed
type ExtractedPath struct {
	Path          []string
	ExtrectionMap map[string]model.ExtractedPathObject
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

// GetSources goes through the source slice, and determines the of source type (ex: zip, git, local).
// It than extracts the files to be scanned. If the source given is not local, a temp dir
// will be created where the files will be stored.
func GetSources(source []string) (ExtractedPath, error) {
	returnStr := ExtractedPath{
		Path:          []string{},
		ExtrectionMap: make(map[string]model.ExtractedPathObject),
		RemoveTmp:     []string{},
	}
	for _, path := range source {
		destination, err := os.MkdirTemp("", "kics-extract-*")
		if err != nil {
			return ExtractedPath{}, err
		}

		err = os.RemoveAll(destination)
		if err != nil {
			return ExtractedPath{}, err
		}

		mode := getter.ClientModeAny

		pwd, err := os.Getwd()
		if err != nil {
			log.Fatal().Msgf("Error getting wd: %s", err)
		}

		opts := []getter.ClientOption{}

		opts = append(opts, getter.WithInsecure())

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

		dst, err := getPaths(&st)
		if err != nil {
			log.Error().Msgf("failed to find path %s: %s", path, err)
			return ExtractedPath{}, err
		}
		returnStr.RemoveTmp = append(returnStr.RemoveTmp, dst)
		tempDst, local := checkSymLink(dst, path)

		returnStr.ExtrectionMap[dst] = model.ExtractedPathObject{
			Path:      path,
			LocalPath: local,
		}

		returnStr.Path = append(returnStr.Path, tempDst)
	}

	return returnStr, nil
}

func getPaths(g *getterStruct) (string, error) {
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
	case <-c:
		signal.Reset(os.Interrupt)
		g.cancel()
		wg.Wait()
	case <-g.ctx.Done():
		wg.Wait()
	case err := <-errChan:
		wg.Wait()
		return "", err
	}

	return g.destination, nil
}

// check if the dst is a symbolic link
func checkSymLink(dst, pathFile string) (string, bool) {
	var local bool
	if _, err := os.Stat(pathFile); err == nil { // check if file exist locally
		local = true
	}

	info, err := os.Lstat(dst)
	if err != nil {
		log.Error().Msgf("failed lstat for %s: %v", dst, err)
	}

	fileInfo := getFileInfo(info, dst, pathFile)

	if info.Mode()&os.ModeSymlink != 0 { // if it's a symbolic Link
		path, err := os.Readlink(dst) // get location of symbolic Link
		if err != nil {
			log.Error().Msgf("failed Readlink for %s: %v", dst, err)
		}
		dst = path // change path to local path
	} else if !fileInfo.IsDir() { // symbolic links are not created for single files
		if local { // check if file exist locally
			dst = pathFile
		}
	}
	return dst, local
}

func getFileInfo(info fs.FileInfo, dst, pathFile string) fs.FileInfo {
	var extension = filepath.Ext(pathFile)
	var path string
	if extension == "" {
		path = filepath.Join(dst, filepath.Base(pathFile[0:len(pathFile)-len(extension)])) // for single file
	} else {
		path = filepath.Join(dst, filepath.Base(pathFile)) // for directories
	}
	fileInfo, err := os.Lstat(path)
	if err != nil {
		fileInfo = info
	}
	return fileInfo
}
