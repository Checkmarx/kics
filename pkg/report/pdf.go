package report

import (
	_ "embed" // used for embedding report static files
	"fmt"
	"path/filepath"
	"time"

	"github.com/Checkmarx/kics/v2/internal/constants"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/johnfercher/maroto/pkg/color"
	"github.com/johnfercher/maroto/pkg/consts"
	"github.com/johnfercher/maroto/pkg/pdf"
	"github.com/johnfercher/maroto/pkg/props"
	"github.com/rs/zerolog/log"
)

const (
	defaultTextSize = 8
	smallTextSize   = 6
	pgMarginLeft    = 10
	pgMarginTop     = 15
	pgMarginRight   = 10
	rowXSmall       = 3
	rowSmall        = 4
	rowMedium       = 5
	rowLarge        = 8
	rowXLarge       = 15
	colOne          = 1
	colTwo          = 2
	colThree        = 3
	colFour         = 4
	colFive         = 5
	colSix          = 6
	colEight        = 8
	colNine         = 9
	colTen          = 10
	colFullPage     = 12
	colRuneSlitter  = 20
	textSize        = 10
)

var (
	grayColor = getGrayColor()
	//go:embed assets/vuln
	vulnImageBase64 string
	//go:embed assets/checkmarx-logo
	checkmarxLogo string
)

func createQueryEntryMetadataField(m pdf.Maroto, label, value string, textSize int) {
	m.Col(colTwo, func() {
		m.Text(label, props.Text{
			Size:        float64(textSize),
			Align:       consts.Left,
			Extrapolate: false,
		})
	})
	m.Col(colTwo, func() {
		m.Text(value, props.Text{
			Size:        float64(textSize),
			Align:       consts.Left,
			Extrapolate: false,
		})
	})
}

func createQueriesTable(m pdf.Maroto, queries []model.QueryResult) error {
	for i := range queries {
		m.SetBackgroundColor(color.NewWhite())
		queryName := queries[i].QueryName
		resultsCount := fmt.Sprint(len(queries[i].Files))
		severity := string(queries[i].Severity)
		platform := queries[i].Platform
		cwe := queries[i].CWE
		category := queries[i].Category
		description := queries[i].Description
		var err error
		m.Row(rowLarge, func() {
			m.Col(colOne, func() {
				err = m.Base64Image(vulnImageBase64, consts.Png, props.Rect{
					Center:  false,
					Percent: 50,
					Left:    2,
				})
			})
			m.Col(colNine, func() {
				m.Text(queryName, props.Text{
					Size:        11,
					Style:       consts.Bold,
					Align:       consts.Left,
					Extrapolate: false,
				})
			})
			m.Col(colOne, func() {
				m.Text("Results", props.Text{
					Size:        8,
					Style:       consts.Bold,
					Align:       consts.Right,
					Extrapolate: false,
				})
			})
			m.Col(colOne, func() {
				m.Text(resultsCount, props.Text{
					Size:        8,
					Style:       consts.Bold,
					Align:       consts.Right,
					Extrapolate: false,
				})
			})
		})
		if err != nil {
			return err
		}
		m.Row(colFive, func() {
			createQueryEntryMetadataField(m, "Severity", severity, textSize)
		})
		m.Row(colThree, func() {
			createQueryEntryMetadataField(m, "Platform", platform, defaultTextSize)
		})
		m.Row(colFour, func() {
			createQueryEntryMetadataField(m, "Cwe", cwe, defaultTextSize)
		})
		m.Row(colSix, func() {
			createQueryEntryMetadataField(m, "Category", category, defaultTextSize)
		})
		if queries[i].CISDescriptionID != "" {
			createCISRows(m, &queries[i])
		} else {
			createDescription(m, description)
		}
		createResultsTable(m, &queries[i])
	}
	return nil
}

func createDescription(m pdf.Maroto, description string) {
	m.Row(colFive, func() {
		m.Col(colTwo, func() {
			m.Text("Description", props.Text{
				Size:        float64(textSize),
				Align:       consts.Left,
				Style:       consts.Bold,
				Extrapolate: false,
			})
		})
	})
	m.Row(getRowLength(description), func() {
		m.Col(colFullPage, func() {
			m.Text(description, props.Text{
				Size:        float64(defaultTextSize),
				Align:       consts.Left,
				Extrapolate: false,
			})
		})
	})
	m.Row(colFive, func() {
		m.ColSpace(0)
	})
}

