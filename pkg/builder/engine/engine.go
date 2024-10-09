package engine

import (
	"fmt"
	"strings"

	build "github.com/Checkmarx/kics/v2/pkg/builder/model"
	commentParser "github.com/Checkmarx/kics/v2/pkg/builder/parser/comment"
	tagParser "github.com/Checkmarx/kics/v2/pkg/builder/parser/tag"
	"github.com/Checkmarx/kics/v2/pkg/model"
	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/hclsyntax"
	"github.com/rs/zerolog/log"
	"github.com/zclconf/go-cty/cty"
	ctyConvert "github.com/zclconf/go-cty/cty/convert"
)

const resourceLabelsCount = 2

// Engine contains the conditions of rules and comments positions
type Engine struct {
	commentParser *commentParser.Parser
	conditions    []build.Condition
}

// Run parses files and execute engine.Run
func Run(src []byte, filename string) ([]build.Rule, error) {
	cp, err := commentParser.NewParser(src, filename)
	if err != nil {
		return nil, err
	}

	file, diags := hclsyntax.ParseConfig(src, filename, hcl.Pos{Byte: 0, Line: 1, Column: 1})
	if diags != nil && diags.HasErrors() {
		return nil, diags.Errs()[0]
	}
	if file == nil {
		return nil, fmt.Errorf("invalid parse result")
	}

	e := &Engine{
		commentParser: cp,
	}

	return e.Run(file.Body.(*hclsyntax.Body))
}

// Run initializes rules for Engine and returns it
func (e *Engine) Run(body *hclsyntax.Body) ([]build.Rule, error) {
	e.conditions = make([]build.Condition, 0)
	if err := e.walkBody(body, []build.PathItem{}); err != nil {
		return nil, err
	}

	rules := make([]build.Rule, 0)
	conditionGroups := make(map[string][]build.Condition)
	for _, condition := range e.conditions {
		group, ok := condition.AttrAsString("group")
		if !ok {
			rules = append(rules, build.Rule{
				Conditions: []build.Condition{condition},
			})
			continue
		}

		conditionGroups[group] = append(conditionGroups[group], condition)
	}

	for _, conditionGroup := range conditionGroups {
		rules = append(rules, build.Rule{
			Conditions: conditionGroup,
		})
	}
	return rules, nil
}

func (e *Engine) walkBody(body *hclsyntax.Body, walkHistory []build.PathItem) error {
	for _, attribute := range body.Attributes {
		if err := e.walkAttribute(attribute, walkHistory); err != nil {
			return err
		}
	}

	for _, block := range body.Blocks {
		if err := e.walkBlock(block, walkHistory); err != nil {
			return err
		}
	}

	return nil
}

func (e *Engine) walkBlock(block *hclsyntax.Block, walkHistory []build.PathItem) error {
	if len(block.Labels) == resourceLabelsCount {
		walkHistory = append(walkHistory,
			build.PathItem{Type: build.PathTypeResource, Name: block.Type},
			build.PathItem{Type: build.PathTypeResourceType, Name: block.Labels[0]},
			build.PathItem{Type: build.PathTypeResourceName, Name: block.Type},
		)
	} else {
		walkHistory = append(walkHistory, build.PathItem{Type: build.PathTypeDefault, Name: block.Type})
	}

	e.checkComment(block.Range(), walkHistory, nil)

	return e.walkBody(block.Body, walkHistory)
}

func (e *Engine) walkAttribute(attr *hclsyntax.Attribute, walkHistory []build.PathItem) error {
	walkHistory = append(walkHistory, build.PathItem{Type: build.PathTypeDefault, Name: attr.Name})

	switch exp := attr.Expr.(type) {
	case *hclsyntax.TemplateExpr,
		*hclsyntax.TemplateWrapExpr,
		*hclsyntax.LiteralValueExpr,
		*hclsyntax.ScopeTraversalExpr:

		v, err := e.ExpToString(attr.Expr)
		if err != nil {
			return err
		}

		e.checkComment(attr.Range(), walkHistory, &v)
	case *hclsyntax.ObjectConsExpr:
		e.checkComment(attr.Range(), walkHistory, nil)

		for _, item := range exp.Items {
			if err := e.walkConstantItem(item, walkHistory); err != nil {
				return err
			}
		}
	default:
		e.checkComment(attr.Range(), walkHistory, nil)
	}

	return nil
}

