package report

import (
	_ "embed" // used for embedding report static files
	"fmt"
	"os"
	"path/filepath"
	"time"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/johnfercher/maroto/pkg/color"
	"github.com/johnfercher/maroto/pkg/consts"
	"github.com/johnfercher/maroto/pkg/pdf"
	"github.com/johnfercher/maroto/pkg/props"
	"github.com/rs/zerolog/log"
)

const (
	defaultTextSize = 8
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
	colNine         = 9
	colTen          = 10
	colFullPage     = 12
)

var (
	grayColor = getGrayColor()
	//go:embed assets/vuln
	vulnImageBase64 string
)

func createQueriesTable(m pdf.Maroto, queries []model.VulnerableQuery, basePath string) error {
	for i := range queries {
		m.SetBackgroundColor(color.NewWhite())
		queryName := queries[i].QueryName
		resultsCount := fmt.Sprint(len(queries[i].Files))
		severity := string(queries[i].Severity)
		platform := queries[i].Platform
		category := queries[i].Category

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
		m.Row(colFour, func() {
			m.Col(colTwo, func() {
				m.Text("Severity", props.Text{
					Size:        10,
					Align:       consts.Left,
					Extrapolate: false,
				})
			})
			m.Col(colTwo, func() {
				m.Text(severity, props.Text{
					Size:        10,
					Align:       consts.Left,
					Extrapolate: false,
				})
			})
		})
		m.Row(colThree, func() {
			m.Col(colTwo, func() {
				m.Text("Platform", props.Text{
					Size:        defaultTextSize,
					Align:       consts.Left,
					Extrapolate: false,
				})
			})
			m.Col(colTwo, func() {
				m.Text(platform, props.Text{
					Size:        defaultTextSize,
					Align:       consts.Left,
					Extrapolate: false,
				})
			})
		})
		m.Row(colFive, func() {
			m.Col(colTwo, func() {
				m.Text("Category", props.Text{
					Size:        defaultTextSize,
					Align:       consts.Left,
					Extrapolate: false,
				})
			})
			m.Col(colTwo, func() {
				m.Text(category, props.Text{
					Size:        defaultTextSize,
					Align:       consts.Left,
					Extrapolate: false,
				})
			})
		})
		err = createResultsTable(m, &queries[i], basePath)
		if err != nil {
			return err
		}
	}
	return nil
}

func createResultsTable(m pdf.Maroto, query *model.VulnerableQuery, basePath string) error {
	for idx := range query.Files {
		if idx%2 == 0 {
			m.SetBackgroundColor(grayColor)
		} else {
			m.SetBackgroundColor(color.NewWhite())
		}
		relativePath, err := filepath.Rel(basePath, query.Files[idx].FileName)
		if err != nil {
			return err
		}
		fileLine := fmt.Sprintf("%s:%s", relativePath, fmt.Sprint(query.Files[idx].Line))
		m.Row(colFive, func() {
			m.Col(colFullPage, func() {
				m.Text(fileLine, props.Text{
					Size:        defaultTextSize,
					Align:       consts.Left,
					Extrapolate: false,
				})
			})
		})
	}
	m.Line(1.0)
	return nil
}

func createHeaderArea(m pdf.Maroto) {
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
		m.ColSpace(colSix)
	})
	m.SetBackgroundColor(color.NewWhite())
	m.Row(rowXSmall, func() {
		m.ColSpace(colFullPage)
	})
}

func createFooterArea(m pdf.Maroto) {
	m.Row(rowMedium, func() {
		m.Col(colOne, func() {
			m.Text("http://kics.io")
		})
	})
}

// PrintPdfReport creates a report file on the PDF format
func PrintPdfReport(path, filename string, body interface{}) error {
	startTime := time.Now()
	log.Info().Msg("Started generating pdf report")

	summary := body.(*model.Summary)
	basePath, err := os.Getwd()
	if err != nil {
		return err
	}

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

	err = createQueriesTable(m, summary.Queries, basePath)
	if err != nil {
		return err
	}

	err = m.OutputFileAndClose(fmt.Sprintf("%s.pdf", filename))
	if err != nil {
		return err
	}

	log.Info().Msgf("Generate report duration: %v", time.Since(startTime))

	return err
}

