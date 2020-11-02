package writer

import (
	"bytes"
	"fmt"
	"html/template"
	"path/filepath"
	"strconv"
	"strings"

	build "github.com/checkmarxDev/ice/cmd/builder/model"
	"github.com/checkmarxDev/ice/pkg/model"
	"github.com/pkg/errors"
	"github.com/rs/zerolog/log"
)

type RegoWriter struct {
	tmpl *template.Template
}

type Block struct {
	Name string
	All  bool
	List []string
}

type RegoRule struct {
	Block Block
	build.Rule
}

func NewRegoWriter() (*RegoWriter, error) {
	tmpl, err := template.New("template.gorego").
		Funcs(template.FuncMap{
			"condition": condition,
			"regoValue": regoValueToString,
			"lastCondition": func(r RegoRule) build.Condition {
				return r.Conditions[len(r.Conditions)-1]
			},
			"unescape": func(v string) template.HTML {
				return template.HTML(v) // nolint:gosec
			},
			"innerKey": func(r RegoRule) template.HTML {
				condition := r.Conditions[len(r.Conditions)-1]
				return template.HTML(conditionKey(r.Block, condition, false, true)) // nolint:gosec
			},
			"searchKey": func(r RegoRule) template.HTML {
				format := "%%s[%%s].%s"
				condition := r.Conditions[len(r.Conditions)-1]
				var vars []string

				if v, ok := condition.Attr("resource"); ok && v == "*" {
					vars = append(vars, "blockType")
				} else {
					vars = append(vars, "blockTypes[blockIndex]")
				}
				vars = append(vars, "name")
				if _, ok := condition.Attr("any_key"); ok {
					format += ".%%s"
					vars = append(vars, "key")
				}
				format = fmt.Sprintf(format, conditionKey(r.Block, condition, false, true))

				return template.HTML(fmt.Sprintf("sprintf(\"%s\", [%s])", format, strings.Join(vars, ", "))) // nolint:gosec
			},
		}).
		ParseFiles(filepath.Join("./cmd/builder/writer/template.gorego"))
	if err != nil {
		return nil, err
	}

	return &RegoWriter{tmpl: tmpl}, nil
}

func (w *RegoWriter) Render(rules []build.Rule) ([]byte, error) {
	wr := bytes.NewBuffer(nil)

	if err := w.tmpl.Execute(wr, format(rules)); err != nil {
		return nil, errors.Wrap(err, "failed to render")
	}

	return wr.Bytes(), nil
}

func condition(r Block, c build.Condition) string {
	key := conditionKey(r, c, true, false)

	if c.IssueType == model.IssueTypeRedundantAttribute {
		return key
	}
	if c.IssueType == model.IssueTypeMissingAttribute {
		return fmt.Sprintf("not %s", key)
	}

	if _, ok := c.Attr("upper"); ok {
		key = fmt.Sprintf("upper(%s)", key)
	}
	if _, ok := c.Attr("lower"); ok {
		key = fmt.Sprintf("lower(%s)", key)
	}

	if reg, ok := c.Attr("regex"); ok {
		return fmt.Sprintf("re_match(\"%s\", %s)", reg, key)
	}

	condition := "=="
	if v, ok := c.AttrAsString("condition"); ok {
		condition = v
	}

	if value, ok := c.AttrAsString("val"); ok {
		return fmt.Sprintf("%s %s %s", key, condition, regoValueToString(value))
	}

	return fmt.Sprintf("%s %s %s", key, condition, regoValueToString(c.Value))
}

func regoValueToString(i interface{}) string {
	switch v := i.(type) {
	case bool:
		if v {
			return "true"
		}
		return "false"
	case int64:
		return strconv.Itoa(int(v))
	case int32:
		return strconv.Itoa(int(v))
	case int:
		return strconv.Itoa(v)
	case float64:
		return strconv.FormatFloat(v, 'f', 6, 64)
	case float32:
		return strconv.FormatFloat(float64(v), 'f', 6, 32)
	case string:
		return fmt.Sprintf("\"%s\"", v)
	case *string:
		if v == nil {
			return "\"\""
		}
		return fmt.Sprintf("\"%s\"", *v)
	case []string:
		sts := make([]string, 0, len(v))
		for _, vi := range v {
			sts = append(sts, fmt.Sprintf("\"%s\"", vi))
		}

		return fmt.Sprintf("{%s}", strings.Join(sts, ", "))
	default:
		log.Warn().Msgf("can't convert value, %T to string", i)
		return ""
	}
}

func conditionKey(block Block, c build.Condition, withBlockPrefix, pathOnly bool) string {
	key := ""
	if withBlockPrefix {
		key = "block"
	}
	for i, pathItem := range c.Path {
		switch pathItem.Type {
		case build.PathTypeResourceType:
			if pathOnly {
				continue
			} else if block.All {
				key += "[blockType]"
			} else {
				key += "[blockTypes[blockIndex]]"
			}
		case build.PathTypeResourceName:
			if !pathOnly {
				key += "[name]"
			}
		case build.PathTypeDefault:
			if _, ok := c.Attr("any_key"); ok && i == len(c.Path)-1 {
				if !pathOnly {
					key += "[key]"
				}
				continue
			}

			if key != "" {
				key += "."
			}

			key += pathItem.Name
		}
	}

	return key
}

func format(rules []build.Rule) []RegoRule {
	res := make([]RegoRule, len(rules))
	for i, r := range rules {
		res[i] = RegoRule{
			Rule:  r,
			Block: createBlock(r),
		}
	}

	return res
}

func createBlock(rule build.Rule) Block { // nolint:gocyclo
	result := Block{}
	for _, pathItem := range rule.Conditions[len(rule.Conditions)-1].Path {
		if pathItem.Type == build.PathTypeResource {
			result.Name = pathItem.Name
			break
		}
	}

	resources := make(map[string]struct{}, len(rule.Conditions))
	for _, condition := range rule.Conditions {
		if len(condition.Path) == 0 {
			continue
		}

		v, ok := condition.Attr("resource")
		if !ok {
			for _, pathItem := range condition.Path {
				if pathItem.Type == build.PathTypeResourceType {
					resources[pathItem.Name] = struct{}{}
				}
			}

			continue
		}

		switch vv := v.(type) {
		case string:
			if vv == "*" {
				result.All = true
			}
			resources[vv] = struct{}{}
		case []string:
			for _, vi := range vv {
				resources[vi] = struct{}{}
			}
		case []interface{}:
			for _, vi := range vv {
				if vvi, ok := vi.(string); ok {
					resources[vvi] = struct{}{}
				}
			}
		}
	}

	result.List = make([]string, 0, len(resources))
	for resource := range resources {
		result.List = append(result.List, resource)
	}

	return result
}
