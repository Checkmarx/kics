package converter

import (
	"fmt"
	"strconv"
	"strings"

	sentryReport "github.com/Checkmarx/kics/v2/internal/sentry"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/Checkmarx/kics/v2/pkg/parser/terraform/functions"
	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/hclsyntax"
	"github.com/rs/zerolog/log"
	"github.com/zclconf/go-cty/cty"
	ctyconvert "github.com/zclconf/go-cty/cty/convert"
	ctyjson "github.com/zclconf/go-cty/cty/json"
)

// VariableMap represents a set of terraform input variables
type VariableMap map[string]cty.Value

var inputVarMap = make(VariableMap)

// This file is attributed to https://github.com/tmccombs/hcl2json.
// convertBlock() is manipulated for combining the both blocks and labels for one given resource.

// DefaultConverted an hcl File to a toJson serializable object
// This assumes that the body is a hclsyntax.Body
var DefaultConverted = func(file *hcl.File, inputVariables VariableMap) (model.Document, error) {
	inputVarMap = inputVariables
	c := converter{bytes: file.Bytes}
	body, err := c.convertBody(file.Body.(*hclsyntax.Body), 0)

	if err != nil {
		sentryReport.ReportSentry(&sentryReport.Report{
			Location: "var DefaultConverted",
			Err:      err,
			Kind:     model.KindTerraform,
			Message:  "Failed to convert body in terraform parser",
		}, false)
		if er, ok := err.(*hcl.Diagnostic); ok && er.Subject != nil {
			return nil, err
		}

		return nil, err
	}

	return body, nil
}

type converter struct {
	bytes []byte
}

const kicsLinesKey = "_kics_"

func (c *converter) rangeSource(r hcl.Range) string {
	return string(c.bytes[r.Start.Byte:r.End.Byte])
}

func (c *converter) convertBody(body *hclsyntax.Body, defLine int) (model.Document, error) {
	var err error
	var v string
	countValue := body.Attributes["count"]
	count := -1

	if countValue != nil {
		value, err := countValue.Expr.Value(nil)
		if err == nil {
			switch value.Type() {
			case cty.String:
				v = value.AsString()
			case cty.Number:
				v = value.AsBigFloat().String()
			}

			intValue, err := strconv.Atoi(v)
			if err == nil {
				count = intValue
			}
		}
	}

	if count == 0 {
		return nil, nil
	}

	out := make(model.Document)
	kicsS := make(map[string]model.LineObject)
	// set kics line for the body
	kicsS["_kics__default"] = model.LineObject{
		Line: defLine,
	}

	if body.Attributes != nil {
		for key, value := range body.Attributes {
			out[key], err = c.convertExpression(value.Expr)
			// set kics line for the body value
			kicsS[kicsLinesKey+key] = model.LineObject{
				Line: value.SrcRange.Start.Line,
				Arr:  c.getArrLines(value.Expr),
			}
			if err != nil {
				sentryReport.ReportSentry(&sentryReport.Report{
					Location: "func convertBody",
					Err:      err,
					Kind:     model.KindTerraform,
					Message:  "Failed to convert Expression in terraform parser",
				}, false)
				return nil, err
			}
		}
	}

	for _, block := range body.Blocks {
		// set kics line for block
		kicsS[kicsLinesKey+block.Type] = model.LineObject{
			Line: block.TypeRange.Start.Line,
		}
		err = c.convertBlock(block, out, block.TypeRange.Start.Line)
		if err != nil {
			sentryReport.ReportSentry(&sentryReport.Report{
				Location: "func convertBody",
				Err:      err,
				Kind:     model.KindTerraform,
				Message:  "Failed to convert block in terraform parser",
			}, false)
			return nil, err
		}
	}

	out["_kics_lines"] = kicsS

	return out, nil
}

