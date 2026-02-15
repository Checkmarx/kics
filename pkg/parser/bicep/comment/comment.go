package comment

import (
	"strings"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/parser/bicep/antlr/parser"
)

type comment parser.LineInfo

type Pos struct {
	Line       int
	Column     int
	Byte       int
	BlockStart int
	BlockEnd   int
}

// linePosition returns the position of the comment in the file
func (c *comment) linePosition() Pos {
	return Pos{
		Line:       c.Range.End.Line + 1,
		Column:     c.Range.End.Column,
		Byte:       c.Range.End.Byte,
		BlockStart: c.Block.StartLine + 1,
		BlockEnd:   c.Block.EndLine,
	}
}

// commentContent returns the content of a comment as a model.CommentCommand
func (c *comment) commentContent() (value model.CommentCommand) {
	comment := strings.ToLower(string(c.Bytes.Bytes))

	// Trim leading and trailing whitespace
	comment = strings.TrimSpace(comment)

	// check if we are working with kics command
	if model.KICSCommentRgxp.MatchString(comment) {
		comment = model.KICSCommentRgxp.ReplaceAllString(comment, "")
		comment = strings.Trim(comment, "\n")
		commands := strings.Split(strings.Trim(comment, "\r"), " ")
		value = model.ProcessCommands(commands)
		return
	}
	return model.CommentCommand(comment)
}

// IgnoreMap is a map of all lines and and blocks
type IgnoreMap map[model.CommentCommand][]Pos

// Build builds the Ignore map
func (i *IgnoreMap) build(ignoreLine, ignoreBlock, ignoreComment []Pos) {
	ignoreStruct := map[model.CommentCommand][]Pos{
		model.IgnoreLine:    ignoreLine,
		model.IgnoreBlock:   ignoreBlock,
		model.IgnoreComment: ignoreComment,
	}

	*i = ignoreStruct
}

// ProcessLines goes over the lines and returns a map of lines and blocks relations
func ProcessLines(lines []parser.LineInfo) (ig IgnoreMap) {
	ignoreLines := make([]Pos, 0)
	ignoreBlocks := make([]Pos, 0)
	ignoreComments := make([]Pos, 0)
	for i := range lines {
		// line is not a comment or is the last line
		if lines[i].Type != "SINGLE_LINE_COMMENT" || i+1 >= len(lines) {
			continue
		}
		// case: CONFIGURATION = X # comment
		if i > 0 && lines[i-1].Range.Start.Line == lines[i].Range.Start.Line {
			continue
		}
		ignoreLines, ignoreBlocks, ignoreComments = processComment((*comment)(&lines[i]),
			(*comment)(&lines[i+1]), ignoreLines, ignoreBlocks, ignoreComments)
	}
	ig = make(map[model.CommentCommand][]Pos)
	ig.build(ignoreLines, ignoreBlocks, ignoreComments)
	return ig
}

// processComment analyzes the comment to determine which type of kics command the comment is
func processComment(comment *comment, tokenToIgnore *comment,
	ignoreLine, ignoreBlock, ignoreComments []Pos) (ignoreLineR, ignoreBlockR, ignoreCommentsR []Pos) {
	ignoreLineR = ignoreLine
	ignoreBlockR = ignoreBlock
	ignoreCommentsR = ignoreComments

	switch comment.commentContent() {
	case model.IgnoreLine:
		// comment is of type kics ignore-line
		ignoreLineR = append(ignoreLineR, tokenToIgnore.linePosition())
	case model.IgnoreBlock:
		// comment is of type kics ignore-block
		ignoreBlockR = append(ignoreBlockR, tokenToIgnore.linePosition())
	default:
		// comment is not of type kics ignore
		ignoreCommentsR = append(ignoreCommentsR, Pos{Line: comment.linePosition().Line - 1})
		return
	}

	return
}

// ///////////////////////////
//     LINES TO IGNORE      //
// ///////////////////////////

// getLinesFromPos will return a list of lines from a list of positions
func getLinesFromPos(positions []Pos) (lines []int) {
	lines = make([]int, 0)
	for _, position := range positions {
		lines = append(lines, position.Line)
	}
	return
}

// GetIgnoreLines returns the lines to ignore from a comment
func GetIgnoreLines(ignore IgnoreMap) (lines []int) {
	lines = make([]int, 0)
	for _, position := range ignore[model.IgnoreBlock] {
		var ignoreBlockLines []int
		for i := position.BlockStart; i <= position.BlockEnd; i++ {
			ignoreBlockLines = append(ignoreBlockLines, i)
		}
		lines = append(lines, ignoreBlockLines...)
	}
	lines = append(lines, getLinesFromPos(ignore[model.IgnoreLine])...)
	lines = append(lines, getLinesFromPos(ignore[model.IgnoreComment])...)
	return
}
