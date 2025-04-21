package bicep

import (
	"encoding/json"
	"strconv"
	"strings"

	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/parser/bicep/antlr/parser"
	"github.com/antlr4-go/antlr/v4"
)

type Parser struct {
}

const (
	kicsPrefix       = "_kics_"
	kicsLine         = kicsPrefix + "line"
	kicsLines        = kicsPrefix + "lines"
	kicsArray        = kicsPrefix + "arr"
	CloseParenthesis = "')"
	CommaWithSpace   = ", "
)

type BicepVisitor struct {
	parser.BasebicepVisitor
	paramList    map[string]interface{}
	varList      map[string]interface{}
	resourceList []interface{}
}

type JSONBicep struct {
	Parameters map[string]interface{} `json:"parameters"`
	Variables  map[string]interface{} `json:"variables"`
	Resources  []interface{}          `json:"resources"`
}

type KicsObjectProperty struct {
	objectProperty map[string]interface{}
	line           int
}

func NewBicepVisitor() *BicepVisitor {
	paramList := map[string]interface{}{}
	varList := map[string]interface{}{}
	resourceList := []interface{}{}
	return &BicepVisitor{paramList: paramList, varList: varList, resourceList: resourceList}
}

func convertVisitorToJSONBicep(visitor *BicepVisitor) *JSONBicep {
	return &JSONBicep{
		Parameters: visitor.paramList,
		Variables:  visitor.varList,
		Resources:  visitor.resourceList,
	}
}

type Resource struct {
	Name         string
	FullType     string
	Parent       string
	Children     []*Resource
	ResourceData interface{}
}

// Filters the Resource array in order to keep only the top-level resources while reformatting them
func filterParentStructs(resources []*Resource) []interface{} {
	filteredResources := []interface{}{}

	for _, resource := range resources {
		if resource.Parent == "" {
			formattedNode := reformatTestTree(resource)
			filteredResources = append(filteredResources, formattedNode)
		}
	}

	return filteredResources
}

func setChildType(child map[string]interface{}, parentType string) {
	childType, hasType := child["type"]
	if !hasType {
		return
	}
	childTypeString, ok := childType.(string)
	if !ok {
		return
	}
	if parentType != "" {
		childTypeString = strings.Replace(childTypeString, parentType+"/", "", 1)
		child["type"] = childTypeString
	}
}

// Converts Resource struct array back to a JBicep structure
func reformatTestTree(resource *Resource) map[string]interface{} {
	reformattedResource := map[string]interface{}{}

	children := []interface{}{}
	for _, child := range resource.Children {
		formattedChild := reformatTestTree(child)
		setChildType(formattedChild, resource.FullType)
		children = append(children, formattedChild)
	}
	if len(children) > 0 {
		reformattedResource["resources"] = children
	}

	resData, ok := resource.ResourceData.(map[string]interface{})
	if !ok {
		return reformattedResource
	}
	for k, v := range resData {
		reformattedResource[k] = v
	}

	return reformattedResource
}

// Adds resource to its parent's children array
func addChildrenToParents(resources []*Resource) {
	resourceMap := map[string]*Resource{}

	// Loops twice through the resources array in order to first fill the resourceMap with the required data
	for _, resource := range resources {
		resourceMap[resource.Name] = resource
	}

	for _, resource := range resources {
		if resource.Parent != "" {
			parent, ok := resourceMap[resource.Parent]
			if !ok {
				continue
			}
			parent.Children = append(parent.Children, resource)
		}
	}
}

// Converts JBicep structure to a Resource struct array
func convertOriginalResourcesToStruct(resources []interface{}) []*Resource {
	newResources := []*Resource{}

	for _, res := range resources {
		actualRes, ok := res.(map[string]interface{})
		if !ok {
			return newResources
		}
		resName, hasName := actualRes["identifier"]
		resType, hasType := actualRes["type"]

		if !hasName || !hasType {
			return newResources
		}

		resNameString, ok := resName.(string)
		if !ok {
			return newResources
		}
		resTypeString, ok := resType.(string)
		if !ok {
			return newResources
		}

		newRes := Resource{
			Name:         resNameString,
			FullType:     resTypeString,
			ResourceData: res,
		}

		if resParent, hasParent := actualRes["parent"]; hasParent {
			var ok bool
			newRes.Parent, ok = resParent.(string)
			if !ok {
				return newResources
			}
		}

		newResources = append(newResources, &newRes)
	}

	return newResources
}

