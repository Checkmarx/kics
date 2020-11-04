package model

import "github.com/checkmarxDev/ice/pkg/model"

type PathItemType string

const (
	PathTypeDefault      PathItemType = "DEFAULT"
	PathTypeResource     PathItemType = "RESOURCE"
	PathTypeResourceType PathItemType = "RESOURCE_TYPE"
	PathTypeResourceName PathItemType = "RESOURCE_NAME"
)

type PathItem struct {
	Name string
	Type PathItemType
}

type Condition struct {
	Line int

	IssueType  model.IssueType
	Path       []PathItem
	Value      interface{}
	Attributes map[string]interface{}
}

type Rule struct {
	Conditions []Condition
}

func (c Condition) Attr(name string) (interface{}, bool) {
	v, ok := c.Attributes[name]
	if !ok {
		return nil, false
	}

	return v, true
}

func (c Condition) AttrAsString(name string) (string, bool) {
	v, ok := c.Attributes[name]
	if !ok {
		return "", false
	}

	if vv, ok := v.(string); ok {
		return vv, true
	}

	return "", false
}
