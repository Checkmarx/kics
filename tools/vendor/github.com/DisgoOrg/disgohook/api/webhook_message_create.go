package api

import (
	"fmt"
	"github.com/DisgoOrg/restclient"
	"io"
)

// WebhookMessageCreate is used to add additional messages to an Interaction after you've responded initially
type WebhookMessageCreate struct {
	Content         string            `json:"content,omitempty"`
	TTS             bool              `json:"tts,omitempty"`
	Embeds          []Embed           `json:"embeds,omitempty"`
	Components      []Component       `json:"components,omitempty"`
	Files           []restclient.File `json:"-"`
	AllowedMentions *AllowedMentions  `json:"allowed_mentions,omitempty"`
	Flags           MessageFlags      `json:"flags,omitempty"`
}

// ToBody returns the WebhookMessageCreate ready for body
func (m WebhookMessageCreate) ToBody() (interface{}, error) {
	if len(m.Files) > 0 {
		return restclient.PayloadWithFiles(m, m.Files...)
	}
	return m, nil
}

// WebhookMessageCreateBuilder allows you to create an WebhookMessageCreate with ease
type WebhookMessageCreateBuilder struct {
	WebhookMessageCreate
}

// NewWebhookMessageCreateBuilder returns a new WebhookMessageCreateBuilder
func NewWebhookMessageCreateBuilder() *WebhookMessageCreateBuilder {
	return &WebhookMessageCreateBuilder{
		WebhookMessageCreate: WebhookMessageCreate{
			AllowedMentions: &DefaultAllowedMentions,
		},
	}
}

// SetTTS sets if the WebhookMessageCreate is a tts message
func (b *WebhookMessageCreateBuilder) SetTTS(tts bool) *WebhookMessageCreateBuilder {
	b.TTS = tts
	return b
}

// SetContent sets the content of the WebhookMessageCreate
func (b *WebhookMessageCreateBuilder) SetContent(content string) *WebhookMessageCreateBuilder {
	b.Content = content
	return b
}

// SetContentf sets the content of the WebhookMessageCreate with format
func (b *WebhookMessageCreateBuilder) SetContentf(content string, a ...interface{}) *WebhookMessageCreateBuilder {
	b.Content = fmt.Sprintf(content, a...)
	return b
}

// SetEmbeds sets the embeds of the WebhookMessageCreate
func (b *WebhookMessageCreateBuilder) SetEmbeds(embeds ...Embed) *WebhookMessageCreateBuilder {
	b.Embeds = embeds
	return b
}

// AddEmbeds adds multiple embeds to the WebhookMessageCreate
func (b *WebhookMessageCreateBuilder) AddEmbeds(embeds ...Embed) *WebhookMessageCreateBuilder {
	b.Embeds = append(b.Embeds, embeds...)
	return b
}

// ClearEmbeds removes all of the embeds from the WebhookMessageCreate
func (b *WebhookMessageCreateBuilder) ClearEmbeds() *WebhookMessageCreateBuilder {
	b.Embeds = []Embed{}
	return b
}

// RemoveEmbed removes an embed from the WebhookMessageCreate
func (b *WebhookMessageCreateBuilder) RemoveEmbed(index int) *WebhookMessageCreateBuilder {
	if b != nil && len(b.Embeds) > index {
		b.Embeds = append(b.Embeds[:index], b.Embeds[index+1:]...)
	}
	return b
}

// SetComponents sets the Component(s) of the WebhookMessageCreate
func (b *WebhookMessageCreateBuilder) SetComponents(components ...Component) *WebhookMessageCreateBuilder {
	b.Components = components
	return b
}

// AddComponents adds the Component(s) to the WebhookMessageCreate
func (b *WebhookMessageCreateBuilder) AddComponents(components ...Component) *WebhookMessageCreateBuilder {
	b.Components = append(b.Components, components...)
	return b
}

// SetFiles sets the files for this WebhookMessageCreate
func (b *WebhookMessageCreateBuilder) SetFiles(files ...restclient.File) *WebhookMessageCreateBuilder {
	b.Files = files
	return b
}

// AddFiles adds the files to the WebhookMessageCreate
func (b *WebhookMessageCreateBuilder) AddFiles(files ...restclient.File) *WebhookMessageCreateBuilder {
	b.Files = append(b.Files, files...)
	return b
}

// AddFile adds a file to the WebhookMessageCreate
func (b *WebhookMessageCreateBuilder) AddFile(name string, reader io.Reader, flags ...restclient.FileFlags) *WebhookMessageCreateBuilder {
	b.Files = append(b.Files, restclient.File{
		Name:   name,
		Reader: reader,
		Flags:  restclient.FileFlagNone.Add(flags...),
	})
	return b
}

// ClearFiles removes all files of this WebhookMessageCreate
func (b *WebhookMessageCreateBuilder) ClearFiles() *WebhookMessageCreateBuilder {
	b.Files = []restclient.File{}
	return b
}

// RemoveFiles removes the file at this index
func (b *WebhookMessageCreateBuilder) RemoveFiles(i int) *WebhookMessageCreateBuilder {
	if len(b.Files) > i {
		b.Files = append(b.Files[:i], b.Files[i+1:]...)
	}
	return b
}

// SetAllowedMentions sets the allowed mentions of the WebhookMessageCreate
func (b *WebhookMessageCreateBuilder) SetAllowedMentions(allowedMentions *AllowedMentions) *WebhookMessageCreateBuilder {
	b.AllowedMentions = allowedMentions
	return b
}

// SetAllowedMentionsEmpty sets the allowed mentions of the WebhookMessageCreate to nothing
func (b *WebhookMessageCreateBuilder) SetAllowedMentionsEmpty() *WebhookMessageCreateBuilder {
	return b.SetAllowedMentions(&AllowedMentions{})
}

// SetFlags sets the message flags of the WebhookMessageCreate
func (b *WebhookMessageCreateBuilder) SetFlags(flags MessageFlags) *WebhookMessageCreateBuilder {
	b.Flags = flags
	return b
}

// SetEphemeral adds/removes MessageFlagEphemeral to the message flags
func (b *WebhookMessageCreateBuilder) SetEphemeral(ephemeral bool) *WebhookMessageCreateBuilder {
	if ephemeral {
		b.Flags = b.Flags.Add(MessageFlagEphemeral)
	} else {
		b.Flags = b.Flags.Remove(MessageFlagEphemeral)
	}
	return b
}

// Build returns your built WebhookMessageCreate
func (b *WebhookMessageCreateBuilder) Build() WebhookMessageCreate {
	return b.WebhookMessageCreate
}