func makeResourcesNestedStructure(jBicep *JSONBicep) []interface{} {
	originalResources := jBicep.Resources

	resources := convertOriginalResourcesToStruct(originalResources)
	addChildrenToParents(resources)
	filteredResources := filterParentStructs(resources)

	return filteredResources
}

// Parse - parses bicep to BicepVisitor template (json file)
func (p *Parser) Parse(file string, _ []byte) ([]model.Document, []int, error) {
	bicepVisitor := NewBicepVisitor()
	stream, err := antlr.NewFileStream(file)
	if err != nil {
		return nil, nil, err
	}
	lexer := parser.NewbicepLexer(stream)

	tokenStream := antlr.NewCommonTokenStream(lexer, antlr.TokenDefaultChannel)
	bicepParser := parser.NewbicepParser(tokenStream)

	bicepParser.RemoveErrorListeners()
	bicepParser.AddErrorListener(antlr.NewDiagnosticErrorListener(true))

	program := bicepParser.Program()
	if program != nil {
		program.Accept(bicepVisitor)
	}

	var doc model.Document

	jBicep := convertVisitorToJSONBicep(bicepVisitor)

	nestedResources := makeResourcesNestedStructure(jBicep)
	jBicep.Resources = nestedResources

	bicepBytes, err := json.Marshal(jBicep)
	if err != nil {
		return nil, nil, err
	}

	err = json.Unmarshal(bicepBytes, &doc)
	if err != nil {
		return nil, nil, err
	}

	return []model.Document{doc}, nil, nil
}

func (s *BicepVisitor) VisitProgram(ctx *parser.ProgramContext) interface{} {
	for _, val := range ctx.AllStatement() {
		val.Accept(s)
	}

	return nil
}

func (s *BicepVisitor) VisitStatement(ctx *parser.StatementContext) interface{} {
	if ctx.ParameterDecl() != nil {
		return ctx.ParameterDecl().Accept(s)
	}
	if ctx.VariableDecl() != nil {
		return ctx.VariableDecl().Accept(s)
	}
	if ctx.ResourceDecl() != nil {
		return ctx.ResourceDecl().Accept(s)
	}

	return nil
}

func parseDecorators(decorators []parser.IDecoratorContext, s *BicepVisitor) map[string]interface{} {
	decoratorsMap := map[string]interface{}{}

	for _, val := range decorators {
		if val == nil {
			continue
		}

		decorator, ok := val.Accept(s).(map[string][]interface{})
		if !ok {
			return map[string]interface{}{}
		}
		for name, values := range decorator {
			switch name {
			case "description":
				decoratorsMap["metadata"] = map[string]interface{}{
					"description": values[0],
				}

			case "maxLength", "minLength", "minValue", "maxValue":
				decoratorsMap[name] = values[0]

			default:
				decoratorsMap[name] = values
			}
		}
	}

	return decoratorsMap
}

func (s *BicepVisitor) VisitParameterDecl(ctx *parser.ParameterDeclContext) interface{} {
	param := map[string]interface{}{}

	identifier := checkAcceptAntlrString(ctx.Identifier(), s)

	if ctx.ParameterDefaultValue() != nil {
		paramVal := ctx.ParameterDefaultValue().Accept(s)
		switch paramVal := paramVal.(type) {
		case map[string][]interface{}:
			stringifiedFunction := parseFunctionCall(paramVal)
			param["defaultValue"] = "[" + stringifiedFunction + "]"
		case interface{}:
			if isDotFunction(paramVal) {
				paramVal = "[" + paramVal.(string) + "]"
			}
			param["defaultValue"] = paramVal
		default:
			param["defaultValue"] = nil
		}
	}

	if ctx.TypeExpression() != nil {
		typeExpression := ctx.TypeExpression().Accept(s)
		param["type"] = typeExpression
	}

	decoratorsMap := parseDecorators(ctx.AllDecorator(), s)
	for name, values := range decoratorsMap {
		switch name {
		case "secure":
			switch param["type"] {
			case "string":
				param["type"] = "secureString"
			case "object":
				param["type"] = "secureObject"
			}

		case "allowed":
			param["allowedValues"] = values

		default:
			param[name] = values
		}
	}

	line := map[string]int{kicsLine: ctx.GetStop().GetLine()}
	lines := map[string]map[string]int{
		kicsPrefix + "defaultValue": line,
		kicsPrefix + "type":         line,
	}

	param[kicsLines] = lines

	s.paramList[identifier] = param

	return nil
}