func createCISRows(m pdf.Maroto, query *model.QueryResult) {
	cisID := query.CISDescriptionIDFormatted
	description := query.CISDescriptionTextFormatted
	title := query.CISDescriptionTitle

	m.Row(colFive, func() {
		m.Col(colTwo, func() {
			m.Text("Description ID", props.Text{
				Size:        float64(defaultTextSize),
				Align:       consts.Left,
				Style:       consts.Bold,
				Extrapolate: false,
			})
		})
		m.Col(colEight, func() {
			m.Text(cisID, props.Text{
				Size:        float64(defaultTextSize),
				Align:       consts.Left,
				Extrapolate: false,
			})
		})
	})
	m.Row(colFive, func() {
		m.Col(colTwo, func() {
			m.Text("Title", props.Text{
				Size:        float64(defaultTextSize),
				Align:       consts.Left,
				Style:       consts.Bold,
				Extrapolate: false,
			})
		})
		m.Col(colEight, func() {
			m.Text(title, props.Text{
				Size:        float64(defaultTextSize),
				Align:       consts.Left,
				Extrapolate: false,
			})
		})
	})
	createDescription(m, description)
}

func getRowLength(value string) float64 {
	length := float64(len(value))
	x := 2.5
	result := ((length / x) / colRuneSlitter) + 1
	return result
}

func createResultsTable(m pdf.Maroto, query *model.QueryResult) {
	for idx := range query.Files {
		if idx%2 == 0 {
			m.SetBackgroundColor(grayColor)
		} else {
			m.SetBackgroundColor(color.NewWhite())
		}

		filePath := query.Files[idx].FileName
		fileLine := fmt.Sprintf("%s:%s", filePath, fmt.Sprint(query.Files[idx].Line))
		m.Row(colFive, func() {
			m.Col(colFullPage, func() {
				m.Text(fileLine, props.Text{
					Size:        defaultTextSize,
					Align:       consts.Left,
					Extrapolate: false,
				})
			})
		})
		expectedValue := fmt.Sprintf("Expected: %s", query.Files[idx].KeyExpectedValue)
		m.Row(colFive, func() {
			m.Col(colFullPage, func() {
				m.Text(expectedValue, props.Text{
					Size:        smallTextSize,
					Align:       consts.Left,
					Extrapolate: false,
				})
			})
		})
	}
	m.SetBackgroundColor(color.NewWhite())
	m.Line(1.0)
}

func createHeaderArea(m pdf.Maroto) {
	m.Row(rowLarge, func() {
		m.Col(colSix, func() {
			_ = m.Base64Image(checkmarxLogo, consts.Png, props.Rect{})
		})
	})
	m.Row(colFive, func() {
		m.ColSpace(0)
	})
	m.SetBackgroundColor(getPurpleColor())
	m.Row(rowXLarge, func() {
		m.Col(colSix, func() {
			m.Text(" KICS REPORT", props.Text{
				Size:        25,
				Style:       consts.Bold,
				Align:       consts.Left,
				Extrapolate: false,
				Color:       color.NewWhite(),
			})
		})
		m.Col(colSix, func() {
			m.Text(fmt.Sprintf("%s ", constants.Version), props.Text{
				Size:        25,
				Style:       consts.Bold,
				Align:       consts.Right,
				Extrapolate: false,
				Color:       color.NewWhite(),
			})
		})
	})
	m.SetBackgroundColor(color.NewWhite())
	m.Row(rowXSmall, func() {
		m.ColSpace(colFullPage)
	})
}

func createFooterArea(m pdf.Maroto) {
	m.Row(rowMedium, func() {
		m.Col(colOne, func() {
			m.Text("https://kics.io")
		})
	})
}

// PrintPdfReport creates a report file on the PDF format
func PrintPdfReport(path, filename string, body interface{}) error {
	startTime := time.Now()
	log.Info().Msg("Started generating pdf report")

	summary := body.(*model.Summary)

	m := pdf.NewMaroto(consts.Portrait, consts.A4)
	m.SetPageMargins(pgMarginLeft, pgMarginTop, pgMarginRight)

	m.SetFirstPageNb(1)
	m.SetAliasNbPages("{total}")

	m.RegisterHeader(func() {
		createHeaderArea(m)
	})
	m.RegisterFooter(func() {
		createFooterArea(m)
	})

	m.SetBackgroundColor(color.NewWhite())

	createFirstPageHeader(m, summary)

	m.Line(1.0)

	err := createQueriesTable(m, summary.Queries)
	if err != nil {
		return err
	}

	err = m.OutputFileAndClose(filepath.Join(path, fmt.Sprintf("%s.pdf", filename)))
	if err != nil {
		return err
	}

	log.Info().Msgf("Generate report duration: %v", time.Since(startTime))

	fileCreationReport(filepath.Join(path, filename+".pdf"), filename)

	return err
}

func createDateField(m pdf.Maroto, label string, scanTime time.Time) {
	m.Row(colFour, func() {
		m.Col(colTwo, func() {
			m.Text(label, props.Text{
				Size:        defaultTextSize,
				Align:       consts.Left,
				Extrapolate: false,
			})
		})
		m.Col(colTwo, func() {
			m.Text(scanTime.Format("15:04:05, Jan 02 2006"), props.Text{
				Size:        defaultTextSize,
				Align:       consts.Left,
				Extrapolate: false,
			})
		})
	})
}