// getArrLines will get line information for the array elements
func (c *converter) getArrLines(expr hclsyntax.Expression) []map[string]*model.LineObject {
	arr := make([]map[string]*model.LineObject, 0)
	if v, ok := expr.(*hclsyntax.TupleConsExpr); ok {
		for _, ex := range v.Exprs {
			arrEx := make(map[string]*model.LineObject)
			// set default line of array
			arrEx["_kics__default"] = &model.LineObject{
				Line: ex.Range().Start.Line,
			}
			switch valType := ex.(type) {
			case *hclsyntax.ObjectConsExpr:
				arrEx["_kics__default"] = &model.LineObject{
					Line: ex.Range().Start.Line + 1,
				}
				// set lines for array elements
				for _, item := range valType.Items {
					key, err := c.convertKey(item.KeyExpr)
					if err != nil {
						sentryReport.ReportSentry(&sentryReport.Report{
							Location: "func getArrLines",
							Err:      err,
							Kind:     model.KindTerraform,
							Message:  "Failed to convert key in terraform parser",
						}, false)
						return nil
					}
					arrEx[kicsLinesKey+key] = &model.LineObject{
						Line: item.KeyExpr.Range().Start.Line,
					}
				}
			case *hclsyntax.TupleConsExpr:
				// set lines for array elements if type is different than array, map/object
				arrEx["_kics__default"] = &model.LineObject{
					Arr: c.getArrLines(valType),
				}
			}

			arr = append(arr, arrEx)
		}
	}
	return arr
}

func (c *converter) convertBlock(block *hclsyntax.Block, out model.Document, defLine int) error {
	var key = block.Type
	value, err := c.convertBody(block.Body, defLine)

	if err != nil {
		return err
	}

	if value == nil {
		return nil
	}

	for _, label := range block.Labels {
		if inner, exists := out[key]; exists {
			var ok bool
			out, ok = inner.(model.Document)
			if !ok {
				return fmt.Errorf("unable to convert Block to JSON: %v.%v", block.Type, strings.Join(block.Labels, "."))
			}
		} else {
			obj := make(model.Document)
			out[key] = obj
			out = obj
		}
		key = label
	}

	if current, exists := out[key]; exists {
		if list, ok := current.([]interface{}); ok {
			out[key] = append(list, value)
		} else {
			out[key] = []interface{}{current, value}
		}
	} else {
		out[key] = value
	}

	return nil
}

func (c *converter) convertExpression(expr hclsyntax.Expression) (interface{}, error) {
	// assume it is hcl syntax (because, um, it is)
	switch value := expr.(type) {
	case *hclsyntax.LiteralValueExpr:
		return ctyjson.SimpleJSONValue{Value: value.Val}, nil
	case *hclsyntax.TemplateExpr:
		return c.convertTemplate(value)
	case *hclsyntax.TemplateWrapExpr:
		return c.convertExpression(value.Wrapped)
	case *hclsyntax.TupleConsExpr:
		list := make([]interface{}, 0)
		for _, ex := range value.Exprs {
			elem, err := c.convertExpression(ex)
			if err != nil {
				sentryReport.ReportSentry(&sentryReport.Report{
					Location: "func convertExpression",
					Err:      err,
					Kind:     model.KindTerraform,
					Message:  "Failed to convert expression in terraform parser",
				}, false)
				return nil, err
			}
			list = append(list, elem)
		}
		return list, nil
	case *hclsyntax.ObjectConsExpr:
		return c.objectConsExpr(value)
	case *hclsyntax.FunctionCallExpr:
		return c.evalFunction(expr)
	case *hclsyntax.ConditionalExpr:
		expressionEvaluated, err := expr.Value(&hcl.EvalContext{
			Variables: inputVarMap,
			Functions: functions.TerraformFuncs,
		})
		if err != nil {
			return c.wrapExpr(expr)
		}
		return ctyjson.SimpleJSONValue{Value: expressionEvaluated}, nil
	default:
		// try to evaluate with variables and functions
		valueConverted, _ := expr.Value(&hcl.EvalContext{
			Variables: inputVarMap,
			Functions: functions.TerraformFuncs,
		})
		if !checkDynamicKnownTypes(valueConverted) {
			return ctyjson.SimpleJSONValue{Value: valueConverted}, nil
		}
		return c.wrapExpr(expr)
	}
}

func checkValue(val cty.Value) bool {
	if val.Type().HasDynamicTypes() || !val.IsKnown() {
		return true
	}
	if !val.Type().IsPrimitiveType() && checkDynamicKnownTypes(val) {
		return true
	}
	return false
}

func checkDynamicKnownTypes(valueConverted cty.Value) bool {
	if !valueConverted.Type().HasDynamicTypes() && valueConverted.IsKnown() {
		if valueConverted.Type().FriendlyName() == "tuple" {
			for _, val := range valueConverted.AsValueSlice() {
				if checkValue(val) {
					return true
				}
			}
		}
		if valueConverted.Type().FriendlyName() == "object" {
			for _, val := range valueConverted.AsValueMap() {
				if checkValue(val) {
					return true
				}
			}
		}
		return false
	}
	return true
}

