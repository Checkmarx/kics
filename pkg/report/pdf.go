package report

import (
	"fmt"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/johnfercher/maroto/pkg/color"
	"github.com/johnfercher/maroto/pkg/consts"
	"github.com/johnfercher/maroto/pkg/pdf"
	"github.com/johnfercher/maroto/pkg/props"
)

func getHeader() []string {
	return []string{"QueryName", "Severity", "Platform", "Category"}
}

func extractContent(queries []model.VulnerableQuery) [][]string {
	var contents [][]string
	contents = make([][]string, 0)
	for _, entry := range queries {
		contents = append(contents, []string{entry.QueryName, string(entry.Severity), entry.Platform, entry.Category})
	}
	return contents
}

func PrintPdfReport(path, filename string, body interface{}) error {
	grayColor := getGrayColor()
	whiteColor := color.NewWhite()
	header := getHeader()
	summary := body.(*model.Summary)
	contents := extractContent(summary.Queries)

	m := pdf.NewMaroto(consts.Portrait, consts.A4)
	m.SetPageMargins(10, 15, 10)

	m.SetAliasNbPages("{nb}")
	m.SetFirstPageNb(1)

	m.RegisterHeader(func() {
		m.Row(20, func() {
			m.Col(2, func() {
				m.Text("HIGH", props.Text{
					Size:        8,
					Align:       consts.Left,
					Extrapolate: false,
				})
			})
			m.Col(2, func() {
				m.Text("MEDIUM", props.Text{
					Size:        8,
					Align:       consts.Left,
					Extrapolate: false,
				})
			})
			m.Col(2, func() {
				m.Text("LOW", props.Text{
					Size:        8,
					Align:       consts.Left,
					Extrapolate: false,
				})
			})
			m.Col(2, func() {
				m.Text("INFO", props.Text{
					Size:        8,
					Align:       consts.Left,
					Extrapolate: false,
				})
			})
			m.Col(2, func() {
				m.Text("TOTAL", props.Text{
					Size:        8,
					Align:       consts.Left,
					Extrapolate: false,
				})
			})
			m.ColSpace(2)
		})
	})

	m.SetBackgroundColor(whiteColor)

	m.TableList(
		header,
		contents,
		props.TableList{
			HeaderProp: props.TableListContent{
				Size:      9,
				GridSizes: []uint{4, 2, 2, 3},
			},
			ContentProp: props.TableListContent{
				Size:      8,
				GridSizes: []uint{4, 2, 2, 3},
			},
			Align:                consts.Center,
			AlternatedBackground: &grayColor,
			HeaderContentSpace:   1,
			Line:                 false,
		},
	)

	err := m.OutputFileAndClose(fmt.Sprintf("%s.pdf", filename))
	return err
}

func getDarkGrayColor() color.Color {
	return color.Color{
		Red:   55,
		Green: 55,
		Blue:  55,
	}
}

func getGrayColor() color.Color {
	return color.Color{
		Red:   200,
		Green: 200,
		Blue:  200,
	}
}
