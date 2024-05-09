// Code generated from bicep.g4 by ANTLR 4.13.1. DO NOT EDIT.

package parser // bicep

import "github.com/antlr4-go/antlr/v4"

type BasebicepVisitor struct {
	*antlr.BaseParseTreeVisitor
}

func (v *BasebicepVisitor) VisitProgram(ctx *ProgramContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitStatement(ctx *StatementContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitTargetScopeDecl(ctx *TargetScopeDeclContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitImportDecl(ctx *ImportDeclContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitMetadataDecl(ctx *MetadataDeclContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitParameterDecl(ctx *ParameterDeclContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitParameterDefaultValue(ctx *ParameterDefaultValueContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitTypeDecl(ctx *TypeDeclContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitVariableDecl(ctx *VariableDeclContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitResourceDecl(ctx *ResourceDeclContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitModuleDecl(ctx *ModuleDeclContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitOutputDecl(ctx *OutputDeclContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitIfCondition(ctx *IfConditionContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitForExpression(ctx *ForExpressionContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitForVariableBlock(ctx *ForVariableBlockContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitForBody(ctx *ForBodyContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitInterpString(ctx *InterpStringContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitExpression(ctx *ExpressionContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitLambdaExpression(ctx *LambdaExpressionContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitLogicCharacter(ctx *LogicCharacterContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitPrimaryExpression(ctx *PrimaryExpressionContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitParenthesizedExpression(ctx *ParenthesizedExpressionContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitTypeExpression(ctx *TypeExpressionContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitLiteralValue(ctx *LiteralValueContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitObject(ctx *ObjectContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitObjectProperty(ctx *ObjectPropertyContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitArray(ctx *ArrayContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitArrayItem(ctx *ArrayItemContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitDecorator(ctx *DecoratorContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitDecoratorExpression(ctx *DecoratorExpressionContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitFunctionCall(ctx *FunctionCallContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitArgumentList(ctx *ArgumentListContext) interface{} {
	return v.VisitChildren(ctx)
}

func (v *BasebicepVisitor) VisitIdentifier(ctx *IdentifierContext) interface{} {
	return v.VisitChildren(ctx)
}
