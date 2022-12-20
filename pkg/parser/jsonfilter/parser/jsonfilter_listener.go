// Code generated from JSONFilter.g4 by ANTLR 4.7.2. DO NOT EDIT.

package parser // JSONFilter

import "github.com/antlr/antlr4/runtime/Go/antlr"

// JSONFilterListener is a complete listener for a parse tree produced by JSONFilterParser.
type JSONFilterListener interface {
	antlr.ParseTreeListener

	// EnterAwsjsonfilter is called when entering the awsjsonfilter production.
	EnterAwsjsonfilter(c *AwsjsonfilterContext)

	// EnterDotnotation is called when entering the dotnotation production.
	EnterDotnotation(c *DotnotationContext)

	// EnterFilter_expr_parenthesized is called when entering the filter_expr_parenthesized production.
	EnterFilter_expr_parenthesized(c *Filter_expr_parenthesizedContext)

	// EnterFilter_expr_and is called when entering the filter_expr_and production.
	EnterFilter_expr_and(c *Filter_expr_andContext)

	// EnterFilter_expr_exp is called when entering the filter_expr_exp production.
	EnterFilter_expr_exp(c *Filter_expr_expContext)

	// EnterFilter_expr_or is called when entering the filter_expr_or production.
	EnterFilter_expr_or(c *Filter_expr_orContext)

	// EnterExp is called when entering the exp production.
	EnterExp(c *ExpContext)

	// EnterSelector is called when entering the selector production.
	EnterSelector(c *SelectorContext)

	// EnterQualifiedidentifier is called when entering the qualifiedidentifier production.
	EnterQualifiedidentifier(c *QualifiedidentifierContext)

	// EnterMember is called when entering the member production.
	EnterMember(c *MemberContext)

	// EnterOperator is called when entering the operator production.
	EnterOperator(c *OperatorContext)

	// EnterLiteral is called when entering the literal production.
	EnterLiteral(c *LiteralContext)

	// ExitAwsjsonfilter is called when exiting the awsjsonfilter production.
	ExitAwsjsonfilter(c *AwsjsonfilterContext)

	// ExitDotnotation is called when exiting the dotnotation production.
	ExitDotnotation(c *DotnotationContext)

	// ExitFilter_expr_parenthesized is called when exiting the filter_expr_parenthesized production.
	ExitFilter_expr_parenthesized(c *Filter_expr_parenthesizedContext)

	// ExitFilter_expr_and is called when exiting the filter_expr_and production.
	ExitFilter_expr_and(c *Filter_expr_andContext)

	// ExitFilter_expr_exp is called when exiting the filter_expr_exp production.
	ExitFilter_expr_exp(c *Filter_expr_expContext)

	// ExitFilter_expr_or is called when exiting the filter_expr_or production.
	ExitFilter_expr_or(c *Filter_expr_orContext)

	// ExitExp is called when exiting the exp production.
	ExitExp(c *ExpContext)

	// ExitSelector is called when exiting the selector production.
	ExitSelector(c *SelectorContext)

	// ExitQualifiedidentifier is called when exiting the qualifiedidentifier production.
	ExitQualifiedidentifier(c *QualifiedidentifierContext)

	// ExitMember is called when exiting the member production.
	ExitMember(c *MemberContext)

	// ExitOperator is called when exiting the operator production.
	ExitOperator(c *OperatorContext)

	// ExitLiteral is called when exiting the literal production.
	ExitLiteral(c *LiteralContext)
}