func (s *BicepVisitor) VisitVariableDecl(ctx *parser.VariableDeclContext) interface{} {
	var variable = map[string]interface{}{}

	identifier := checkAcceptAntlrString(ctx.Identifier(), s)

	decoratorsMap := parseDecorators(ctx.AllDecorator(), s)
	for name, values := range decoratorsMap {
		variable[name] = values
	}

	expression := checkAcceptExpression(ctx.Expression(), s)
	variable["value"] = expression
	s.varList[identifier] = variable

	return nil
}

func (s *BicepVisitor) VisitResourceDecl(ctx *parser.ResourceDeclContext) interface{} {
	resource := map[string]interface{}{}
	resourceType := ""
	apiVersion := ""

	interpString := checkAcceptAntlrString(ctx.InterpString(), s)
	identifier := checkAcceptAntlrString(ctx.Identifier(), s)

	fullType := strings.Split(interpString, "@")
	if len(fullType) > 0 {
		resourceType = fullType[0]
	}
	if len(fullType) > 1 {
		apiVersion = fullType[1]
	}

	resource["identifier"] = identifier
	resource["type"] = resourceType
	resource["apiVersion"] = apiVersion

	decoratorsMap := parseDecorators(ctx.AllDecorator(), s)
	for name, values := range decoratorsMap {
		resource[name] = values
	}

	if ctx.Object() != nil {
		object, ok := ctx.Object().Accept(s).(map[string]interface{})
		if ok {
			for key, val := range object {
				resource[key] = val
			}
		}
	}

	lines := map[string]interface{}{}
	if resKicsLines, hasLines := resource[kicsLines]; hasLines {
		var ok bool
		lines, ok = resKicsLines.(map[string]interface{})
		if !ok {
			lines = map[string]interface{}{}
		}
	}

	line := map[string]int{kicsLine: ctx.GetStart().GetLine()}
	lines[kicsPrefix+"apiVersion"] = line
	lines[kicsPrefix+"type"] = line

	s.resourceList = append(s.resourceList, resource)

	return nil
}

func checkAcceptAntlrString(ctx antlr.ParserRuleContext, s *BicepVisitor) string {
	if ctx != nil {
		if result, ok := ctx.Accept(s).(string); ok {
			return result
		}
	}

	return ""
}

func checkAcceptExpression(ctx antlr.ParserRuleContext, s *BicepVisitor) interface{} {
	if ctx != nil {
		return ctx.Accept(s)
	}

	return ""
}

func (s *BicepVisitor) VisitParameterDefaultValue(ctx *parser.ParameterDefaultValueContext) interface{} {
	param := checkAcceptExpression(ctx.Expression(), s)
	return param
}

/*
Converts functioncall data (map of identifying string to slice of arguments) into a string

	Example: "FunctionName": ["arg1", 2, "arg3", map[Function2: [arg4, arg5]]] becomes
	"FunctionName(arg1, 2, arg3, Function2(arg4, arg5))"
*/
func parseFunctionCall(functionData map[string][]interface{}) string {
	stringifiedFunctionCall := ""

	for functionName, argumentList := range functionData {
		stringifiedFunctionCall += functionName + "("
		for index, argument := range argumentList {
			switch argument := argument.(type) {
			case string:
				stringifiedFunctionCall += argument
			case int:
				convertedArgument := strconv.Itoa(argument)
				stringifiedFunctionCall += convertedArgument
			case map[string][]interface{}:
				stringifiedFunctionCall += parseFunctionCall(argument)
			}

			if index < len(argumentList)-1 {
				stringifiedFunctionCall += CommaWithSpace
			}
		}
		stringifiedFunctionCall += ")"
	}

	return stringifiedFunctionCall
}

