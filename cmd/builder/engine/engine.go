package engine

import (
	"fmt"
	"regexp"
	"strings"

	"github.com/checkmarxDev/ice/cmd/builder/comment_parser"
	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/hashicorp/hcl/v2"
	"github.com/hashicorp/hcl/v2/hclsyntax"
	"github.com/rs/zerolog/log"
	"github.com/zclconf/go-cty/cty"
	ctyconvert "github.com/zclconf/go-cty/cty/convert"
)

type Engine struct {
	commentParser *comment_parser.Parser
	rules         []Rule
}

type infoType string

const (
	InfoTypePath         infoType = "PATH"
	InfoTypeResourceName infoType = "RESOURCE_NAME"
)

type Rule struct {
	ResourceType  string
	WalkHistory   []WalkHistoryItem
	IssueType     model.IssueType
	ActualValue   string
	ExpectedValue string
}

type WalkHistoryItem struct {
	InfoType infoType
	Name     string
}

func New(commentParser *comment_parser.Parser) *Engine {
	return &Engine{
		commentParser: commentParser,
	}
}

func (e *Engine) Run(body *hclsyntax.Body) ([]Rule, error) {
	e.rules = make([]Rule, 0)
	e.walkBody(body, []WalkHistoryItem{})

	return e.rules, nil
}

func (e *Engine) walkBody(body *hclsyntax.Body, walkHistory []WalkHistoryItem) {
	for _, attribute := range body.Attributes {
		e.walkAttribute(attribute, walkHistory)
	}

	for _, block := range body.Blocks {
		e.walkBlock(block, walkHistory)
	}
}

func (e *Engine) walkBlock(block *hclsyntax.Block, walkHistory []WalkHistoryItem) {
	walkHistory = append(walkHistory, WalkHistoryItem{InfoType: InfoTypePath, Name: block.Type})
	if len(block.Labels) == 2 {
		walkHistory = append(walkHistory, WalkHistoryItem{InfoType: InfoTypePath, Name: block.Labels[0]})
		walkHistory = append(walkHistory, WalkHistoryItem{InfoType: InfoTypeResourceName, Name: block.Labels[1]})
	}

	e.checkComment(block.Range(), walkHistory, nil)

	e.walkBody(block.Body, walkHistory)
}

func (e *Engine) walkAttribute(attr *hclsyntax.Attribute, walkHistory []WalkHistoryItem) {
	walkHistory = append(walkHistory, WalkHistoryItem{InfoType: InfoTypePath, Name: attr.Name})

	switch attr.Expr.(type) {
	case *hclsyntax.TemplateExpr,
		*hclsyntax.TemplateWrapExpr,
		*hclsyntax.LiteralValueExpr,
		*hclsyntax.ScopeTraversalExpr:

		v := e.expToString(attr.Expr)
		e.checkComment(attr.Range(), walkHistory, &v)
	case *hclsyntax.ObjectConsExpr:
		e.checkComment(attr.Range(), walkHistory, nil)

		if oc, ok := attr.Expr.(*hclsyntax.ObjectConsExpr); ok {
			for _, item := range oc.Items {
				e.walkConstantItem(item, walkHistory)
			}
		}
	default:
		e.checkComment(attr.Range(), walkHistory, nil)
	}
}

func (e *Engine) expToString(expr hclsyntax.Expression) string {
	switch t := expr.(type) {
	case *hclsyntax.LiteralValueExpr:
		s, _ := ctyconvert.Convert(t.Val, cty.String) // todo: add error handling
		return s.AsString()
	case *hclsyntax.TemplateExpr:
		if t.IsStringLiteral() {
			v, _ := t.Value(nil) // todo: add error handling
			return v.AsString()
		}
		var builder strings.Builder
		for _, part := range t.Parts {
			builder.WriteString(e.expToString(part))
		}
		return builder.String()
	case *hclsyntax.TemplateWrapExpr:
		return e.expToString(t.Wrapped)
	case *hclsyntax.ObjectConsKeyExpr:
		return e.expToString(t.Wrapped)
	case *hclsyntax.ScopeTraversalExpr:
		var items []string
		for _, part := range t.Traversal {
			switch tt := part.(type) {
			case hcl.TraverseAttr:
				items = append(items, tt.Name)
			case hcl.TraverseRoot:
				items = append(items, tt.Name)
			case hcl.TraverseIndex:
				items = append(items, tt.Key.AsString())
			}

		}
		return strings.Join(items, ".")
	}

	return "" // todo: return error here
}

