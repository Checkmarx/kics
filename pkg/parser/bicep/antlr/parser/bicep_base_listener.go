// Code generated from bicep.g4 by ANTLR 4.13.1. DO NOT EDIT.

package parser // bicep

import "github.com/antlr4-go/antlr/v4"

// BasebicepListener is a complete listener for a parse tree produced by bicepParser.
type BasebicepListener struct{}

var _ bicepListener = &BasebicepListener{}

// VisitTerminal is called when a terminal node is visited.
func (s *BasebicepListener) VisitTerminal(node antlr.TerminalNode) {}

// VisitErrorNode is called when an error node is visited.
func (s *BasebicepListener) VisitErrorNode(node antlr.ErrorNode) {}

// EnterEveryRule is called when any rule is entered.
func (s *BasebicepListener) EnterEveryRule(ctx antlr.ParserRuleContext) {}

// ExitEveryRule is called when any rule is exited.
func (s *BasebicepListener) ExitEveryRule(ctx antlr.ParserRuleContext) {}

// EnterProgram is called when production program is entered.
func (s *BasebicepListener) EnterProgram(ctx *ProgramContext) {}

// ExitProgram is called when production program is exited.
func (s *BasebicepListener) ExitProgram(ctx *ProgramContext) {}

// EnterStatement is called when production statement is entered.
func (s *BasebicepListener) EnterStatement(ctx *StatementContext) {}

// ExitStatement is called when production statement is exited.
func (s *BasebicepListener) ExitStatement(ctx *StatementContext) {}

// EnterParameterDecl is called when production parameterDecl is entered.
func (s *BasebicepListener) EnterParameterDecl(ctx *ParameterDeclContext) {}

// ExitParameterDecl is called when production parameterDecl is exited.
func (s *BasebicepListener) ExitParameterDecl(ctx *ParameterDeclContext) {}

// EnterParameterDefaultValue is called when production parameterDefaultValue is entered.
func (s *BasebicepListener) EnterParameterDefaultValue(ctx *ParameterDefaultValueContext) {}

// ExitParameterDefaultValue is called when production parameterDefaultValue is exited.
func (s *BasebicepListener) ExitParameterDefaultValue(ctx *ParameterDefaultValueContext) {}

// EnterVariableDecl is called when production variableDecl is entered.
func (s *BasebicepListener) EnterVariableDecl(ctx *VariableDeclContext) {}

// ExitVariableDecl is called when production variableDecl is exited.
func (s *BasebicepListener) ExitVariableDecl(ctx *VariableDeclContext) {}

// EnterResourceDecl is called when production resourceDecl is entered.
func (s *BasebicepListener) EnterResourceDecl(ctx *ResourceDeclContext) {}

// ExitResourceDecl is called when production resourceDecl is exited.
func (s *BasebicepListener) ExitResourceDecl(ctx *ResourceDeclContext) {}

// EnterInterpString is called when production interpString is entered.
func (s *BasebicepListener) EnterInterpString(ctx *InterpStringContext) {}

// ExitInterpString is called when production interpString is exited.
func (s *BasebicepListener) ExitInterpString(ctx *InterpStringContext) {}

// EnterExpression is called when production expression is entered.
func (s *BasebicepListener) EnterExpression(ctx *ExpressionContext) {}

// ExitExpression is called when production expression is exited.
func (s *BasebicepListener) ExitExpression(ctx *ExpressionContext) {}

// EnterPrimaryExpression is called when production primaryExpression is entered.
func (s *BasebicepListener) EnterPrimaryExpression(ctx *PrimaryExpressionContext) {}

// ExitPrimaryExpression is called when production primaryExpression is exited.
func (s *BasebicepListener) ExitPrimaryExpression(ctx *PrimaryExpressionContext) {}

// EnterParenthesizedExpression is called when production parenthesizedExpression is entered.
func (s *BasebicepListener) EnterParenthesizedExpression(ctx *ParenthesizedExpressionContext) {}

// ExitParenthesizedExpression is called when production parenthesizedExpression is exited.
func (s *BasebicepListener) ExitParenthesizedExpression(ctx *ParenthesizedExpressionContext) {}

// EnterTypeExpression is called when production typeExpression is entered.
func (s *BasebicepListener) EnterTypeExpression(ctx *TypeExpressionContext) {}

// ExitTypeExpression is called when production typeExpression is exited.
func (s *BasebicepListener) ExitTypeExpression(ctx *TypeExpressionContext) {}

// EnterLiteralValue is called when production literalValue is entered.
func (s *BasebicepListener) EnterLiteralValue(ctx *LiteralValueContext) {}

// ExitLiteralValue is called when production literalValue is exited.
func (s *BasebicepListener) ExitLiteralValue(ctx *LiteralValueContext) {}

// EnterObject is called when production object is entered.
func (s *BasebicepListener) EnterObject(ctx *ObjectContext) {}

// ExitObject is called when production object is exited.
func (s *BasebicepListener) ExitObject(ctx *ObjectContext) {}

// EnterObjectProperty is called when production objectProperty is entered.
func (s *BasebicepListener) EnterObjectProperty(ctx *ObjectPropertyContext) {}

// ExitObjectProperty is called when production objectProperty is exited.
func (s *BasebicepListener) ExitObjectProperty(ctx *ObjectPropertyContext) {}

// EnterArray is called when production array is entered.
func (s *BasebicepListener) EnterArray(ctx *ArrayContext) {}

// ExitArray is called when production array is exited.
func (s *BasebicepListener) ExitArray(ctx *ArrayContext) {}

// EnterArrayItem is called when production arrayItem is entered.
func (s *BasebicepListener) EnterArrayItem(ctx *ArrayItemContext) {}

// ExitArrayItem is called when production arrayItem is exited.
func (s *BasebicepListener) ExitArrayItem(ctx *ArrayItemContext) {}

// EnterDecorator is called when production decorator is entered.
func (s *BasebicepListener) EnterDecorator(ctx *DecoratorContext) {}

// ExitDecorator is called when production decorator is exited.
func (s *BasebicepListener) ExitDecorator(ctx *DecoratorContext) {}

// EnterDecoratorExpression is called when production decoratorExpression is entered.
func (s *BasebicepListener) EnterDecoratorExpression(ctx *DecoratorExpressionContext) {}

// ExitDecoratorExpression is called when production decoratorExpression is exited.
func (s *BasebicepListener) ExitDecoratorExpression(ctx *DecoratorExpressionContext) {}

// EnterFunctionCall is called when production functionCall is entered.
func (s *BasebicepListener) EnterFunctionCall(ctx *FunctionCallContext) {}

// ExitFunctionCall is called when production functionCall is exited.
func (s *BasebicepListener) ExitFunctionCall(ctx *FunctionCallContext) {}

// EnterArgumentList is called when production argumentList is entered.
func (s *BasebicepListener) EnterArgumentList(ctx *ArgumentListContext) {}

// ExitArgumentList is called when production argumentList is exited.
func (s *BasebicepListener) ExitArgumentList(ctx *ArgumentListContext) {}

// EnterIdentifier is called when production identifier is entered.
func (s *BasebicepListener) EnterIdentifier(ctx *IdentifierContext) {}

// ExitIdentifier is called when production identifier is exited.
func (s *BasebicepListener) ExitIdentifier(ctx *IdentifierContext) {}
