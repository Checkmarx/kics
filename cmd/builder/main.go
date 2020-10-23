package main

import (
	"context"
	"io/ioutil"
	"os"
	"path"

	"github.com/checkmarxDev/ice/cmd/builder/comment_parser"
	"github.com/checkmarxDev/ice/cmd/builder/engine"
	"github.com/checkmarxDev/ice/cmd/builder/writer"
	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/hclsyntax"
	"github.com/pkg/errors"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
)

func main() {
	var (
		inPath  string
		outPath string
	)

	ctx := context.Background()
	log.Logger = log.Output(zerolog.ConsoleWriter{Out: os.Stdout})
	zerolog.SetGlobalLevel(zerolog.DebugLevel)

	rootCmd := &cobra.Command{
		Use:   "inspect",
		Short: "Tool to build new query from example file",
		RunE: func(cmd *cobra.Command, args []string) error {
			file, commentParser, err := parseFile(inPath)
			if err != nil {
				return errors.Wrap(err, "failed to parse file")
			}

			e := engine.New(commentParser)
			rules, err := e.Run(file.Body.(*hclsyntax.Body))
			if err != nil {
				return err
			}

			regoWriter, err := writer.NewRegoWriter()
			if err != nil {
				return err
			}

			content, err := regoWriter.Render(rules)
			if err != nil {
				return err
			}

			return saveFile(outPath, content)
		},
	}

	rootCmd.Flags().StringVarP(&inPath, "in", "i", "", "path for in file")
	rootCmd.Flags().StringVarP(&outPath, "out", "o", "", "path for out path")

	if err := rootCmd.MarkFlagRequired("in"); err != nil {
		log.Err(err).Msg("failed to add command required flags")
	}
	if err := rootCmd.MarkFlagRequired("out"); err != nil {
		log.Err(err).Msg("failed to add command required flags")
	}

	if err := rootCmd.ExecuteContext(ctx); err != nil {
		os.Exit(-1)
	}
}

func saveFile(filePath string, content []byte) error {
	f, err := os.OpenFile(filePath, os.O_CREATE|os.O_WRONLY|os.O_TRUNC, os.ModePerm)
	if err != nil {
		return err
	}
	if _, err := f.Write(content); err != nil {
		return err
	}
	return f.Close()
}

func parseFile(filePath string) (*hcl.File, *comment_parser.Parser, error) {
	content, err := ioutil.ReadFile(filePath)
	if err != nil {
		return nil, nil, err
	}

	fileName := path.Base(filePath)

	file, diags := hclsyntax.ParseConfig(content, fileName, hcl.Pos{Byte: 0, Line: 1, Column: 1})
	if diags != nil && diags.HasErrors() {
		return nil, nil, diags.Errs()[0]
	}

	commentParser, err := comment_parser.NewParser(content, fileName)
	if err != nil {
		return nil, nil, err
	}

	return file, commentParser, nil
}
