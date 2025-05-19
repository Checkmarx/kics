package printer

import (
	"fmt"
	"io"
	"sort"
	"strconv"
	"strings"

	"github.com/Checkmarx/kics/v2/pkg/utils"

	consoleFlags "github.com/Checkmarx/kics/v2/internal/console/flags"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/gookit/color"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"github.com/spf13/pflag"
)

const (
	charsLimitPerLine = 255
	common            = "common"
)

var (
	optionsMap = map[string]func(opt interface{}, changed bool) error{
		consoleFlags.CIFlag: func(opt interface{}, changed bool) error {
			return nil
		},
		consoleFlags.LogFileFlag:  LogFile,
		consoleFlags.LogLevelFlag: LogLevel,
		consoleFlags.LogPathFlag:  LogPath,
		consoleFlags.SilentFlag: func(opt interface{}, changed bool) error {
			return nil
		},
		consoleFlags.VerboseFlag: Verbose,
		consoleFlags.LogFormatFlag: func(opt interface{}, changed bool) error {
			return nil
		},
		consoleFlags.NoColorFlag: NoColor,
	}

	optionsOrderMap = map[int]string{
		1: consoleFlags.CIFlag,
		2: consoleFlags.LogFileFlag,
		3: consoleFlags.LogLevelFlag,
		4: consoleFlags.LogPathFlag,
		5: consoleFlags.SilentFlag,
		6: consoleFlags.VerboseFlag,
		7: consoleFlags.LogFormatFlag,
		8: consoleFlags.NoColorFlag,
	}

	consoleLogger = zerolog.ConsoleWriter{Out: io.Discard}
	fileLogger    = zerolog.ConsoleWriter{Out: io.Discard}

	outFileLogger    interface{}
	outConsoleLogger = io.Discard

	loggerFile  interface{}
	initialized bool
)

// Printer wil print console output with colors
// Medium is for medium sevevity results
// High is for high sevevity results
// Low is for low sevevity results
// Info is for info sevevity results
// Success is for successful prints
// Line is the color to print the line with the vulnerability
// minVersion is a bool that if true will print the results output in a minimum version
type Printer struct {
	Critical            color.RGBColor
	Medium              color.RGBColor
	High                color.RGBColor
	Low                 color.RGBColor
	Info                color.RGBColor
	Success             color.RGBColor
	Line                color.RGBColor
	VersionMessage      color.RGBColor
	ContributionMessage color.RGBColor
	minimal             bool
}

// WordWrap Wraps text at the specified number of words
func WordWrap(s, indentation string, limit int) string {
	if strings.TrimSpace(s) == "" {
		return s
	}

	wordSlice := strings.Fields(s)
	var result string

	for len(wordSlice) >= 1 {
		result = result + indentation + strings.Join(wordSlice[:limit], " ") + "\r\n"

		wordSlice = wordSlice[limit:]
		if len(wordSlice) < limit {
			limit = len(wordSlice)
		}
	}
	return result
}

// PrintResult prints on output the summary results
func PrintResult(summary *model.Summary, printer *Printer, usingCustomQueries bool) error {
	log.Debug().Msg("helpers.PrintResult()")
	fmt.Printf("\n\n")
	for index := range summary.Queries {
		idx := len(summary.Queries) - index - 1
		if summary.Queries[idx].Severity == model.SeverityTrace {
			continue
		}

		fmt.Printf(
			"%s, Severity: %s, Results: %d\n",
			printer.PrintBySev(summary.Queries[idx].QueryName, string(summary.Queries[idx].Severity)),
			printer.PrintBySev(string(summary.Queries[idx].Severity), string(summary.Queries[idx].Severity)),
			len(summary.Queries[idx].Files),
		)

		if summary.Queries[idx].Experimental {
			fmt.Println("Note: this is an experimental query")
		}

		if !printer.minimal {
			if summary.Queries[idx].CISDescriptionID != "" {
				fmt.Printf("%s %s\n", printer.Bold("Description ID:"), summary.Queries[idx].CISDescriptionIDFormatted)
				fmt.Printf("%s %s\n", printer.Bold("Title:"), summary.Queries[idx].CISDescriptionTitle)
				fmt.Printf("%s %s\n", printer.Bold("Description:"), summary.Queries[idx].CISDescriptionTextFormatted)
			} else {
				fmt.Printf("%s %s\n", printer.Bold("Description:"), summary.Queries[idx].Description)
			}
			fmt.Printf("%s %s\n", printer.Bold("Platform:"), summary.Queries[idx].Platform)

			if summary.Queries[idx].CWE != "" {
				fmt.Printf("%s %s\n", printer.Bold("CWE:"), summary.Queries[idx].CWE)
			}

			// checks if should print queries URL DOCS based on the use of custom queries and invalid ids
			if !usingCustomQueries && validQueryID(summary.Queries[idx].QueryID) {
				queryURLId := summary.Queries[idx].QueryID
				queryURLPlatform := strings.ToLower(summary.Queries[idx].Platform)

				if queryURLPlatform == common && strings.Contains(strings.ToLower(summary.Queries[idx].QueryName), "passwords and secrets") {
					queryURLId = "a88baa34-e2ad-44ea-ad6f-8cac87bc7c71"
				}

				fmt.Printf("%s %s\n\n",
					printer.Bold("Learn more about this vulnerability:"),
					fmt.Sprintf("https://docs.kics.io/latest/queries/%s-queries/%s%s",
						queryURLPlatform,
						normalizeURLCloudProvider(summary.Queries[idx].CloudProvider),
						queryURLId))
			}
		}
		printFiles(&summary.Queries[idx], printer)
	}
	fmt.Printf("\nResults Summary:\n")
	printSeverityCounter(model.SeverityCritical, summary.SeverityCounters[model.SeverityCritical], printer.Critical)
	printSeverityCounter(model.SeverityHigh, summary.SeverityCounters[model.SeverityHigh], printer.High)
	printSeverityCounter(model.SeverityMedium, summary.SeverityCounters[model.SeverityMedium], printer.Medium)
	printSeverityCounter(model.SeverityLow, summary.SeverityCounters[model.SeverityLow], printer.Low)
	printSeverityCounter(model.SeverityInfo, summary.SeverityCounters[model.SeverityInfo], printer.Info)
	fmt.Printf("TOTAL: %d\n\n", summary.TotalCounter)

	log.Info().Msgf("Scanned Files: %d", summary.ScannedFiles)
	log.Info().Msgf("Parsed Files: %d", summary.ParsedFiles)
	log.Info().Msgf("Scanned Lines: %d", summary.ScannedFilesLines)
	log.Info().Msgf("Parsed Lines: %d", summary.ParsedFilesLines)
	log.Info().Msgf("Ignored Lines: %d", summary.IgnoredFilesLines)
	log.Info().Msgf("Queries loaded: %d", summary.TotalQueries)
	log.Info().Msgf("Queries failed to execute: %d", summary.FailedToExecuteQueries)
	log.Info().Msg("Inspector stopped")

	return nil
}

