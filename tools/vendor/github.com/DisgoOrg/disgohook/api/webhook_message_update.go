package api

import (
	"encoding/json"
	"fmt"
	"github.com/DisgoOrg/restclient"
	"io"
)

type updateFlags int

const (
	updateFlagContent = 1 << iota
	updateFlagComponents
	updateFlagEmbeds
	updateFlagFiles
	updateFlagRetainAttachment
	updateFlagAllowedMentions
	updateFlagFlags
)

// WebhookMessageUpdate is used to edit a WebhookMessage
type WebhookMessageUpdate struct {
	Content         string            `json:"content"`
	Embeds          []Embed           `json:"embeds"`
	Components      []Component       `json:"components"`
	Attachments     []Attachment      `json:"attachments"`
	Files           []restclient.File `json:"-"`
	AllowedMentions *AllowedMentions  `json:"allowed_mentions"`
	Flags           MessageFlags      `json:"flags"`
	updateFlags     updateFlags
}

// ToBody returns the WebhookMessageUpdate ready for body
func (m WebhookMessageUpdate) ToBody() (interface{}, error) {
	if len(m.Files) > 0 && m.isUpdated(updateFlagFiles) {
		return restclient.PayloadWithFiles(m, m.Files...)
	}
	return m, nil
}

func (m WebhookMessageUpdate) isUpdated(flag updateFlags) bool {
	return (m.updateFlags & flag) == flag
}

// MarshalJSON marshals the WebhookMessageUpdate into json
func (m WebhookMessageUpdate) MarshalJSON() ([]byte, error) {
	data := map[string]interface{}{}

	if m.isUpdated(updateFlagContent) {
		data["content"] = m.Content
	}
	if m.isUpdated(updateFlagComponents) {
		data["components"] = m.Components
	}
	if m.isUpdated(updateFlagEmbeds) {
		data["embeds"] = m.Embeds
	}
	if m.isUpdated(updateFlagAllowedMentions) {
		data["allowed_mentions"] = m.AllowedMentions
	}
	if m.isUpdated(updateFlagFlags) {
		data["flags"] = m.Flags
	}

	return json.Marshal(data)
}

// WebhookMessageUpdateBuilder helper to build WebhookMessageUpdate easier
type WebhookMessageUpdateBuilder struct {
	WebhookMessageUpdate
}

// NewWebhookMessageUpdateBuilder creates a new WebhookMessageUpdateBuilder to be built later
func NewWebhookMessageUpdateBuilder() *WebhookMessageUpdateBuilder {
	return &WebhookMessageUpdateBuilder{
		WebhookMessageUpdate: WebhookMessageUpdate{
			AllowedMentions: &DefaultAllowedMentions,
		},
	}
}

// SetContent sets content of the WebhookMessage
func (b *WebhookMessageUpdateBuilder) SetContent(content string) *WebhookMessageUpdateBuilder {
	b.Content = content
	b.updateFlags |= updateFlagContent
	return b
}

// SetContentf sets content of the WebhookMessage
func (b *WebhookMessageUpdateBuilder) SetContentf(content string, a ...interface{}) *WebhookMessageUpdateBuilder {
	return b.SetContent(fmt.Sprintf(content, a...))
}

// SetEmbeds sets the embeds of the WebhookMessage
func (b *WebhookMessageUpdateBuilder) SetEmbeds(embeds ...Embed) *WebhookMessageUpdateBuilder {
	b.Embeds = embeds
	b.updateFlags |= updateFlagEmbeds
	return b
}

// AddEmbeds adds multiple embeds to the WebhookMessage
func (b *WebhookMessageUpdateBuilder) AddEmbeds(embeds ...Embed) *WebhookMessageUpdateBuilder {
	b.Embeds = append(b.Embeds, embeds...)
	b.updateFlags |= updateFlagEmbeds
	return b
}

// ClearEmbeds removes all of the embeds from the WebhookMessage
func (b *WebhookMessageUpdateBuilder) ClearEmbeds() *WebhookMessageUpdateBuilder {
	b.Embeds = []Embed{}
	b.updateFlags |= updateFlagEmbeds
	return b
}

// RemoveEmbed removes an embed from the WebhookMessage
func (b *WebhookMessageUpdateBuilder) RemoveEmbed(index int) *WebhookMessageUpdateBuilder {
	if b != nil && len(b.Embeds) > index {
		b.Embeds = append(b.Embeds[:index], b.Embeds[index+1:]...)
	}
	b.updateFlags |= updateFlagEmbeds
	return b
}

