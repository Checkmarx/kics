package docker

import (
	"strings"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/moby/buildkit/frontend/dockerfile/parser"
)

// ignore is a structure that contains information about the lines that are being ignored.
type ignore struct {
	from  map[string]bool
	lines []int
}

// newIgnore returns a new ignore struct.
func newIgnore() *ignore {
	return &ignore{
		from:  make(map[string]bool),
		lines: make([]int, 0),
	}
}

// setIgnore adds a new entry to the ignore struct for the 'FROM' block to be ignored
func (i *ignore) setIgnore(from string) {
	i.from[from] = true
}

// ignoreBlock adds block lines to be ignored to the ignore struct.
func (i *ignore) ignoreBlock(node *parser.Node, from string) {
	if _, ok := i.from[from]; ok {
		i.lines = append(i.lines, commentRange(node.StartLine, node.EndLine)...)
	}
}

// getIgnoreLines returns the lines that are being ignored.
func (i *ignore) getIgnoreLines() []int { // nolint
	return removeDups(i.lines)
}

// removeDups removes duplicates from a slice of ints.
func removeDups(lines []int) []int { // nolint
	seen := make(map[int]bool)
	var result []int
	for _, line := range lines {
		if !seen[line] {
			result = append(result, line)
			seen[line] = true
		}
	}
	return result
}

// getIgnoreComments returns lines to be ignored for each node of the dockerfile
func (i *ignore) getIgnoreComments(node *parser.Node) (ignore bool) {
	if len(node.PrevComment) == 0 {
		return false
	}

	for idx, comment := range node.PrevComment {
		switch processComment(comment) {
		case model.IgnoreLine:
			i.lines = append(i.lines, commentRange(node.StartLine-(idx+1), node.EndLine)...)
		case model.IgnoreBlock:
			i.lines = append(i.lines, node.StartLine-(idx+1))
			ignore = true
		default:
			i.lines = append(i.lines, node.StartLine-(idx+1))
		}
	}

	return
}

// processComment returns the type of comment given.
func processComment(comment string) (value model.CommentCommand) {
	commentLower := strings.ToLower(comment)

	if model.KICSCommentRgxp.MatchString(commentLower) {
		commentLower = model.KICSCommentRgxp.ReplaceAllString(commentLower, "")
		commands := strings.Split(strings.Trim(commentLower, "\n"), " ")
		value = processCommands(commands)
		return
	}
	return model.CommentCommand(comment)
}

// processCommands goes over kics commands in a line and returns the type of command given
func processCommands(commands []string) model.CommentCommand {
	for _, command := range commands {
		switch com := model.CommentCommand(command); com {
		case model.IgnoreLine:
			return model.IgnoreLine
		case model.IgnoreBlock:
			return model.IgnoreBlock
		default:
			continue
		}
	}

	return model.CommentCommand(commands[0])
}

// commentRange returns the range of the comment between the start and end lines.
func commentRange(start, end int) (lines []int) {
	lines = make([]int, end-start+1)
	for i := range lines {
		lines[i] = start + i
	}
	return
}
