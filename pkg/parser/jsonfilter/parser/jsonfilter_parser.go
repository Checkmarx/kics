// Code generated from JSONFilter.g4 by ANTLR 4.13.1. DO NOT EDIT.

package parser // JSONFilter

import (
	"fmt"
	"strconv"
	"sync"

	"github.com/antlr4-go/antlr/v4"
)

// Suppress unused import errors
var _ = fmt.Printf
var _ = strconv.Itoa
var _ = sync.Once{}

type JSONFilterParser struct {
	*antlr.BaseParser
}

var JSONFilterParserStaticData struct {
	once                   sync.Once
	serializedATN          []int32
	LiteralNames           []string
	SymbolicNames          []string
	RuleNames              []string
	PredictionContextCache *antlr.PredictionContextCache
	atn                    *antlr.ATN
	decisionToDFA          []*antlr.DFA
}

func jsonfilterParserInit() {
	staticData := &JSONFilterParserStaticData
	staticData.LiteralNames = []string{
		"", "'$.'", "'*'", "'{'", "'}'", "'('", "')'", "'['", "']'", "'.'",
		"'&&'", "'||'", "'='", "'!='", "'>'", "'<'", "'>='", "'<='", "'IS'",
		"'NOT'", "'NULL'", "'EXISTS'", "'TRUE'", "'FALSE'",
	}
	staticData.SymbolicNames = []string{
		"", "SEL_START", "STAR", "LCURLY", "RCURLY", "LPAREN", "RPAREN", "LBRACKET",
		"RBRACKET", "DOT", "AND", "OR", "EQUALS", "NOT_EQUALS", "GT", "LT",
		"GE", "LE", "IS", "NOT", "NULL", "EXISTS", "TRUE", "FALSE", "INDENTIFIER",
		"STRING", "NUMBER", "WS",
	}
	staticData.RuleNames = []string{
		"awsjsonfilter", "dotnotation", "filter_expr", "exp", "selector", "qualifiedidentifier",
		"member", "operator", "literal",
	}
	staticData.PredictionContextCache = antlr.NewPredictionContextCache()
	staticData.serializedATN = []int32{
		4, 1, 27, 90, 2, 0, 7, 0, 2, 1, 7, 1, 2, 2, 7, 2, 2, 3, 7, 3, 2, 4, 7,
		4, 2, 5, 7, 5, 2, 6, 7, 6, 2, 7, 7, 7, 2, 8, 7, 8, 1, 0, 1, 0, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 3, 2, 31, 8, 2, 1, 2,
		1, 2, 1, 2, 1, 2, 1, 2, 1, 2, 5, 2, 39, 8, 2, 10, 2, 12, 2, 42, 9, 2, 1,
		3, 1, 3, 1, 3, 1, 3, 3, 3, 48, 8, 3, 1, 4, 1, 4, 1, 4, 1, 5, 1, 5, 1, 5,
		5, 5, 56, 8, 5, 10, 5, 12, 5, 59, 9, 5, 1, 6, 1, 6, 1, 6, 1, 6, 1, 6, 4,
		6, 66, 8, 6, 11, 6, 12, 6, 67, 3, 6, 70, 8, 6, 1, 7, 1, 7, 1, 8, 1, 8,
		1, 8, 4, 8, 77, 8, 8, 11, 8, 12, 8, 78, 1, 8, 1, 8, 1, 8, 1, 8, 1, 8, 1,
		8, 1, 8, 3, 8, 88, 8, 8, 1, 8, 0, 1, 4, 9, 0, 2, 4, 6, 8, 10, 12, 14, 16,
		0, 2, 1, 0, 12, 19, 2, 0, 2, 2, 26, 26, 95, 0, 18, 1, 0, 0, 0, 2, 20, 1,
		0, 0, 0, 4, 30, 1, 0, 0, 0, 6, 43, 1, 0, 0, 0, 8, 49, 1, 0, 0, 0, 10, 52,
		1, 0, 0, 0, 12, 69, 1, 0, 0, 0, 14, 71, 1, 0, 0, 0, 16, 87, 1, 0, 0, 0,
		18, 19, 3, 2, 1, 0, 19, 1, 1, 0, 0, 0, 20, 21, 5, 3, 0, 0, 21, 22, 3, 4,
		2, 0, 22, 23, 5, 4, 0, 0, 23, 3, 1, 0, 0, 0, 24, 25, 6, 2, -1, 0, 25, 26,
		5, 5, 0, 0, 26, 27, 3, 4, 2, 0, 27, 28, 5, 6, 0, 0, 28, 31, 1, 0, 0, 0,
		29, 31, 3, 6, 3, 0, 30, 24, 1, 0, 0, 0, 30, 29, 1, 0, 0, 0, 31, 40, 1,
		0, 0, 0, 32, 33, 10, 3, 0, 0, 33, 34, 5, 10, 0, 0, 34, 39, 3, 4, 2, 4,
		35, 36, 10, 2, 0, 0, 36, 37, 5, 11, 0, 0, 37, 39, 3, 4, 2, 3, 38, 32, 1,
		0, 0, 0, 38, 35, 1, 0, 0, 0, 39, 42, 1, 0, 0, 0, 40, 38, 1, 0, 0, 0, 40,
		41, 1, 0, 0, 0, 41, 5, 1, 0, 0, 0, 42, 40, 1, 0, 0, 0, 43, 44, 3, 8, 4,
		0, 44, 47, 3, 14, 7, 0, 45, 48, 3, 16, 8, 0, 46, 48, 3, 10, 5, 0, 47, 45,
		1, 0, 0, 0, 47, 46, 1, 0, 0, 0, 48, 7, 1, 0, 0, 0, 49, 50, 5, 1, 0, 0,
		50, 51, 3, 10, 5, 0, 51, 9, 1, 0, 0, 0, 52, 57, 3, 12, 6, 0, 53, 54, 5,
		9, 0, 0, 54, 56, 3, 12, 6, 0, 55, 53, 1, 0, 0, 0, 56, 59, 1, 0, 0, 0, 57,
		55, 1, 0, 0, 0, 57, 58, 1, 0, 0, 0, 58, 11, 1, 0, 0, 0, 59, 57, 1, 0, 0,
		0, 60, 70, 5, 24, 0, 0, 61, 65, 5, 24, 0, 0, 62, 63, 5, 7, 0, 0, 63, 64,
		5, 26, 0, 0, 64, 66, 5, 8, 0, 0, 65, 62, 1, 0, 0, 0, 66, 67, 1, 0, 0, 0,
		67, 65, 1, 0, 0, 0, 67, 68, 1, 0, 0, 0, 68, 70, 1, 0, 0, 0, 69, 60, 1,
		0, 0, 0, 69, 61, 1, 0, 0, 0, 70, 13, 1, 0, 0, 0, 71, 72, 7, 0, 0, 0, 72,
		15, 1, 0, 0, 0, 73, 76, 5, 26, 0, 0, 74, 75, 5, 9, 0, 0, 75, 77, 7, 1,
		0, 0, 76, 74, 1, 0, 0, 0, 77, 78, 1, 0, 0, 0, 78, 76, 1, 0, 0, 0, 78, 79,
		1, 0, 0, 0, 79, 88, 1, 0, 0, 0, 80, 88, 5, 25, 0, 0, 81, 88, 5, 26, 0,
		0, 82, 88, 5, 20, 0, 0, 83, 88, 5, 21, 0, 0, 84, 88, 5, 22, 0, 0, 85, 88,
		5, 23, 0, 0, 86, 88, 5, 24, 0, 0, 87, 73, 1, 0, 0, 0, 87, 80, 1, 0, 0,
		0, 87, 81, 1, 0, 0, 0, 87, 82, 1, 0, 0, 0, 87, 83, 1, 0, 0, 0, 87, 84,
		1, 0, 0, 0, 87, 85, 1, 0, 0, 0, 87, 86, 1, 0, 0, 0, 88, 17, 1, 0, 0, 0,
		9, 30, 38, 40, 47, 57, 67, 69, 78, 87,
	}
	deserializer := antlr.NewATNDeserializer(nil)
	staticData.atn = deserializer.Deserialize(staticData.serializedATN)
	atn := staticData.atn
	staticData.decisionToDFA = make([]*antlr.DFA, len(atn.DecisionToState))
	decisionToDFA := staticData.decisionToDFA
	for index, state := range atn.DecisionToState {
		decisionToDFA[index] = antlr.NewDFA(state, index)
	}
}

