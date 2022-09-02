package api

var _ Component = (*ActionRow)(nil)

// NewActionRow creates a new ActionRow holding th provided Component(s)
func NewActionRow(components ...Component) ActionRow {
	return ActionRow{
		ComponentImpl: newComponentImpl(ComponentTypeActionRow),
		Components:    components,
	}
}

// ActionRow holds up to 5 Component(s) in a row
type ActionRow struct {
	ComponentImpl
	Components []Component `json:"components"`
}

// SetComponents returns a new ActionRow with the provided Component(s)
func (r ActionRow) SetComponents(components ...Component) ActionRow {
	r.Components = components
	return r
}

// SetComponent returns a new ActionRow with the Component which has the customID replaced
func (r ActionRow) SetComponent(customID string, component Component) ActionRow {
	for i, c := range r.Components {
		switch com := c.(type) {
		case Button:
			if com.CustomID == customID {
				r.Components[i] = component
				break
			}
		case SelectMenu:
			if com.CustomID == customID {
				r.Components[i] = component
				break
			}
		default:
			continue
		}
	}
	return r
}

// AddComponents returns a new ActionRow with the provided Component(s) added
func (r ActionRow) AddComponents(components ...Component) ActionRow {
	r.Components = append(r.Components, components...)
	return r
}

// RemoveComponent returns a new ActionRow with the provided Component at the index removed
func (r ActionRow) RemoveComponent(index int) ActionRow {
	if len(r.Components) > index {
		r.Components = append(r.Components[:index], r.Components[index+1:]...)
	}
	return r
}
