package parser

import "github.com/antlr4-go/antlr/v4"

type CustomSyntaxError struct {
	line, column int
	msg          string
}

type CustomErrorListener struct {
	*antlr.DefaultErrorListener
	Errors []*CustomSyntaxError
}

func NewCustomErrorListener() *CustomErrorListener {
	return &CustomErrorListener{
		DefaultErrorListener: antlr.NewDefaultErrorListener(),
		Errors:               make([]*CustomSyntaxError, 0),
	}
}

func (c *CustomErrorListener) HasErrors() bool {
	return len(c.Errors) > 0
}

func (c *CustomErrorListener) SyntaxError(recognizer antlr.Recognizer,
	offendingSymbol interface{}, line, column int, msg string, e antlr.RecognitionException) {
	c.Errors = append(c.Errors, &CustomSyntaxError{
		line:   line,
		column: column,
		msg:    msg,
	})
}
