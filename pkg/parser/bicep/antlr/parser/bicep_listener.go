// Code generated from bicep.g4 by ANTLR 4.13.1. DO NOT EDIT.

package parser // bicep

import "github.com/antlr4-go/antlr/v4"

// bicepListener is a complete listener for a parse tree produced by bicepParser.
type bicepListener interface {
	antlr.ParseTreeListener

	// EnterProgram is called when entering the program production.
	EnterProgram(c *ProgramContext)

	// EnterStatement is called when entering the statement production.
	EnterStatement(c *StatementContext)

	// EnterParameterDecl is called when entering the parameterDecl production.
	EnterParameterDecl(c *ParameterDeclContext)

	// EnterParameterDefaultValue is called when entering the parameterDefaultValue production.
	EnterParameterDefaultValue(c *ParameterDefaultValueContext)

	// EnterVariableDecl is called when entering the variableDecl production.
	EnterVariableDecl(c *VariableDeclContext)

	// EnterResourceDecl is called when entering the resourceDecl production.
	EnterResourceDecl(c *ResourceDeclContext)

	// EnterInterpString is called when entering the interpString production.
	EnterInterpString(c *InterpStringContext)

	// EnterExpression is called when entering the expression production.
	EnterExpression(c *ExpressionContext)

	// EnterPrimaryExpression is called when entering the primaryExpression production.
	EnterPrimaryExpression(c *PrimaryExpressionContext)

	// EnterParenthesizedExpression is called when entering the parenthesizedExpression production.
	EnterParenthesizedExpression(c *ParenthesizedExpressionContext)

	// EnterTypeExpression is called when entering the typeExpression production.
	EnterTypeExpression(c *TypeExpressionContext)

	// EnterLiteralValue is called when entering the literalValue production.
	EnterLiteralValue(c *LiteralValueContext)

	// EnterObject is called when entering the object production.
	EnterObject(c *ObjectContext)

	// EnterObjectProperty is called when entering the objectProperty production.
	EnterObjectProperty(c *ObjectPropertyContext)

	// EnterArray is called when entering the array production.
	EnterArray(c *ArrayContext)

	// EnterArrayItem is called when entering the arrayItem production.
	EnterArrayItem(c *ArrayItemContext)

	// EnterDecorator is called when entering the decorator production.
	EnterDecorator(c *DecoratorContext)

	// EnterDecoratorExpression is called when entering the decoratorExpression production.
	EnterDecoratorExpression(c *DecoratorExpressionContext)

	// EnterFunctionCall is called when entering the functionCall production.
	EnterFunctionCall(c *FunctionCallContext)

	// EnterArgumentList is called when entering the argumentList production.
	EnterArgumentList(c *ArgumentListContext)

	// EnterIdentifier is called when entering the identifier production.
	EnterIdentifier(c *IdentifierContext)

	// ExitProgram is called when exiting the program production.
	ExitProgram(c *ProgramContext)

	// ExitStatement is called when exiting the statement production.
	ExitStatement(c *StatementContext)

	// ExitParameterDecl is called when exiting the parameterDecl production.
	ExitParameterDecl(c *ParameterDeclContext)

	// ExitParameterDefaultValue is called when exiting the parameterDefaultValue production.
	ExitParameterDefaultValue(c *ParameterDefaultValueContext)

	// ExitVariableDecl is called when exiting the variableDecl production.
	ExitVariableDecl(c *VariableDeclContext)

	// ExitResourceDecl is called when exiting the resourceDecl production.
	ExitResourceDecl(c *ResourceDeclContext)

	// ExitInterpString is called when exiting the interpString production.
	ExitInterpString(c *InterpStringContext)

	// ExitExpression is called when exiting the expression production.
	ExitExpression(c *ExpressionContext)

	// ExitPrimaryExpression is called when exiting the primaryExpression production.
	ExitPrimaryExpression(c *PrimaryExpressionContext)

	// ExitParenthesizedExpression is called when exiting the parenthesizedExpression production.
	ExitParenthesizedExpression(c *ParenthesizedExpressionContext)

	// ExitTypeExpression is called when exiting the typeExpression production.
	ExitTypeExpression(c *TypeExpressionContext)

	// ExitLiteralValue is called when exiting the literalValue production.
	ExitLiteralValue(c *LiteralValueContext)

	// ExitObject is called when exiting the object production.
	ExitObject(c *ObjectContext)

	// ExitObjectProperty is called when exiting the objectProperty production.
	ExitObjectProperty(c *ObjectPropertyContext)

	// ExitArray is called when exiting the array production.
	ExitArray(c *ArrayContext)

	// ExitArrayItem is called when exiting the arrayItem production.
	ExitArrayItem(c *ArrayItemContext)

	// ExitDecorator is called when exiting the decorator production.
	ExitDecorator(c *DecoratorContext)

	// ExitDecoratorExpression is called when exiting the decoratorExpression production.
	ExitDecoratorExpression(c *DecoratorExpressionContext)

	// ExitFunctionCall is called when exiting the functionCall production.
	ExitFunctionCall(c *FunctionCallContext)

	// ExitArgumentList is called when exiting the argumentList production.
	ExitArgumentList(c *ArgumentListContext)

	// ExitIdentifier is called when exiting the identifier production.
	ExitIdentifier(c *IdentifierContext)
}
