package comment

import (
	"bufio"
	"strings"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/parser/bicep/antlr/parser"
	"github.com/antlr4-go/antlr/v4"
)

// LineInfo represents information about a line in the source code
type LineInfo struct {
	Type     string
	IsInline bool // true if comment has code before it on the same line
	Bytes    struct {
		Bytes  []byte
		String string
	}
	Range struct {
		Start struct {
			Line   int
			Column int
			Byte   int
		}
		End struct {
			Line   int
			Column int
			Byte   int
		}
	}
	Block struct {
		BlockType string
		StartLine int
		EndLine   int
	}
}

type comment LineInfo

type Pos struct {
	Line       int
	Column     int
	Byte       int
	BlockStart int
	BlockEnd   int
}

// BlockInfo represents information about a code block
type BlockInfo struct {
	BlockType string
	StartLine int
	EndLine   int
}

// GetLinesInfo analyzes the input text and returns line information including blocks and tokens
func GetLinesInfo(input string) []LineInfo {
	var linesInfo []LineInfo
	scanner := bufio.NewScanner(strings.NewReader(input))
	lineNumber, byteOffset := 0, 0
	var currentBlock BlockInfo
	var blockStack []BlockInfo

	for scanner.Scan() {
		line := scanner.Text()
		trimmedLine := strings.TrimSpace(line)
		lineBytes := []byte(line)
		lineLength := len(lineBytes)

		lineBlock := BlockInfo{}
		if len(blockStack) > 0 {
			lineBlock = blockStack[len(blockStack)-1]
		}

		if strings.HasSuffix(trimmedLine, "{") {
			newBlock := BlockInfo{
				BlockType: trimmedLine,
				StartLine: lineNumber,
			}
			lineBlock = newBlock
			blockStack = append(blockStack, newBlock)
		} else if strings.Contains(trimmedLine, "}") && len(blockStack) > 0 {
			closingBlock := blockStack[len(blockStack)-1]
			blockStack = blockStack[:len(blockStack)-1]
			for i := range linesInfo {
				if linesInfo[i].Block.StartLine == closingBlock.StartLine {
					linesInfo[i].Block.EndLine = lineNumber
				}
			}
		}

		currentBlock = lineBlock

		lineLexer := parser.NewbicepLexer(antlr.NewInputStream(line))
		tokens := lineLexer.GetAllTokens()
		lineType := "other"
		commentBytes := lineBytes
		commentString := line
		hasCodeBeforeComment := false
		commentColumn := 0

		if len(tokens) > 0 {
			symbolicNames := lineLexer.GetSymbolicNames()
			if tok := tokens[0].GetTokenType(); tok < len(symbolicNames) {
				lineType = symbolicNames[tok]
			}
			for tokenIdx, token := range tokens {
				if tok := token.GetTokenType(); tok < len(symbolicNames) {
					tokenName := symbolicNames[tok]
					if tokenName == "SINGLE_LINE_COMMENT" {
						lineType = "SINGLE_LINE_COMMENT"
						commentColumn = strings.Index(line, "//")
						if commentColumn == -1 {
							commentColumn = 0
						}
						hasCodeBeforeComment = tokenIdx > 0
						commentText := token.GetText()
						commentBytes = []byte(commentText)
						commentString = commentText
						break
					}
				}
			}
		}

		lineInfo := LineInfo{
			Type:     lineType,
			IsInline: hasCodeBeforeComment,
			Bytes: struct {
				Bytes  []byte
				String string
			}{
				Bytes:  commentBytes,
				String: commentString,
			},
			Range: struct {
				Start struct {
					Line   int
					Column int
					Byte   int
				}
				End struct {
					Line   int
					Column int
					Byte   int
				}
			}{
				Start: struct {
					Line   int
					Column int
					Byte   int
				}{
					Line:   lineNumber,
					Column: commentColumn,
					Byte:   byteOffset,
				},
				End: struct {
					Line   int
					Column int
					Byte   int
				}{
					Line:   lineNumber,
					Column: lineLength,
					Byte:   byteOffset + lineLength,
				},
			},
			Block: struct {
				BlockType string
				StartLine int
				EndLine   int
			}{
				BlockType: currentBlock.BlockType,
				StartLine: currentBlock.StartLine,
				EndLine:   currentBlock.EndLine,
			},
		}
		linesInfo = append(linesInfo, lineInfo)

		lineNumber++
		byteOffset += lineLength + 1
	}

	return linesInfo
}

// linePosition returns the position of the comment in the file
func (c *comment) linePosition() Pos {
	return Pos{
		Line:       c.Range.End.Line + 1,
		Column:     c.Range.Start.Column,
		Byte:       c.Range.End.Byte,
		BlockStart: c.Block.StartLine + 1,
		BlockEnd:   c.Block.EndLine + 1,
	}
}

// commentContent returns the content of a comment as a model.CommentCommand
func (c *comment) commentContent() (value model.CommentCommand) {
	comment := strings.ToLower(string(c.Bytes.Bytes))
	comment = strings.TrimSpace(comment)

	if model.KICSCommentRgxp.MatchString(comment) {
		comment = model.KICSCommentRgxp.ReplaceAllString(comment, "")
		comment = strings.Trim(comment, "\n")
		commands := strings.Split(strings.Trim(comment, "\r"), " ")
		value = model.ProcessCommands(commands)
		return
	}
	return model.CommentCommand(comment)
}

// IgnoreMap is a map of all lines and blocks to ignore
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
func ProcessLines(lines []LineInfo) (ig IgnoreMap) {
	ignoreLines := make([]Pos, 0)
	ignoreBlocks := make([]Pos, 0)
	ignoreComments := make([]Pos, 0)
	for i := range lines {
		if lines[i].Type != "SINGLE_LINE_COMMENT" {
			continue
		}

		if lines[i].IsInline {
			// For inline comments, ignore the current line (not the next)
			ignoreLines, ignoreBlocks, ignoreComments = processComment((*comment)(&lines[i]),
				(*comment)(&lines[i]), ignoreLines, ignoreBlocks, ignoreComments)
		} else {
			// For standalone comments, ignore the next line (if not the last line)
			if i+1 >= len(lines) {
				continue
			}
			ignoreLines, ignoreBlocks, ignoreComments = processComment((*comment)(&lines[i]),
				(*comment)(&lines[i+1]), ignoreLines, ignoreBlocks, ignoreComments)
		}
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
		pos := tokenToIgnore.linePosition()
		pos.Column = comment.Range.Start.Column
		ignoreLineR = append(ignoreLineR, pos)
	case model.IgnoreBlock:
		pos := tokenToIgnore.linePosition()
		pos.Column = comment.Range.Start.Column
		ignoreBlockR = append(ignoreBlockR, pos)
	default:
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
