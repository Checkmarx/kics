package parser // JSONFilter

import (
	"github.com/antlr4-go/antlr/v4"
)

const (
	AND = "&&"
	OR  = "||"
)

type AWSJSONFilter struct {
	FilterExpression interface{} `json:"_kics_filter_expr"`
}

type FilterExp struct {
	Op    interface{} `json:"_op"`
	Left  interface{} `json:"_left"`
	Right interface{} `json:"_right"`
}

type FilterSelector struct {
	Selector interface{} `json:"_selector"`
	Op       interface{} `json:"_op"`
	Value    interface{} `json:"_value"`
}

type JSONFilterTreeVisitor struct {
	*antlr.BaseParseTreeVisitor
}

func NewJSONFilterPrinterVisitor() *JSONFilterTreeVisitor {
	return &JSONFilterTreeVisitor{
		&antlr.BaseParseTreeVisitor{},
	}
}

func (v *JSONFilterTreeVisitor) VisitAll(tree antlr.ParseTree) AWSJSONFilter {
	return AWSJSONFilter{
		FilterExpression: v.Visit(tree),
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
	return FilterExp{
		Op:    AND,
		Left:  v.Visit(ctx.GetLhs()),
		Right: v.Visit(ctx.GetRhs()),
	}
}

func (v *JSONFilterTreeVisitor) VisitFilter_expr_exp(ctx *Filter_expr_expContext) interface{} {
	return v.Visit(ctx.Exp())
}

func (v *JSONFilterTreeVisitor) VisitFilter_expr_or(ctx *Filter_expr_orContext) interface{} {
	return FilterExp{
		Op:    OR,
		Left:  v.Visit(ctx.GetLhs()),
		Right: v.Visit(ctx.GetRhs()),
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
	selector := FilterSelector{
		Selector: v.Visit(ctx.Selector()),
		Op:       v.Visit(ctx.Operator()),
		Value:    value,
	}

	return selector
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
