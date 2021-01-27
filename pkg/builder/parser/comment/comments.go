package comment

import (
	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/hclsyntax"
)

// Parser represents a list of code tokens
type Parser struct {
	tokens hclsyntax.Tokens
}

// NewParser parses the content of a file and return a parser with its tokens
func NewParser(src []byte, filename string) (*Parser, error) {
	tokens, diags := hclsyntax.LexConfig(src, filename, hcl.Pos{Line: 0, Column: 0})
	if diags != nil && diags.HasErrors() {
		return nil, diags.Errs()[0]
	}

	return &Parser{
		tokens: tokens,
	}, nil
}

// ParseCommentsForNode returns a comment in the range given in rg, if exists
func (p *Parser) ParseCommentsForNode(rg hcl.Range) (startComment, leadComment Comment) {
	start, end := p.rangePosition(rg)
	startLeadComment := p.leadCommentStarts(start)
	endLineComment := p.lineCommentEnds(end)

	return p.createCommentFromRange(startLeadComment, start), p.createCommentFromRange(end, endLineComment)
}

func (p *Parser) rangePosition(rng hcl.Range) (start, end int) {
	for i := 0; ; i++ {
		if i >= len(p.tokens) {
			return len(p.tokens), len(p.tokens)
		}

		if p.tokens[i].Range.Start.Byte >= rng.Start.Byte {
			start = i
			break
		}
	}

	for i := start; ; i++ {
		if i >= len(p.tokens) {
			return start, len(p.tokens)
		}

		if p.tokens[i].Range.Start.Byte >= rng.End.Byte {
			end = i
			break
		}
	}

	return start, end
}

func (p *Parser) leadCommentStarts(before int) (i int) {
	defer func() {
		if i != before && i-1 >= 0 && p.tokens[i-1].Type != hclsyntax.TokenNewline {
			i++
		}
	}()

	for i = before - 1; i >= 0; i-- {
		if p.tokens[i].Type != hclsyntax.TokenComment {
			return i + 1
		}
	}

	return 0
}

func (p *Parser) lineCommentEnds(after int) int {
	for i := after; i < len(p.tokens); i++ {
		tok := p.tokens[i]
		if tok.Type != hclsyntax.TokenComment {
			return i
		}

		if len(tok.Bytes) > 0 && tok.Bytes[len(tok.Bytes)-1] == '\n' {
			return i + 1
		}
	}
	return len(p.tokens)
}

// Comment - struct with comment value and its position on file
type Comment struct {
	pos   hcl.Pos
	value string
}

// IsEmpty returns true if comment is empty, otherwise returns false
func (c Comment) IsEmpty() bool {
	return c.value == ""
}

// Value returns comment value
func (c Comment) Value() string {
	return c.value
}

// Line returns the line comment starts
func (c Comment) Line() int {
	return c.pos.Line + 1
}

func (p *Parser) createCommentFromRange(start, end int) Comment {
	s := ""
	for i := start; i < end; i++ {
		s += string(p.tokens[i].Bytes)
	}

	return Comment{
		pos:   p.tokens[start].Range.Start,
		value: s,
	}
}