func (c *converter) objectConsExpr(value *hclsyntax.ObjectConsExpr) (model.Document, error) {
	m := make(model.Document)
	for _, item := range value.Items {
		key, err := c.convertKey(item.KeyExpr)
		if err != nil {
			sentryReport.ReportSentry(&sentryReport.Report{
				Location: "func objectConsExpr",
				Err:      err,
				Kind:     model.KindTerraform,
				Message:  "Failed to convert key in terraform parser",
			}, false)
			return nil, err
		}
		m[key], err = c.convertExpression(item.ValueExpr)
		if err != nil {
			sentryReport.ReportSentry(&sentryReport.Report{
				Location: "func objectConsExpr",
				Err:      err,
				Kind:     model.KindTerraform,
				Message:  "Failed to convert expression in terraform parser",
			}, false)
			return nil, err
		}
	}
	return m, nil
}

func (c *converter) convertKey(keyExpr hclsyntax.Expression) (string, error) {
	// a key should never have dynamic input
	if k, isKeyExpr := keyExpr.(*hclsyntax.ObjectConsKeyExpr); isKeyExpr {
		keyExpr = k.Wrapped
		if _, isTraversal := keyExpr.(*hclsyntax.ScopeTraversalExpr); isTraversal {
			return c.rangeSource(keyExpr.Range()), nil
		}
	}
	return c.convertStringPart(keyExpr)
}

func (c *converter) convertTemplate(t *hclsyntax.TemplateExpr) (string, error) {
	if t.IsStringLiteral() {
		// safe because the value is just the string
		v, err := t.Value(nil)
		if err != nil {
			return "", err
		}
		return v.AsString(), nil
	}
	builder := &strings.Builder{}
	for _, part := range t.Parts {
		s, err := c.convertStringPart(part)
		if err != nil {
			sentryReport.ReportSentry(&sentryReport.Report{
				Location: "func convertTemplate",
				Err:      err,
				Kind:     model.KindTerraform,
				Message:  "Failed to convert string part in terraform parser",
			}, false)
			return "", err
		}
		builder.WriteString(s)
	}

	s := builder.String()

	builder.Reset()
	builder = nil

	return s, nil
}

func (c *converter) convertStringPart(expr hclsyntax.Expression) (string, error) {
	switch v := expr.(type) {
	case *hclsyntax.LiteralValueExpr:
		s, err := ctyconvert.Convert(v.Val, cty.String)
		if err != nil {
			sentryReport.ReportSentry(&sentryReport.Report{
				Location: "func convertStringPart",
				Err:      err,
				Kind:     model.KindTerraform,
				Message:  "Failed to cty convert in terraform parser",
			}, false)
			return "", err
		}
		return s.AsString(), nil
	case *hclsyntax.TemplateExpr:
		return c.convertTemplate(v)
	case *hclsyntax.TemplateWrapExpr:
		return c.convertStringPart(v.Wrapped)
	case *hclsyntax.ConditionalExpr:
		return c.convertTemplateConditional(v)
	case *hclsyntax.TemplateJoinExpr:
		return c.convertTemplateFor(v.Tuple.(*hclsyntax.ForExpr))
	case *hclsyntax.ParenthesesExpr:
		return c.convertStringPart(v.Expression)
	default:
		// try to evaluate with variables
		valueConverted, _ := expr.Value(&hcl.EvalContext{
			Variables: inputVarMap,
		})
		if valueConverted.Type().FriendlyName() == "string" {
			return valueConverted.AsString(), nil
		}
		// treating as an embedded expression
		return c.wrapExpr(expr)
	}
}