func printSeverityCounter(severity string, counter int, printColor color.RGBColor) {
	fmt.Printf("%s: %d\n", printColor.Sprint(severity), counter)
}

func printFiles(query *model.QueryResult, printer *Printer) {
	for fileIdx := range query.Files {
		fmt.Printf("\t%s %s:%s\n", printer.PrintBySev(fmt.Sprintf("[%d]:", fileIdx+1), string(query.Severity)),
			query.Files[fileIdx].FileName, printer.Success.Sprint(query.Files[fileIdx].Line))
		if !printer.minimal {
			fmt.Println()
			for _, line := range *query.Files[fileIdx].VulnLines {
				if len(line.Line) > charsLimitPerLine {
					line.Line = line.Line[:charsLimitPerLine]
				}
				if line.Position == query.Files[fileIdx].Line {
					printer.Line.Printf("\t\t%03d: %s\n", line.Position, line.Line)
				} else {
					fmt.Printf("\t\t%03d: %s\n", line.Position, line.Line)
				}
			}
			fmt.Print("\n\n")
		}
	}
}

// SetupPrinter - configures stdout and log options with given FlagSet
func SetupPrinter(flags *pflag.FlagSet) error {
	err := validateFlags()
	if err != nil {
		return err
	}

	keys := make([]int, 0, len(optionsOrderMap))
	for k := range optionsOrderMap {
		keys = append(keys, k)
	}

	sort.Ints(keys)

	for _, key := range keys {
		f := flags.Lookup(optionsOrderMap[key])
		switch f.Value.Type() {
		case "string":
			value := f.Value.String()
			err = optionsMap[optionsOrderMap[key]](value, f.Changed)
			if err != nil {
				return err
			}
		case "bool":
			value, errBool := strconv.ParseBool(f.Value.String())
			if errBool != nil {
				return err
			}
			err = optionsMap[optionsOrderMap[key]](value, f.Changed)
			if err != nil {
				return err
			}
		}
	}

	// LogFormat needs to be the last option
	logFormat := strings.ToLower(consoleFlags.GetStrFlag(consoleFlags.LogFormatFlag))
	err = LogFormat(logFormat)
	if err != nil {
		return err
	}

	err = Silent(consoleFlags.GetBoolFlag(consoleFlags.SilentFlag))
	if err != nil {
		return err
	}

	err = CI(consoleFlags.GetBoolFlag(consoleFlags.CIFlag))
	if err != nil {
		return err
	}
	initialized = true
	return nil
}

// IsInitialized returns true if printer is ready, false otherwise
func IsInitialized() bool {
	return initialized
}

// NewPrinter initializes a new Printer
func NewPrinter(minimal bool) *Printer {
	return &Printer{
		Critical:            color.HEX("#ff0000"),
		Medium:              color.HEX("#ff7213"),
		High:                color.HEX("#bb2124"),
		Low:                 color.HEX("#edd57e"),
		Success:             color.HEX("#22bb33"),
		Info:                color.HEX("#5bc0de"),
		Line:                color.HEX("#f0ad4e"),
		VersionMessage:      color.HEX("#ff9913"),
		ContributionMessage: color.HEX("ffe313"),
		minimal:             minimal,
	}
}

// PrintBySev will print the output with the specific severity color given the severity of the result
func (p *Printer) PrintBySev(content, sev string) string {
	switch strings.ToUpper(sev) {
	case model.SeverityCritical:
		return p.Critical.Sprintf("%s", content)
	case model.SeverityHigh:
		return p.High.Sprintf("%s", content)
	case model.SeverityMedium:
		return p.Medium.Sprintf("%s", content)
	case model.SeverityLow:
		return p.Low.Sprintf("%s", content)
	case model.SeverityInfo:
		return p.Info.Sprintf("%s", content)
	}
	return content
}

// Bold returns the output in a bold format
func (p *Printer) Bold(content string) string {
	return color.Bold.Sprintf("%s", content)
}

func validQueryID(queryID string) bool {
	if queryID == "" {
		return false
	} else {
		return utils.ValidateUUID(queryID)
	}
}

func normalizeURLCloudProvider(cloudProvider string) string {
	cloudProvider = strings.ToLower(cloudProvider)
	if cloudProvider == common {
		cloudProvider = ""
	} else if cloudProvider != "" {
		cloudProvider += "/"
	}
	return cloudProvider
}