// function to check if an identifier is a parameter/variable and add the required keyword if so
func convertToParamVar(str string, s *BicepVisitor) string {
	for variable := range s.varList {
		if variable == str {
			return "variables('" + str + CloseParenthesis
		}
	}
	for parameter := range s.paramList {
		if parameter == str {
			return "parameters('" + str + CloseParenthesis
		}
	}

	return str
}

func (s *BicepVisitor) VisitExpression(ctx *parser.ExpressionContext) interface{} {
	if ctx.GetChildCount() > 1 {
		if ctx.DOT() != nil {
			var expressionString string

			var exp interface{} = ""
			if ctx.Expression(0) != nil {
				exp = ctx.Expression(0).Accept(s)
			}

			switch exp := exp.(type) {
			case map[string][]interface{}:
				expressionString = parseFunctionCall(exp)
			case string:
				expressionString = exp
			default:
				expressionString = ""
			}

			if ctx.Identifier() != nil {
				identifier := checkAcceptAntlrString(ctx.Identifier(), s)
				identifier = convertToParamVar(identifier, s)

				return expressionString + "." + identifier
			}

			if ctx.FunctionCall() != nil {
				fc := ctx.FunctionCall().Accept(s)
				fcData, ok := fc.(map[string][]interface{})
				if !ok {
					return ""
				}
				functionCallString := parseFunctionCall(fcData)
				return expressionString + "." + functionCallString
			}
		}
	}

	if ctx.PrimaryExpression() != nil {
		return ctx.PrimaryExpression().Accept(s)
	}

	return nil
}

func (s *BicepVisitor) VisitPrimaryExpression(ctx *parser.PrimaryExpressionContext) interface{} {
	if ctx.LiteralValue() != nil {
		return ctx.LiteralValue().Accept(s)
	}
	if ctx.FunctionCall() != nil {
		return ctx.FunctionCall().Accept(s)
	}
	if ctx.InterpString() != nil {
		return ctx.InterpString().Accept(s)
	}
	if ctx.MULTILINE_STRING() != nil {
		finalString := strings.ReplaceAll(ctx.MULTILINE_STRING().GetText(), "'''", "")
		finalString = strings.ReplaceAll(finalString, "\r", "")
		finalString = strings.ReplaceAll(finalString, "\n", "")
		return finalString
	}
	if ctx.Array() != nil {
		return ctx.Array().Accept(s)
	}
	if ctx.Object() != nil {
		return ctx.Object().Accept(s)
	}
	if ctx.ParenthesizedExpression() != nil {
		return ctx.ParenthesizedExpression().Accept(s)
	}

	return nil
}

func (s *BicepVisitor) VisitLiteralValue(ctx *parser.LiteralValueContext) interface{} {
	if ctx.NUMBER() != nil {
		number, _ := strconv.ParseFloat(ctx.NUMBER().GetText(), 32)
		return number
	}
	if ctx.TRUE() != nil {
		return true
	}
	if ctx.FALSE() != nil {
		return false
	}
	if ctx.Identifier() != nil {
		identifier, ok := ctx.Identifier().Accept(s).(string)
		if ok {
			identifier = convertToParamVar(identifier, s)
			return identifier
		}
	}

	return nil
}

func acceptExpressionAtIndex(idx int, ctx *parser.InterpStringContext, s *BicepVisitor) interface{} {
	if ctx.Expression(idx) != nil {
		return ctx.Expression(idx).Accept(s)
	}

	return ""
}

func buildComplexInterp(interpStringValues []interface{}) string {
	str := ""
	for _, v := range interpStringValues {
		switch v := v.(type) {
		case string:
			str += v
		case map[string][]interface{}:
			for identifier, argumentList := range v {
				resStr := "[" + identifier + "("
				for idx, arg := range argumentList {
					stringArg, ok := arg.(string)
					if !ok {
						return ""
					}
					resStr += stringArg
					if idx < len(argumentList)-1 {
						resStr += CommaWithSpace
					}
				}

				resStr += ")]"
				str += resStr
			}
		}
	}

	return str
}

