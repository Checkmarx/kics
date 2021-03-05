package helpers

import (
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"io/ioutil"
	"math"
	"os"
	"path/filepath"
	"strings"
	"sync"

	"github.com/BurntSushi/toml"
	"github.com/Checkmarx/kics/pkg/model"
	"github.com/gookit/color"
	"github.com/hashicorp/hcl"
	"github.com/rs/zerolog"
	"github.com/rs/zerolog/log"
	"gopkg.in/yaml.v3"
)

// ProgressBar represents a Progress
// Writer is the writer output for progress bar
type ProgressBar struct {
	Writer   io.Writer
	label    string
	space    int
	total    float64
	progress chan float64
}

// Printer wil print console output with colors
// Medium is for medium sevevity results
// High is for high sevevity results
// Low is for low sevevity results
// Info is for info sevevity results
// Success is for successful prints
// Line is the color to print the line with the vulnerability
// minVersion is a bool that if true will print the results output in a minimum version
type Printer struct {
	Medium  color.RGBColor
	High    color.RGBColor
	Low     color.RGBColor
	Info    color.RGBColor
	Success color.RGBColor
	Line    color.RGBColor
	minimal bool
}

// NewProgressBar initializes a new ProgressBar
// label is a string print before the progress bar
// total is the progress bar target (a.k.a 100%)
// space is the number of '=' characters on each side of the bar
// progress is a channel updating the current executed elements
func NewProgressBar(label string, space int, total float64, progress chan float64) ProgressBar {
	return ProgressBar{
		Writer:   os.Stdout,
		label:    label,
		space:    space,
		total:    total,
		progress: progress,
	}
}

// Start starts to print a progress bar on console
// wg is a wait group to report when progress is done
func (p *ProgressBar) Start(wg *sync.WaitGroup) {
	defer wg.Done()
	// TODO ioutil will be deprecated on go v1.16, so ioutil.Discard should be changed to io.Discard
	if p.Writer != ioutil.Discard {
		var firstHalfPercentage, secondHalfPercentage string
		const hundredPercent = 100
		formmatingString := "\r" + p.label + "[%s %4.1f%% %s]"
		for {
			currentProgress, ok := <-p.progress
			if !ok || currentProgress >= p.total {
				fmt.Fprintf(p.Writer, formmatingString, strings.Repeat("=", p.space), 100.0, strings.Repeat("=", p.space))
				break
			}

			percentage := currentProgress / p.total * hundredPercent
			convertedPercentage := int(math.Round(float64(p.space+p.space) / hundredPercent * math.Round(percentage)))
			if percentage >= hundredPercent/2 {
				firstHalfPercentage = strings.Repeat("=", p.space)
				secondHalfPercentage = strings.Repeat("=", convertedPercentage-p.space) +
					strings.Repeat(" ", 2*p.space-convertedPercentage)
			} else {
				secondHalfPercentage = strings.Repeat(" ", p.space)
				firstHalfPercentage = strings.Repeat("=", convertedPercentage) +
					strings.Repeat(" ", p.space-convertedPercentage)
			}
			fmt.Fprintf(p.Writer, formmatingString, firstHalfPercentage, percentage, secondHalfPercentage)
		}
	}
	fmt.Println()
}

// WordWrap Wraps text at the specified number of words
func WordWrap(s, identation string, limit int) string {
	if strings.TrimSpace(s) == "" {
		return s
	}

	wordSlice := strings.Fields(s)
	var result string

	for len(wordSlice) >= 1 {
		result = result + identation + strings.Join(wordSlice[:limit], " ") + "\r\n"

		wordSlice = wordSlice[limit:]
		if len(wordSlice) < limit {
			limit = len(wordSlice)
		}
	}
	return result
}

