package converter

import (
	"fmt"
	"strings"

	"github.com/Checkmarx/kics/pkg/model"
	"github.com/Checkmarx/kics/pkg/parser/terraform/functions"
	"github.com/getsentry/sentry-go"
	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/hclsyntax"
	"github.com/rs/zerolog/log"
	"github.com/zclconf/go-cty/cty"
	ctyconvert "github.com/zclconf/go-cty/cty/convert"
	ctyjson "github.com/zclconf/go-cty/cty/json"
)

// InputVariableMap represents a set of terraform input variables
type InputVariableMap map[string]cty.Value

var inputVarMap = make(InputVariableMap)

// This file is attributed to https://github.com/tmccombs/hcl2json.
// convertBlock() is manipulated for combining the both blocks and labels for one given resource.

// DefaultConverted an hcl File to a toJson serializable object
// This assumes that the body is a hclsyntax.Body
var DefaultConverted = func(file *hcl.File, inputVariables InputVariableMap) (model.Document, error) {
	inputVarMap = inputVariables
	c := converter{bytes: file.Bytes}
	body, err := c.convertBody(file.Body.(*hclsyntax.Body))

	if err != nil {
		sentry.CaptureException(err)
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

func (c *converter) rangeSource(r hcl.Range) string {
	return string(c.bytes[r.Start.Byte:r.End.Byte])
}

func (c *converter) convertBody(body *hclsyntax.Body) (model.Document, error) {
	var err error
	out := make(model.Document)
	for key, value := range body.Attributes {
		out[key], err = c.convertExpression(value.Expr)
		if err != nil {
			sentry.CaptureException(err)
			return nil, err
		}
	}

	for _, block := range body.Blocks {
		err = c.convertBlock(block, out)
		if err != nil {
			sentry.CaptureException(err)
			return nil, err
		}
	}

	return out, nil
}

func (c *converter) convertBlock(block *hclsyntax.Block, out model.Document) error {
	var key = block.Type
	value, err := c.convertBody(block.Body)
	if err != nil {
		return err
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
		var list []interface{}
		for _, ex := range value.Exprs {
			elem, err := c.convertExpression(ex)
			if err != nil {
				sentry.CaptureException(err)
				return nil, err
			}
			list = append(list, elem)
		}
		return list, nil
	case *hclsyntax.ObjectConsExpr:
		return c.objectConsExpr(value)
	case *hclsyntax.FunctionCallExpr:
		return c.evalFunction(expr)
	default:
		// try to evaluate with variables
		valueConverted, _ := expr.Value(&hcl.EvalContext{
			Variables: inputVarMap,
		})
		if !valueConverted.Type().HasDynamicTypes() && valueConverted.IsKnown() {
			return ctyjson.SimpleJSONValue{Value: valueConverted}, nil
		}
		return c.wrapExpr(expr)
	}
}

func (c *converter) objectConsExpr(value *hclsyntax.ObjectConsExpr) (model.Document, error) {
	m := make(model.Document)
	for _, item := range value.Items {
		key, err := c.convertKey(item.KeyExpr)
		if err != nil {
			sentry.CaptureException(err)
			return nil, err
		}
		m[key], err = c.convertExpression(item.ValueExpr)
		if err != nil {
			sentry.CaptureException(err)
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
			sentry.CaptureException(err)
			return "", err
		}
		return v.AsString(), nil
	}
	var builder strings.Builder
	for _, part := range t.Parts {
		s, err := c.convertStringPart(part)
		if err != nil {
			sentry.CaptureException(err)
			return "", err
		}
		builder.WriteString(s)
	}
	return builder.String(), nil
}

func (c *converter) convertStringPart(expr hclsyntax.Expression) (string, error) {
	switch v := expr.(type) {
	case *hclsyntax.LiteralValueExpr:
		s, err := ctyconvert.Convert(v.Val, cty.String)
		if err != nil {
			sentry.CaptureException(err)
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
	var builder strings.Builder
	builder.WriteString("%{if ")
	builder.WriteString(c.rangeSource(expr.Condition.Range()))
	builder.WriteString("}")
	trueResult, err := c.convertStringPart(expr.TrueResult)
	if err != nil {
		sentry.CaptureException(err)
		return "", nil
	}
	builder.WriteString(trueResult)
	falseResult, err := c.convertStringPart(expr.FalseResult)
	if err != nil {
		sentry.CaptureException(err)
		return "", nil
	}
	if len(falseResult) > 0 {
		builder.WriteString("%{else}")
		builder.WriteString(falseResult)
	}
	builder.WriteString("%{endif}")

	return builder.String(), nil
}

func (c *converter) convertTemplateFor(expr *hclsyntax.ForExpr) (string, error) {
	var builder strings.Builder
	builder.WriteString("%{for ")
	if len(expr.KeyVar) > 0 {
		builder.WriteString(expr.KeyVar)
		builder.WriteString(", ")
	}
	builder.WriteString(expr.ValVar)
	builder.WriteString(" in ")
	builder.WriteString(c.rangeSource(expr.CollExpr.Range()))
	builder.WriteString("}")
	templ, err := c.convertStringPart(expr.ValExpr)
	if err != nil {
		sentry.CaptureException(err)
		return "", err
	}
	builder.WriteString(templ)
	builder.WriteString("%{endfor}")

	return builder.String(), nil
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
	return ctyjson.SimpleJSONValue{Value: expressionEvaluated}, nil
}

func createEntryInputVar(path []string, defaultValue string) (cty.Value, error) {
	mapJSON := "{"
	closeMap := "}"
	for idx, key := range path {
		if idx+1 < len(path) {
			mapJSON += fmt.Sprintf("\"%s\":{", key)
			closeMap += "}"
		} else {
			mapJSON += fmt.Sprintf("\"%s\": \"%s\"", key, defaultValue)
		}
	}
	mapJSON += closeMap
	jsonType, _ := ctyjson.ImpliedType([]byte(mapJSON))
	value, err := ctyjson.Unmarshal([]byte(mapJSON), jsonType)
	if err != nil {
		return cty.NilVal, err
	}
	return value, nil
}