// ExpToString converts an expression into a string
func (e *Engine) ExpToString(expr hclsyntax.Expression) (string, error) {
	switch t := expr.(type) {
	case *hclsyntax.LiteralValueExpr:
		s, err := ctyConvert.Convert(t.Val, cty.String)
		if err != nil {
			return "", err
		}
		return s.AsString(), nil
	case *hclsyntax.TemplateExpr:
		if t.IsStringLiteral() {
			v, err := t.Value(nil)
			if err != nil {
				return "", err
			}
			return v.AsString(), nil
		}
		builderString, err := e.buildString(t.Parts)
		if err != nil {
			return "", err
		}

		return builderString, nil
	case *hclsyntax.TemplateWrapExpr:
		return e.ExpToString(t.Wrapped)
	case *hclsyntax.ObjectConsKeyExpr:
		return e.ExpToString(t.Wrapped)
	case *hclsyntax.ScopeTraversalExpr:
		items := evaluateScopeTraversalExpr(t.Traversal)
		return strings.Join(items, "."), nil
	}

	return "", fmt.Errorf("can't convert expression %T to string", expr)
}

func (e *Engine) buildString(parts []hclsyntax.Expression) (string, error) {
	builder := &strings.Builder{}

	for _, part := range parts {
		s, err := e.ExpToString(part)
		if err != nil {
			return "", err
		}
		builder.WriteString(s)
	}

	s := builder.String()

	builder.Reset()
	builder = nil

	return s, nil
}

func (e *Engine) walkConstantItem(item hclsyntax.ObjectConsItem, walkHistory []build.PathItem) error {
	k, err := e.ExpToString(item.KeyExpr)
	if err != nil {
		return err
	}

	walkHistory = append(walkHistory, build.PathItem{Type: build.PathTypeDefault, Name: k})

	v, err := e.ExpToString(item.ValueExpr)
	if err != nil {
		return err
	}

	e.checkComment(item.ValueExpr.Range(), walkHistory, &v)

	return nil
}

func (e *Engine) checkComment(rg hcl.Range, walkHistory []build.PathItem, actualValue *string) {
	leadComment, endLineComment := e.commentParser.ParseCommentsForNode(rg)
	if !leadComment.IsEmpty() {
		e.addRule(walkHistory, leadComment, actualValue)
	}
	if !endLineComment.IsEmpty() {
		e.addRule(walkHistory, endLineComment, actualValue)
	}
}

func (e *Engine) addRule(walkHistory []build.PathItem, comment commentParser.Comment, actualValue *string) {
	tags, err := tagParser.Parse(comment.Value(), model.AllIssueTypesAsString)
	if err != nil {
		log.Err(err).Msgf("Line %d: failed to parse comment '%s'", comment.Line(), comment.Value())
		return
	}

	if len(tags) == 0 {
		return
	}

	cp := make([]build.PathItem, len(walkHistory))
	copy(cp, walkHistory)

	for _, t := range tags {
		e.conditions = append(e.conditions, build.Condition{
			Line:       comment.Line(),
			IssueType:  model.IssueType(t.Name),
			Path:       cp,
			Value:      actualValue,
			Attributes: t.Attributes,
		})
	}
}

func evaluateScopeTraversalExpr(t hcl.Traversal) []string {
	items := make([]string, 0)
	for _, part := range t {
		switch tt := part.(type) {
		case hcl.TraverseAttr:
			items = append(items, tt.Name)
		case hcl.TraverseRoot:
			items = append(items, tt.Name)
		case hcl.TraverseIndex:
			switch tt.Key.Type() {
			case cty.Number:
				items = append(items, tt.Key.AsBigFloat().String())
			case cty.String:
				items = append(items, tt.Key.AsString())
			}
		}
	}
	return items
}
