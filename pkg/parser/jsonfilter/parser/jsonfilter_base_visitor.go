// Code generated from JSONFilter.g4 by ANTLR 4.13.1. DO NOT EDIT.

package parser // JSONFilter

import "github.com/antlr4-go/antlr/v4"

type BaseJSONFilterVisitor struct {
	*antlr.BaseParseTreeVisitor
}

func (v *BaseJSONFilterVisitor) VisitAwsjsonfilter(ctx *AwsjsonfilterContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BaseJSONFilterVisitor) VisitDotnotation(ctx *DotnotationContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BaseJSONFilterVisitor) VisitFilter_expr_parenthesized(ctx *Filter_expr_parenthesizedContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BaseJSONFilterVisitor) VisitFilter_expr_and(ctx *Filter_expr_andContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BaseJSONFilterVisitor) VisitFilter_expr_exp(ctx *Filter_expr_expContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BaseJSONFilterVisitor) VisitFilter_expr_or(ctx *Filter_expr_orContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BaseJSONFilterVisitor) VisitExp(ctx *ExpContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BaseJSONFilterVisitor) VisitSelector(ctx *SelectorContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BaseJSONFilterVisitor) VisitQualifiedidentifier(ctx *QualifiedidentifierContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BaseJSONFilterVisitor) VisitMember(ctx *MemberContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BaseJSONFilterVisitor) VisitOperator(ctx *OperatorContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BaseJSONFilterVisitor) VisitLiteral(ctx *LiteralContext) interface{} {
	return v.VisitChildren(ctx)
}
