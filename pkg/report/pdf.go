package report

import (
	"fmt"
	"path/filepath"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/johnfercher/maroto/pkg/color"
	"github.com/johnfercher/maroto/pkg/consts"
	"github.com/johnfercher/maroto/pkg/pdf"
	"github.com/johnfercher/maroto/pkg/props"
)

const (
	rowHeight     = 20
	colWidthOne   = 1
	colWidthTwo   = 2
	textSize      = 8
	pgMarginLeft  = 10
	pgMarginTop   = 15
	pgMarginRight = 10
)

var (
	grayColor = getGrayColor()
)

func createFullReportTable(m pdf.Maroto, queries []model.VulnerableQuery) {
	m.Row(rowHeight, func() {
		m.Col(colWidthOne, func() {
			m.Text("QueryName", props.Text{
				Size:        textSize,
				Align:       consts.Left,
				Extrapolate: false,
			})
		})
		m.Col(colWidthOne, func() {
			m.Text("Severity", props.Text{
				Size:        textSize,
				Align:       consts.Left,
				Extrapolate: false,
			})
		})
		m.Col(colWidthOne, func() {
			m.Text("Platform", props.Text{
				Size:        textSize,
				Align:       consts.Left,
				Extrapolate: false,
			})
		})
		m.Col(colWidthOne, func() {
			m.Text("Category", props.Text{
				Size:        textSize,
				Align:       consts.Left,
				Extrapolate: false,
			})
		})
	})
	createQueriesTable(m, queries)
}

func createQueriesTable(m pdf.Maroto, queries []model.VulnerableQuery) {
	contents := make([][]string, 0)
	for idx := range queries {
		contents = createResultsTable(contents, &queries[idx])
		m.TableList(
			[]string{queries[idx].QueryName, string(queries[idx].Severity), queries[idx].Platform, queries[idx].Category},
			contents,
			props.TableList{
				HeaderProp: props.TableListContent{
					Size:      10,
					GridSizes: []uint{4, 2, 2, 3},
				},
				ContentProp: props.TableListContent{
					Size:      textSize,
					GridSizes: []uint{3, 1, 5, 2},
				},
				Align:                consts.Center,
				AlternatedBackground: &grayColor,
				HeaderContentSpace:   1,
				Line:                 false,
			},
		)
		m.Line(1.0)
	}
}

func createResultsTable(contents [][]string, query *model.VulnerableQuery) [][]string {
	for idx := range query.Files {
		fileLine := fmt.Sprintf("%s:%s", filepath.Base(query.Files[idx].FileName), fmt.Sprint(query.Files[idx].Line))
		contents = append(contents, []string{fileLine, "", query.Files[idx].SimilarityID, ""})
	}

	return contents
}

// PrintPdfReport creates a report file on the PDF format
func PrintPdfReport(path, filename string, body interface{}) error {
	whiteColor := color.NewWhite()
	summary := body.(*model.Summary)

	highSeverityCount := fmt.Sprint(summary.SeverityCounters["HIGH"])
	mediumSeverityCount := fmt.Sprint(summary.SeverityCounters["MEDIUM"])
	lowSeverityCount := fmt.Sprint(summary.SeverityCounters["LOW"])
	infoSeverityCount := fmt.Sprint(summary.SeverityCounters["INFO"])
	totalCount := fmt.Sprint(summary.TotalCounter)

	m := pdf.NewMaroto(consts.Portrait, consts.A4)
	m.SetPageMargins(pgMarginLeft, pgMarginTop, pgMarginRight)

	m.SetAliasNbPages("{nb}")
	m.SetFirstPageNb(1)

	m.RegisterHeader(func() {
		m.Row(rowHeight, func() {
			m.Col(colWidthOne, func() {
				m.Text("HIGH", props.Text{
					Size:        textSize,
					Align:       consts.Left,
					Extrapolate: false,
				})
			})
			m.Col(colWidthOne, func() {
				m.Text(highSeverityCount, props.Text{
					Size:        textSize,
					Align:       consts.Left,
					Extrapolate: false,
				})
			})
			m.Col(colWidthOne, func() {
				m.Text("MEDIUM", props.Text{
					Size:        textSize,
					Align:       consts.Left,
					Extrapolate: false,
				})
			})
			m.Col(colWidthOne, func() {
				m.Text(mediumSeverityCount, props.Text{
					Size:        textSize,
					Align:       consts.Left,
					Extrapolate: false,
				})
			})
			m.Col(colWidthOne, func() {
				m.Text("LOW", props.Text{
					Size:        textSize,
					Align:       consts.Left,
					Extrapolate: false,
				})
			})
			m.Col(colWidthOne, func() {
				m.Text(lowSeverityCount, props.Text{
					Size:        textSize,
					Align:       consts.Left,
					Extrapolate: false,
				})
			})
			m.Col(colWidthOne, func() {
				m.Text("INFO", props.Text{
					Size:        textSize,
					Align:       consts.Left,
					Extrapolate: false,
				})
			})
			m.Col(colWidthOne, func() {
				m.Text(infoSeverityCount, props.Text{
					Size:        textSize,
					Align:       consts.Left,
					Extrapolate: false,
				})
			})
			m.Col(colWidthTwo, func() {
				m.Text("TOTAL", props.Text{
					Size:        textSize,
					Align:       consts.Left,
					Extrapolate: false,
				})
			})
			m.Col(colWidthTwo, func() {
				m.Text(totalCount, props.Text{
					Size:        textSize,
					Align:       consts.Right,
					Extrapolate: false,
				})
			})
		})
	})

	m.Line(1.0)

	m.SetBackgroundColor(whiteColor)

	createFullReportTable(m, summary.Queries)

	err := m.OutputFileAndClose(fmt.Sprintf("%s.pdf", filename))
	return err
}

func getGrayColor() color.Color {
	return color.Color{
		Red:   200,
		Green: 200,
		Blue:  200,
	}
}