func createDateArea(m pdf.Maroto, summary *model.Summary) {
	m.Row(colFour, func() {
		m.Col(colTwo, func() {
			m.Text("START TIME", props.Text{
				Size:        defaultTextSize,
				Align:       consts.Left,
				Extrapolate: false,
			})
		})
		m.Col(colTwo, func() {
			m.Text(summary.Start.Format("15:04:05, Jan 02 2006"), props.Text{
				Size:        defaultTextSize,
				Align:       consts.Left,
				Extrapolate: false,
			})
		})
	})
	m.Row(colSix, func() {
		m.Col(colTwo, func() {
			m.Text("END TIME", props.Text{
				Size:        defaultTextSize,
				Align:       consts.Left,
				Extrapolate: false,
			})
		})
		m.Col(colTwo, func() {
			m.Text(summary.End.Format("15:04:05, Jan 02 2006"), props.Text{
				Size:        defaultTextSize,
				Align:       consts.Left,
				Extrapolate: false,
			})
		})
	})
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

func createSummaryArea(m pdf.Maroto, summary *model.Summary) {
	highSeverityCount := fmt.Sprint(summary.SeverityCounters["HIGH"])
	mediumSeverityCount := fmt.Sprint(summary.SeverityCounters["MEDIUM"])
	lowSeverityCount := fmt.Sprint(summary.SeverityCounters["LOW"])
	infoSeverityCount := fmt.Sprint(summary.SeverityCounters["INFO"])
	totalCount := fmt.Sprint(summary.TotalCounter)

	m.Row(rowMedium, func() {
		m.Col(colOne, func() {
			m.Text("HIGH", props.Text{
				Size:        defaultTextSize,
				Align:       consts.Left,
				Style:       consts.Bold,
				Extrapolate: false,
				Color:       getRedColor(),
			})
		})
		m.Col(colOne, func() {
			m.Text(highSeverityCount, props.Text{
				Size:        defaultTextSize,
				Align:       consts.Left,
				Style:       consts.Bold,
				Extrapolate: false,
				Color:       getRedColor(),
			})
		})
		m.Col(colOne, func() {
			m.Text("MEDIUM", props.Text{
				Size:        defaultTextSize,
				Align:       consts.Left,
				Style:       consts.Bold,
				Extrapolate: false,
				Color:       getOrangeColor(),
			})
		})
		m.Col(colOne, func() {
			m.Text(mediumSeverityCount, props.Text{
				Size:        defaultTextSize,
				Align:       consts.Left,
				Style:       consts.Bold,
				Extrapolate: false,
				Color:       getOrangeColor(),
			})
		})
		m.Col(colOne, func() {
			m.Text("LOW", props.Text{
				Size:        defaultTextSize,
				Align:       consts.Left,
				Style:       consts.Bold,
				Extrapolate: false,
				Color:       getYellowColor(),
			})
		})
		m.Col(colOne, func() {
			m.Text(lowSeverityCount, props.Text{
				Size:        defaultTextSize,
				Align:       consts.Left,
				Style:       consts.Bold,
				Extrapolate: false,
				Color:       getYellowColor(),
			})
		})
		m.Col(colOne, func() {
			m.Text("INFO", props.Text{
				Size:        defaultTextSize,
				Align:       consts.Left,
				Style:       consts.Bold,
				Extrapolate: false,
				Color:       getBlueColor(),
			})
		})
		m.Col(colOne, func() {
			m.Text(infoSeverityCount, props.Text{
				Size:        defaultTextSize,
				Align:       consts.Left,
				Style:       consts.Bold,
				Extrapolate: false,
				Color:       getBlueColor(),
			})
		})
		m.ColSpace(colTwo)
		m.Col(colOne, func() {
			m.Text("TOTAL", props.Text{
				Size:        defaultTextSize,
				Align:       consts.Right,
				Style:       consts.Bold,
				Extrapolate: false,
			})
		})
		m.Col(colOne, func() {
			m.Text(totalCount, props.Text{
				Size:        defaultTextSize,
				Align:       consts.Right,
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
