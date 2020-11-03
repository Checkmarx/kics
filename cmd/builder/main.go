package main

import (
	"context"
	"os"

	"github.com/checkmarxDev/ice/pkg/builder/engine"
	"github.com/checkmarxDev/ice/pkg/builder/writer"
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
			e := engine.New()
			rules, err := e.Run(inPath)
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
