// Code generated from JSONFilter.g4 by ANTLR 4.7.2. DO NOT EDIT.

package parser // JSONFilter

import "github.com/antlr/antlr4/runtime/Go/antlr"

// BaseJSONFilterListener is a complete listener for a parse tree produced by JSONFilterParser.
type BaseJSONFilterListener struct{}

var _ JSONFilterListener = &BaseJSONFilterListener{}

// VisitTerminal is called when a terminal node is visited.
func (s *BaseJSONFilterListener) VisitTerminal(node antlr.TerminalNode) {}

// VisitErrorNode is called when an error node is visited.
func (s *BaseJSONFilterListener) VisitErrorNode(node antlr.ErrorNode) {}

// EnterEveryRule is called when any rule is entered.
func (s *BaseJSONFilterListener) EnterEveryRule(ctx antlr.ParserRuleContext) {}

// ExitEveryRule is called when any rule is exited.
func (s *BaseJSONFilterListener) ExitEveryRule(ctx antlr.ParserRuleContext) {}

// EnterAwsjsonfilter is called when production awsjsonfilter is entered.
func (s *BaseJSONFilterListener) EnterAwsjsonfilter(ctx *AwsjsonfilterContext) {}

// ExitAwsjsonfilter is called when production awsjsonfilter is exited.
func (s *BaseJSONFilterListener) ExitAwsjsonfilter(ctx *AwsjsonfilterContext) {}

// EnterDotnotation is called when production dotnotation is entered.
func (s *BaseJSONFilterListener) EnterDotnotation(ctx *DotnotationContext) {}

// ExitDotnotation is called when production dotnotation is exited.
func (s *BaseJSONFilterListener) ExitDotnotation(ctx *DotnotationContext) {}

// EnterFilter_expr_parenthesized is called when production filter_expr_parenthesized is entered.
func (s *BaseJSONFilterListener) EnterFilter_expr_parenthesized(ctx *Filter_expr_parenthesizedContext) {
}

// ExitFilter_expr_parenthesized is called when production filter_expr_parenthesized is exited.
func (s *BaseJSONFilterListener) ExitFilter_expr_parenthesized(ctx *Filter_expr_parenthesizedContext) {
}

// EnterFilter_expr_and is called when production filter_expr_and is entered.
func (s *BaseJSONFilterListener) EnterFilter_expr_and(ctx *Filter_expr_andContext) {}

// ExitFilter_expr_and is called when production filter_expr_and is exited.
func (s *BaseJSONFilterListener) ExitFilter_expr_and(ctx *Filter_expr_andContext) {}

// EnterFilter_expr_exp is called when production filter_expr_exp is entered.
func (s *BaseJSONFilterListener) EnterFilter_expr_exp(ctx *Filter_expr_expContext) {}

// ExitFilter_expr_exp is called when production filter_expr_exp is exited.
func (s *BaseJSONFilterListener) ExitFilter_expr_exp(ctx *Filter_expr_expContext) {}

// EnterFilter_expr_or is called when production filter_expr_or is entered.
func (s *BaseJSONFilterListener) EnterFilter_expr_or(ctx *Filter_expr_orContext) {}

// ExitFilter_expr_or is called when production filter_expr_or is exited.
func (s *BaseJSONFilterListener) ExitFilter_expr_or(ctx *Filter_expr_orContext) {}

// EnterExp is called when production exp is entered.
func (s *BaseJSONFilterListener) EnterExp(ctx *ExpContext) {}

// ExitExp is called when production exp is exited.
func (s *BaseJSONFilterListener) ExitExp(ctx *ExpContext) {}

// EnterSelector is called when production selector is entered.
func (s *BaseJSONFilterListener) EnterSelector(ctx *SelectorContext) {}

// ExitSelector is called when production selector is exited.
func (s *BaseJSONFilterListener) ExitSelector(ctx *SelectorContext) {}

// EnterQualifiedidentifier is called when production qualifiedidentifier is entered.
func (s *BaseJSONFilterListener) EnterQualifiedidentifier(ctx *QualifiedidentifierContext) {}

// ExitQualifiedidentifier is called when production qualifiedidentifier is exited.
func (s *BaseJSONFilterListener) ExitQualifiedidentifier(ctx *QualifiedidentifierContext) {}

// EnterMember is called when production member is entered.
func (s *BaseJSONFilterListener) EnterMember(ctx *MemberContext) {}

// ExitMember is called when production member is exited.
func (s *BaseJSONFilterListener) ExitMember(ctx *MemberContext) {}

// EnterOperator is called when production operator is entered.
func (s *BaseJSONFilterListener) EnterOperator(ctx *OperatorContext) {}

// ExitOperator is called when production operator is exited.
func (s *BaseJSONFilterListener) ExitOperator(ctx *OperatorContext) {}

// EnterLiteral is called when production literal is entered.
func (s *BaseJSONFilterListener) EnterLiteral(ctx *LiteralContext) {}

// ExitLiteral is called when production literal is exited.
func (s *BaseJSONFilterListener) ExitLiteral(ctx *LiteralContext) {}
