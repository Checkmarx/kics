// Code generated from JSONFilter.g4 by ANTLR 4.13.1. DO NOT EDIT.

package parser // JSONFilter

import "github.com/antlr4-go/antlr/v4"

// A complete Visitor for a parse tree produced by JSONFilterParser.
type JSONFilterVisitor interface {
	antlr.ParseTreeVisitor

	// Visit a parse tree produced by JSONFilterParser#awsjsonfilter.
	VisitAwsjsonfilter(ctx *AwsjsonfilterContext) interface{}

	// Visit a parse tree produced by JSONFilterParser#dotnotation.
	VisitDotnotation(ctx *DotnotationContext) interface{}

	// Visit a parse tree produced by JSONFilterParser#filter_expr_parenthesized.
	VisitFilter_expr_parenthesized(ctx *Filter_expr_parenthesizedContext) interface{}

	// Visit a parse tree produced by JSONFilterParser#filter_expr_and.
	VisitFilter_expr_and(ctx *Filter_expr_andContext) interface{}

	// Visit a parse tree produced by JSONFilterParser#filter_expr_exp.
	VisitFilter_expr_exp(ctx *Filter_expr_expContext) interface{}

	// Visit a parse tree produced by JSONFilterParser#filter_expr_or.
	VisitFilter_expr_or(ctx *Filter_expr_orContext) interface{}

	// Visit a parse tree produced by JSONFilterParser#exp.
	VisitExp(ctx *ExpContext) interface{}

	// Visit a parse tree produced by JSONFilterParser#selector.
	VisitSelector(ctx *SelectorContext) interface{}

	// Visit a parse tree produced by JSONFilterParser#qualifiedidentifier.
	VisitQualifiedidentifier(ctx *QualifiedidentifierContext) interface{}

	// Visit a parse tree produced by JSONFilterParser#member.
	VisitMember(ctx *MemberContext) interface{}

	// Visit a parse tree produced by JSONFilterParser#operator.
	VisitOperator(ctx *OperatorContext) interface{}

	// Visit a parse tree produced by JSONFilterParser#literal.
	VisitLiteral(ctx *LiteralContext) interface{}
}
