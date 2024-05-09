package model

import "github.com/Checkmarx/kics/v2/pkg/model"

// PathItemType represents which type of path that item belongs on json representation
type PathItemType string

// Constants for kinds of PathItemTypes
const (
	PathTypeDefault      PathItemType = "DEFAULT"
	PathTypeResource     PathItemType = "RESOURCE"
	PathTypeResourceType PathItemType = "RESOURCE_TYPE"
	PathTypeResourceName PathItemType = "RESOURCE_NAME"
)

// PathItem represents json's element name and type
type PathItem struct {
	Name string
	Type PathItemType
}

// Condition represents a condition from a rule that should be checked
type Condition struct {
	Line int

	IssueType  model.IssueType
	Path       []PathItem
	Value      interface{}
	Attributes map[string]interface{}
}

// Rule represents a list of conditions to validate a rule
type Rule struct {
	Conditions []Condition
}

// Attr add some configurations to the condition to return the condition to be matched
func (c Condition) Attr(name string) (interface{}, bool) {
	v, ok := c.Attributes[name]
	if !ok {
		return nil, false
	}

	return v, true
}

// AttrAsString gets Attr and converts to string
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
