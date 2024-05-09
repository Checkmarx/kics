// Code generated from bicep.g4 by ANTLR 4.13.1. DO NOT EDIT.

package parser // bicep

import "github.com/antlr4-go/antlr/v4"

// A complete Visitor for a parse tree produced by bicepParser.
type bicepVisitor interface {
	antlr.ParseTreeVisitor

	// Visit a parse tree produced by bicepParser#program.
	VisitProgram(ctx *ProgramContext) interface{}

	// Visit a parse tree produced by bicepParser#statement.
	VisitStatement(ctx *StatementContext) interface{}

	// Visit a parse tree produced by bicepParser#targetScopeDecl.
	VisitTargetScopeDecl(ctx *TargetScopeDeclContext) interface{}

	// Visit a parse tree produced by bicepParser#importDecl.
	VisitImportDecl(ctx *ImportDeclContext) interface{}

	// Visit a parse tree produced by bicepParser#metadataDecl.
	VisitMetadataDecl(ctx *MetadataDeclContext) interface{}

	// Visit a parse tree produced by bicepParser#parameterDecl.
	VisitParameterDecl(ctx *ParameterDeclContext) interface{}

	// Visit a parse tree produced by bicepParser#parameterDefaultValue.
	VisitParameterDefaultValue(ctx *ParameterDefaultValueContext) interface{}

	// Visit a parse tree produced by bicepParser#typeDecl.
	VisitTypeDecl(ctx *TypeDeclContext) interface{}

	// Visit a parse tree produced by bicepParser#variableDecl.
	VisitVariableDecl(ctx *VariableDeclContext) interface{}

	// Visit a parse tree produced by bicepParser#resourceDecl.
	VisitResourceDecl(ctx *ResourceDeclContext) interface{}

	// Visit a parse tree produced by bicepParser#moduleDecl.
	VisitModuleDecl(ctx *ModuleDeclContext) interface{}

	// Visit a parse tree produced by bicepParser#outputDecl.
	VisitOutputDecl(ctx *OutputDeclContext) interface{}

	// Visit a parse tree produced by bicepParser#ifCondition.
	VisitIfCondition(ctx *IfConditionContext) interface{}

	// Visit a parse tree produced by bicepParser#forExpression.
	VisitForExpression(ctx *ForExpressionContext) interface{}

	// Visit a parse tree produced by bicepParser#forVariableBlock.
	VisitForVariableBlock(ctx *ForVariableBlockContext) interface{}

	// Visit a parse tree produced by bicepParser#forBody.
	VisitForBody(ctx *ForBodyContext) interface{}

	// Visit a parse tree produced by bicepParser#interpString.
	VisitInterpString(ctx *InterpStringContext) interface{}

	// Visit a parse tree produced by bicepParser#expression.
	VisitExpression(ctx *ExpressionContext) interface{}

	// Visit a parse tree produced by bicepParser#lambdaExpression.
	VisitLambdaExpression(ctx *LambdaExpressionContext) interface{}

	// Visit a parse tree produced by bicepParser#logicCharacter.
	VisitLogicCharacter(ctx *LogicCharacterContext) interface{}

	// Visit a parse tree produced by bicepParser#primaryExpression.
	VisitPrimaryExpression(ctx *PrimaryExpressionContext) interface{}

	// Visit a parse tree produced by bicepParser#parenthesizedExpression.
	VisitParenthesizedExpression(ctx *ParenthesizedExpressionContext) interface{}

	// Visit a parse tree produced by bicepParser#typeExpression.
	VisitTypeExpression(ctx *TypeExpressionContext) interface{}

	// Visit a parse tree produced by bicepParser#literalValue.
	VisitLiteralValue(ctx *LiteralValueContext) interface{}

	// Visit a parse tree produced by bicepParser#object.
	VisitObject(ctx *ObjectContext) interface{}

	// Visit a parse tree produced by bicepParser#objectProperty.
	VisitObjectProperty(ctx *ObjectPropertyContext) interface{}

	// Visit a parse tree produced by bicepParser#array.
	VisitArray(ctx *ArrayContext) interface{}

	// Visit a parse tree produced by bicepParser#arrayItem.
	VisitArrayItem(ctx *ArrayItemContext) interface{}

	// Visit a parse tree produced by bicepParser#decorator.
	VisitDecorator(ctx *DecoratorContext) interface{}

	// Visit a parse tree produced by bicepParser#decoratorExpression.
	VisitDecoratorExpression(ctx *DecoratorExpressionContext) interface{}

	// Visit a parse tree produced by bicepParser#functionCall.
	VisitFunctionCall(ctx *FunctionCallContext) interface{}

	// Visit a parse tree produced by bicepParser#argumentList.
	VisitArgumentList(ctx *ArgumentListContext) interface{}

	// Visit a parse tree produced by bicepParser#identifier.
	VisitIdentifier(ctx *IdentifierContext) interface{}
}
