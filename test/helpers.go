package test

import (
	"bytes"
	"fmt"
	"io"
	"os"
	"strings"

	"github.com/spf13/cobra"
)

// ValidUUIDRegex is a constant representing a regular expression rule to validate UUID string
const ValidUUIDRegex = `(?i)^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$`

type execute func() error

// CaptureOutput changes default stdout to intercept into a buffer, converts it to string and returns it
func CaptureOutput(funcToExec execute) (string, error) {
	old := os.Stdout
	r, w, _ := os.Pipe()
	os.Stdout = w

	err := funcToExec()

	outC := make(chan string)

	go func() {
		var buf bytes.Buffer
		if _, errors := io.Copy(&buf, r); errors != nil { // nolint
			return
		}
		outC <- buf.String()
	}()

	if errors := w.Close(); errors != nil {
		return "", errors
	}
	os.Stdout = old
	out := <-outC

	return out, err
}

// CaptureCommandOutput set cobra command args, if necessary, then capture the output
func CaptureCommandOutput(cmd *cobra.Command, args []string) (string, error) {
	if len(args) > 0 {
		cmd.SetArgs(args)
	}

	return CaptureOutput(cmd.Execute)
}

// ChangeCurrentDir gets current working directory and changes to its parent until finds the desired directory
// or fail
func ChangeCurrentDir(desiredDir string) error {
	for currentDir, err := os.Getwd(); GetCurrentDirName(currentDir) != desiredDir; currentDir, err = os.Getwd() {
		if err == nil {
			if err = os.Chdir(".."); err != nil {
				fmt.Printf("change path error = %v", err)
				return fmt.Errorf("change path error = %v", err)
			}
		} else {
			return fmt.Errorf("change path error = %v", err)
		}
	}
	return nil
}

// GetCurrentDirName returns current working directory
func GetCurrentDirName(path string) string {
	dirs := strings.Split(path, string(os.PathSeparator))
	if dirs[len(dirs)-1] == "" && len(dirs) > 1 {
		return dirs[len(dirs)-2]
	}
	return dirs[len(dirs)-1]
}
