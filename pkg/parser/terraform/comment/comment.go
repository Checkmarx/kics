package comment

import (
	"strings"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/hclsyntax"
)

// comment is a comment token
type comment hclsyntax.Token

// position returns the position of the comment
func (c *comment) position() hcl.Pos {
	return hcl.Pos{Line: c.Range.End.Line + 1, Column: c.Range.End.Column, Byte: c.Range.End.Byte}
}

// value returns the value of a comment and, for query-specific commands, the query UUID.
func (c *comment) value() (value model.CommentCommand, queryID string) {
	comment := strings.ToLower(string(c.Bytes))
	// check if we are working with kics command
	if model.KICSCommentRgxp.MatchString(comment) {
		comment = model.KICSCommentRgxp.ReplaceAllString(comment, "")
		comment = strings.Trim(comment, "\n")
		commands := strings.Split(strings.Trim(comment, "\r"), " ")
		value, queryID = model.ProcessCommands(commands)
		return
	}
	return model.CommentCommand(comment), ""
}

// Ignore is a map of commands to ignore
type Ignore map[model.CommentCommand][]hcl.Pos

// Build builds the Ignore map
func (i *Ignore) build(ignoreLine, ignoreBlock, ignoreComment []hcl.Pos) {
	ignoreStruct := map[model.CommentCommand][]hcl.Pos{
		model.IgnoreLine:    ignoreLine,
		model.IgnoreBlock:   ignoreBlock,
		model.IgnoreComment: ignoreComment,
	}

	*i = ignoreStruct
}

// QueryIgnore maps a query UUID to command-specific positions.
type QueryIgnore map[string]map[model.CommentCommand][]hcl.Pos

// ///////////////////////////
//     LINES TO IGNORE      //
// ///////////////////////////

// GetIgnoreLines returns the lines to ignore from a comment
func GetIgnoreLines(ignore Ignore, body *hclsyntax.Body) (lines []int) {
	lines = make([]int, 0)
	for _, position := range ignore[model.IgnoreBlock] {
		lines = append(lines, checkBlock(body, position)...)
	}
	lines = append(lines, getLinesFromPos(ignore[model.IgnoreLine])...)
	lines = append(lines, getLinesFromPos(ignore[model.IgnoreComment])...)
	return
}

// getLinesFromPos will return a list of lines from a list of positions
func getLinesFromPos(positions []hcl.Pos) (lines []int) {
	lines = make([]int, 0)
	for _, position := range positions {
		lines = append(lines, position.Line)
	}
	return
}

// checkBlock checks if the position is inside a block and returns the lines to ignore
func checkBlock(body *hclsyntax.Body, position hcl.Pos) (lines []int) {
	lines = make([]int, 0)
	blocks := body.BlocksAtPos(position)

	for _, block := range blocks {
		lines = append(lines, getLinesFromBlock(block, position)...)
	}
	return
}

// getLinesFromBlock returns the lines to ignore from a block
func getLinesFromBlock(block *hcl.Block, position hcl.Pos) (lines []int) {
	lines = make([]int, 0)
	if checkBlockRange(block, position) {
		rangeBlock := block.Body.(*hclsyntax.Body).Range()
		lines = append(lines, model.Range(rangeBlock.Start.Line, rangeBlock.End.Line)...)
	} else {
		// check in attributes
		attribute := block.Body.(*hclsyntax.Body).AttributeAtPos(position)
		lines = append(lines, getLinesFromAttr(attribute)...)
	}
	return
}

// getLinesFromAttr returns the lines to ignore from an attribute
func getLinesFromAttr(atr *hcl.Attribute) (lines []int) {
	lines = make([]int, 0)
	if atr == nil {
		return
	}

	lines = append(lines, model.Range(atr.Range.Start.Line, atr.Range.End.Line)...)
	return
}

// checkBlockRange checks if the position is inside a block
func checkBlockRange(block *hcl.Block, position hcl.Pos) bool {
	return block.TypeRange.End == position
}

// ///////////////////////////
//     COMMENT PARSER       //
// ///////////////////////////

// ParseComments parses the comments and returns the kics commands
func ParseComments(src []byte, filename string) (Ignore, QueryIgnore, error) {
	comments, diags := hclsyntax.LexConfig(src, filename, hcl.Pos{Line: 0, Column: 0})
	if diags != nil && diags.HasErrors() {
		return Ignore{}, QueryIgnore{}, diags.Errs()[0]
	}

	ig, qi := processTokens(comments)

	return ig, qi, nil
}

