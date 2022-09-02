package api

// ComponentType defines different Component(s)
type ComponentType int

// Supported ComponentType(s)
const (
	ComponentTypeActionRow = iota + 1
	ComponentTypeButton
	ComponentTypeSelectMenu
)

// Component is a general interface each Component needs to implement
type Component interface {
	Type() ComponentType
}

func newComponentImpl(componentType ComponentType) ComponentImpl {
	return ComponentImpl{ComponentType: componentType}
}

// ComponentImpl is used to embed in each different ComponentType
type ComponentImpl struct {
	ComponentType ComponentType `json:"type"`
}

// Type returns the ComponentType of this Component
func (t ComponentImpl) Type() ComponentType {
	return t.ComponentType
}

// UnmarshalComponent is used for easier unmarshalling of different Component(s)
type UnmarshalComponent struct {
	ComponentType ComponentType `json:"type"`

	// Button && SelectMenu
	CustomID string `json:"custom_id"`

	// Button
	Style    ButtonStyle `json:"style"`
	Label    string      `json:"label"`
	Emoji    *Emoji      `json:"emoji"`
	URL      string      `json:"url"`
	Disabled bool        `json:"disabled"`

	// ActionRow
	Components []UnmarshalComponent `json:"components"`

	// SelectMenu
	Placeholder string         `json:"placeholder"`
	MinValues   int            `json:"min_values,omitempty"`
	MaxValues   int            `json:"max_values,omitempty"`
	Options     []SelectOption `json:"options"`
}