func parseComplexInterp(ctx *parser.InterpStringContext, s *BicepVisitor) string {
	interpString := []interface{}{}

	if ctx.STRING_LEFT_PIECE() == nil || ctx.STRING_RIGHT_PIECE() == nil {
		return ""
	}

	leftPiece := ctx.STRING_LEFT_PIECE().GetText()
	rightPiece := ctx.STRING_RIGHT_PIECE().GetText()
	middlePieces := ctx.AllSTRING_MIDDLE_PIECE()

	interpString = append(interpString, leftPiece)

	if middlePieces != nil && (len(middlePieces) > 0) {
		for idx, val := range middlePieces {
			expression := acceptExpressionAtIndex(idx, ctx, s)
			interpString = append(interpString, expression, val.GetText())
		}
	}

	lastExpression := acceptExpressionAtIndex(len(middlePieces), ctx, s)
	interpString = append(interpString,
		lastExpression,
		rightPiece)

	resultString := buildComplexInterp(interpString)

	return resultString
}

func (s *BicepVisitor) VisitInterpString(ctx *parser.InterpStringContext) interface{} {
	if ctx.GetChildCount() > 1 {
		complexInterpString := parseComplexInterp(ctx, s)
		return complexInterpString
	}

	if ctx.STRING_COMPLETE() != nil {
		unformattedString := ctx.STRING_COMPLETE().GetText()
		finalString := strings.ReplaceAll(unformattedString, "'", "")
		return finalString
	}

	return ""
}

func (s *BicepVisitor) VisitArray(ctx *parser.ArrayContext) interface{} {
	array := []interface{}{}
	for _, val := range ctx.AllArrayItem() {
		expression := val.Accept(s)
		if isParameter(expression) || isDotFunction(expression) {
			expression = "[" + expression.(string) + "]"
		}
		array = append(array, expression)
	}
	return array
}

func (s *BicepVisitor) VisitArrayItem(ctx *parser.ArrayItemContext) interface{} {
	return checkAcceptExpression(ctx.Expression(), s)
}

func isParameter(expression interface{}) bool {
	exp, ok := expression.(string)
	if !ok {
		return false
	}

	return strings.Contains(exp, "parameters(") || strings.Contains(exp, "variables(")
}

func isDotFunction(expression interface{}) bool {
	exp, ok := expression.(string)
	if !ok {
		return false
	}

	return strings.Contains(exp, ").")
}

func (s *BicepVisitor) VisitObject(ctx *parser.ObjectContext) interface{} {
	object := map[string]interface{}{}
	propertiesLines := map[string]interface{}{}

	for _, val := range ctx.AllObjectProperty() {
		objectProperty, ok := val.Accept(s).(KicsObjectProperty)
		if !ok {
			return object
		}
		for key, val := range objectProperty.objectProperty {
			object[key] = val
			line := map[string]interface{}{kicsLine: objectProperty.line}

			arr, isArray := val.([]interface{})
			if isArray {
				for range arr {
					arrLine := map[string]int{kicsLine: objectProperty.line}
					kicsDefault := map[string]interface{}{kicsPrefix + "_default": arrLine}
					kicsArr := []interface{}{kicsDefault}
					line[kicsArray] = kicsArr
				}
			}
			propertiesLines[kicsPrefix+key] = line
		}
	}

	defaultLine := map[string]int{kicsLine: ctx.GetStart().GetLine()}
	propertiesLines[kicsPrefix+"_default"] = defaultLine

	object[kicsLines] = propertiesLines

	return object
}

func (s *BicepVisitor) VisitObjectProperty(ctx *parser.ObjectPropertyContext) interface{} {
	objectProperty := map[string]interface{}{}

	if ctx.Expression() != nil {
		objectValue := ctx.Expression().Accept(s)
		if isParameter(objectValue) || isDotFunction(objectValue) {
			objectValue = "[" + objectValue.(string) + "]"
		}

		if ctx.Identifier() != nil {
			identifier, ok := ctx.Identifier().Accept(s).(string)
			if ok {
				objectProperty[identifier] = objectValue
			}
		}
		if ctx.InterpString() != nil {
			interpString, ok := ctx.InterpString().Accept(s).(string)
			if ok {
				objectProperty[interpString] = objectValue
			}
		}
	}

	return KicsObjectProperty{objectProperty: objectProperty, line: ctx.GetStart().GetLine()}
}