// JSONFilterParserInit initializes any static state used to implement JSONFilterParser. By default the
// static state used to implement the parser is lazily initialized during the first call to
// NewJSONFilterParser(). You can call this function if you wish to initialize the static state ahead
// of time.
func JSONFilterParserInit() {
	staticData := &JSONFilterParserStaticData
	staticData.once.Do(jsonfilterParserInit)
}

// NewJSONFilterParser produces a new parser instance for the optional input antlr.TokenStream.
func NewJSONFilterParser(input antlr.TokenStream) *JSONFilterParser {
	JSONFilterParserInit()
	this := new(JSONFilterParser)
	this.BaseParser = antlr.NewBaseParser(input)
	staticData := &JSONFilterParserStaticData
	this.Interpreter = antlr.NewParserATNSimulator(this, staticData.atn, staticData.decisionToDFA, staticData.PredictionContextCache)
	this.RuleNames = staticData.RuleNames
	this.LiteralNames = staticData.LiteralNames
	this.SymbolicNames = staticData.SymbolicNames
	this.GrammarFileName = "JSONFilter.g4"

	return this
}

// JSONFilterParser tokens.
const (
	JSONFilterParserEOF         = antlr.TokenEOF
	JSONFilterParserSEL_START   = 1
	JSONFilterParserSTAR        = 2
	JSONFilterParserLCURLY      = 3
	JSONFilterParserRCURLY      = 4
	JSONFilterParserLPAREN      = 5
	JSONFilterParserRPAREN      = 6
	JSONFilterParserLBRACKET    = 7
	JSONFilterParserRBRACKET    = 8
	JSONFilterParserDOT         = 9
	JSONFilterParserAND         = 10
	JSONFilterParserOR          = 11
	JSONFilterParserEQUALS      = 12
	JSONFilterParserNOT_EQUALS  = 13
	JSONFilterParserGT          = 14
	JSONFilterParserLT          = 15
	JSONFilterParserGE          = 16
	JSONFilterParserLE          = 17
	JSONFilterParserIS          = 18
	JSONFilterParserNOT         = 19
	JSONFilterParserNULL        = 20
	JSONFilterParserEXISTS      = 21
	JSONFilterParserTRUE        = 22
	JSONFilterParserFALSE       = 23
	JSONFilterParserINDENTIFIER = 24
	JSONFilterParserSTRING      = 25
	JSONFilterParserNUMBER      = 26
	JSONFilterParserWS          = 27
)

// JSONFilterParser rules.
const (
	JSONFilterParserRULE_awsjsonfilter       = 0
	JSONFilterParserRULE_dotnotation         = 1
	JSONFilterParserRULE_filter_expr         = 2
	JSONFilterParserRULE_exp                 = 3
	JSONFilterParserRULE_selector            = 4
	JSONFilterParserRULE_qualifiedidentifier = 5
	JSONFilterParserRULE_member              = 6
	JSONFilterParserRULE_operator            = 7
	JSONFilterParserRULE_literal             = 8
)

// IAwsjsonfilterContext is an interface to support dynamic dispatch.
type IAwsjsonfilterContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// Getter signatures
	Dotnotation() IDotnotationContext

	// IsAwsjsonfilterContext differentiates from other interfaces.
	IsAwsjsonfilterContext()
}

type AwsjsonfilterContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyAwsjsonfilterContext() *AwsjsonfilterContext {
	var p = new(AwsjsonfilterContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = JSONFilterParserRULE_awsjsonfilter
	return p
}

func InitEmptyAwsjsonfilterContext(p *AwsjsonfilterContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = JSONFilterParserRULE_awsjsonfilter
}

func (*AwsjsonfilterContext) IsAwsjsonfilterContext() {}

func NewAwsjsonfilterContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *AwsjsonfilterContext {
	var p = new(AwsjsonfilterContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = JSONFilterParserRULE_awsjsonfilter

	return p
}

func (s *AwsjsonfilterContext) GetParser() antlr.Parser { return s.parser }

func (s *AwsjsonfilterContext) Dotnotation() IDotnotationContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IDotnotationContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IDotnotationContext)
}

func (s *AwsjsonfilterContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *AwsjsonfilterContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *AwsjsonfilterContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case JSONFilterVisitor:
		return t.VisitAwsjsonfilter(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *JSONFilterParser) Awsjsonfilter() (localctx IAwsjsonfilterContext) {
	localctx = NewAwsjsonfilterContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 0, JSONFilterParserRULE_awsjsonfilter)
	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(18)
		p.Dotnotation()
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.ExitRule()
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

// IDotnotationContext is an interface to support dynamic dispatch.
type IDotnotationContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// Getter signatures
	LCURLY() antlr.TerminalNode
	Filter_expr() IFilter_exprContext
	RCURLY() antlr.TerminalNode

	// IsDotnotationContext differentiates from other interfaces.
	IsDotnotationContext()
}

type DotnotationContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyDotnotationContext() *DotnotationContext {
	var p = new(DotnotationContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = JSONFilterParserRULE_dotnotation
	return p
}

func InitEmptyDotnotationContext(p *DotnotationContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = JSONFilterParserRULE_dotnotation
}

func (*DotnotationContext) IsDotnotationContext() {}

func NewDotnotationContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *DotnotationContext {
	var p = new(DotnotationContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = JSONFilterParserRULE_dotnotation

	return p
}

func (s *DotnotationContext) GetParser() antlr.Parser { return s.parser }

func (s *DotnotationContext) LCURLY() antlr.TerminalNode {
	return s.GetToken(JSONFilterParserLCURLY, 0)
}

func (s *DotnotationContext) Filter_expr() IFilter_exprContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IFilter_exprContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IFilter_exprContext)
}

func (s *DotnotationContext) RCURLY() antlr.TerminalNode {
	return s.GetToken(JSONFilterParserRCURLY, 0)
}

func (s *DotnotationContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *DotnotationContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *DotnotationContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case JSONFilterVisitor:
		return t.VisitDotnotation(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *JSONFilterParser) Dotnotation() (localctx IDotnotationContext) {
	localctx = NewDotnotationContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 2, JSONFilterParserRULE_dotnotation)
	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(20)
		p.Match(JSONFilterParserLCURLY)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(21)
		p.filter_expr(0)
	}
	{
		p.SetState(22)
		p.Match(JSONFilterParserRCURLY)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.ExitRule()
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

// IFilter_exprContext is an interface to support dynamic dispatch.
type IFilter_exprContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser
	// IsFilter_exprContext differentiates from other interfaces.
	IsFilter_exprContext()
}

type Filter_exprContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyFilter_exprContext() *Filter_exprContext {
	var p = new(Filter_exprContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = JSONFilterParserRULE_filter_expr
	return p
}

func InitEmptyFilter_exprContext(p *Filter_exprContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = JSONFilterParserRULE_filter_expr
}

func (*Filter_exprContext) IsFilter_exprContext() {}

func NewFilter_exprContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *Filter_exprContext {
	var p = new(Filter_exprContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = JSONFilterParserRULE_filter_expr

	return p
}

func (s *Filter_exprContext) GetParser() antlr.Parser { return s.parser }

func (s *Filter_exprContext) CopyAll(ctx *Filter_exprContext) {
	s.CopyFrom(&ctx.BaseParserRuleContext)
}

func (s *Filter_exprContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *Filter_exprContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

type Filter_expr_parenthesizedContext struct {
	Filter_exprContext
}

func NewFilter_expr_parenthesizedContext(parser antlr.Parser, ctx antlr.ParserRuleContext) *Filter_expr_parenthesizedContext {
	var p = new(Filter_expr_parenthesizedContext)

	InitEmptyFilter_exprContext(&p.Filter_exprContext)
	p.parser = parser
	p.CopyAll(ctx.(*Filter_exprContext))

	return p
}

func (s *Filter_expr_parenthesizedContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *Filter_expr_parenthesizedContext) LPAREN() antlr.TerminalNode {
	return s.GetToken(JSONFilterParserLPAREN, 0)
}

func (s *Filter_expr_parenthesizedContext) Filter_expr() IFilter_exprContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IFilter_exprContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IFilter_exprContext)
}

func (s *Filter_expr_parenthesizedContext) RPAREN() antlr.TerminalNode {
	return s.GetToken(JSONFilterParserRPAREN, 0)
}

func (s *Filter_expr_parenthesizedContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case JSONFilterVisitor:
		return t.VisitFilter_expr_parenthesized(s)

	default:
		return t.VisitChildren(s)
	}
}

type Filter_expr_andContext struct {
	Filter_exprContext
	lhs IFilter_exprContext
	rhs IFilter_exprContext
}

func NewFilter_expr_andContext(parser antlr.Parser, ctx antlr.ParserRuleContext) *Filter_expr_andContext {
	var p = new(Filter_expr_andContext)

	InitEmptyFilter_exprContext(&p.Filter_exprContext)
	p.parser = parser
	p.CopyAll(ctx.(*Filter_exprContext))

	return p
}

func (s *Filter_expr_andContext) GetLhs() IFilter_exprContext { return s.lhs }

func (s *Filter_expr_andContext) GetRhs() IFilter_exprContext { return s.rhs }