func (e *Engine) walkConstantItem(item hclsyntax.ObjectConsItem, walkHistory []WalkHistoryItem) {
	k := e.expToString(item.KeyExpr)
	walkHistory = append(walkHistory, WalkHistoryItem{InfoType: InfoTypePath, Name: k})

	v := e.expToString(item.ValueExpr)
	e.checkComment(item.ValueExpr.Range(), walkHistory, &v)
}

func (e *Engine) checkComment(rg hcl.Range, walkHistory []WalkHistoryItem, actualValue *string) {
	leadComment, endLineComment := e.commentParser.ParseCommentsForNode(rg)
	if e.isSupportedComment(leadComment) {
		e.addRule(walkHistory, leadComment, actualValue)
	}
	if e.isSupportedComment(endLineComment) {
		e.addRule(walkHistory, endLineComment, actualValue)
	}
}

func (e *Engine) isSupportedComment(comment comment_parser.Comment) bool {
	if comment.IsEmpty() {
		return false
	}

	msgLower := strings.ToLower(comment.Value())
	for _, issueType := range model.AllIssueTypes {
		if strings.Contains(msgLower, strings.ToLower(string(issueType))) {
			return true
		}
	}

	return false
}

var expectedRegex = regexp.MustCompile(`expected[ ]?"(.*)"`)

func (e *Engine) addRule(walkHistory []WalkHistoryItem, comment comment_parser.Comment, actualValue *string) {
	msgLower := strings.ToLower(comment.Value())
	for _, issueType := range model.AllIssueTypes {
		if strings.Contains(msgLower, strings.ToLower(string(issueType))) {
			r := Rule{
				ResourceType: walkHistory[0].Name,
				WalkHistory:  walkHistory[1:],
				IssueType:    issueType,
			}

			if issueType == model.IssueTypeIncorrectValue {
				if actualValue == nil {
					log.Error().Msgf("line %d: invalid comment 'IncorrectValue' position (should be only new valuable field)", comment.Line())
					continue
				}
				r.ActualValue = *actualValue

				if expectedRegex.MatchString(comment.Value()) {
					parts := expectedRegex.FindStringSubmatch(comment.Value())
					r.ExpectedValue = parts[1]
				} else {
					log.Info().Msgf("line %d: comment 'IncorrectValue' without expected value", comment.Line())
				}
			}

			e.rules = append(e.rules, r)
		}
	}
}

type ResourcePaths struct {
	Vars         string
	Path         string
	PathWithVars string
	SearchPath   string
}

func (r Rule) ResourcePaths() ResourcePaths {
	var (
		vars                              []string
		varsPath, searchPath, withoutVars string
	)
	index := 0
	for _, item := range r.WalkHistory {
		switch item.InfoType {
		case InfoTypePath:
			if len(searchPath) > 0 {
				searchPath += "."
				varsPath += "."
				withoutVars += "."
			}
			searchPath += item.Name
			varsPath += item.Name
			withoutVars += item.Name
		case InfoTypeResourceName:
			v := fmt.Sprintf("var%d", index)
			vars = append(vars, v)
			varsPath += "[%s]"
			searchPath += fmt.Sprintf("[%s]", v)
			index++
		}
	}

	return ResourcePaths{
		Vars:         strings.Join(vars, ", "),
		PathWithVars: varsPath,
		Path:         withoutVars,
		SearchPath:   searchPath,
	}
}
