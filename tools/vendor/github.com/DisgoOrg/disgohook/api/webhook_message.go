package api

import (
	"encoding/json"
	"time"
)

// WebhookMessage represents a message created by a Webhook
type WebhookMessage struct {
	Webhook         WebhookClient
	ID              Snowflake     `json:"id"`
	WebhookID       Snowflake     `json:"webhook_id"`
	ChannelID       Snowflake     `json:"channel_id"`
	GuildID         Snowflake     `json:"guild_id"`
	TTS             bool          `json:"tts"`
	Author          *User         `json:"author"`
	CreatedAt       time.Time     `json:"timestamp"`
	EditedAt        *time.Time    `json:"edited_timestamp"`
	Content         *string       `json:"content,omitempty"`
	Embeds          []Embed       `json:"embeds,omitempty"`
	Components      []Component   `json:"-"`
	Attachments     []Attachment  `json:"attachments,omitempty"`
	Mentions        []interface{} `json:"mentions"`
	MentionEveryone bool          `json:"mention_everyone"`
	MentionRoles    []string      `json:"mention_roles"`
}

// Unmarshal is used to unmarshal a WebhookMessage we received from discord
func (m *WebhookMessage) Unmarshal(data []byte) error {
	var fullM struct {
		*WebhookMessage
		Components []UnmarshalComponent `json:"components,omitempty"`
	}
	err := json.Unmarshal(data, &fullM)
	if err != nil {
		return err
	}
	*m = *fullM.WebhookMessage
	for _, component := range fullM.Components {
		m.Components = append(m.Components, createComponent(component))
	}
	return nil
}

// Marshal is used to marshal a WebhookMessage we send to discord
func (m *WebhookMessage) Marshal() ([]byte, error) {
	fullM := struct {
		*WebhookMessage
		Components []Component `json:"components,omitempty"`
	}{
		WebhookMessage: m,
		Components:     m.Components,
	}
	fullM.WebhookMessage = m
	data, err := json.Marshal(fullM)
	if err != nil {
		return nil, err
	}
	return data, nil
}

func createComponent(unmarshalComponent UnmarshalComponent) Component {
	switch unmarshalComponent.ComponentType {
	case ComponentTypeActionRow:
		components := make([]Component, len(unmarshalComponent.Components))
		for i, unmarshalC := range unmarshalComponent.Components {
			components[i] = createComponent(unmarshalC)
		}
		return ActionRow{
			ComponentImpl: ComponentImpl{
				ComponentType: ComponentTypeActionRow,
			},
			Components: components,
		}

	case ComponentTypeButton:
		return Button{
			ComponentImpl: ComponentImpl{
				ComponentType: ComponentTypeButton,
			},
			Style:    unmarshalComponent.Style,
			Label:    unmarshalComponent.Label,
			Emoji:    unmarshalComponent.Emoji,
			CustomID: unmarshalComponent.CustomID,
			URL:      unmarshalComponent.URL,
			Disabled: unmarshalComponent.Disabled,
		}

	default:
		return nil
	}
}

// Edit allows you to edit an existing WebhookMessage sent by you
func (m *WebhookMessage) Edit(WebhookMessage WebhookMessageUpdate) (*WebhookMessage, error) {
	return m.Webhook.EditMessage(m.ID, WebhookMessage)
}

// Delete allows you to delete an existing WebhookMessage sent by you
func (m *WebhookMessage) Delete() error {
	return m.Webhook.DeleteMessage(m.ID)
}

// ActionRows returns all ActionRow(s) from this WebhookMessage
func (m *WebhookMessage) ActionRows() []ActionRow {
	var actionRows []ActionRow
	for _, component := range m.Components {
		if actionRow, ok := component.(ActionRow); ok {
			actionRows = append(actionRows, actionRow)
		}
	}
	return actionRows
}

// ComponentByID returns the first Component with the specific customID
func (m *WebhookMessage) ComponentByID(customID string) Component {
	for _, actionRow := range m.ActionRows() {
		for _, component := range actionRow.Components {
			switch c := component.(type) {
			case Button:
				if c.CustomID == customID {
					return c
				}
			case SelectMenu:
				if c.CustomID == customID {
					return c
				}
			default:
				continue
			}
		}
	}
	return nil
}

// Buttons returns all Button(s) from this WebhookMessage
func (m *WebhookMessage) Buttons() []Button {
	var buttons []Button
	for _, actionRow := range m.ActionRows() {
		for _, component := range actionRow.Components {
			if button, ok := component.(Button); ok {
				buttons = append(buttons, button)
			}
		}
	}
	return buttons
}

// ButtonByID returns a Button with the specific customID from this WebhookMessage
func (m *WebhookMessage) ButtonByID(customID string) *Button {
	for _, button := range m.Buttons() {
		if button.CustomID == customID {
			return &button
		}
	}
	return nil
}

// SelectMenus returns all SelectMenu(s) from this WebhookMessage
func (m *WebhookMessage) SelectMenus() []SelectMenu {
	var selectMenus []SelectMenu
	for _, actionRow := range m.ActionRows() {
		for _, component := range actionRow.Components {
			if selectMenu, ok := component.(SelectMenu); ok {
				selectMenus = append(selectMenus, selectMenu)
			}
		}
	}
	return selectMenus
}

// SelectMenuByID returns a SelectMenu with the specific customID from this WebhookMessage
func (m *WebhookMessage) SelectMenuByID(customID string) *SelectMenu {
	for _, selectMenu := range m.SelectMenus() {
		if selectMenu.CustomID == customID {
			return &selectMenu
		}
	}
	return nil
}

//Attachment is used for files sent in a WebhookMessage
type Attachment struct {
	ID       Snowflake `json:"id,omitempty"`
	Filename string    `json:"filename"`
	Size     int       `json:"size"`
	URL      string    `json:"url"`
	ProxyURL string    `json:"proxy_url"`
	Height   *int      `json:"height"`
	Width    *int      `json:"width"`
}
