package buildah

import (
	"strings"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"mvdan.cc/sh/v3/syntax"
)

func getKicsIgnore(comment string) string {
	commentLower := model.KICSCommentRgxp.ReplaceAllString(strings.ToLower(comment), "")
	commentLower = strings.Trim(commentLower, "\r")
	commentLower = strings.Trim(commentLower, "\n")

	return commentLower
}

func (i *Info) getIgnoreLines(comment *syntax.Comment) {
	// get normal comments
	i.IgnoreLines = append(i.IgnoreLines, int(comment.Hash.Line())) //nolint:gosec

	if model.KICSCommentRgxp.MatchString(comment.Text) {
		kicsIgnore := getKicsIgnore(comment.Text)

		switch model.CommentCommand(kicsIgnore) {
		case model.IgnoreLine:
			// get kics-scan ignore-line
			i.IgnoreLines = append(i.IgnoreLines, int(comment.Hash.Line())+1) //nolint:gosec
		case model.IgnoreBlock:
			// get kics-scan ignore-block for ignoreFromBlock
			i.IgnoreBlockLines = append(i.IgnoreBlockLines, int(comment.Pos().Line())) //nolint:gosec
		}
	}
}

func (i *Info) getIgnoreBlockLines(comments []syntax.Comment, start, end int) {
	for c := range comments {
		comment := comments[c]

		// get kics-scan ignore-block related to command
		if model.KICSCommentRgxp.MatchString(comment.Text) {
			kicsIgnore := getKicsIgnore(comment.Text)

			if model.CommentCommand(kicsIgnore) == model.IgnoreBlock {
				if int(comment.Hash.Line()) == start-1 { //nolint:gosec
					i.IgnoreLines = append(i.IgnoreLines, model.Range(start, end)...)
					i.IgnoreBlockLines = append(i.IgnoreBlockLines, model.Range(start, end)...)
				}
			}
		}
	}
}

func (i *Info) ignoreFromBlock() {
	for j := range i.IgnoreBlockLines {
		for z := range i.FromValues {
			i.getIgnoreLinesFromBlock(i.IgnoreBlockLines[j], i.FromValues[z])
		}
	}
}

func (i *Info) getIgnoreLinesFromBlock(ignoreBlockLine int, fromValue FromValue) {
	start := fromValue.Line
	value := fromValue.Value
	if start == ignoreBlockLine+1 {
		targetFrom := i.From[value]
		end := targetFrom[len(targetFrom)-1].EndLine
		i.IgnoreLines = append(i.IgnoreLines, model.Range(start, end)...)
	}
}