func (s *Filter_expr_andContext) SetLhs(v IFilter_exprContext) { s.lhs = v }

func (s *Filter_expr_andContext) SetRhs(v IFilter_exprContext) { s.rhs = v }

func (s *Filter_expr_andContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *Filter_expr_andContext) AND() antlr.TerminalNode {
	return s.GetToken(JSONFilterParserAND, 0)
}

func (s *Filter_expr_andContext) AllFilter_expr() []IFilter_exprContext {
	children := s.GetChildren()
	len := 0
	for _, ctx := range children {
		if _, ok := ctx.(IFilter_exprContext); ok {
			len++
		}
	}

	tst := make([]IFilter_exprContext, len)
	i := 0
	for _, ctx := range children {
		if t, ok := ctx.(IFilter_exprContext); ok {
			tst[i] = t.(IFilter_exprContext)
			i++
		}
	}

	return tst
}

func (s *Filter_expr_andContext) Filter_expr(i int) IFilter_exprContext {
	var t antlr.RuleContext
	j := 0
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IFilter_exprContext); ok {
			if j == i {
				t = ctx.(antlr.RuleContext)
				break
			}
			j++
		}
	}

	if t == nil {
		return nil
	}

	return t.(IFilter_exprContext)
}

func (s *Filter_expr_andContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case JSONFilterVisitor:
		return t.VisitFilter_expr_and(s)

	default:
		return t.VisitChildren(s)
	}
}

type Filter_expr_expContext struct {
	Filter_exprContext
}

func NewFilter_expr_expContext(parser antlr.Parser, ctx antlr.ParserRuleContext) *Filter_expr_expContext {
	var p = new(Filter_expr_expContext)

	InitEmptyFilter_exprContext(&p.Filter_exprContext)
	p.parser = parser
	p.CopyAll(ctx.(*Filter_exprContext))

	return p
}

func (s *Filter_expr_expContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *Filter_expr_expContext) Exp() IExpContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IExpContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IExpContext)
}

func (s *Filter_expr_expContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case JSONFilterVisitor:
		return t.VisitFilter_expr_exp(s)

	default:
		return t.VisitChildren(s)
	}
}

type Filter_expr_orContext struct {
	Filter_exprContext
	lhs IFilter_exprContext
	rhs IFilter_exprContext
}

func NewFilter_expr_orContext(parser antlr.Parser, ctx antlr.ParserRuleContext) *Filter_expr_orContext {
	var p = new(Filter_expr_orContext)

	InitEmptyFilter_exprContext(&p.Filter_exprContext)
	p.parser = parser
	p.CopyAll(ctx.(*Filter_exprContext))

	return p
}

func (s *Filter_expr_orContext) GetLhs() IFilter_exprContext { return s.lhs }

func (s *Filter_expr_orContext) GetRhs() IFilter_exprContext { return s.rhs }

func (s *Filter_expr_orContext) SetLhs(v IFilter_exprContext) { s.lhs = v }

func (s *Filter_expr_orContext) SetRhs(v IFilter_exprContext) { s.rhs = v }

func (s *Filter_expr_orContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *Filter_expr_orContext) OR() antlr.TerminalNode {
	return s.GetToken(JSONFilterParserOR, 0)
}

func (s *Filter_expr_orContext) AllFilter_expr() []IFilter_exprContext {
	children := s.GetChildren()
	len := 0
	for _, ctx := range children {
		if _, ok := ctx.(IFilter_exprContext); ok {
			len++
		}
	}

	tst := make([]IFilter_exprContext, len)
	i := 0
	for _, ctx := range children {
		if t, ok := ctx.(IFilter_exprContext); ok {
			tst[i] = t.(IFilter_exprContext)
			i++
		}
	}

	return tst
}

func (s *Filter_expr_orContext) Filter_expr(i int) IFilter_exprContext {
	var t antlr.RuleContext
	j := 0
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IFilter_exprContext); ok {
			if j == i {
				t = ctx.(antlr.RuleContext)
				break
			}
			j++
		}
	}

	if t == nil {
		return nil
	}

	return t.(IFilter_exprContext)
}

