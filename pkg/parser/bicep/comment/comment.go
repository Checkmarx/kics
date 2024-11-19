package comment

import (
	"github.com/antlr4-go/antlr/v4"
)

// BicepParserListener is a complete listener for a parse tree produced by BicepParser.
type BicepParserListener struct {
	*antlr.BaseParseTreeListener
	comments []antlr.Token
}

// NewBicepParserListener creates a new listener.
func NewBicepParserListener() *BicepParserListener {
	return &BicepParserListener{
		comments: []antlr.Token{},
	}
}

// EnterEveryRule is called when any rule is entered.
func (l *BicepParserListener) EnterEveryRule(ctx antlr.ParserRuleContext) {
	// Capture comments from hidden channel
	tokens := ctx.GetParser().GetTokenStream().(*antlr.CommonTokenStream)
	for _, token := range tokens.GetHiddenTokensToLeft(ctx.GetStart().GetTokenIndex(), BicepLexerSINGLE_LINE_COMMENT) {
		l.comments = append(l.comments, token)
	}
}

// GetComments returns the captured comments.
func (l *BicepParserListener) GetComments() []antlr.Token {
	return l.comments
}