// processTokens goes over the tokens and returns the kics commands
func processTokens(tokens hclsyntax.Tokens) (ig Ignore, qi QueryIgnore) {
	ignoreLines := make([]hcl.Pos, 0)
	ignoreBlocks := make([]hcl.Pos, 0)
	ignoreComments := make([]hcl.Pos, 0)
	qi = make(QueryIgnore)
	for i := range tokens {
		// token is not a comment
		if tokens[i].Type != hclsyntax.TokenComment || i+1 > len(tokens) {
			continue
		}
		// case: CONFIGURATION = X # comment
		if i > 0 && tokens[i-1].Range.Start.Line == tokens[i].Range.Start.Line {
			continue
		}
		ignoreLines, ignoreBlocks, ignoreComments = processComment((*comment)(&tokens[i]),
			(*comment)(&tokens[i+1]), ignoreLines, ignoreBlocks, ignoreComments, qi)
	}
	ig = make(map[model.CommentCommand][]hcl.Pos)
	ig.build(ignoreLines, ignoreBlocks, ignoreComments)
	return ig, qi
}

// processComment analyzes the comment to determine which type of kics command the comment is
func processComment(comment *comment, tokenToIgnore *comment,
	ignoreLine, ignoreBlock, ignoreComments []hcl.Pos, qi QueryIgnore) (ignoreLineR, ignoreBlockR, ignoreCommentsR []hcl.Pos) {
	ignoreLineR = ignoreLine
	ignoreBlockR = ignoreBlock
	ignoreCommentsR = ignoreComments

	cmd, queryID := comment.value()
	switch cmd {
	case model.IgnoreLine:
		// comment is of type kics ignore-line
		ignoreLineR = append(ignoreLineR, tokenToIgnore.position(), hcl.Pos{Line: comment.position().Line - 1})
	case model.IgnoreBlock:
		// comment is of type kics ignore-block
		ignoreBlockR = append(ignoreBlockR, tokenToIgnore.position(), hcl.Pos{Line: comment.position().Line - 1})
	case model.IgnoreLineQuery:
		// comment is of type kics ignore-line=<uuid>
		if queryID != "" {
			if qi[queryID] == nil {
				qi[queryID] = make(map[model.CommentCommand][]hcl.Pos)
			}
			qi[queryID][model.IgnoreLineQuery] = append(qi[queryID][model.IgnoreLineQuery],
				tokenToIgnore.position(), hcl.Pos{Line: comment.position().Line - 1})
		}
		// treat as a comment line (not a global ignore)
		ignoreCommentsR = append(ignoreCommentsR, hcl.Pos{Line: comment.position().Line - 1})
		return
	case model.IgnoreBlockQuery:
		// comment is of type kics ignore-block=<uuid>
		if queryID != "" {
			if qi[queryID] == nil {
				qi[queryID] = make(map[model.CommentCommand][]hcl.Pos)
			}
			qi[queryID][model.IgnoreBlockQuery] = append(qi[queryID][model.IgnoreBlockQuery],
				tokenToIgnore.position(), hcl.Pos{Line: comment.position().Line - 1})
		}
		// treat as a comment line (not a global ignore)
		ignoreCommentsR = append(ignoreCommentsR, hcl.Pos{Line: comment.position().Line - 1})
		return
	default:
		// comment is not of type kics ignore
		ignoreCommentsR = append(ignoreCommentsR, hcl.Pos{Line: comment.position().Line - 1})
		return
	}

	return
}

// GetQueryIgnoreLines resolves QueryIgnore positions to line numbers per query UUID
func GetQueryIgnoreLines(qi QueryIgnore, body *hclsyntax.Body) model.QueryIgnoreLines {
	result := make(model.QueryIgnoreLines)
	for queryID, cmdMap := range qi {
		lines := make([]int, 0)
		for cmd, positions := range cmdMap {
			switch cmd {
			case model.IgnoreLineQuery:
				lines = append(lines, getLinesFromPos(positions)...)
			case model.IgnoreBlockQuery:
				for _, position := range positions {
					lines = append(lines, checkBlock(body, position)...)
				}
			}
		}
		result[queryID] = model.RemoveDuplicates(lines)
	}
	return result
}