func createDateArea(m pdf.Maroto, summary *model.Summary) {
	createDateField(m, "START TIME", summary.Start)
	createDateField(m, "END TIME", summary.End)
}

func createPlatformsArea(m pdf.Maroto, summary *model.Summary) {
	m.Row(rowSmall, func() {
		m.Col(colTwo, func() {
			m.Text("PLATFORMS", props.Text{
				Size:        defaultTextSize,
				Align:       consts.Left,
				Extrapolate: false,
			})
		})
		m.Col(colTen, func() {
			m.Text(getPlatforms(summary.Queries), props.Text{
				Size:        defaultTextSize,
				Align:       consts.Left,
				Extrapolate: false,
			})
		})
	})
}

func createSummaryResultsField(m pdf.Maroto, label, value string, mColor color.Color) {
	m.Col(colOne, func() {
		m.Text(label, props.Text{
			Size:        defaultTextSize,
			Align:       consts.Left,
			Style:       consts.Bold,
			Extrapolate: false,
			Color:       mColor,
		})
	})
	m.Col(colOne, func() {
		m.Text(value, props.Text{
			Size:        defaultTextSize,
			Align:       consts.Left,
			Style:       consts.Bold,
			Extrapolate: false,
			Color:       mColor,
		})
	})
}

func createSummaryArea(m pdf.Maroto, summary *model.Summary) {
	criticalSeverityCount := fmt.Sprint(summary.SeverityCounters["CRITICAL"])
	highSeverityCount := fmt.Sprint(summary.SeverityCounters["HIGH"])
	mediumSeverityCount := fmt.Sprint(summary.SeverityCounters["MEDIUM"])
	lowSeverityCount := fmt.Sprint(summary.SeverityCounters["LOW"])
	infoSeverityCount := fmt.Sprint(summary.SeverityCounters["INFO"])
	totalCount := fmt.Sprint(summary.TotalCounter)

	m.Row(rowMedium, func() {
		createSummaryResultsField(m, "CRITICAL", criticalSeverityCount, getPureRedColor())
		createSummaryResultsField(m, "HIGH", highSeverityCount, getRedColor())
		createSummaryResultsField(m, "MEDIUM", mediumSeverityCount, getOrangeColor())
		createSummaryResultsField(m, "LOW", lowSeverityCount, getYellowColor())
		createSummaryResultsField(m, "INFO", infoSeverityCount, getBlueColor())

		m.ColSpace(colOne)

		m.Col(colOne, func() {
			m.Text("TOTAL", props.Text{
				Size:        defaultTextSize,
				Right:       10.0,
				Align:       consts.Right,
				Style:       consts.Bold,
				Extrapolate: false,
			})
		})
		m.Col(colOne, func() {
			m.Text(totalCount, props.Text{
				Size:        defaultTextSize,
				Align:       consts.Left,
				Style:       consts.Bold,
				Extrapolate: false,
			})
		})
	})
}

func createFirstPageHeader(m pdf.Maroto, summary *model.Summary) {
	createSummaryArea(m, summary)
	createPlatformsArea(m, summary)
	createDateArea(m, summary)
	m.Row(rowSmall, func() {
		m.Col(colTwo, func() {
			m.Text("SCANNED PATHS:", props.Text{
				Size:        defaultTextSize,
				Align:       consts.Left,
				Extrapolate: false,
			})
		})
	})
	for i := range summary.ScannedPaths {
		scannedPaths := summary.ScannedPaths[i]
		m.Row(rowSmall, func() {
			m.Col(colFullPage, func() {
				m.Text(fmt.Sprintf("- %s", scannedPaths), props.Text{
					Size:        defaultTextSize,
					Align:       consts.Left,
					Extrapolate: true,
				})
			})
		})
	}
	m.Row(rowXSmall, func() {
		m.ColSpace(colFullPage)
	})
}

func getGrayColor() color.Color {
	return color.Color{
		Red:   200,
		Green: 200,
		Blue:  200,
	}
}

func getPureRedColor() color.Color {
	return color.Color{
		Red:   250,
		Green: 0,
		Blue:  0,
	}
}

func getRedColor() color.Color {
	return color.Color{
		Red:   200,
		Green: 0,
		Blue:  0,
	}
}

func getYellowColor() color.Color {
	return color.Color{
		Red:   206,
		Green: 182,
		Blue:  26,
	}
}

func getOrangeColor() color.Color {
	return color.Color{
		Red:   255,
		Green: 165,
		Blue:  0,
	}
}

func getBlueColor() color.Color {
	return color.Color{
		Red:   0,
		Green: 0,
		Blue:  200,
	}
}

func getPurpleColor() color.Color {
	return color.Color{
		Red:   80,
		Green: 62,
		Blue:  158,
	}
}