func (s *BicepVisitor) VisitIdentifier(ctx *parser.IdentifierContext) interface{} {
	contexts := []antlr.TerminalNode{
		ctx.IDENTIFIER(),
		ctx.IMPORT(),
		ctx.WITH(),
		ctx.AS(),
		ctx.METADATA(),
		ctx.PARAM(),
		ctx.RESOURCE(),
		ctx.OUTPUT(),
		ctx.EXISTING(),
		ctx.VAR(),
		ctx.IF(),
		ctx.FOR(),
		ctx.IN(),
		ctx.TRUE(),
		ctx.FALSE(),
		ctx.NULL(),
		ctx.TARGET_SCOPE(),
		ctx.STRING(),
		ctx.INT(),
		ctx.BOOL(),
		ctx.ARRAY(),
		ctx.OBJECT(),
		ctx.TYPE(),
		ctx.MODULE(),
	}

	for _, context := range contexts {
		if context != nil {
			return context.GetText()
		}
	}

	return ""
}

func (s *BicepVisitor) VisitParenthesizedExpression(ctx *parser.ParenthesizedExpressionContext) interface{} {
	return checkAcceptExpression(ctx.Expression(), s)
}

func (s *BicepVisitor) VisitDecorator(ctx *parser.DecoratorContext) interface{} {
	if ctx.DecoratorExpression() == nil {
		return map[string][]interface{}{}
	}
	decorator := ctx.DecoratorExpression().Accept(s)
	return decorator
}

func (s *BicepVisitor) VisitDecoratorExpression(ctx *parser.DecoratorExpressionContext) interface{} {
	if ctx.FunctionCall() == nil {
		return map[string][]interface{}{}
	}
	return ctx.FunctionCall().Accept(s)
}

func (s *BicepVisitor) VisitFunctionCall(ctx *parser.FunctionCallContext) interface{} {
	var argumentList []interface{}
	identifier := checkAcceptAntlrString(ctx.Identifier(), s)

	if ctx.ArgumentList() != nil {
		var ok bool
		argumentList, ok = ctx.ArgumentList().Accept(s).([]interface{})
		if !ok {
			return map[string]interface{}{}
		}
	}
	functionCall := map[string][]interface{}{
		identifier: argumentList,
	}

	return functionCall
}

func (s *BicepVisitor) VisitArgumentList(ctx *parser.ArgumentListContext) interface{} {
	var argumentList []interface{}

	for _, val := range ctx.AllExpression() {
		argument := val.Accept(s)
		argumentList = append(argumentList, argument)
	}
	return argumentList
}

func (s *BicepVisitor) VisitTypeExpression(ctx *parser.TypeExpressionContext) interface{} {
	return checkAcceptAntlrString(ctx.Identifier(), s)
}

// GetKind returns the kind of the parser
func (p *Parser) GetKind() model.FileKind {
	return model.KindBICEP
}

// SupportedExtensions returns Bicep extensions
func (p *Parser) SupportedExtensions() []string {
	return []string{".bicep"}
}

// SupportedTypes returns types supported by this parser, which are bicep files
func (p *Parser) SupportedTypes() map[string]bool {
	return map[string]bool{"bicep": true, "azureresourcemanager": true}
}

// GetCommentToken return the comment token of Bicep files - #
func (p *Parser) GetCommentToken() string {
	return "//"
}

// StringifyContent converts original content into string formatted version
func (p *Parser) StringifyContent(content []byte) (string, error) {
	return string(content), nil
}

// Resolve resolves bicep files variables
func (p *Parser) Resolve(fileContent []byte, _ string, _ bool, _ int) ([]byte, error) {
	return fileContent, nil
}

// GetResolvedFiles returns the list of files that are resolved
func (p *Parser) GetResolvedFiles() map[string]model.ResolvedFile {
	return make(map[string]model.ResolvedFile)
}
