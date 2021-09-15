package parser // JSONFilter

import (
	"github.com/antlr/antlr4/runtime/Go/antlr"
)

type JSONFilterTreeVisitor struct {
	*antlr.BaseParseTreeVisitor
}

type FilterNode map[string]interface{}

func NewJSONFilterPrinterVisitor() *JSONFilterTreeVisitor {
	return &JSONFilterTreeVisitor{
		&antlr.BaseParseTreeVisitor{},
	}
}

func (v *JSONFilterTreeVisitor) Visit(tree antlr.ParseTree) interface{} {
	return tree.Accept(v)
}

func (v *JSONFilterTreeVisitor) VisitChildren(node antlr.RuleNode) interface{} {
	children := node.GetChildren()
	for _, child := range children {
		child.(antlr.ParseTree).Accept(v)
	}
	return nil
}

func (v *JSONFilterTreeVisitor) VisitAwsjsonfilter(ctx *AwsjsonfilterContext) interface{} {
	return v.Visit(ctx.Dotnotation())
}

func (v *JSONFilterTreeVisitor) VisitDotnotation(ctx *DotnotationContext) interface{} {
	return v.Visit(ctx.Filter_expr())
}

func (v *JSONFilterTreeVisitor) VisitFilter_expr_parenthesized(ctx *Filter_expr_parenthesizedContext) interface{} {
	return v.Visit(ctx.Filter_expr())
}

func (v *JSONFilterTreeVisitor) VisitFilter_expr_and(ctx *Filter_expr_andContext) interface{} {
	return FilterNode{
		"_op":    "&&",
		"_left":  v.Visit(ctx.GetLhs()),
		"_right": v.Visit(ctx.GetRhs()),
	}
}

func (v *JSONFilterTreeVisitor) VisitFilter_expr_exp(ctx *Filter_expr_expContext) interface{} {
	return v.Visit(ctx.Exp())
}

func (v *JSONFilterTreeVisitor) VisitFilter_expr_or(ctx *Filter_expr_orContext) interface{} {
	return FilterNode{
		"_op":    "||",
		"_left":  v.Visit(ctx.GetLhs()),
		"_right": v.Visit(ctx.GetRhs()),
	}
}

func (v *JSONFilterTreeVisitor) VisitQualifiedidentifier(ctx *QualifiedidentifierContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *JSONFilterTreeVisitor) VisitExp(ctx *ExpContext) interface{} {
	var value interface{}
	if ctx.Literal() != nil {
		value = v.Visit(ctx.Literal())
	} else {
		value = v.Visit(ctx.Qualifiedidentifier())
	}

	return FilterNode{
		"_selector": v.Visit(ctx.Selector()),
		"_op":       v.Visit(ctx.Operator()),
		"_value":    value,
	}
}

func (v *JSONFilterTreeVisitor) VisitSelector(ctx *SelectorContext) interface{} {
	return ctx.GetText()
}

func (v *JSONFilterTreeVisitor) VisitMember(ctx *MemberContext) interface{} {
	return ctx.GetText()
}

func (v *JSONFilterTreeVisitor) VisitOperator(ctx *OperatorContext) interface{} {
	return ctx.GetText()
}

func (v *JSONFilterTreeVisitor) VisitLiteral(ctx *LiteralContext) interface{} {
	return ctx.GetText()
}