func (c *converter) convertTemplateConditional(expr *hclsyntax.ConditionalExpr) (string, error) {
	builder := &strings.Builder{}
	builder.WriteString("%{if ")
	builder.WriteString(c.rangeSource(expr.Condition.Range()))
	builder.WriteString("}")
	trueResult, err := c.convertStringPart(expr.TrueResult)
	if err != nil {
		sentryReport.ReportSentry(&sentryReport.Report{
			Location: "func convertTemplateConditional",
			Err:      err,
			Kind:     model.KindTerraform,
			Message:  "Failed to convert string part terraform parser",
		}, false)
		return "", nil
	}
	builder.WriteString(trueResult)
	falseResult, err := c.convertStringPart(expr.FalseResult)
	if err != nil {
		sentryReport.ReportSentry(&sentryReport.Report{
			Location: "func convertTemplateConditional",
			Err:      err,
			Kind:     model.KindTerraform,
			Message:  "Failed to convert string part terraform parser",
		}, false)
		return "", nil
	}
	if falseResult != "" {
		builder.WriteString("%{else}")
		builder.WriteString(falseResult)
	}
	builder.WriteString("%{endif}")

	s := builder.String()

	builder.Reset()
	builder = nil

	return s, nil
}

func (c *converter) convertTemplateFor(expr *hclsyntax.ForExpr) (string, error) {
	builder := &strings.Builder{}
	builder.WriteString("%{for ")
	if expr.KeyVar != "" {
		builder.WriteString(expr.KeyVar)
		builder.WriteString(", ")
	}
	builder.WriteString(expr.ValVar)
	builder.WriteString(" in ")
	builder.WriteString(c.rangeSource(expr.CollExpr.Range()))
	builder.WriteString("}")
	templ, err := c.convertStringPart(expr.ValExpr)
	if err != nil {
		sentryReport.ReportSentry(&sentryReport.Report{
			Location: "func convertTemplateFor",
			Err:      err,
			Kind:     model.KindTerraform,
			Message:  "Failed to convert string part terraform parser",
		}, false)
		return "", err
	}
	builder.WriteString(templ)
	builder.WriteString("%{endfor}")

	s := builder.String()

	builder.Reset()
	builder = nil
	return s, nil
}

func (c *converter) wrapExpr(expr hclsyntax.Expression) (string, error) {
	expression := c.rangeSource(expr.Range())
	if strings.HasPrefix(expression, "var.") {
		log.Trace().Msgf("Variable ${%s} value not found", expression)
	}
	return "${" + expression + "}", nil
}

func (c *converter) evalFunction(expression hclsyntax.Expression) (interface{}, error) {
	expressionEvaluated, err := expression.Value(&hcl.EvalContext{
		Variables: inputVarMap,
		Functions: functions.TerraformFuncs,
	})
	if err != nil {
		for _, expressionError := range err {
			if expressionError.Summary == "Unknown variable" {
				jsonPath := c.rangeSource(expressionError.Expression.Range())
				rootKey := strings.Split(jsonPath, ".")[0]
				if strings.Contains(jsonPath, ".") {
					jsonCtyValue, convertErr := createEntryInputVar(strings.Split(jsonPath, ".")[1:], jsonPath)
					if convertErr != nil {
						return c.wrapExpr(expression)
					}
					inputVarMap[rootKey] = jsonCtyValue
				} else {
					inputVarMap[rootKey] = cty.StringVal(jsonPath)
				}
			}
		}
		expressionEvaluated, err = expression.Value(&hcl.EvalContext{
			Variables: inputVarMap,
			Functions: functions.TerraformFuncs,
		})
		if err != nil {
			return c.wrapExpr(expression)
		}
	}
	if !expressionEvaluated.HasWhollyKnownType() {
		// in some cases, the expression is evaluated with no error but the type is unknown.
		// this causes the json marshaling of the Document later on to fail with an error, and the entire scan fails.
		// Therefore, we prefer to wrap it as a string and continue the scan.
		return c.wrapExpr(expression)
	}
	return ctyjson.SimpleJSONValue{Value: expressionEvaluated}, nil
}

func createEntryInputVar(path []string, defaultValue string) (cty.Value, error) {
	mapJSON := "{"
	closeMap := "}"
	for idx, key := range path {
		if idx+1 < len(path) {
			mapJSON += fmt.Sprintf("%q:{", key)
			closeMap += "}"
		} else {
			mapJSON += fmt.Sprintf("%q: %q", key, defaultValue)
		}
	}
	mapJSON += closeMap
	jsonType, err := ctyjson.ImpliedType([]byte(mapJSON))
	if err != nil {
		return cty.NilVal, err
	}
	value, err := ctyjson.Unmarshal([]byte(mapJSON), jsonType)
	if err != nil {
		return cty.NilVal, err
	}
	return value, nil
}
