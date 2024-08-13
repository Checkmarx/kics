/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the Apache-2.0 License.
 *
 * This product includes software developed at Datadog (https://www.datadoghq.com)  Copyright 2024 Datadog, Inc.
 */
package console

import (
	_ "embed" // Embed kics CLI img and scan-flags
	"fmt"
	"runtime"
	"strings"

	consoleHelpers "github.com/Checkmarx/kics/internal/console/helpers"
	"github.com/Checkmarx/kics/internal/constants"
	internalPrinter "github.com/Checkmarx/kics/pkg/printer"
	"github.com/Checkmarx/kics/pkg/progress"
	"github.com/Checkmarx/kics/pkg/scan"

	"github.com/rs/zerolog/log"
)

var (
	//go:embed assets/kics-console
	banner string
)

// func preRun(cmd *cobra.Command) error {
// 	err := initializeConfig(cmd)
// 	if err != nil {
// 		return errors.New(initError + err.Error())
// 	}

// 	err = flags.Validate()
// 	if err != nil {
// 		return err
// 	}

// 	err = flags.ValidateQuerySelectionFlags()
// 	if err != nil {
// 		return err
// 	}

// 	err = flags.ValidateTypeSelectionFlags()
// 	if err != nil {
// 		return err
// 	}

// 	err = internalPrinter.SetupPrinter(cmd.InheritedFlags())
// 	if err != nil {
// 		return errors.New(initError + err.Error())
// 	}
// 	err = metrics.InitializeMetrics(flags.GetStrFlag(flags.ProfilingFlag), flags.GetBoolFlag(flags.CIFlag))
// 	if err != nil {
// 		return errors.New(initError + err.Error())
// 	}
// 	return nil
// }

// func setupConfigFile() (bool, error) {
// 	if flags.GetStrFlag(flags.ConfigFlag) == "" {
// 		path := flags.GetMultiStrFlag(flags.PathFlag)
// 		if len(path) == 0 {
// 			return true, nil
// 		}
// 		if len(path) > 1 {
// 			warnings = append(warnings, "Any kics.config file will be ignored, please use --config if kics.config is wanted")
// 			return true, nil
// 		}
// 		configPath := path[0]
// 		info, err := os.Stat(configPath)
// 		if err != nil {
// 			return true, nil
// 		}
// 		if !info.IsDir() {
// 			configPath = filepath.Dir(configPath)
// 		}
// 		_, err = os.Stat(filepath.ToSlash(filepath.Join(configPath, constants.DefaultConfigFilename)))
// 		if err != nil {
// 			if os.IsNotExist(err) {
// 				return true, nil
// 			}
// 			return true, err
// 		}
// 		flags.SetStrFlag(flags.ConfigFlag, filepath.ToSlash(filepath.Join(configPath, constants.DefaultConfigFilename)))
// 	}
// 	return false, nil
// }

// func initializeConfig(cmd *cobra.Command) error {
// 	log.Debug().Msg("console.initializeConfig()")

// 	v := viper.New()
// 	v.SetEnvPrefix("KICS")
// 	v.AutomaticEnv()
// 	errBind := flags.BindFlags(cmd, v)
// 	if errBind != nil {
// 		return errBind
// 	}

// 	exit, err := setupConfigFile()
// 	if err != nil {
// 		return err
// 	}
// 	if exit {
// 		return nil
// 	}

// 	base := filepath.Base(flags.GetStrFlag(flags.ConfigFlag))
// 	v.SetConfigName(base)
// 	v.AddConfigPath(filepath.Dir(flags.GetStrFlag(flags.ConfigFlag)))
// 	ext, err := consoleHelpers.FileAnalyzer(flags.GetStrFlag(flags.ConfigFlag))
// 	if err != nil {
// 		return err
// 	}
// 	v.SetConfigType(ext)
// 	if err := v.ReadInConfig(); err != nil {
// 		return err
// 	}

// 	errBind = flags.BindFlags(cmd, v)
// 	if errBind != nil {
// 		return errBind
// 	}
// 	return nil
// }

type console struct {
	Printer       *internalPrinter.Printer
	ProBarBuilder *progress.PbBuilder
}

func newConsole() *console {
	return &console{}
}

// preScan is responsible for scan preparation
func (console *console) preScan(params *scan.Parameters) {
	log.Debug().Msg("console.scan()")
	// for _, warn := range warnings {
	// 	log.Warn().Msgf(warn)
	// }

	printer := internalPrinter.NewPrinter(true)
	printer.Success.Printf("\n%s\n", banner)

	versionMsg := fmt.Sprintf("\nScanning with %s\n\n", constants.GetVersion())
	fmt.Println(versionMsg)
	log.Info().Msgf(strings.ReplaceAll(versionMsg, "\n", ""))

	log.Info().Msgf("Operating system: %s", runtime.GOOS)

	cpu := consoleHelpers.GetNumCPU()
	log.Info().Msgf("CPU: %.1f", cpu)

	log.Info().Msgf("Max file size permitted for scanning: %d MB", params.MaxFileSizeFlag)
	log.Info().Msgf("Max resolver depth permitted for resolving files: %d", params.MaxResolverDepth)

	noProgress := false

	proBarBuilder := progress.InitializePbBuilder(
		noProgress,
		false,
		true)

	console.Printer = printer
	console.ProBarBuilder = proBarBuilder
}
