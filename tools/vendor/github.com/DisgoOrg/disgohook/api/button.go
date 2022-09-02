package api

// ButtonStyle defines how the Button looks like (https://discord.com/assets/7bb017ce52cfd6575e21c058feb3883b.png)
type ButtonStyle int

// Supported ButtonStyle(s)
const (
	ButtonStylePrimary = iota + 1
	ButtonStyleSecondary
	ButtonStyleSuccess
	ButtonStyleDanger
	ButtonStyleLink
)

// NewButton creates a new Button with the provided parameters. Link Button(s) need a url and other Button(s) need a customID
func NewButton(style ButtonStyle, label string, customID string, url string, emoji *Emoji, disabled bool) Button {
	return Button{
		ComponentImpl: newComponentImpl(ComponentTypeButton),
		Style:         style,
		CustomID:      customID,
		URL:           url,
		Label:         label,
		Emoji:         emoji,
		Disabled:      disabled,
	}
}

// NewPrimaryButton creates a new Button with ButtonStylePrimary & the provided parameters
func NewPrimaryButton(label string, customID string, emoji *Emoji) Button {
	return NewButton(ButtonStylePrimary, label, customID, "", emoji, false)
}

// NewSecondaryButton creates a new Button with ButtonStyleSecondary & the provided parameters
func NewSecondaryButton(label string, customID string, emoji *Emoji) Button {
	return NewButton(ButtonStyleSecondary, label, customID, "", emoji, false)
}

// NewSuccessButton creates a new Button with ButtonStyleSuccess & the provided parameters
func NewSuccessButton(label string, customID string, emoji *Emoji) Button {
	return NewButton(ButtonStyleSuccess, label, customID, "", emoji, false)
}

// NewDangerButton creates a new Button with ButtonStyleDanger & the provided parameters
func NewDangerButton(label string, customID string, emoji *Emoji) Button {
	return NewButton(ButtonStyleDanger, label, customID, "", emoji, false)
}

// NewLinkButton creates a new link Button with ButtonStyleLink & the provided parameters
func NewLinkButton(label string, url string, emoji *Emoji, disabled bool) Button {
	return NewButton(ButtonStyleLink, label, "", url, emoji, disabled)
}

// Button can be attacked to all messages & be clicked by a User. If clicked it fires a events.ButtonClickEvent with the declared customID
type Button struct {
	ComponentImpl
	Style    ButtonStyle `json:"style,omitempty"`
	Label    string      `json:"label,omitempty"`
	Emoji    *Emoji      `json:"emoji,omitempty"`
	CustomID string      `json:"custom_id,omitempty"`
	URL      string      `json:"url,omitempty"`
	Disabled bool        `json:"disabled,omitempty"`
}

// AsDisabled returns a new Button but disabled
func (b Button) AsDisabled() Button {
	b.Disabled = true
	return b
}

// AsEnabled returns a new Button but enabled
func (b Button) AsEnabled() Button {
	b.Disabled = true
	return b
}

// WithDisabled returns a new Button but disabled/enabled
func (b Button) WithDisabled(disabled bool) Button {
	b.Disabled = disabled
	return b
}

// WithEmoji returns a new Button with the provided Emoji
func (b Button) WithEmoji(emoji *Emoji) Button {
	b.Emoji = emoji
	return b
}

// WithCustomID returns a new Button with the provided custom id
func (b Button) WithCustomID(customID string) Button {
	b.CustomID = customID
	return b
}

// WithStyle returns a new Button with the provided style
func (b Button) WithStyle(style ButtonStyle) Button {
	b.Style = style
	return b
}

// WithLabel returns a new Button with the provided label
func (b Button) WithLabel(label string) Button {
	b.Label = label
	return b
}

// WithURL returns a new Button with the provided url
func (b Button) WithURL(url string) Button {
	b.URL = url
	return b
}
