package docker

import (
	"strings"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/moby/buildkit/frontend/dockerfile/parser"
)

// ignore is a structure that contains information about the lines that are being ignored.
type ignore struct {
	from       map[string]bool
	lines      []int
	queryLines model.QueryIgnoreLines
}

// newIgnore returns a new ignore struct.
func newIgnore() *ignore {
	return &ignore{
		from:       make(map[string]bool),
		lines:      make([]int, 0),
		queryLines: make(model.QueryIgnoreLines),
	}
}

// setIgnore adds a new entry to the ignore struct for the 'FROM' block to be ignored
func (i *ignore) setIgnore(from string) {
	i.from[from] = true
}

// ignoreBlock adds block lines to be ignored to the ignore struct.
func (i *ignore) ignoreBlock(node *parser.Node, from string) {
	if _, ok := i.from[from]; ok {
		i.lines = append(i.lines, model.Range(node.StartLine, node.EndLine)...)
	}
}

// getIgnoreLines returns the lines that are being ignored.
func (i *ignore) getIgnoreLines() []int {
	return model.RemoveDuplicates(i.lines)
}

// getIgnoreComments returns lines to be ignored for each node of the dockerfile
func (i *ignore) getIgnoreComments(node *parser.Node) (ignore bool) {
	if len(node.PrevComment) == 0 {
		return false
	}

	for idx, comment := range node.PrevComment {
		cmd, queryID := processComment(comment)
		switch cmd {
		case model.IgnoreLine:
			i.lines = append(i.lines, model.Range(node.StartLine-(idx+1), node.EndLine)...)
		case model.IgnoreBlock:
			i.lines = append(i.lines, node.StartLine-(idx+1))
			ignore = true
		case model.IgnoreLineQuery:
			if queryID != "" {
				lines := model.Range(node.StartLine-(idx+1), node.EndLine)
				i.queryLines[queryID] = append(i.queryLines[queryID], lines...)
			}
			i.lines = append(i.lines, node.StartLine-(idx+1))
		case model.IgnoreBlockQuery:
			if queryID != "" {
				i.queryLines[queryID] = append(i.queryLines[queryID], node.StartLine-(idx+1))
			}
			i.lines = append(i.lines, node.StartLine-(idx+1))
		default:
			i.lines = append(i.lines, node.StartLine-(idx+1))
		}
	}

	return
}

// getQueryIgnoreLines returns the per-query suppressed lines.
func (i *ignore) getQueryIgnoreLines() model.QueryIgnoreLines {
	result := make(model.QueryIgnoreLines, len(i.queryLines))
	for k, v := range i.queryLines {
		result[k] = model.RemoveDuplicates(v)
	}
	return result
}

// processComment returns the type of comment given and, for query-specific commands, the query UUID.
func processComment(comment string) (value model.CommentCommand, queryID string) {
	commentLower := strings.ToLower(comment)

	if model.KICSCommentRgxp.MatchString(commentLower) {
		commentLower = model.KICSCommentRgxp.ReplaceAllString(commentLower, "")
		commands := strings.Split(strings.Trim(commentLower, "\n"), " ")
		value, queryID = model.ProcessCommands(commands)
		return
	}
	return model.CommentCommand(comment), ""
}
