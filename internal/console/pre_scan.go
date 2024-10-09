package console

import (
	_ "embed" // Embed kics CLI img and scan-flags
	"fmt"
	"os"
	"path/filepath"
	"runtime"
	"strings"

	"code.cloudfoundry.org/bytefmt"
	"github.com/Checkmarx/kics/v2/internal/console/flags"
	consoleHelpers "github.com/Checkmarx/kics/v2/internal/console/helpers"
	"github.com/Checkmarx/kics/v2/internal/constants"
	"github.com/Checkmarx/kics/v2/internal/metrics"
	internalPrinter "github.com/Checkmarx/kics/v2/pkg/printer"
	"github.com/Checkmarx/kics/v2/pkg/progress"
	"github.com/mackerelio/go-osstat/memory"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

func preRun(cmd *cobra.Command) error {
	err := initializeConfig(cmd)
	if err != nil {
		return errors.New(initError + err.Error())
	}

	err = flags.Validate()
	if err != nil {
		return err
	}

	err = flags.ValidateQuerySelectionFlags()
	if err != nil {
		return err
	}

	err = flags.ValidateTypeSelectionFlags()
	if err != nil {
		return err
	}

	err = internalPrinter.SetupPrinter(cmd.InheritedFlags())
	if err != nil {
		return errors.New(initError + err.Error())
	}
	err = metrics.InitializeMetrics(flags.GetStrFlag(flags.ProfilingFlag), flags.GetBoolFlag(flags.CIFlag))
	if err != nil {
		return errors.New(initError + err.Error())
	}
	return nil
}

func setupConfigFile() (bool, error) {
	if flags.GetStrFlag(flags.ConfigFlag) == "" {
		path := flags.GetMultiStrFlag(flags.PathFlag)
		if len(path) == 0 {
			return true, nil
		}
		if len(path) > 1 {
			warnings = append(warnings, "Any kics.config file will be ignored, please use --config if kics.config is wanted")
			return true, nil
		}
		configPath := path[0]
		info, err := os.Stat(configPath)
		if err != nil {
			return true, nil
		}
		if !info.IsDir() {
			configPath = filepath.Dir(configPath)
		}
		_, err = os.Stat(filepath.ToSlash(filepath.Join(configPath, constants.DefaultConfigFilename)))
		if err != nil {
			if os.IsNotExist(err) {
				return true, nil
			}
			return true, err
		}
		flags.SetStrFlag(flags.ConfigFlag, filepath.ToSlash(filepath.Join(configPath, constants.DefaultConfigFilename)))
	}
	return false, nil
}

func initializeConfig(cmd *cobra.Command) error {
	log.Debug().Msg("console.initializeConfig()")

	v := viper.New()
	v.SetEnvPrefix("KICS")
	v.AutomaticEnv()
	errBind := flags.BindFlags(cmd, v)
	if errBind != nil {
		return errBind
	}

	exit, err := setupConfigFile()
	if err != nil {
		return err
	}
	if exit {
		return nil
	}

	base := filepath.Base(flags.GetStrFlag(flags.ConfigFlag))
	v.SetConfigName(base)
	v.AddConfigPath(filepath.Dir(flags.GetStrFlag(flags.ConfigFlag)))
	ext, err := consoleHelpers.FileAnalyzer(flags.GetStrFlag(flags.ConfigFlag))
	if err != nil {
		return err
	}
	v.SetConfigType(ext)
	if err := v.ReadInConfig(); err != nil {
		return err
	}

	errBind = flags.BindFlags(cmd, v)
	if errBind != nil {
		return errBind
	}
	return nil
}

type console struct {
	Printer       *internalPrinter.Printer
	ProBarBuilder *progress.PbBuilder
}

func newConsole() *console {
	return &console{}
}

// preScan is responsible for scan preparation
func (console *console) preScan() {
	log.Debug().Msg("console.scan()")
	for _, warn := range warnings {
		log.Warn().Msgf("%s", warn)
	}

	printer := internalPrinter.NewPrinter(flags.GetBoolFlag(flags.MinimalUIFlag))
	printer.Success.Printf("\n%s\n", banner)

	versionMsg := fmt.Sprintf("\nScanning with %s\n\n", constants.GetVersion())
	fmt.Println(versionMsg)
	log.Info().Msgf("%s", strings.ReplaceAll(versionMsg, "\n", ""))

	log.Info().Msgf("Operating system: %s", runtime.GOOS)

	mem, err := memory.Get()
	if err != nil {
		log.Err(err)
	} else {
		log.Info().Msgf("Total memory: %s", bytefmt.ByteSize(mem.Total))
	}

	cpu := consoleHelpers.GetNumCPU()
	log.Info().Msgf("CPU: %.1f", cpu)

	log.Info().Msgf("Max file size permitted for scanning: %d MB", flags.GetIntFlag(flags.MaxFileSizeFlag))
	log.Info().Msgf("Max resolver depth permitted for resolving files: %d", flags.GetIntFlag(flags.MaxResolverDepth))

	noProgress := flags.GetBoolFlag(flags.NoProgressFlag)
	if strings.EqualFold(flags.GetStrFlag(flags.LogLevelFlag), "debug") {
		noProgress = true
	}

	proBarBuilder := progress.InitializePbBuilder(
		noProgress,
		flags.GetBoolFlag(flags.CIFlag),
		flags.GetBoolFlag(flags.SilentFlag))

	console.Printer = printer
	console.ProBarBuilder = proBarBuilder
}