// SetComponents sets the Component(s) of the WebhookMessage
func (b *WebhookMessageUpdateBuilder) SetComponents(components ...Component) *WebhookMessageUpdateBuilder {
	b.Components = components
	b.updateFlags |= updateFlagComponents
	return b
}

// AddComponents adds the Component(s) to the WebhookMessage
func (b *WebhookMessageUpdateBuilder) AddComponents(components ...Component) *WebhookMessageUpdateBuilder {
	b.Components = append(b.Components, components...)
	b.updateFlags |= updateFlagComponents
	return b
}

// ClearComponents removes all of the Component(s) of the WebhookMessage
func (b *WebhookMessageUpdateBuilder) ClearComponents() *WebhookMessageUpdateBuilder {
	b.Components = []Component{}
	b.updateFlags |= updateFlagComponents
	return b
}

// RemoveComponent removes a Component from the WebhookMessage
func (b *WebhookMessageUpdateBuilder) RemoveComponent(i int) *WebhookMessageUpdateBuilder {
	if b != nil && len(b.Components) > i {
		b.Components = append(b.Components[:i], b.Components[i+1:]...)
	}
	b.updateFlags |= updateFlagComponents
	return b
}

// SetFiles sets the files for this WebhookMessage
func (b *WebhookMessageUpdateBuilder) SetFiles(files ...restclient.File) *WebhookMessageUpdateBuilder {
	b.Files = files
	b.updateFlags |= updateFlagFiles
	return b
}

// AddFiles adds the files to the WebhookMessage
func (b *WebhookMessageUpdateBuilder) AddFiles(files ...restclient.File) *WebhookMessageUpdateBuilder {
	b.Files = append(b.Files, files...)
	b.updateFlags |= updateFlagFiles
	return b
}

// AddFile adds a file to the WebhookMessage
func (b *WebhookMessageUpdateBuilder) AddFile(name string, reader io.Reader, flags ...restclient.FileFlags) *WebhookMessageUpdateBuilder {
	b.Files = append(b.Files, restclient.File{
		Name:   name,
		Reader: reader,
		Flags:  restclient.FileFlagNone.Add(flags...),
	})
	b.updateFlags |= updateFlagFiles
	return b
}

// ClearFiles removes all files of this WebhookMessage
func (b *WebhookMessageUpdateBuilder) ClearFiles() *WebhookMessageUpdateBuilder {
	b.Files = []restclient.File{}
	b.updateFlags |= updateFlagFiles
	return b
}

// RemoveFiles removes the file at this index
func (b *WebhookMessageUpdateBuilder) RemoveFiles(i int) *WebhookMessageUpdateBuilder {
	if len(b.Files) > i {
		b.Files = append(b.Files[:i], b.Files[i+1:]...)
	}
	b.updateFlags |= updateFlagFiles
	return b
}

// RetainAttachments removes all Attachment(s) from this WebhookMessage except the ones provided
func (b *WebhookMessageUpdateBuilder) RetainAttachments(attachments ...Attachment) *WebhookMessageUpdateBuilder {
	b.Attachments = append(b.Attachments, attachments...)
	b.updateFlags |= updateFlagRetainAttachment
	return b
}

// RetainAttachmentsByID removes all Attachment(s) from this WebhookMessage except the ones provided
func (b *WebhookMessageUpdateBuilder) RetainAttachmentsByID(attachmentIDs ...Snowflake) *WebhookMessageUpdateBuilder {
	for _, attachmentID := range attachmentIDs {
		b.Attachments = append(b.Attachments, Attachment{
			ID: attachmentID,
		})
	}
	b.updateFlags |= updateFlagRetainAttachment
	return b
}

// SetAllowedMentions sets the AllowedMentions of the Message
func (b *WebhookMessageUpdateBuilder) SetAllowedMentions(allowedMentions *AllowedMentions) *WebhookMessageUpdateBuilder {
	b.AllowedMentions = allowedMentions
	b.updateFlags |= updateFlagAllowedMentions
	return b
}

// ClearAllowedMentions clears the allowed mentions of the Message
func (b *WebhookMessageUpdateBuilder) ClearAllowedMentions() *WebhookMessageUpdateBuilder {
	return b.SetAllowedMentions(&AllowedMentions{})
}

// Build builds the WebhookMessageUpdateBuilder to a WebhookMessageUpdate struct
func (b *WebhookMessageUpdateBuilder) Build() WebhookMessageUpdate {
	return b.WebhookMessageUpdate
}