func (s *Filter_expr_orContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case JSONFilterVisitor:
		return t.VisitFilter_expr_or(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *JSONFilterParser) Filter_expr() (localctx IFilter_exprContext) {
	return p.filter_expr(0)
}

func (p *JSONFilterParser) filter_expr(_p int) (localctx IFilter_exprContext) {
	var _parentctx antlr.ParserRuleContext = p.GetParserRuleContext()

	_parentState := p.GetState()
	localctx = NewFilter_exprContext(p, p.GetParserRuleContext(), _parentState)
	var _prevctx IFilter_exprContext = localctx
	var _ antlr.ParserRuleContext = _prevctx // TODO: To prevent unused variable warning.
	_startState := 4
	p.EnterRecursionRule(localctx, 4, JSONFilterParserRULE_filter_expr, _p)
	var _alt int

	p.EnterOuterAlt(localctx, 1)
	p.SetState(30)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetTokenStream().LA(1) {
	case JSONFilterParserLPAREN:
		localctx = NewFilter_expr_parenthesizedContext(p, localctx)
		p.SetParserRuleContext(localctx)
		_prevctx = localctx

		{
			p.SetState(25)
			p.Match(JSONFilterParserLPAREN)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}
		{
			p.SetState(26)
			p.filter_expr(0)
		}
		{
			p.SetState(27)
			p.Match(JSONFilterParserRPAREN)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case JSONFilterParserSEL_START:
		localctx = NewFilter_expr_expContext(p, localctx)
		p.SetParserRuleContext(localctx)
		_prevctx = localctx
		{
			p.SetState(29)
			p.Exp()
		}

	default:
		p.SetError(antlr.NewNoViableAltException(p, nil, nil, nil, nil, nil))
		goto errorExit
	}
	p.GetParserRuleContext().SetStop(p.GetTokenStream().LT(-1))
	p.SetState(40)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_alt = p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 2, p.GetParserRuleContext())
	if p.HasError() {
		goto errorExit
	}
	for _alt != 2 && _alt != antlr.ATNInvalidAltNumber {
		if _alt == 1 {
			if p.GetParseListeners() != nil {
				p.TriggerExitRuleEvent()
			}
			_prevctx = localctx
			p.SetState(38)
			p.GetErrorHandler().Sync(p)
			if p.HasError() {
				goto errorExit
			}

			switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 1, p.GetParserRuleContext()) {
			case 1:
				localctx = NewFilter_expr_andContext(p, NewFilter_exprContext(p, _parentctx, _parentState))
				localctx.(*Filter_expr_andContext).lhs = _prevctx

				p.PushNewRecursionContext(localctx, _startState, JSONFilterParserRULE_filter_expr)
				p.SetState(32)

				if !(p.Precpred(p.GetParserRuleContext(), 3)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 3)", ""))
					goto errorExit
				}
				{
					p.SetState(33)
					p.Match(JSONFilterParserAND)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(34)

					var _x = p.filter_expr(4)

					localctx.(*Filter_expr_andContext).rhs = _x
				}

			case 2:
				localctx = NewFilter_expr_orContext(p, NewFilter_exprContext(p, _parentctx, _parentState))
				localctx.(*Filter_expr_orContext).lhs = _prevctx

				p.PushNewRecursionContext(localctx, _startState, JSONFilterParserRULE_filter_expr)
				p.SetState(35)

				if !(p.Precpred(p.GetParserRuleContext(), 2)) {
					p.SetError(antlr.NewFailedPredicateException(p, "p.Precpred(p.GetParserRuleContext(), 2)", ""))
					goto errorExit
				}
				{
					p.SetState(36)
					p.Match(JSONFilterParserOR)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(37)

					var _x = p.filter_expr(3)

					localctx.(*Filter_expr_orContext).rhs = _x
				}

			case antlr.ATNInvalidAltNumber:
				goto errorExit
			}

		}
		p.SetState(42)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_alt = p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 2, p.GetParserRuleContext())
		if p.HasError() {
			goto errorExit
		}
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.UnrollRecursionContexts(_parentctx)
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

// IExpContext is an interface to support dynamic dispatch.
type IExpContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// Getter signatures
	Selector() ISelectorContext
	Operator() IOperatorContext
	Literal() ILiteralContext
	Qualifiedidentifier() IQualifiedidentifierContext

	// IsExpContext differentiates from other interfaces.
	IsExpContext()
}

type ExpContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyExpContext() *ExpContext {
	var p = new(ExpContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = JSONFilterParserRULE_exp
	return p
}

func InitEmptyExpContext(p *ExpContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = JSONFilterParserRULE_exp
}

func (*ExpContext) IsExpContext() {}

func NewExpContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *ExpContext {
	var p = new(ExpContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = JSONFilterParserRULE_exp

	return p
}

func (s *ExpContext) GetParser() antlr.Parser { return s.parser }

func (s *ExpContext) Selector() ISelectorContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(ISelectorContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(ISelectorContext)
}

func (s *ExpContext) Operator() IOperatorContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IOperatorContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IOperatorContext)
}

func (s *ExpContext) Literal() ILiteralContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(ILiteralContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(ILiteralContext)
}

func (s *ExpContext) Qualifiedidentifier() IQualifiedidentifierContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IQualifiedidentifierContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IQualifiedidentifierContext)
}

func (s *ExpContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *ExpContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *ExpContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case JSONFilterVisitor:
		return t.VisitExp(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *JSONFilterParser) Exp() (localctx IExpContext) {
	localctx = NewExpContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 6, JSONFilterParserRULE_exp)
	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(43)
		p.Selector()
	}
	{
		p.SetState(44)
		p.Operator()
	}
	p.SetState(47)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 3, p.GetParserRuleContext()) {
	case 1:
		{
			p.SetState(45)
			p.Literal()
		}

	case 2:
		{
			p.SetState(46)
			p.Qualifiedidentifier()
		}

	case antlr.ATNInvalidAltNumber:
		goto errorExit
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.ExitRule()
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

// ISelectorContext is an interface to support dynamic dispatch.
type ISelectorContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// Getter signatures
	SEL_START() antlr.TerminalNode
	Qualifiedidentifier() IQualifiedidentifierContext

	// IsSelectorContext differentiates from other interfaces.
	IsSelectorContext()
}

type SelectorContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptySelectorContext() *SelectorContext {
	var p = new(SelectorContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = JSONFilterParserRULE_selector
	return p
}

func InitEmptySelectorContext(p *SelectorContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = JSONFilterParserRULE_selector
}

func (*SelectorContext) IsSelectorContext() {}

func NewSelectorContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *SelectorContext {
	var p = new(SelectorContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = JSONFilterParserRULE_selector

	return p
}

func (s *SelectorContext) GetParser() antlr.Parser { return s.parser }

func (s *SelectorContext) SEL_START() antlr.TerminalNode {
	return s.GetToken(JSONFilterParserSEL_START, 0)
}

func (s *SelectorContext) Qualifiedidentifier() IQualifiedidentifierContext {
	var t antlr.RuleContext
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IQualifiedidentifierContext); ok {
			t = ctx.(antlr.RuleContext)
			break
		}
	}

	if t == nil {
		return nil
	}

	return t.(IQualifiedidentifierContext)
}

func (s *SelectorContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *SelectorContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *SelectorContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case JSONFilterVisitor:
		return t.VisitSelector(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *JSONFilterParser) Selector() (localctx ISelectorContext) {
	localctx = NewSelectorContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 8, JSONFilterParserRULE_selector)
	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(49)
		p.Match(JSONFilterParserSEL_START)
		if p.HasError() {
			// Recognition error - abort rule
			goto errorExit
		}
	}
	{
		p.SetState(50)
		p.Qualifiedidentifier()
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.ExitRule()
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

// IQualifiedidentifierContext is an interface to support dynamic dispatch.
type IQualifiedidentifierContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// Getter signatures
	AllMember() []IMemberContext
	Member(i int) IMemberContext
	AllDOT() []antlr.TerminalNode
	DOT(i int) antlr.TerminalNode

	// IsQualifiedidentifierContext differentiates from other interfaces.
	IsQualifiedidentifierContext()
}

type QualifiedidentifierContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyQualifiedidentifierContext() *QualifiedidentifierContext {
	var p = new(QualifiedidentifierContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = JSONFilterParserRULE_qualifiedidentifier
	return p
}

func InitEmptyQualifiedidentifierContext(p *QualifiedidentifierContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = JSONFilterParserRULE_qualifiedidentifier
}

func (*QualifiedidentifierContext) IsQualifiedidentifierContext() {}

func NewQualifiedidentifierContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *QualifiedidentifierContext {
	var p = new(QualifiedidentifierContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = JSONFilterParserRULE_qualifiedidentifier

	return p
}

func (s *QualifiedidentifierContext) GetParser() antlr.Parser { return s.parser }

func (s *QualifiedidentifierContext) AllMember() []IMemberContext {
	children := s.GetChildren()
	len := 0
	for _, ctx := range children {
		if _, ok := ctx.(IMemberContext); ok {
			len++
		}
	}

	tst := make([]IMemberContext, len)
	i := 0
	for _, ctx := range children {
		if t, ok := ctx.(IMemberContext); ok {
			tst[i] = t.(IMemberContext)
			i++
		}
	}

	return tst
}

func (s *QualifiedidentifierContext) Member(i int) IMemberContext {
	var t antlr.RuleContext
	j := 0
	for _, ctx := range s.GetChildren() {
		if _, ok := ctx.(IMemberContext); ok {
			if j == i {
				t = ctx.(antlr.RuleContext)
				break
			}
			j++
		}
	}

	if t == nil {
		return nil
	}

	return t.(IMemberContext)
}

func (s *QualifiedidentifierContext) AllDOT() []antlr.TerminalNode {
	return s.GetTokens(JSONFilterParserDOT)
}

func (s *QualifiedidentifierContext) DOT(i int) antlr.TerminalNode {
	return s.GetToken(JSONFilterParserDOT, i)
}

func (s *QualifiedidentifierContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *QualifiedidentifierContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *QualifiedidentifierContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case JSONFilterVisitor:
		return t.VisitQualifiedidentifier(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *JSONFilterParser) Qualifiedidentifier() (localctx IQualifiedidentifierContext) {
	localctx = NewQualifiedidentifierContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 10, JSONFilterParserRULE_qualifiedidentifier)
	var _alt int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(52)
		p.Member()
	}
	p.SetState(57)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}
	_alt = p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 4, p.GetParserRuleContext())
	if p.HasError() {
		goto errorExit
	}
	for _alt != 2 && _alt != antlr.ATNInvalidAltNumber {
		if _alt == 1 {
			{
				p.SetState(53)
				p.Match(JSONFilterParserDOT)
				if p.HasError() {
					// Recognition error - abort rule
					goto errorExit
				}
			}
			{
				p.SetState(54)
				p.Member()
			}

		}
		p.SetState(59)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_alt = p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 4, p.GetParserRuleContext())
		if p.HasError() {
			goto errorExit
		}
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.ExitRule()
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

// IMemberContext is an interface to support dynamic dispatch.
type IMemberContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// Getter signatures
	INDENTIFIER() antlr.TerminalNode
	AllLBRACKET() []antlr.TerminalNode
	LBRACKET(i int) antlr.TerminalNode
	AllNUMBER() []antlr.TerminalNode
	NUMBER(i int) antlr.TerminalNode
	AllRBRACKET() []antlr.TerminalNode
	RBRACKET(i int) antlr.TerminalNode

	// IsMemberContext differentiates from other interfaces.
	IsMemberContext()
}

type MemberContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyMemberContext() *MemberContext {
	var p = new(MemberContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = JSONFilterParserRULE_member
	return p
}

func InitEmptyMemberContext(p *MemberContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = JSONFilterParserRULE_member
}

func (*MemberContext) IsMemberContext() {}

func NewMemberContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *MemberContext {
	var p = new(MemberContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = JSONFilterParserRULE_member

	return p
}

func (s *MemberContext) GetParser() antlr.Parser { return s.parser }

func (s *MemberContext) INDENTIFIER() antlr.TerminalNode {
	return s.GetToken(JSONFilterParserINDENTIFIER, 0)
}

func (s *MemberContext) AllLBRACKET() []antlr.TerminalNode {
	return s.GetTokens(JSONFilterParserLBRACKET)
}

func (s *MemberContext) LBRACKET(i int) antlr.TerminalNode {
	return s.GetToken(JSONFilterParserLBRACKET, i)
}

func (s *MemberContext) AllNUMBER() []antlr.TerminalNode {
	return s.GetTokens(JSONFilterParserNUMBER)
}

func (s *MemberContext) NUMBER(i int) antlr.TerminalNode {
	return s.GetToken(JSONFilterParserNUMBER, i)
}

func (s *MemberContext) AllRBRACKET() []antlr.TerminalNode {
	return s.GetTokens(JSONFilterParserRBRACKET)
}

func (s *MemberContext) RBRACKET(i int) antlr.TerminalNode {
	return s.GetToken(JSONFilterParserRBRACKET, i)
}

func (s *MemberContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *MemberContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *MemberContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case JSONFilterVisitor:
		return t.VisitMember(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *JSONFilterParser) Member() (localctx IMemberContext) {
	localctx = NewMemberContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 12, JSONFilterParserRULE_member)
	var _alt int

	p.SetState(69)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 6, p.GetParserRuleContext()) {
	case 1:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(60)
			p.Match(JSONFilterParserINDENTIFIER)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 2:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(61)
			p.Match(JSONFilterParserINDENTIFIER)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}
		p.SetState(65)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_alt = 1
		for ok := true; ok; ok = _alt != 2 && _alt != antlr.ATNInvalidAltNumber {
			switch _alt {
			case 1:
				{
					p.SetState(62)
					p.Match(JSONFilterParserLBRACKET)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(63)
					p.Match(JSONFilterParserNUMBER)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(64)
					p.Match(JSONFilterParserRBRACKET)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}

			default:
				p.SetError(antlr.NewNoViableAltException(p, nil, nil, nil, nil, nil))
				goto errorExit
			}

			p.SetState(67)
			p.GetErrorHandler().Sync(p)
			_alt = p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 5, p.GetParserRuleContext())
			if p.HasError() {
				goto errorExit
			}
		}

	case antlr.ATNInvalidAltNumber:
		goto errorExit
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.ExitRule()
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

// IOperatorContext is an interface to support dynamic dispatch.
type IOperatorContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// Getter signatures
	EQUALS() antlr.TerminalNode
	NOT_EQUALS() antlr.TerminalNode
	IS() antlr.TerminalNode
	NOT() antlr.TerminalNode
	GT() antlr.TerminalNode
	LT() antlr.TerminalNode
	GE() antlr.TerminalNode
	LE() antlr.TerminalNode

	// IsOperatorContext differentiates from other interfaces.
	IsOperatorContext()
}

type OperatorContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyOperatorContext() *OperatorContext {
	var p = new(OperatorContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = JSONFilterParserRULE_operator
	return p
}

func InitEmptyOperatorContext(p *OperatorContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = JSONFilterParserRULE_operator
}

func (*OperatorContext) IsOperatorContext() {}

func NewOperatorContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *OperatorContext {
	var p = new(OperatorContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = JSONFilterParserRULE_operator

	return p
}

func (s *OperatorContext) GetParser() antlr.Parser { return s.parser }

func (s *OperatorContext) EQUALS() antlr.TerminalNode {
	return s.GetToken(JSONFilterParserEQUALS, 0)
}

func (s *OperatorContext) NOT_EQUALS() antlr.TerminalNode {
	return s.GetToken(JSONFilterParserNOT_EQUALS, 0)
}

func (s *OperatorContext) IS() antlr.TerminalNode {
	return s.GetToken(JSONFilterParserIS, 0)
}

func (s *OperatorContext) NOT() antlr.TerminalNode {
	return s.GetToken(JSONFilterParserNOT, 0)
}

func (s *OperatorContext) GT() antlr.TerminalNode {
	return s.GetToken(JSONFilterParserGT, 0)
}

func (s *OperatorContext) LT() antlr.TerminalNode {
	return s.GetToken(JSONFilterParserLT, 0)
}

func (s *OperatorContext) GE() antlr.TerminalNode {
	return s.GetToken(JSONFilterParserGE, 0)
}

func (s *OperatorContext) LE() antlr.TerminalNode {
	return s.GetToken(JSONFilterParserLE, 0)
}

func (s *OperatorContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *OperatorContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *OperatorContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case JSONFilterVisitor:
		return t.VisitOperator(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *JSONFilterParser) Operator() (localctx IOperatorContext) {
	localctx = NewOperatorContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 14, JSONFilterParserRULE_operator)
	var _la int

	p.EnterOuterAlt(localctx, 1)
	{
		p.SetState(71)
		_la = p.GetTokenStream().LA(1)

		if !((int64(_la) & ^0x3f) == 0 && ((int64(1)<<_la)&1044480) != 0) {
			p.GetErrorHandler().RecoverInline(p)
		} else {
			p.GetErrorHandler().ReportMatch(p)
			p.Consume()
		}
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.ExitRule()
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

// ILiteralContext is an interface to support dynamic dispatch.
type ILiteralContext interface {
	antlr.ParserRuleContext

	// GetParser returns the parser.
	GetParser() antlr.Parser

	// Getter signatures
	AllNUMBER() []antlr.TerminalNode
	NUMBER(i int) antlr.TerminalNode
	AllDOT() []antlr.TerminalNode
	DOT(i int) antlr.TerminalNode
	AllSTAR() []antlr.TerminalNode
	STAR(i int) antlr.TerminalNode
	STRING() antlr.TerminalNode
	NULL() antlr.TerminalNode
	EXISTS() antlr.TerminalNode
	TRUE() antlr.TerminalNode
	FALSE() antlr.TerminalNode
	INDENTIFIER() antlr.TerminalNode

	// IsLiteralContext differentiates from other interfaces.
	IsLiteralContext()
}

type LiteralContext struct {
	antlr.BaseParserRuleContext
	parser antlr.Parser
}

func NewEmptyLiteralContext() *LiteralContext {
	var p = new(LiteralContext)
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = JSONFilterParserRULE_literal
	return p
}

func InitEmptyLiteralContext(p *LiteralContext) {
	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, nil, -1)
	p.RuleIndex = JSONFilterParserRULE_literal
}

func (*LiteralContext) IsLiteralContext() {}

func NewLiteralContext(parser antlr.Parser, parent antlr.ParserRuleContext, invokingState int) *LiteralContext {
	var p = new(LiteralContext)

	antlr.InitBaseParserRuleContext(&p.BaseParserRuleContext, parent, invokingState)

	p.parser = parser
	p.RuleIndex = JSONFilterParserRULE_literal

	return p
}

func (s *LiteralContext) GetParser() antlr.Parser { return s.parser }

func (s *LiteralContext) AllNUMBER() []antlr.TerminalNode {
	return s.GetTokens(JSONFilterParserNUMBER)
}

func (s *LiteralContext) NUMBER(i int) antlr.TerminalNode {
	return s.GetToken(JSONFilterParserNUMBER, i)
}

func (s *LiteralContext) AllDOT() []antlr.TerminalNode {
	return s.GetTokens(JSONFilterParserDOT)
}

func (s *LiteralContext) DOT(i int) antlr.TerminalNode {
	return s.GetToken(JSONFilterParserDOT, i)
}

func (s *LiteralContext) AllSTAR() []antlr.TerminalNode {
	return s.GetTokens(JSONFilterParserSTAR)
}

func (s *LiteralContext) STAR(i int) antlr.TerminalNode {
	return s.GetToken(JSONFilterParserSTAR, i)
}

func (s *LiteralContext) STRING() antlr.TerminalNode {
	return s.GetToken(JSONFilterParserSTRING, 0)
}

func (s *LiteralContext) NULL() antlr.TerminalNode {
	return s.GetToken(JSONFilterParserNULL, 0)
}

func (s *LiteralContext) EXISTS() antlr.TerminalNode {
	return s.GetToken(JSONFilterParserEXISTS, 0)
}

func (s *LiteralContext) TRUE() antlr.TerminalNode {
	return s.GetToken(JSONFilterParserTRUE, 0)
}

func (s *LiteralContext) FALSE() antlr.TerminalNode {
	return s.GetToken(JSONFilterParserFALSE, 0)
}

func (s *LiteralContext) INDENTIFIER() antlr.TerminalNode {
	return s.GetToken(JSONFilterParserINDENTIFIER, 0)
}

func (s *LiteralContext) GetRuleContext() antlr.RuleContext {
	return s
}

func (s *LiteralContext) ToStringTree(ruleNames []string, recog antlr.Recognizer) string {
	return antlr.TreesStringTree(s, ruleNames, recog)
}

func (s *LiteralContext) Accept(visitor antlr.ParseTreeVisitor) interface{} {
	switch t := visitor.(type) {
	case JSONFilterVisitor:
		return t.VisitLiteral(s)

	default:
		return t.VisitChildren(s)
	}
}

func (p *JSONFilterParser) Literal() (localctx ILiteralContext) {
	localctx = NewLiteralContext(p, p.GetParserRuleContext(), p.GetState())
	p.EnterRule(localctx, 16, JSONFilterParserRULE_literal)
	var _la int

	var _alt int

	p.SetState(87)
	p.GetErrorHandler().Sync(p)
	if p.HasError() {
		goto errorExit
	}

	switch p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 8, p.GetParserRuleContext()) {
	case 1:
		p.EnterOuterAlt(localctx, 1)
		{
			p.SetState(73)
			p.Match(JSONFilterParserNUMBER)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}
		p.SetState(76)
		p.GetErrorHandler().Sync(p)
		if p.HasError() {
			goto errorExit
		}
		_alt = 1
		for ok := true; ok; ok = _alt != 2 && _alt != antlr.ATNInvalidAltNumber {
			switch _alt {
			case 1:
				{
					p.SetState(74)
					p.Match(JSONFilterParserDOT)
					if p.HasError() {
						// Recognition error - abort rule
						goto errorExit
					}
				}
				{
					p.SetState(75)
					_la = p.GetTokenStream().LA(1)

					if !(_la == JSONFilterParserSTAR || _la == JSONFilterParserNUMBER) {
						p.GetErrorHandler().RecoverInline(p)
					} else {
						p.GetErrorHandler().ReportMatch(p)
						p.Consume()
					}
				}

			default:
				p.SetError(antlr.NewNoViableAltException(p, nil, nil, nil, nil, nil))
				goto errorExit
			}

			p.SetState(78)
			p.GetErrorHandler().Sync(p)
			_alt = p.GetInterpreter().AdaptivePredict(p.BaseParser, p.GetTokenStream(), 7, p.GetParserRuleContext())
			if p.HasError() {
				goto errorExit
			}
		}

	case 2:
		p.EnterOuterAlt(localctx, 2)
		{
			p.SetState(80)
			p.Match(JSONFilterParserSTRING)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 3:
		p.EnterOuterAlt(localctx, 3)
		{
			p.SetState(81)
			p.Match(JSONFilterParserNUMBER)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 4:
		p.EnterOuterAlt(localctx, 4)
		{
			p.SetState(82)
			p.Match(JSONFilterParserNULL)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 5:
		p.EnterOuterAlt(localctx, 5)
		{
			p.SetState(83)
			p.Match(JSONFilterParserEXISTS)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 6:
		p.EnterOuterAlt(localctx, 6)
		{
			p.SetState(84)
			p.Match(JSONFilterParserTRUE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 7:
		p.EnterOuterAlt(localctx, 7)
		{
			p.SetState(85)
			p.Match(JSONFilterParserFALSE)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case 8:
		p.EnterOuterAlt(localctx, 8)
		{
			p.SetState(86)
			p.Match(JSONFilterParserINDENTIFIER)
			if p.HasError() {
				// Recognition error - abort rule
				goto errorExit
			}
		}

	case antlr.ATNInvalidAltNumber:
		goto errorExit
	}

errorExit:
	if p.HasError() {
		v := p.GetError()
		localctx.SetException(v)
		p.GetErrorHandler().ReportError(p, v)
		p.GetErrorHandler().Recover(p, v)
		p.SetError(nil)
	}
	p.ExitRule()
	return localctx
	goto errorExit // Trick to prevent compiler error if the label is not used
}

func (p *JSONFilterParser) Sempred(localctx antlr.RuleContext, ruleIndex, predIndex int) bool {
	switch ruleIndex {
	case 2:
		var t *Filter_exprContext = nil
		if localctx != nil {
			t = localctx.(*Filter_exprContext)
		}
		return p.Filter_expr_Sempred(t, predIndex)

	default:
		panic("No predicate with index: " + fmt.Sprint(ruleIndex))
	}
}

func (p *JSONFilterParser) Filter_expr_Sempred(localctx antlr.RuleContext, predIndex int) bool {
	switch predIndex {
	case 0:
		return p.Precpred(p.GetParserRuleContext(), 3)

	case 1:
		return p.Precpred(p.GetParserRuleContext(), 2)

	default:
		panic("No predicate with index: " + fmt.Sprint(predIndex))
	}
}