// PrintResult prints on output the summary results
func PrintResult(summary *model.Summary, failedQueries map[string]error, printer *Printer) error {
	fmt.Printf("Files scanned: %d\n", summary.ScannedFiles)
	fmt.Printf("Parsed files: %d\n", summary.ParsedFiles)
	fmt.Printf("Queries loaded: %d\n", summary.TotalQueries)

	fmt.Printf("Queries failed to execute: %d\n\n", summary.FailedToExecuteQueries)
	for queryName, err := range failedQueries {
		fmt.Printf("\t- %s:\n", queryName)
		fmt.Printf("%s", WordWrap(err.Error(), "\t\t", 5))
	}
	fmt.Printf("------------------------------------\n\n")
	for _, q := range summary.Queries.SortBySev() {
		fmt.Printf("%s, Severity: %s, Results: %d\n", printer.PrintBySev(q.QueryName,
			string(q.Severity)), printer.PrintBySev(string(q.Severity), string(q.Severity)), len(q.Files))
		if !printer.minimal {
			fmt.Printf("Description: %s\n", q.Description)
			fmt.Printf("Platform: %s\n\n", q.Platform)
		}
		for i := 0; i < len(q.Files); i++ {
			fmt.Printf("\t%s %s:%s\n", printer.PrintBySev(fmt.Sprintf("[%d]:", i+1), string(q.Severity)),
				q.Files[i].FileName, printer.Success.Sprint(q.Files[i].Line))
			if !printer.minimal {
				fmt.Println()
				for idx, line := range q.Files[i].VulnLines.Lines {
					if q.Files[i].VulnLines.Positions[idx] == q.Files[i].Line {
						printer.Line.Printf("\t\t%03d: %s\n", q.Files[i].VulnLines.Positions[idx], line)
					} else {
						fmt.Printf("\t\t%03d: %s\n", q.Files[i].VulnLines.Positions[idx], line)
					}
				}
				fmt.Print("\n\n")
			}
		}
	}
	fmt.Printf("\nResults Summary:\n")
	fmt.Printf("%s: %d\n", printer.High.Sprint(model.SeverityHigh), summary.SeveritySummary.SeverityCounters[model.SeverityHigh])
	fmt.Printf("%s: %d\n", printer.Medium.Sprint(model.SeverityMedium), summary.SeveritySummary.SeverityCounters[model.SeverityMedium])
	fmt.Printf("%s: %d\n", printer.Low.Sprint(model.SeverityLow), summary.SeveritySummary.SeverityCounters[model.SeverityLow])
	fmt.Printf("%s: %d\n", printer.Info.Sprint(model.SeverityInfo), summary.SeveritySummary.SeverityCounters[model.SeverityInfo])
	fmt.Printf("TOTAL: %d\n\n", summary.SeveritySummary.TotalCounter)
	log.
		Info().
		Msgf("\n\nFiles scanned: %d\n"+
			"Parsed files: %d\nQueries loaded: %d\n"+
			"Queries failed to execute: %d\n",
			summary.ScannedFiles, summary.ParsedFiles, summary.TotalQueries, summary.FailedToExecuteQueries)
	log.
		Info().
		Msg("Inspector stopped\n")

	return nil
}

// PrintToJSONFile prints on JSON file the summary results
func PrintToJSONFile(path string, body interface{}) error {
	f, err := os.OpenFile(filepath.Clean(path), os.O_WRONLY|os.O_CREATE|os.O_TRUNC, os.ModePerm)
	if err != nil {
		return err
	}
	defer func() {
		if err := f.Close(); err != nil {
			log.Err(err).Msgf("failed to close file %s", path)
		}

		curDir, err := os.Getwd()
		if err != nil {
			log.Err(err).Msgf("failed to get current directory")
		}

		log.Info().Str("fileName", path).Msgf("Results saved to file %s", filepath.Join(curDir, path))
	}()

	encoder := json.NewEncoder(f)
	encoder.SetIndent("", "\t")

	return encoder.Encode(body)
}

// CustomConsoleWriter creates an output to print log in a files
func CustomConsoleWriter(fileLogger *zerolog.ConsoleWriter) zerolog.ConsoleWriter {
	fileLogger.FormatLevel = func(i interface{}) string {
		return strings.ToUpper(fmt.Sprintf("| %-6s|", i))
	}

	fileLogger.FormatFieldName = func(i interface{}) string {
		return fmt.Sprintf("%s:", i)
	}

	fileLogger.FormatErrFieldName = func(i interface{}) string {
		return "ERROR:"
	}

	fileLogger.FormatFieldValue = func(i interface{}) string {
		return fmt.Sprintf("%s", i)
	}

	return *fileLogger
}

// FileAnalyzer determines the type of extension in the passed config file by its content
func FileAnalyzer(path string) (string, error) {
	ostat, err := os.Open(path)
	if err != nil {
		return "", err
	}
	rc, err := ioutil.ReadAll(ostat)
	if err != nil {
		return "", err
	}
	var temp map[string]interface{}

	if err := json.Unmarshal(rc, &temp); err == nil {
		return "json", nil
	}

	if err := yaml.Unmarshal(rc, &temp); err == nil {
		return "yaml", nil
	}

	if _, err := toml.Decode(string(rc), &temp); err == nil {
		return "toml", nil
	}

	if c, err := hcl.Parse(string(rc)); err == nil {
		if err = hcl.DecodeObject(&temp, c); err == nil {
			return "hcl", nil
		}
	}

	return "", errors.New("invalid configuration file format")
}

// NewPrinter initializes a new Printer
func NewPrinter(minimal bool) *Printer {
	return &Printer{
		Medium:  color.HEX("#ff7213"),
		High:    color.HEX("#bb2124"),
		Low:     color.HEX("#edd57e"),
		Success: color.HEX("#22bb33"),
		Info:    color.HEX("#5bc0de"),
		Line:    color.HEX("#f0ad4e"),
		minimal: minimal,
	}
}

// PrintBySev will print the output with the specific severity color given the severity of the result
func (p *Printer) PrintBySev(content, sev string) string {
	switch strings.ToUpper(sev) {
	case model.SeverityHigh:
		return p.High.Sprintf(content)
	case model.SeverityMedium:
		return p.Medium.Sprintf(content)
	case model.SeverityLow:
		return p.Low.Sprintf(content)
	case model.SeverityInfo:
		return p.Info.Sprintf(content)
	}
	return content
}
